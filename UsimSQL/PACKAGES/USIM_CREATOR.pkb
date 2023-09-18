CREATE OR REPLACE PACKAGE BODY usim_creator
IS
  -- see header for documentation

  FUNCTION write_json_log(p_json_clob IN CLOB)
    RETURN NUMBER
  IS
    l_file        UTL_FILE.FILE_TYPE;
    l_filename    VARCHAR2(100);
    l_buffer      VARCHAR2(8191);
    l_bufsize     CONSTANT BINARY_INTEGER := 8191;
    l_pos         PLS_INTEGER;
    l_clob_len    PLS_INTEGER;
    l_clob        CLOB;
    l_file_exist  BOOLEAN;
    l_file_length NUMBER;
    l_block_size  BINARY_INTEGER;
  BEGIN
    l_clob  := p_json_clob;
    UTL_FILE.FGETATTR('USIM_DIR', 'usim_space_log.json', l_file_exist, l_file_length, l_block_size);
    IF l_file_exist
    THEN
      l_filename := 'usim_space_log_' || TO_CHAR(SYSDATE, 'YYYYMMDDHH24MISS') || '.json';
      -- copy file first
      UTL_FILE.FCOPY('USIM_DIR', 'usim_space_log.json', 'USIM_HIST_DIR', l_filename);
      -- delete old file
      UTL_FILE.FREMOVE('USIM_DIR', 'usim_space_log.json');
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
    l_file     := UTL_FILE.FOPEN('USIM_DIR', 'usim_space_log.json', 'WB', l_bufsize);
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
    l_main_object.put('max_number', usim_base.get_abs_max_number);
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
        l_from_xyz.put('x', usim_spo.get_dim_coord(rec.usim_id_spc_source, 1));
        l_from_xyz.put('y', usim_spo.get_dim_coord(rec.usim_id_spc_source, 2));
        l_from_xyz.put('z', usim_spo.get_dim_coord(rec.usim_id_spc_source, 3));
        l_from_xyz.put('energy', rec.usim_energy_source);
        l_from_xyz.put('dimension', usim_spc.get_dimension(rec.usim_id_spc_source));
        l_from_xyz.put('dim_sign', usim_spc.get_dim_sign(rec.usim_id_spc_source));
        l_to_xyz.put('x', usim_spo.get_dim_coord(rec.usim_id_spc_target, 1));
        l_to_xyz.put('y', usim_spo.get_dim_coord(rec.usim_id_spc_target, 2));
        l_to_xyz.put('z', usim_spo.get_dim_coord(rec.usim_id_spc_target, 3));
        l_to_xyz.put('energy', NVL(rec.usim_energy_target, 0));
        l_to_xyz.put('dimension', usim_spc.get_dimension(rec.usim_id_spc_target));
        l_to_xyz.put('dim_sign', usim_spc.get_dim_sign(rec.usim_id_spc_target));
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
        l_file := usim_creator.write_json_log(l_json_log);
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

  FUNCTION init_dimension( p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                         , p_do_commit        IN BOOLEAN                              DEFAULT TRUE
                         )
    RETURN usim_dimension.usim_id_dim%TYPE
  IS
    l_usim_id_dim usim_dimension.usim_id_dim%TYPE;
  BEGIN
    IF    usim_base.has_basedata = 0
       OR p_usim_n_dimension    IS NULL
    THEN
      usim_erl.log_error('usim_creator.init_dimension', 'Used without base data or dimension is NULL.');
      RETURN NULL;
    END IF;
    IF usim_dim.dimension_exists(p_usim_n_dimension) = 1
    THEN
      l_usim_id_dim := usim_dim.get_id_dim(p_usim_n_dimension);
      RETURN l_usim_id_dim;
    ELSE
      -- create next dimension
      IF p_usim_n_dimension <= usim_base.get_max_dimension
      THEN
        LOOP
          l_usim_id_dim := usim_dim.insert_next_dimension(p_do_commit);
          EXIT WHEN p_usim_n_dimension = usim_dim.get_dimension(l_usim_id_dim);
        END LOOP;
        RETURN l_usim_id_dim;
      ELSE
        usim_erl.log_error('usim_creator.init_dimension', 'Used with dimension over max [' || p_usim_n_dimension || '].');
        RETURN NULL;
      END IF;
    END IF;
  END init_dimension
  ;

  FUNCTION init_dim_axis( p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE
                        , p_usim_id_dim IN usim_dimension.usim_id_dim%TYPE
                        , p_usim_sign   IN usim_rel_mlv_dim.usim_sign%TYPE
                        , p_do_commit   IN BOOLEAN                          DEFAULT TRUE
                        )
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
  IS
    l_dim         usim_dimension.usim_n_dimension%TYPE;
    l_usim_id_rmd usim_rel_mlv_dim.usim_id_rmd%TYPE;
  BEGIN
    IF     usim_base.has_basedata           = 1
       AND usim_mlv.has_data(p_usim_id_mlv) = 1
       AND usim_dim.has_data(p_usim_id_dim) = 1
       AND p_usim_sign                     IN (0, 1, -1)
    THEN
      l_dim := usim_dim.get_dimension(p_usim_id_dim);
      IF    (l_dim = 0 AND p_usim_sign = 0)
         OR (l_dim > 0 AND p_usim_sign != 0)
      THEN
        l_usim_id_rmd := usim_rmd.insert_rmd(p_usim_id_mlv, p_usim_id_dim, p_usim_sign, NULL, p_do_commit);
        RETURN l_usim_id_rmd;
      ELSE
        usim_erl.log_error('usim_creator.init_dim_axis', 'Used dimension [' || l_dim || '] and sign [' || p_usim_sign || '] do not match, mlv id [' || p_usim_id_mlv || '], dim id [' || p_usim_id_dim || '].');
        RETURN NULL;
      END IF;
    ELSE
      usim_erl.log_error('usim_creator.init_dim_axis', 'Used without base data or invalid mlv id [' || p_usim_id_mlv || '], dim id [' || p_usim_id_dim || '] or sign [' || p_usim_sign || '].');
      RETURN NULL;
    END IF;
  END init_dim_axis
  ;

  FUNCTION init_dim_all( p_usim_id_mlv      IN usim_multiverse.usim_id_mlv%TYPE
                       , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                       , p_do_commit        IN BOOLEAN                              DEFAULT TRUE
                       )
    RETURN NUMBER
  IS
    l_usim_id_dim   usim_dimension.usim_id_dim%TYPE;
    l_usim_id_rmd   usim_rel_mlv_dim.usim_id_rmd%TYPE;
  BEGIN
    l_usim_id_dim := usim_creator.init_dimension(p_usim_n_dimension, p_do_commit);
    IF l_usim_id_dim IS NULL
    THEN
      usim_erl.log_error('usim_creator.init_dim_all', 'usim_creator.init_dimension failed for dimension [' || p_usim_n_dimension || '].');
      RETURN 0;
    END IF;
    IF p_usim_n_dimension = 0
    THEN
      l_usim_id_rmd := usim_creator.init_dim_axis(p_usim_id_mlv, l_usim_id_dim, 0, p_do_commit);
      IF l_usim_id_rmd IS NULL
      THEN
        usim_erl.log_error('usim_creator.init_dim_all', 'usim_creator.init_dim_axis failed for mlv id [' || p_usim_id_mlv || '], dim id [' || l_usim_id_dim || '] and sign 0.');
        RETURN 0;
      END IF;
    ELSE
      l_usim_id_rmd := usim_creator.init_dim_axis(p_usim_id_mlv, l_usim_id_dim, 1, p_do_commit);
      IF l_usim_id_rmd IS NULL
      THEN
        usim_erl.log_error('usim_creator.init_dim_all', 'usim_creator.init_dim_axis failed for mlv id [' || p_usim_id_mlv || '], dim id [' || l_usim_id_dim || '] and sign 1.');
        RETURN 0;
      END IF;
      l_usim_id_rmd := usim_creator.init_dim_axis(p_usim_id_mlv, l_usim_id_dim, -1, p_do_commit);
      IF l_usim_id_rmd IS NULL
      THEN
        usim_erl.log_error('usim_creator.init_dim_all', 'usim_creator.init_dim_axis failed for mlv id [' || p_usim_id_mlv || '], dim id [' || l_usim_id_dim || '] and sign -1.');
        RETURN 0;
      END IF;
    END IF;
    RETURN 1;
  END init_dim_all
  ;

  FUNCTION init_zero_dim_nodes( p_usim_id_mlv        IN usim_multiverse.usim_id_mlv%TYPE
                              , p_usim_id_spc_parent IN usim_space.usim_id_spc%TYPE
                              , p_usim_n_dimension   IN usim_dimension.usim_n_dimension%TYPE
                              , p_do_commit          IN BOOLEAN                              DEFAULT TRUE
                              )
    RETURN NUMBER
  IS
    l_usim_id_parent  usim_space.usim_id_spc%TYPE;
    l_usim_id_spc0p   usim_space.usim_id_spc%TYPE;
    l_usim_id_spc0n   usim_space.usim_id_spc%TYPE;
    l_usim_id_spc1p   usim_space.usim_id_spc%TYPE;
    l_usim_id_spc1n   usim_space.usim_id_spc%TYPE;
    l_usim_id_rmd     usim_rel_mlv_dim.usim_id_rmd%TYPE;
    l_usim_id_pos     usim_position.usim_id_pos%TYPE;
    l_usim_id_nod     usim_node.usim_id_nod%TYPE;
    l_status          INTEGER;
  BEGIN
    IF     usim_mlv.has_data(p_usim_id_mlv)                                 = 1
       AND usim_spc.has_data(p_usim_id_spc_parent)                          = 1
       AND usim_spc.get_dimension(p_usim_id_spc_parent)                     = (p_usim_n_dimension -1)
       AND usim_spc.get_coordinate(p_usim_id_spc_parent)                    = 0
       AND usim_rmd.dimension_exists(p_usim_id_mlv, p_usim_n_dimension, 1)  = 1
       AND usim_rmd.dimension_exists(p_usim_id_mlv, p_usim_n_dimension, -1) = 1
       AND usim_pos.coordinate_exists(0)                                    = 1
       AND usim_pos.coordinate_exists(1)                                    = 1
       AND usim_pos.coordinate_exists(-1)                                   = 1
    THEN
      -- space nodes
      l_usim_id_rmd := usim_rmd.get_id_rmd(p_usim_id_mlv, p_usim_n_dimension, 1);
      l_usim_id_pos := usim_pos.get_id_pos(0);
      l_usim_id_nod := usim_nod.insert_node(p_do_commit);
      IF l_usim_id_nod IS NULL
      THEN
        usim_erl.log_error('usim_creator.init_zero_dim_nodes', 'usim_nod.insert_node failed.');
        RETURN 0;
      END IF;
      l_usim_id_spc0p := usim_spc.insert_spc(l_usim_id_rmd, l_usim_id_pos, l_usim_id_nod, FALSE);
      IF l_usim_id_spc0p IS NULL
      THEN
        usim_erl.log_error('usim_creator.init_zero_dim_nodes', 'usim_nod.insert_spc failed with rmd id [' || l_usim_id_rmd || '] pos id [' || l_usim_id_pos || '] node id [' || l_usim_id_nod || '].');
        RETURN 0;
      END IF;
      l_usim_id_rmd := usim_rmd.get_id_rmd(p_usim_id_mlv, p_usim_n_dimension, -1);
      l_usim_id_nod := usim_nod.insert_node(p_do_commit);
      IF l_usim_id_nod IS NULL
      THEN
        usim_erl.log_error('usim_creator.init_zero_dim_nodes', 'usim_nod.insert_node failed.');
        RETURN 0;
      END IF;
      l_usim_id_spc0n := usim_spc.insert_spc(l_usim_id_rmd, l_usim_id_pos, l_usim_id_nod, FALSE);
      IF l_usim_id_spc0p IS NULL
      THEN
        usim_erl.log_error('usim_creator.init_zero_dim_nodes', 'usim_nod.insert_spc failed with rmd id [' || l_usim_id_rmd || '] pos id [' || l_usim_id_pos || '] node id [' || l_usim_id_nod || '].');
        RETURN 0;
      END IF;
      l_usim_id_rmd := usim_rmd.get_id_rmd(p_usim_id_mlv, p_usim_n_dimension, 1);
      l_usim_id_pos := usim_pos.get_id_pos(1);
      l_usim_id_nod := usim_nod.insert_node(p_do_commit);
      IF l_usim_id_nod IS NULL
      THEN
        usim_erl.log_error('usim_creator.init_zero_dim_nodes', 'usim_nod.insert_node failed.');
        RETURN 0;
      END IF;
      l_usim_id_spc1p := usim_spc.insert_spc(l_usim_id_rmd, l_usim_id_pos, l_usim_id_nod, FALSE);
      IF l_usim_id_spc1p IS NULL
      THEN
        usim_erl.log_error('usim_creator.init_zero_dim_nodes', 'usim_nod.insert_spc failed with rmd id [' || l_usim_id_rmd || '] pos id [' || l_usim_id_pos || '] node id [' || l_usim_id_nod || '].');
        RETURN 0;
      END IF;
      l_usim_id_rmd := usim_rmd.get_id_rmd(p_usim_id_mlv, p_usim_n_dimension, -1);
      l_usim_id_pos := usim_pos.get_id_pos(-1);
      l_usim_id_nod := usim_nod.insert_node(p_do_commit);
      IF l_usim_id_nod IS NULL
      THEN
        usim_erl.log_error('usim_creator.init_zero_dim_nodes', 'usim_nod.insert_node failed.');
        RETURN 0;
      END IF;
      l_usim_id_spc1n := usim_spc.insert_spc(l_usim_id_rmd, l_usim_id_pos, l_usim_id_nod, FALSE);
      IF l_usim_id_spc1n IS NULL
      THEN
        usim_erl.log_error('usim_creator.init_zero_dim_nodes', 'usim_nod.insert_spc failed with rmd id [' || l_usim_id_rmd || '] pos id [' || l_usim_id_pos || '] node id [' || l_usim_id_nod || '].');
        RETURN 0;
      END IF;
      -- position entries
      l_status := usim_spo.insert_spc_pos(l_usim_id_spc0p, p_usim_id_spc_parent, p_do_commit);
      IF l_status = 0
      THEN
        usim_erl.log_error('usim_creator.init_zero_dim_nodes', 'usim_spo.insert_spc_pos failed With space id [' || l_usim_id_spc0p || ']and parent id [' || p_usim_id_spc_parent || '].');
        RETURN 0;
      END IF;
      l_status := usim_spo.insert_spc_pos(l_usim_id_spc0n, p_usim_id_spc_parent, p_do_commit);
      IF l_status = 0
      THEN
        usim_erl.log_error('usim_creator.init_zero_dim_nodes', 'usim_spo.insert_spc_pos failed With space id [' || l_usim_id_spc0n || ']and parent id [' || p_usim_id_spc_parent || '].');
        RETURN 0;
      END IF;
      l_status := usim_spo.insert_spc_pos(l_usim_id_spc1p, l_usim_id_spc0p, p_do_commit);
      IF l_status = 0
      THEN
        usim_erl.log_error('usim_creator.init_zero_dim_nodes', 'usim_spo.insert_spc_pos failed With space id [' || l_usim_id_spc1p || ']and parent id [' || l_usim_id_spc0p || '].');
        RETURN 0;
      END IF;
      l_status := usim_spo.insert_spc_pos(l_usim_id_spc1n, l_usim_id_spc0n, p_do_commit);
      IF l_status = 0
      THEN
        usim_erl.log_error('usim_creator.init_zero_dim_nodes', 'usim_spo.insert_spc_pos failed With space id [' || l_usim_id_spc1n || ']and parent id [' || l_usim_id_spc0n || '].');
        RETURN 0;
      END IF;
      -- parent relations
      l_usim_id_parent := usim_chi.insert_chi(p_usim_id_spc_parent, l_usim_id_spc0p, p_do_commit);
      IF l_usim_id_parent IS NULL
      THEN
        usim_erl.log_error('usim_creator.init_zero_dim_nodes', 'usim_chi.insert_chi failed with parent id [' || p_usim_id_spc_parent || '] child id [' || l_usim_id_spc0p || '].');
        RETURN 0;
      END IF;
      l_usim_id_parent := usim_chi.insert_chi(p_usim_id_spc_parent, l_usim_id_spc0n, p_do_commit);
      IF l_usim_id_parent IS NULL
      THEN
        usim_erl.log_error('usim_creator.init_zero_dim_nodes', 'usim_chi.insert_chi failed with parent id [' || p_usim_id_spc_parent || '] child id [' || l_usim_id_spc0n || '].');
        RETURN 0;
      END IF;
      l_usim_id_parent := usim_chi.insert_chi(l_usim_id_spc0p, l_usim_id_spc1p, p_do_commit);
      IF l_usim_id_parent IS NULL
      THEN
        usim_erl.log_error('usim_creator.init_zero_dim_nodes', 'usim_chi.insert_chi failed with parent id [' || l_usim_id_spc0p || '] child id [' || l_usim_id_spc1p || '].');
        RETURN 0;
      END IF;
      l_usim_id_parent := usim_chi.insert_chi(l_usim_id_spc0n, l_usim_id_spc1n, p_do_commit);
      IF l_usim_id_parent IS NULL
      THEN
        usim_erl.log_error('usim_creator.init_zero_dim_nodes', 'usim_chi.insert_chi failed with parent id [' || l_usim_id_spc0p || '] child id [' || l_usim_id_spc1p || '].');
        RETURN 0;
      END IF;
      RETURN 1;
    ELSE
      usim_erl.log_error('usim_creator.init_zero_dim_nodes', 'Invalid parameter mlv id [' || p_usim_id_mlv || '], parent id [' || p_usim_id_spc_parent || '] or dimension [' || p_usim_n_dimension || '].');
      RETURN 0;
    END IF;
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
    l_usim_id_mlv   usim_multiverse.usim_id_mlv%TYPE;
    l_status        INTEGER;
    l_usim_id_spc   usim_space.usim_id_spc%TYPE;
    l_usim_id_par   usim_space.usim_id_spc%TYPE;
    l_usim_id_spcp  usim_space.usim_id_spc%TYPE;
    l_usim_id_spcn  usim_space.usim_id_spc%TYPE;
    l_usim_id_rmd   usim_rel_mlv_dim.usim_id_rmd%TYPE;
    l_usim_id_rmdp  usim_rel_mlv_dim.usim_id_rmd%TYPE;
    l_usim_id_rmdn  usim_rel_mlv_dim.usim_id_rmd%TYPE;
    l_usim_id_pos   usim_position.usim_id_pos%TYPE;
    l_usim_id_posp  usim_position.usim_id_pos%TYPE;
    l_usim_id_posn  usim_position.usim_id_pos%TYPE;
    l_usim_id_nod   usim_node.usim_id_nod%TYPE;
    l_usim_id_nodp  usim_node.usim_id_nod%TYPE;
    l_usim_id_nodn  usim_node.usim_id_nod%TYPE;
  BEGIN
    IF usim_base.has_basedata = 0
    THEN
      usim_erl.log_error('usim_creator.create_new_universe', 'Used without base data initialized.');
      RETURN NULL;
    END IF;
    -- universe
    l_usim_id_mlv   := usim_mlv.insert_universe( p_usim_energy_start_value
                                               , p_usim_planck_time_unit
                                               , p_usim_planck_length_unit
                                               , p_usim_planck_speed_unit
                                               , p_usim_planck_stable
                                               , p_usim_ultimate_border
                                               , FALSE
                                               )
                       ;
    IF l_usim_id_mlv IS NULL
    THEN
      ROLLBACK;
      usim_erl.log_error('usim_creator.create_new_universe', 'Unable to create universe usim_mlv.insert_universe(' || p_usim_planck_time_unit || ',' || p_usim_planck_length_unit || ',' || p_usim_planck_speed_unit || ',' || p_usim_planck_stable || ',' || p_usim_ultimate_border || ',FALSE).');
      RETURN NULL;
    END IF;
    -- dimension 0
    l_status := usim_creator.init_dim_all(l_usim_id_mlv, 0, FALSE);
    IF l_status = 0
    THEN
      ROLLBACK;
      usim_erl.log_error('usim_creator.create_new_universe', 'usim_creator.init_dim_all for dimension 0 failed.');
      RETURN NULL;
    END IF;
    -- dimension 1
    l_status := usim_creator.init_dim_all(l_usim_id_mlv, 1, FALSE);
    IF l_status = 0
    THEN
      ROLLBACK;
      usim_erl.log_error('usim_creator.create_new_universe', 'usim_creator.init_dim_all for dimension 1 failed.');
      RETURN NULL;
    END IF;
    l_status := usim_pos.insert_dim_pair(0, FALSE);
    IF l_status = 0
    THEN
      ROLLBACK;
      usim_erl.log_error('usim_creator.create_new_universe', 'usim_pos.insert_dim_pair(0, FALSE) failed.');
      RETURN NULL;
    END IF;
    -- dimension 0
    l_usim_id_rmd := usim_rmd.get_id_rmd(l_usim_id_mlv, 0, 0);
    l_usim_id_pos := usim_pos.get_id_pos(0);
    l_usim_id_nod := usim_nod.insert_node(FALSE);
    IF l_usim_id_nod IS NULL
    THEN
      ROLLBACK;
      usim_erl.log_error('usim_creator.create_new_universe', 'usim_nod.insert_node failed.');
      RETURN NULL;
    END IF;
    l_usim_id_spc := usim_spc.insert_spc(l_usim_id_rmd, l_usim_id_pos, l_usim_id_nod, FALSE);
    IF l_usim_id_spc IS NULL
    THEN
      ROLLBACK;
      usim_erl.log_error('usim_creator.create_new_universe', 'usim_nod.insert_spc failed with rmd id [' || l_usim_id_rmd || '] pos id [' || l_usim_id_pos || '] node id [' || l_usim_id_nod || '].');
      RETURN NULL;
    END IF;
    -- position entry, no parent
    l_status := usim_spo.insert_spc_pos(l_usim_id_spc, NULL, FALSE);
    IF l_status = 0
    THEN
      ROLLBACK;
      usim_erl.log_error('usim_creator.create_new_universe', 'usim_spo.insert_spc_pos failed With space id [' || l_usim_id_spc || '].');
      RETURN NULL;
    END IF;
    -- parent relation
    IF p_usim_id_spc_parent               IS NOT NULL
       AND usim_mlv.is_base(l_usim_id_spc) = 0
    THEN
      l_usim_id_par := usim_chi.insert_chi(p_usim_id_spc_parent, l_usim_id_spc, FALSE);
      IF l_usim_id_par IS NULL
      THEN
        ROLLBACK;
        usim_erl.log_error('usim_creator.create_new_universe', 'usim_chi.insert_chi failed with parent id [' || p_usim_id_spc_parent || '] child id [' || l_usim_id_spc || '].');
        RETURN NULL;
      END IF;
    END IF;
    l_status := usim_creator.init_zero_dim_nodes(l_usim_id_mlv, l_usim_id_spc, 1, FALSE);
    IF l_status = 0
    THEN
      ROLLBACK;
      usim_erl.log_error('usim_creator.create_new_universe', 'usim_creator.init_zero_dim_nodes failed with mlv id [' || l_usim_id_mlv || '] and parent id [' || l_usim_id_spc || '].');
      RETURN NULL;
    END IF;

    -- finally
    IF p_do_commit
    THEN
      COMMIT;
    END IF;
    RETURN l_usim_id_spc;
  END create_new_universe
  ;

END usim_creator;
/