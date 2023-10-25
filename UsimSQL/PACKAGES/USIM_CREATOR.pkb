CREATE OR REPLACE PACKAGE BODY usim_creator
IS
  -- see header for documentation

  FUNCTION write_json_log( p_json_clob IN CLOB
                         , p_filename  IN VARCHAR2 DEFAULT 'usim_space_log'
                         )
    RETURN NUMBER
  IS
    l_file        UTL_FILE.FILE_TYPE;
    l_filename    VARCHAR2(100);
    l_backup      VARCHAR2(100);
    l_buffer      VARCHAR2(8191);
    l_bufsize     CONSTANT BINARY_INTEGER := 8191;
    l_pos         PLS_INTEGER;
    l_clob_len    PLS_INTEGER;
    l_clob        CLOB;
    l_file_exist  BOOLEAN;
    l_file_length NUMBER;
    l_block_size  BINARY_INTEGER;
  BEGIN
    IF LENGTH(p_filename) > 100
    THEN
      usim_erl.log_error('usim_creator.write_json_log', 'Filename [' || p_filename || '] too long.');
      RETURN 0;
    END IF;
    l_clob  := p_json_clob;
    l_filename := TRIM(p_filename) || '.json';
    UTL_FILE.FGETATTR('USIM_DIR', l_filename, l_file_exist, l_file_length, l_block_size);
    IF l_file_exist
    THEN
      l_backup := TRIM(p_filename) || '_' || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') || '.json';
      -- "copy" file first by rename, FCOPY requires reading content with required CR limiter before 32767 bytes
      -- furthermore with rename no FREMOVE is required
      UTL_FILE.FRENAME('USIM_DIR', l_filename, 'USIM_HIST_DIR', l_backup);
    END IF;
    -- now write new file
    -- open CLOB first
    IF DBMS_LOB.ISOPEN(l_clob) = 0
    THEN
      DBMS_LOB.OPEN(l_clob, DBMS_LOB.LOB_READONLY);
    END IF;
    -- prepare and open
    l_pos      := 1;
    l_clob_len := DBMS_LOB.GETLENGTH(l_clob);
    l_file     := UTL_FILE.FOPEN('USIM_DIR', l_filename, 'WB', l_bufsize);
    -- get first buffer chunk
    l_buffer   := DBMS_LOB.SUBSTR(l_clob, l_bufsize, l_pos);
    -- loop until last chunk
    WHILE l_pos < l_clob_len
    LOOP
      EXIT WHEN l_buffer IS NULL;
      UTL_FILE.PUT_RAW(l_file, UTL_RAW.CAST_TO_RAW(l_buffer));
      l_pos := l_pos + LEAST(LENGTH(l_buffer) + 1, l_bufsize);
      UTL_FILE.FFLUSH(l_file);
      -- load next buffer chunk
      l_buffer := DBMS_LOB.SUBSTR(l_clob, l_bufsize, l_pos);
    END LOOP;
    -- close file
    UTL_FILE.FCLOSE(l_file);
    DBMS_LOB.CLOSE(l_clob);
    RETURN 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF DBMS_LOB.ISOPEN(l_clob) = 1
      THEN
        DBMS_LOB.CLOSE(l_clob);
      END IF;
      IF UTL_FILE.IS_OPEN(l_file)
      THEN
        UTL_FILE.FCLOSE(l_file);
      END IF;
      usim_erl.log_error('usim_creator.write_json_log', 'Unexpected exception writing JSON log SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      RETURN 0;
  END write_json_log
  ;

  FUNCTION get_json_log( p_planck_aeon      IN     usim_spc_process.usim_planck_aeon%TYPE
                       , p_from_planck_time IN OUT usim_spc_process.usim_planck_time%TYPE
                       , p_to_planck_time   IN     usim_spc_process.usim_planck_time%TYPE
                       , p_json_log            OUT CLOB
                       )
    RETURN NUMBER
  IS
    l_main_object         JSON_OBJECT_T;
    l_planck_times_array  JSON_ARRAY_T;
    l_planck_detail_array JSON_ARRAY_T;
    l_planck_time_details JSON_OBJECT_T;
    l_planck_time_main    JSON_OBJECT_T;
    l_from_xyz            JSON_OBJECT_T;
    l_to_xyz              JSON_OBJECT_T;
    l_return              NUMBER;
    l_result              NUMBER;

    CURSOR cur_planck_pieces( cp_planck_aeon      IN usim_spc_process.usim_planck_aeon%TYPE
                            , cp_from_planck_time IN usim_spc_process.usim_planck_time%TYPE
                            , cp_to_planck_time   IN usim_spc_process.usim_planck_time%TYPE
                            )
    IS
      SELECT usim_planck_aeon
           , usim_planck_time
        FROM usim_spc_process
       WHERE usim_planck_aeon       = cp_planck_aeon
         AND usim_planck_time BETWEEN cp_from_planck_time
                                  AND cp_to_planck_time
       GROUP BY usim_planck_aeon
              , usim_planck_time
    ;
    CURSOR cur_log_details( cp_planck_aeon IN usim_spc_process.usim_planck_aeon%TYPE
                          , cp_planck_time IN usim_spc_process.usim_planck_time%TYPE
                          )
    IS
      SELECT usim_planck_aeon
           , usim_planck_time
           , usim_id_spc_source
           , usim_id_spc_target
           , usim_real_time
           , is_processed
           , usim_energy_source
           , usim_energy_target
           , usim_energy_output
        FROM usim_spc_process
       WHERE usim_planck_aeon = cp_planck_aeon
         AND usim_planck_time = cp_planck_time
             -- order by insert order
       ORDER BY ROWID
    ;
  BEGIN
    SELECT COUNT(*)
      INTO l_result
      FROM (SELECT usim_planck_time
              FROM usim_spc_process
             WHERE usim_planck_aeon = p_planck_aeon
               AND usim_planck_time IN (p_from_planck_time, p_to_planck_time)
             GROUP BY usim_planck_aeon
                    , usim_planck_time
           )
    ;
    IF l_result != 2
    THEN
      usim_erl.log_error('usim_creator.get_json_log', 'Invalid input parameter aeon [' || p_planck_aeon || '], from [' || p_from_planck_time || '] or to [' || p_to_planck_time || '].');
      RETURN -1;
    END IF;
    l_return              := 1;
    l_main_object         := new JSON_OBJECT_T;
    l_planck_times_array  := new JSON_ARRAY_T;
    l_main_object.put('planck_aeon', p_planck_aeon);
    l_main_object.put('max_number', usim_dbif.get_abs_max_number);
    FOR mainrec IN cur_planck_pieces(p_planck_aeon, p_from_planck_time, p_to_planck_time)
    LOOP
      -- check size
      -- take about the half of 5 MB bytes as frontier as UTF8 will need mostly 2 Bytes.
      IF LENGTH(l_planck_times_array.to_clob) > 2600000
      THEN
        p_from_planck_time := mainrec.usim_planck_time;
        l_return           := 0;
        -- exit loop
        EXIT;
      END IF;
      l_planck_detail_array := new JSON_ARRAY_T;
      l_planck_time_main    := new JSON_OBJECT_T;
      -- get details for time tick
      FOR rec IN cur_log_details(mainrec.usim_planck_aeon, mainrec.usim_planck_time)
      LOOP
        l_planck_time_details := new JSON_OBJECT_T;
        l_from_xyz            := new JSON_OBJECT_T;
        l_to_xyz              := new JSON_OBJECT_T;
        l_from_xyz.put('x', usim_dbif.get_dim_coord(rec.usim_id_spc_source, 1));
        l_from_xyz.put('y', usim_dbif.get_dim_coord(rec.usim_id_spc_source, 2));
        l_from_xyz.put('z', usim_dbif.get_dim_coord(rec.usim_id_spc_source, 3));
        l_from_xyz.put('energy', rec.usim_energy_source);
        l_from_xyz.put('dimension', usim_dbif.get_dimension(rec.usim_id_spc_source));
        l_from_xyz.put('dim_sign', usim_dbif.get_dim_sign(rec.usim_id_spc_source));
        l_from_xyz.put('dim_n1_sign', usim_dbif.get_dim_n1_sign(rec.usim_id_spc_source));
        l_to_xyz.put('x', usim_dbif.get_dim_coord(rec.usim_id_spc_target, 1));
        l_to_xyz.put('y', usim_dbif.get_dim_coord(rec.usim_id_spc_target, 2));
        l_to_xyz.put('z', usim_dbif.get_dim_coord(rec.usim_id_spc_target, 3));
        l_to_xyz.put('energy', NVL(rec.usim_energy_target, 0));
        l_to_xyz.put('dimension', usim_dbif.get_dimension(rec.usim_id_spc_target));
        l_to_xyz.put('dim_sign', usim_dbif.get_dim_sign(rec.usim_id_spc_target));
        l_to_xyz.put('dim_n1_sign', usim_dbif.get_dim_n1_sign(rec.usim_id_spc_target));
        l_planck_time_details.put('output_energy', rec.usim_energy_output);
        l_planck_time_details.put('from', l_from_xyz);
        l_planck_time_details.put('to', l_to_xyz);
        l_planck_detail_array.append(l_planck_time_details);
      END LOOP;
      l_planck_time_main.put('planck_time', mainrec.usim_planck_time);
      l_planck_time_main.put('details', l_planck_detail_array);
      l_planck_times_array.append(l_planck_time_main);
    END LOOP;
    l_main_object.put('planck_ticks', l_planck_times_array);
    p_json_log := l_main_object.to_clob;
    RETURN l_return;
  EXCEPTION
    WHEN OTHERS THEN
      usim_erl.log_error('usim_creator.get_json_log', 'Unexpected exception SQL code [' || SQLCODE || '] message [' || SQLERRM || '].');
      RETURN -1;
  END get_json_log
  ;

  FUNCTION get_json_struct( p_usim_id_mlv IN  usim_multiverse.usim_id_mlv%TYPE
                          , p_json_struct OUT CLOB
                          )
    RETURN NUMBER
  IS
    l_has_data         NUMBER;
    l_main_object      JSON_OBJECT_T;
    l_node_array       JSON_ARRAY_T;
    l_child_array      JSON_ARRAY_T;
    l_coord_array      JSON_ARRAY_T;
    l_zero_array       JSON_ARRAY_T;
    l_zero_child_array JSON_ARRAY_T;
    l_zero_child       JSON_OBJECT_T;
    l_zero_parent      JSON_OBJECT_T;
    l_node             JSON_OBJECT_T;
    l_child            JSON_OBJECT_T;

    CURSOR cur_has_xyz(cp_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    IS
      SELECT COUNT(*)
        FROM usim_spo_xyz_v
       WHERE usim_n_dimension BETWEEN 1 AND 3
         AND usim_id_mlv = cp_usim_id_mlv
    ;
    CURSOR cur_coordinates(cp_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    IS
      SELECT xyz_coord
        FROM usim_spo_xyz_v
       WHERE usim_n_dimension BETWEEN 1 AND 3
         AND usim_id_mlv = cp_usim_id_mlv
       GROUP BY xyz_coord
       ORDER BY xyz_coord
    ;
    CURSOR cur_child_coordinates( cp_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE
                                , cp_xyz_coord   IN VARCHAR2
                                )
    IS
        WITH parents AS
             (SELECT usim_id_spc
                FROM usim_spo_xyz_v
               WHERE usim_n_dimension BETWEEN 1 AND 3
                 AND usim_id_mlv = cp_usim_id_mlv
                 AND xyz_coord   = cp_xyz_coord
             )
           , chi AS
             (SELECT usim_id_spc
                   , usim_id_spc_child
                   , usim_id_mlv
                   , usim_dbif.get_xyz(usim_id_spc) AS xyz_parent
                FROM usim_spc_chi_v
             )
           , coords AS
             (SELECT usim_id_spc
                   , usim_id_mlv
                   , xyz_coord
                FROM usim_spo_xyz_v
               WHERE usim_n_dimension BETWEEN 1 AND 3
             )
      SELECT coords.xyz_coord
        FROM parents
       INNER JOIN chi
          ON parents.usim_id_spc   = chi.usim_id_spc
       INNER JOIN coords
          ON chi.usim_id_spc_child = coords.usim_id_spc
         AND chi.usim_id_mlv       = coords.usim_id_mlv
             -- exclude self references on 0,0,0 coordinates
         AND chi.xyz_parent       != coords.xyz_coord
       GROUP BY coords.xyz_coord
       ORDER BY coords.xyz_coord
    ;
    CURSOR cur_zero_struct(cp_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    IS
      SELECT usim_id_spc
           , usim_n_dimension
           , dim_sign
           , NVL(dim_n1_sign, 0) AS dim_n1_sign
        FROM usim_spo_xyz_v
       WHERE usim_n_dimension < 4
         AND xyz_coord        = '0,0,0'
         AND usim_id_mlv      = cp_usim_id_mlv
       ORDER BY usim_n_dimension
              , dim_n1_sign
              , dim_sign
    ;

  BEGIN
    OPEN cur_has_xyz(p_usim_id_mlv);
    FETCH cur_has_xyz INTO l_has_data;
    CLOSE cur_has_xyz;
    IF l_has_data = 0
    THEN
      usim_erl.log_error('usim_creator.get_json_struct', 'No data found for  [' || p_usim_id_mlv || '].');
      RETURN -1;
    END IF;
    l_main_object := new JSON_OBJECT_T;
    l_node_array  := new JSON_ARRAY_T;
    l_zero_array  := new JSON_ARRAY_T;
    l_main_object.put('universe_id', p_usim_id_mlv);
    -- zero structure
    FOR mainrec IN cur_zero_struct(p_usim_id_mlv)
    LOOP
      l_zero_parent := new JSON_OBJECT_T;
      l_zero_parent.put('dimension', mainrec.usim_n_dimension);
      l_zero_parent.put('dim_sign', mainrec.dim_sign);
      l_zero_parent.put('dim_n1_sign', mainrec.dim_n1_sign);
      l_zero_array.append(l_zero_parent);
    END LOOP;
    l_main_object.put('zero_nodes', l_zero_array);
    -- xyz relations
    FOR mainrec IN cur_coordinates(p_usim_id_mlv)
    LOOP
      -- build main node
      l_node        := new JSON_OBJECT_T;
      l_coord_array := JSON_ARRAY_T.parse('[' || mainrec.xyz_coord || ']');
      l_node.put('xyz', l_coord_array);
      -- build unique child coordinates array
      l_child_array := new JSON_ARRAY_T;
      -- condsider n parents for 0,0,0 space nodes
      FOR rec IN cur_child_coordinates(p_usim_id_mlv, mainrec.xyz_coord)
      LOOP
        l_child       := new JSON_OBJECT_T;
        l_coord_array := JSON_ARRAY_T.parse('[' || rec.xyz_coord || ']');
        l_child.put('xyz', l_coord_array);
        l_child_array.append(l_child);
      END LOOP;
      -- add child array
      l_node.put('childs', l_child_array);
      l_node_array.append(l_node);
    END LOOP;
    -- add to main object
    l_main_object.put('nodes', l_node_array);
    p_json_struct := l_main_object.to_clob;
    RETURN 1;
  EXCEPTION
    WHEN OTHERS THEN
      usim_erl.log_error('usim_creator.get_json_struct', 'Unexpected exception SQL code [' || SQLCODE || '] message [' || SQLERRM || '].');
      RETURN NULL;
  END get_json_struct
  ;

  FUNCTION create_space_log( p_planck_aeon      IN usim_spc_process.usim_planck_aeon%TYPE
                           , p_from_planck_time IN usim_spc_process.usim_planck_time%TYPE
                           , p_to_planck_time   IN usim_spc_process.usim_planck_time%TYPE
                           )
    RETURN NUMBER
  IS
    l_has_data          NUMBER;
    l_result            NUMBER;
    l_file              NUMBER;
    l_planck_aeon       usim_spc_process.usim_planck_aeon%TYPE;
    l_from_planck_time  usim_spc_process.usim_planck_time%TYPE;
    l_to_planck_time    usim_spc_process.usim_planck_time%TYPE;
    l_json_log          CLOB;
  BEGIN
    SELECT COUNT(*) INTO l_has_data FROM usim_spc_process;
    IF l_has_data = 0
    THEN
      usim_erl.log_error('usim_creator.create_space_log', 'Could not write log without logging data in USIM_SPC_PROCESS, table is empty.');
      RETURN 0;
    END IF;
    -- check if from record exists
    SELECT COUNT(*) INTO l_has_data FROM usim_spc_process WHERE usim_planck_aeon = p_planck_aeon AND usim_planck_time = p_from_planck_time;
    IF l_has_data = 0
    THEN
      -- get first record in table
      SELECT usim_planck_aeon
           , usim_planck_time
        INTO l_planck_aeon
           , l_from_planck_time
        FROM (SELECT usim_planck_aeon
                   , usim_planck_time
                FROM usim_spc_process
               ORDER BY ROWID
             )
       WHERE ROWNUM = 1
      ;
    ELSE
      l_planck_aeon := p_planck_aeon;
      l_from_planck_time := p_from_planck_time;
    END IF;
    -- check if to record exists
    SELECT COUNT(*) INTO l_has_data FROM usim_spc_process WHERE usim_planck_aeon = p_planck_aeon AND usim_planck_time = p_to_planck_time;
    IF l_has_data = 0
    THEN
      -- get last record in table
      SELECT usim_planck_time
        INTO l_to_planck_time
        FROM (SELECT usim_planck_aeon
                   , usim_planck_time
                FROM usim_spc_process
               ORDER BY ROWID DESC
             )
       WHERE ROWNUM = 1
      ;
    ELSE
      l_to_planck_time := p_to_planck_time;
    END IF;
    -- repeat until end is reached
    LOOP
      l_result := usim_creator.get_json_log(l_planck_aeon, l_from_planck_time, l_to_planck_time, l_json_log);
      IF l_result = -1
      THEN
        usim_erl.log_error('usim_creator.create_space_log', 'Could not get json space log for from [' || l_planck_aeon || '], [' || l_from_planck_time || '] or to [' || l_to_planck_time || '].');
        RETURN 0;
      ELSE
        -- write file
        l_file := usim_creator.write_json_log(l_json_log, 'usim_space_log');
        IF l_result = 1
        THEN
          EXIT;
        ELSE
          usim_erl.log_error('usim_creator.create_space_log', 'ERROR writing json space log for from [' || l_planck_aeon || '], [' || l_from_planck_time || '] or to [' || l_to_planck_time || '].');
          RETURN 0;
        END IF;
      END IF;
    END LOOP;
    RETURN 1;
  END create_space_log
  ;

  FUNCTION create_json_struct(p_usim_id_mlv IN  usim_multiverse.usim_id_mlv%TYPE)
    RETURN NUMBER
  IS
    l_json_struct CLOB;
    l_return      NUMBER;
    l_file        NUMBER;
  BEGIN
    IF    usim_dbif.has_data_spc                = 0
       OR usim_dbif.has_data_mlv(p_usim_id_mlv) = 0
    THEN
      usim_erl.log_error('usim_creator.create_json_struct', 'Either not existing [' || p_usim_id_mlv || '] or no data in USIM_SPACE for structure JSON.');
      RETURN 0;
    END IF;
    l_return := usim_creator.get_json_struct(p_usim_id_mlv, l_json_struct);
    IF l_return = 0
    THEN
      usim_erl.log_error('usim_creator.create_json_struct', 'ERROR getting json space structure for mlv [' || p_usim_id_mlv || '].');
      RETURN 0;
    END IF;
    -- write file
    l_file := usim_creator.write_json_log(l_json_struct, 'usim_space_struct');
    IF l_file = 0
    THEN
      usim_erl.log_error('usim_creator.create_json_struct', 'ERROR writing json space structure for mlv [' || p_usim_id_mlv || '].');
      RETURN 0;
    END IF;
    RETURN 1;
  END create_json_struct
  ;

  FUNCTION create_next_dimension(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
  BEGIN
    usim_erl.log_error('usim_creator.create_next_dimension', 'NOT IMPLEMENTED.');
    RETURN 1;
  END create_next_dimension
  ;

  FUNCTION init_dimension( p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                         , p_do_commit        IN BOOLEAN                              DEFAULT TRUE
                         )
    RETURN usim_dimension.usim_id_dim%TYPE
  IS
  BEGIN
    usim_erl.log_error('usim_creator.init_dimension', 'NOT IMPLEMENTED.');
    RETURN NULL;
  END init_dimension
  ;

  FUNCTION init_dim_axis( p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE
                        , p_usim_id_dim IN usim_dimension.usim_id_dim%TYPE
                        , p_usim_sign   IN usim_rel_mlv_dim.usim_sign%TYPE
                        , p_do_commit   IN BOOLEAN                          DEFAULT TRUE
                        )
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
  IS
  BEGIN
    usim_erl.log_error('usim_creator.init_dim_axis', 'NOT IMPLEMENTED.');
    RETURN NULL;
  END init_dim_axis
  ;

  FUNCTION init_dim_all( p_usim_id_mlv      IN usim_multiverse.usim_id_mlv%TYPE
                       , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                       , p_do_commit        IN BOOLEAN                              DEFAULT TRUE
                       )
    RETURN NUMBER
  IS
  BEGIN
    usim_erl.log_error('usim_creator.init_dim_all', 'NOT IMPLEMENTED.');
    RETURN 0;
  END init_dim_all
  ;

  FUNCTION init_zero_dim_nodes( p_usim_id_mlv        IN usim_multiverse.usim_id_mlv%TYPE
                              , p_usim_id_spc_parent IN usim_space.usim_id_spc%TYPE
                              , p_usim_n_dimension   IN usim_dimension.usim_n_dimension%TYPE
                              , p_do_commit          IN BOOLEAN                              DEFAULT TRUE
                              )
    RETURN NUMBER
  IS
  BEGIN
    usim_erl.log_error('usim_creator.init_zero_dim_nodes', 'NOT IMPLEMENTED.');
    RETURN 0;
  END init_zero_dim_nodes
  ;

  FUNCTION create_new_universe( p_usim_energy_start_value IN usim_multiverse.usim_energy_start_value%TYPE DEFAULT 1
                              , p_usim_planck_time_unit   IN usim_multiverse.usim_planck_time_unit%TYPE   DEFAULT 1
                              , p_usim_planck_length_unit IN usim_multiverse.usim_planck_length_unit%TYPE DEFAULT 1
                              , p_usim_planck_speed_unit  IN usim_multiverse.usim_planck_speed_unit%TYPE  DEFAULT 1
                              , p_usim_planck_stable      IN usim_multiverse.usim_planck_stable%TYPE      DEFAULT 1
                              , p_usim_ultimate_border    IN usim_multiverse.usim_ultimate_border%TYPE    DEFAULT 1
                              , p_usim_id_spc_parent      IN usim_space.usim_id_spc%TYPE                  DEFAULT NULL
                              , p_do_commit               IN BOOLEAN                                      DEFAULT TRUE
                              )
    RETURN usim_space.usim_id_spc%TYPE
  IS
    -- zero node dim 0 pos 0
    l_usim_id_spc           usim_space.usim_id_spc%TYPE;
    -- used for parent check
    l_usim_id_spc_parent    usim_space.usim_id_spc%TYPE;
    -- dim 1 n1+ pos +0
    l_id_spc0_n1p_1p        usim_space.usim_id_spc%TYPE;
    -- dim 1 n1- pos -0
    l_id_spc0_n1n_1n        usim_space.usim_id_spc%TYPE;
    -- dim 1 n1+ pos +1
    l_id_spc1p_n1p_1p       usim_space.usim_id_spc%TYPE;
    -- dim 1 n1- pos -1
    l_id_spc1n_n1n_1n       usim_space.usim_id_spc%TYPE;
    -- universe id
    l_usim_id_mlv           usim_multiverse.usim_id_mlv%TYPE;
    -- dim axis 0
    l_usim_id_rmd           usim_rel_mlv_dim.usim_id_rmd%TYPE;
    -- pos 0
    l_usim_id_pos           usim_position.usim_id_pos%TYPE;
    -- pos +1
    l_usim_id_pos_1p        usim_position.usim_id_pos%TYPE;
    -- pos -1
    l_usim_id_pos_1n        usim_position.usim_id_pos%TYPE;
    -- dim axis 1+
    l_id_rmd_n1p_1p         usim_rel_mlv_dim.usim_id_rmd%TYPE;
    -- dim axis 1-
    l_id_rmd_n1n_1n         usim_rel_mlv_dim.usim_id_rmd%TYPE;
    -- dummy of dim axis 0 creation
    l_rmd_dummy             usim_rel_mlv_dim.usim_id_rmd%TYPE;
    -- parents array
    l_parents               usim_static.usim_ids_type;
    l_return                NUMBER;
  BEGIN
    -- check base data, must exist
    IF usim_dbif.has_basedata = 0
    THEN
      usim_erl.log_error('usim_creator.create_new_universe', 'Base data not initialized.');
      RETURN NULL;
    END IF;
    -- a parent must be given, if usim_space has already data, assuming an existing base universe seed.
    IF     usim_dbif.has_data_mlv = 1
       AND p_usim_id_spc_parent  IS NULL
    THEN
      usim_erl.log_error('usim_creator.create_new_universe', 'Parent for new universe missing, as already data in usim_multiverse exist.');
      RETURN NULL;
    END IF;
    -- ignore parent if usim_space is empty
    IF     usim_dbif.has_data_mlv = 0
       AND p_usim_id_spc_parent  IS NOT NULL
    THEN
      usim_erl.log_error('usim_creator.create_new_universe', 'Ignoring parent assignment [' || p_usim_id_spc_parent || '] on empty multiverse.');
      l_usim_id_spc_parent := NULL;
    ELSE
      l_usim_id_spc_parent := p_usim_id_spc_parent;
    END IF;
    -- create universe
    l_usim_id_mlv := usim_dbif.create_universe( p_usim_energy_start_value
                                              , p_usim_planck_time_unit
                                              , p_usim_planck_length_unit
                                              , p_usim_planck_speed_unit
                                              , p_usim_planck_stable
                                              , p_usim_ultimate_border
                                              , FALSE
                                              )
    ;
    -- if universe creation failed rollback everything
    IF l_usim_id_mlv IS NULL
    THEN
      usim_erl.log_error('usim_creator.create_new_universe', 'Failed to create new universe with data energy start [' || p_usim_energy_start_value || '], planck time [' || p_usim_planck_time_unit || '], planck length [' || p_usim_planck_length_unit || '], planck speed [' || p_usim_planck_speed_unit || '], planck stable [' || p_usim_planck_stable || '] and ultimate border rule [' || p_usim_ultimate_border || '].');
      ROLLBACK;
      RETURN NULL;
    END IF;
    -- check and create dimension, if necessary
    l_return := usim_dbif.init_dimensions(FALSE);
    IF l_return = 0
    THEN
      usim_erl.log_error('usim_creator.create_new_universe', 'Failed to init dimensions.');
      ROLLBACK;
      RETURN NULL;
    END IF;
    -- check and create positions, if necessary
    l_return := usim_dbif.init_positions(FALSE);
    IF l_return = 0
    THEN
      usim_erl.log_error('usim_creator.create_new_universe', 'Failed to init positions.');
      ROLLBACK;
      RETURN NULL;
    END IF;
    -- get position 0
    l_usim_id_pos := usim_dbif.get_id_pos(0);
    IF l_usim_id_pos IS NULL
    THEN
      usim_erl.log_error('usim_creator.create_new_universe', 'Failed to get position 0.');
      ROLLBACK;
      RETURN NULL;
    END IF;
    -- create dim axis
    l_return  := usim_dbif.create_dim_axis(l_usim_id_mlv, 0, NULL, l_usim_id_rmd, l_rmd_dummy, FALSE);
    IF l_return = 0
    THEN
      usim_erl.log_error('usim_creator.create_new_universe', 'Failed to create dimension axis for dimension 0 universe id [' || l_usim_id_mlv || '].');
      ROLLBACK;
      RETURN NULL;
    END IF;
    -- set parent if available
    IF l_usim_id_spc_parent IS NOT NULL
    THEN
      l_parents(1) := l_usim_id_spc_parent;
    END IF;
    -- create basic space node
    l_usim_id_spc := usim_dbif.create_space_node(l_usim_id_rmd, l_usim_id_pos, l_parents, FALSE);
    IF l_usim_id_spc IS NULL
    THEN
      usim_erl.log_error('usim_creator.create_new_universe', 'Failed to create space node for rmd id [' || l_usim_id_rmd || '], pos id [' || l_usim_id_pos || '] and parent [' || NVL(l_usim_id_spc_parent, 'NONE') || '].');
      ROLLBACK;
      RETURN NULL;
    END IF;
    -- create dim axis (+/-) for dimension 1
    l_return := usim_dbif.create_dim_axis(l_usim_id_mlv, 1, l_usim_id_rmd, l_id_rmd_n1p_1p, l_id_rmd_n1n_1n, FALSE);
    IF l_return = 0
    THEN
      usim_erl.log_error('usim_creator.create_new_universe', 'Failed to create dimension axis for dimension 1 universe id [' || l_usim_id_mlv || '] and rmd id [' || l_usim_id_rmd || '].');
      ROLLBACK;
      RETURN NULL;
    END IF;
    -- create space nodes on dimension 1
    l_parents(1) := l_usim_id_spc;
    -- +0,0,0
    l_id_spc0_n1p_1p  := usim_dbif.create_space_node(l_id_rmd_n1p_1p, l_usim_id_pos, l_parents, FALSE);
    IF l_id_spc0_n1p_1p IS NULL
    THEN
      usim_erl.log_error('usim_creator.create_new_universe', 'Failed to create space node position +0 at dimension 1, n1+ for rmd id [' || l_id_rmd_n1p_1p || '], pos id [' || l_usim_id_pos || '] and parent [' || NVL(l_usim_id_spc_parent, 'NONE') || '].');
      ROLLBACK;
      RETURN NULL;
    END IF;
    -- -0,0,0
    l_id_spc0_n1n_1n  := usim_dbif.create_space_node(l_id_rmd_n1n_1n, l_usim_id_pos, l_parents, FALSE);
    IF l_id_spc0_n1p_1p IS NULL
    THEN
      usim_erl.log_error('usim_creator.create_new_universe', 'Failed to create space node position -0 at dimension 1, n1- for rmd id [' || l_id_rmd_n1n_1n || '], pos id [' || l_usim_id_pos || '] and parent [' || NVL(l_usim_id_spc_parent, 'NONE') || '].');
      ROLLBACK;
      RETURN NULL;
    END IF;
    -- get positions 1 (+/-)
    l_usim_id_pos_1p := usim_dbif.get_id_pos(1);
    IF l_usim_id_pos_1p IS NULL
    THEN
      usim_erl.log_error('usim_creator.create_new_universe', 'Failed to get position +1.');
      ROLLBACK;
      RETURN NULL;
    END IF;
    l_usim_id_pos_1n := usim_dbif.get_id_pos(-1);
    IF l_usim_id_pos_1n IS NULL
    THEN
      usim_erl.log_error('usim_creator.create_new_universe', 'Failed to get position -1.');
      ROLLBACK;
      RETURN NULL;
    END IF;
    -- from here on parents have to have the same dim n1 sign
    -- +1,0,0
    l_parents(1) := l_id_spc0_n1p_1p;
    l_id_spc1p_n1p_1p := usim_dbif.create_space_node(l_id_rmd_n1p_1p, l_usim_id_pos_1p, l_parents, FALSE);
    IF l_id_spc1p_n1p_1p IS NULL
    THEN
      usim_erl.log_error('usim_creator.create_new_universe', 'Failed to create space node position +1 at dimension 1, n1+ for rmd id [' || l_id_rmd_n1p_1p || '], pos id [' || l_usim_id_pos_1p || '] and parent [' || NVL(l_parents(1), 'NONE') || '].');
      ROLLBACK;
      RETURN NULL;
    END IF;
    -- -1,0,0
    l_parents(1) := l_id_spc0_n1n_1n;
    l_id_spc1n_n1n_1n := usim_dbif.create_space_node(l_id_rmd_n1n_1n, l_usim_id_pos_1n, l_parents, FALSE);
    IF l_id_spc1p_n1p_1p IS NULL
    THEN
      usim_erl.log_error('usim_creator.create_new_universe', 'Failed to create space node position -1 at dimension 1, n1- for rmd id [' || l_id_rmd_n1n_1n || '], pos id [' || l_usim_id_pos_1n || '] and parent [' || NVL(l_parents(1), 'NONE') || '].');
      ROLLBACK;
      RETURN NULL;
    END IF;
    -- now commit if coming so far and do commit is set
    IF p_do_commit
    THEN
      COMMIT;
    END IF;
    RETURN l_usim_id_spc;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_creator.create_new_universe', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END create_new_universe
  ;

  FUNCTION handle_overflow_dim( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                              , p_do_commit   IN BOOLEAN                     DEFAULT TRUE
                              )
    RETURN NUMBER
  IS
    l_dim_parent      usim_space.usim_id_spc%TYPE;
    l_spc_id_pos0p    usim_space.usim_id_spc%TYPE;
    l_spc_id_pos1p    usim_space.usim_id_spc%TYPE;
    l_spc_id_pos0n    usim_space.usim_id_spc%TYPE;
    l_spc_id_pos1n    usim_space.usim_id_spc%TYPE;
    l_id_pos0         usim_position.usim_id_pos%TYPE;
    l_id_pos1p        usim_position.usim_id_pos%TYPE;
    l_id_pos1n        usim_position.usim_id_pos%TYPE;
    l_parents         usim_static.usim_ids_type;
    l_next_dim        usim_dimension.usim_n_dimension%TYPE;
    l_usim_id_mlv     usim_multiverse.usim_id_mlv%TYPE;
    l_usim_id_rmd     usim_rel_mlv_dim.usim_id_rmd%TYPE;
    l_usim_id_rmd_p   usim_rel_mlv_dim.usim_id_rmd%TYPE;
    l_usim_id_rmd_n   usim_rel_mlv_dim.usim_id_rmd%TYPE;
    l_dim_sign        usim_rel_mlv_dim.usim_sign%TYPE;
    l_dim_n1_sign     usim_rel_mlv_dim.usim_n1_sign%TYPE;
    l_result          NUMBER;
    l_classify        NUMBER;
  BEGIN
    l_classify := usim_dbif.is_dim_extendable(p_usim_id_spc, l_dim_parent, l_next_dim);
    IF l_classify = 2
    THEN
      -- get data for create dimension
      l_result := usim_dbif.get_spc_dim_details(l_dim_parent, l_usim_id_mlv, l_usim_id_rmd, l_dim_sign, l_dim_n1_sign);
      IF l_result = 0
      THEN
        usim_erl.log_error('usim_creator.handle_overflow_dim', 'Could not fetch data for space id [' || p_usim_id_spc || '].');
        usim_dbif.set_crashed;
        RETURN 0;
      END IF;
      -- create a new dimension on zero pos axis node
      l_result := usim_dbif.create_dim_axis(l_usim_id_mlv, l_next_dim, l_usim_id_rmd, l_usim_id_rmd_p, l_usim_id_rmd_n);
      -- create position 0 and 1 on new dimension
      l_id_pos0      := usim_dbif.get_id_pos(0);
      l_id_pos1p     := usim_dbif.get_id_pos(1);
      l_id_pos1n     := usim_dbif.get_id_pos(-1);
      l_parents(1)   := l_dim_parent;
      l_spc_id_pos0p := usim_dbif.create_space_node(l_usim_id_rmd_p, l_id_pos0, l_parents);
      IF l_spc_id_pos0p IS NULL
      THEN
        usim_erl.log_error('usim_creator.handle_overflow_dim', 'Could not create space id for rmd [' || l_usim_id_rmd_p || '], pos [' || l_id_pos0 || '] and parent [' || l_parents(1) || '].');
        usim_dbif.set_crashed;
        RETURN 0;
      END IF;
      l_parents(1)   := l_spc_id_pos0p;
      l_spc_id_pos1p := usim_dbif.create_space_node(l_usim_id_rmd_p, l_id_pos1p, l_parents);
      IF l_spc_id_pos1p IS NULL
      THEN
        usim_erl.log_error('usim_creator.handle_overflow_dim', 'Could not create space id for rmd [' || l_usim_id_rmd_p || '], pos [' || l_id_pos1p || '] and parent [' || l_parents(1) || '].');
        usim_dbif.set_crashed;
        RETURN 0;
      END IF;
      l_parents(1)   := l_dim_parent;
      l_spc_id_pos0n := usim_dbif.create_space_node(l_usim_id_rmd_n, l_id_pos0, l_parents);
      IF l_spc_id_pos0n IS NULL
      THEN
        usim_erl.log_error('usim_creator.handle_overflow_dim', 'Could not create space id for rmd [' || l_usim_id_rmd_n || '], pos [' || l_id_pos0 || '] and parent [' || l_parents(1) || '].');
        usim_dbif.set_crashed;
        RETURN 0;
      END IF;
      l_parents(1)   := l_spc_id_pos0n;
      l_spc_id_pos1n := usim_dbif.create_space_node(l_usim_id_rmd_n, l_id_pos1n, l_parents);
      IF l_spc_id_pos1n IS NULL
      THEN
        usim_erl.log_error('usim_creator.handle_overflow_dim', 'Could not create space id for rmd [' || l_usim_id_rmd_n || '], pos [' || l_id_pos1n || '] and parent [' || l_parents(1) || '].');
        usim_dbif.set_crashed;
        RETURN 0;
      END IF;
      usim_erl.log_error('usim_creator.handle_overflow_dim', 'Handle new dimension in zero pos for space id [' || p_usim_id_spc || '].');
      RETURN 1;
    ELSIF l_classify = 1
    THEN
      -- connect node to available dimension
      usim_erl.log_error('usim_creator.handle_overflow_dim', 'Not implemented for space id [' || p_usim_id_spc || '].');
    ELSE
      usim_erl.log_error('usim_creator.handle_overflow_dim', 'Not implemented for space id [' || p_usim_id_spc || '].');
    END IF;
    RETURN 1;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_creator.handle_overflow_dim', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END handle_overflow_dim
  ;


  FUNCTION handle_overflow_pos( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                              , p_do_commit   IN BOOLEAN                     DEFAULT TRUE
                              )
    RETURN NUMBER
  IS
    l_result    usim_space.usim_id_spc%TYPE;
    l_parent    usim_space.usim_id_spc%TYPE;
    l_parents   usim_static.usim_ids_type;
    l_id_pos    usim_position.usim_id_pos%TYPE;
    l_id_rmd    usim_rel_mlv_dim.usim_id_rmd%TYPE;
    l_is_valid  NUMBER;
    l_return    NUMBER;
  BEGIN
    l_is_valid := usim_dbif.is_pos_extendable(p_usim_id_spc);
    IF l_is_valid = 0
    THEN
      usim_erl.log_error('usim_creator.handle_overflow_pos', 'Used invalid node id [' || p_usim_id_spc || '] no axis zero pos or no position free.');
      RETURN 0;
    END IF;
    IF l_is_valid = 1
    THEN
      -- new position with parent current given node
      l_parent := p_usim_id_spc;
    ELSE
      -- get max pos for zero nodes using their dimension settings
      l_parent := usim_dbif.get_axis_max_pos_parent(p_usim_id_spc);
      IF l_parent IS NULL
      THEN
        usim_erl.log_error('usim_creator.handle_overflow_pos', 'Could not retrieve max pos parent id from space node [' || p_usim_id_spc || '].');
        RETURN 0;
      END IF;
    END IF;
    l_parents(1) := l_parent;
    -- get next position and axis
    l_return := usim_dbif.get_next_pos_on_axis(l_parent, l_id_pos, l_id_rmd);
    IF l_return = 0
    THEN
      usim_erl.log_error('usim_creator.handle_overflow_pos', 'usim_dbif.get_next_pos_on_axis failed for parent [' || l_parent || '].');
      RETURN 0;
    END IF;
    -- create space node with parent identified
    l_result := usim_dbif.create_space_node(l_id_rmd, l_id_pos, l_parents, p_do_commit);
    IF l_result IS NULL
    THEN
      usim_erl.log_error('usim_creator.handle_overflow_pos', 'Failed to create space node for rmd [' || l_id_rmd || '], pos [' || l_id_pos || '] and parent [' || l_parents(1) || '].');
      RETURN 0;
    END IF;
    RETURN 1;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_creator.handle_overflow_pos', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END handle_overflow_pos
  ;

  FUNCTION handle_overflow( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                          , p_do_commit   IN BOOLEAN                     DEFAULT TRUE
                          )
    RETURN NUMBER
  IS
    l_escape    NUMBER;
    l_result    NUMBER;
  BEGIN
    l_escape := usim_dbif.classify_escape(p_usim_id_spc);

    IF l_escape IN (3, 4)
    THEN
      -- escape position 4 and 3 can be handled together
      l_result := usim_creator.handle_overflow_pos(p_usim_id_spc, p_do_commit);
      IF l_result = 0
      THEN
        usim_erl.log_error('usim_creator.handle_overflow', 'Pos overflow handling error for [' || p_usim_id_spc || '] escape strategy [' || l_escape || '].');
        usim_dbif.set_crashed;
        RETURN 0;
      END IF;
      usim_erl.log_error('usim_creator.handle_overflow', 'Handle pos overflow for [' || p_usim_id_spc || '] escape strategy [' || l_escape || '].');
    ELSIF l_escape = 2
    THEN
      l_result := usim_creator.handle_overflow_dim(p_usim_id_spc, p_do_commit);
      IF l_result = 0
      THEN
        usim_erl.log_error('usim_creator.handle_overflow', 'Dim overflow handling error for [' || p_usim_id_spc || '] escape strategy [' || l_escape || '].');
        usim_dbif.set_crashed;
        RETURN 0;
      END IF;
      usim_erl.log_error('usim_creator.handle_overflow', 'Handle dim overflow for [' || p_usim_id_spc || '] escape strategy [' || l_escape || '].');
    ELSIF l_escape = 1
    THEN
      IF usim_dbif.is_pos_extendable(p_usim_id_spc) = 1
      THEN
        l_result := usim_creator.handle_overflow_pos(p_usim_id_spc, p_do_commit);
      ELSE
        l_result := usim_creator.handle_overflow_dim(p_usim_id_spc, p_do_commit);
      END IF;
      IF l_result = 0
      THEN
        usim_erl.log_error('usim_creator.handle_overflow', 'Pos/dim overflow handling error for [' || p_usim_id_spc || '] escape strategy [' || l_escape || '].');
        usim_dbif.set_crashed;
        RETURN 0;
      END IF;
      usim_erl.log_error('usim_creator.handle_overflow', 'Handle overflow pos/dim for [' || p_usim_id_spc || '] escape strategy [' || l_escape || '].');
    ELSE
      usim_erl.log_error('usim_creator.handle_overflow', 'Should handle overflow for [' || p_usim_id_spc || '] escape strategy [' || l_escape || '].');
    END IF;
    RETURN 1;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_creator.handle_overflow', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END handle_overflow
  ;

END usim_creator;
/