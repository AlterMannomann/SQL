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
      -- copy file first
      UTL_FILE.FCOPY('USIM_DIR', l_filename, 'USIM_HIST_DIR', l_backup);
      -- delete old file
      UTL_FILE.FREMOVE('USIM_DIR', l_filename);
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
      UTL_FILE.put_raw(l_file, UTL_RAW.CAST_TO_RAW(l_buffer));
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
        l_to_xyz.put('x', usim_dbif.get_dim_coord(rec.usim_id_spc_target, 1));
        l_to_xyz.put('y', usim_dbif.get_dim_coord(rec.usim_id_spc_target, 2));
        l_to_xyz.put('z', usim_dbif.get_dim_coord(rec.usim_id_spc_target, 3));
        l_to_xyz.put('energy', NVL(rec.usim_energy_target, 0));
        l_to_xyz.put('dimension', usim_dbif.get_dimension(rec.usim_id_spc_target));
        l_to_xyz.put('dim_sign', usim_dbif.get_dim_sign(rec.usim_id_spc_target));
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
    l_has_data      NUMBER;
    l_main_object   JSON_OBJECT_T;
    l_node_array    JSON_ARRAY_T;
    l_child_array   JSON_ARRAY_T;
    l_coord_array   JSON_ARRAY_T;
    l_node          JSON_OBJECT_T;
    l_child         JSON_OBJECT_T;

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
    l_main_object.put('universe_id', p_usim_id_mlv);
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
  BEGIN
    usim_erl.log_error('usim_creator.create_new_universe', 'NOT IMPLEMENTED.');
    RETURN NULL;
  END create_new_universe
  ;

END usim_creator;
/