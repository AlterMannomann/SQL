-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
CREATE OR REPLACE PACKAGE BODY &USIM_SCHEMA..usim_apex
IS
  -- see header for documentation
  PROCEDURE run_init_basedata( p_max_dimension    VARCHAR2 DEFAULT '42'
                             , p_max_abs_number   VARCHAR2 DEFAULT '99999999999999999999999999999999999999'
                             , p_special_overflow VARCHAR2 DEFAULT '0'
                             , p_init_dimensions  VARCHAR2 DEFAULT '1'
                             , p_init_positions     VARCHAR2 DEFAULT '1'
                             )
  IS
    l_max_dimension     NUMBER;
    l_max_abs_number    NUMBER;
    l_special_overflow  NUMBER;
    l_result            NUMBER;
    l_result_dim        NUMBER;
    l_result_pos        NUMBER;
    l_par_check         NUMBER;
    l_par_error_msg     VARCHAR2(2000);
  BEGIN
    -- try transform parameters, may raise exception
    l_max_dimension     := NVL(TO_NUMBER(p_max_dimension), 42);
    l_max_abs_number    := NVL(TO_NUMBER(p_max_abs_number), 99999999999999999999999999999999999999);
    l_special_overflow  := NVL(TO_NUMBER(p_special_overflow), 0);
    -- check parameters, usim_base called by usim_dbif will use defaults on wrong parameters
    l_par_check     := 1; -- assume okay
    l_par_error_msg := NULL;
    IF    TRUNC(l_max_dimension) != l_max_dimension -- no integer
       OR l_max_dimension < 0                       -- lower boundary missed
       OR l_max_dimension > 99                      -- upper boundary missed
    THEN
      l_par_check     := 0;
      l_par_error_msg := 'ERROR p_max_dimension value not valid: ' || p_max_dimension;
    END IF;
    IF    TRUNC(l_max_abs_number) != l_max_abs_number               -- no integer
       OR l_max_abs_number < 0                                      -- lower boundary missed
       OR l_max_abs_number > 99999999999999999999999999999999999999 -- upper boundary missed
    THEN
      l_par_check     := 0;
      IF l_par_error_msg IS NULL
      THEN
        l_par_error_msg := 'ERROR p_max_abs_number value not valid: ' || p_max_abs_number;
      ELSE
        l_par_error_msg := l_par_error_msg || ' / ERROR p_max_abs_number value not valid: ' || p_max_abs_number;
      END IF;
    END IF;
    IF l_special_overflow NOT IN (0, 1)
    THEN
      l_par_check     := 0;
      IF l_par_error_msg IS NULL
      THEN
        l_par_error_msg := 'ERROR l_special_overflow value not valid: ' || p_special_overflow;
      ELSE
        l_par_error_msg := l_par_error_msg || ' / ERROR l_special_overflow value not valid: ' || p_special_overflow;
      END IF;
    END IF;
    IF l_par_check = 1
    THEN
      l_result := usim_dbif.init_basedata(l_max_dimension, l_max_abs_number, l_special_overflow);
      IF l_result = 1
      THEN
        -- check if we should init dimensions
        IF p_init_dimensions = '1'
        THEN
          l_result_dim := usim_dbif.init_dimensions;
          IF l_result_dim = 0
          THEN
            -- error init dimensions failed
            usim_erl.log_error('usim_apex.run_init_basedata', 'ERROR: usim_dbif.init_dimensions failed see error log.');
          END IF;
        END IF;
        -- check if we should init numbers
        IF p_init_positions = '1'
        THEN
          l_result_pos := usim_dbif.init_positions;
          IF l_result_pos = 0
          THEN
            -- error init positions failed
            usim_erl.log_error('usim_apex.run_init_basedata', 'ERROR: usim_dbif.init_positions failed see error log.');
          END IF;
        END IF;
      ELSE
        -- error init failed
        usim_erl.log_error('usim_apex.run_init_basedata', 'ERROR: usim_dbif.init_basedata failed see error log.');
      END IF;
    ELSE
        -- parameter error
        usim_erl.log_error('usim_apex.run_init_basedata', l_par_error_msg);
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      usim_erl.log_error('usim_apex.run_init_basedata', 'ERROR: unexpected application error ' || SQLERRM);
  END run_init_basedata
  ;

  FUNCTION disp_has_basedata( p_yes_option    IN VARCHAR2 DEFAULT 'Yes'
                            , p_no_option     IN VARCHAR2 DEFAULT 'No'
                            , p_error_option  IN VARCHAR2 DEFAULT 'ERROR'
                            )
    RETURN VARCHAR2
  IS
    l_return  VARCHAR2(4000);
    l_hasdata NUMBER;
  BEGIN
    l_hasdata := usim_dbif.has_basedata;
    IF l_hasdata = 1
    THEN
      l_return := NVL(p_yes_option, 'Yes');
    ELSIF l_hasdata = 0
    THEN
      l_return := NVL(p_no_option, 'No');
    ELSE
      usim_erl.log_error('usim_apex.disp_has_basedata', 'ERROR: Invalid return value from usim_dbif.has_basedata: ' || l_hasdata);
      l_return := NVL(p_error_option, 'ERROR') || ': invalid return value: ' || CASE WHEN l_hasdata IS NULL THEN 'NULL' ELSE TO_CHAR(l_hasdata) END;
    END IF;
    RETURN l_return;
  EXCEPTION
    WHEN OTHERS THEN
      usim_erl.log_error('usim_apex.disp_has_basedata', 'ERROR: unexpected application error ' || SQLERRM);
      l_return := NVL(p_error_option, 'ERROR') || ': unexpected application error ' || SQLERRM;
      RETURN l_return;
  END disp_has_basedata
  ;

  FUNCTION disp_has_base_universe( p_yes_option    IN VARCHAR2 DEFAULT 'Yes'
                                 , p_no_option     IN VARCHAR2 DEFAULT 'No'
                                 , p_error_option  IN VARCHAR2 DEFAULT 'ERROR'
                                 )
    RETURN VARCHAR2
  IS
    l_return  VARCHAR2(4000);
    l_hasdata NUMBER;
  BEGIN
    l_hasdata := usim_mlv.has_base;
    IF l_hasdata = 1
    THEN
      l_return := NVL(p_yes_option, 'Yes');
    ELSIF l_hasdata = 0
    THEN
      l_return := NVL(p_no_option, 'No');
    ELSE
      usim_erl.log_error('usim_apex.disp_has_base_universe', 'ERROR: Invalid return value from usim_mlv.has_base: ' || l_hasdata);
      l_return := NVL(p_error_option, 'ERROR') || ': invalid return value: ' || CASE WHEN l_hasdata IS NULL THEN 'NULL' ELSE TO_CHAR(l_hasdata) END;
    END IF;
    RETURN l_return;
  EXCEPTION
    WHEN OTHERS THEN
      usim_erl.log_error('usim_apex.disp_has_base_universe', 'ERROR: unexpected application error ' || SQLERRM);
      l_return := NVL(p_error_option, 'ERROR') || ': unexpected application error ' || SQLERRM;
      RETURN l_return;
  END disp_has_base_universe
  ;

  FUNCTION disp_max_dimension( p_none_option  IN VARCHAR2 DEFAULT 'N/A'
                             , p_error_option IN VARCHAR2 DEFAULT 'ERROR'
                             )
    RETURN VARCHAR2
  IS
    l_return  VARCHAR2(4000);
    l_hasdata NUMBER;
  BEGIN
    l_hasdata := usim_dbif.has_basedata;
    IF l_hasdata = 1
    THEN
      l_return := TO_CHAR(usim_base.get_max_dimension);
    ELSIF l_hasdata = 0
    THEN
      l_return := NVL(p_none_option, 'N/A');
    ELSE
      usim_erl.log_error('usim_apex.disp_max_dimension', 'ERROR: Invalid return value from usim_dbif.has_basedata: ' || l_hasdata);
      l_return := NVL(p_error_option, 'ERROR') || ': invalid return value: ' || CASE WHEN l_hasdata IS NULL THEN 'NULL' ELSE TO_CHAR(l_hasdata) END;
    END IF;
    RETURN l_return;
  EXCEPTION
    WHEN OTHERS THEN
      usim_erl.log_error('usim_apex.disp_max_dimension', 'ERROR: unexpected application error ' || SQLERRM);
      l_return := NVL(p_error_option, 'ERROR') || ': unexpected application error ' || SQLERRM;
      RETURN l_return;
  END disp_max_dimension
  ;

  FUNCTION disp_max_numbers( p_none_option  IN VARCHAR2 DEFAULT 'N/A'
                           , p_error_option IN VARCHAR2 DEFAULT 'ERROR'
                           )
    RETURN VARCHAR2
  IS
    l_return  VARCHAR2(4000);
    l_hasdata NUMBER;
  BEGIN
    l_hasdata := usim_dbif.has_basedata;
    IF l_hasdata = 1
    THEN
      l_return := '+' || TRIM(TO_CHAR(usim_base.get_abs_max_number)) ||
                  CHR(10) ||
                  TRIM(TO_CHAR(usim_base.get_abs_max_number * -1))
      ;
    ELSIF l_hasdata = 0
    THEN
      l_return := NVL(p_none_option, 'N/A');
    ELSE
      usim_erl.log_error('usim_apex.disp_max_numbers', 'ERROR: Invalid return value from usim_dbif.has_basedata: ' || l_hasdata);
      l_return := NVL(p_error_option, 'ERROR') || ': invalid return value: ' || CASE WHEN l_hasdata IS NULL THEN 'NULL' ELSE TO_CHAR(l_hasdata) END;
    END IF;
    RETURN l_return;
  EXCEPTION
    WHEN OTHERS THEN
      usim_erl.log_error('usim_apex.disp_max_numbers', 'ERROR: unexpected application error ' || SQLERRM);
      l_return := NVL(p_error_option, 'ERROR') || ': unexpected application error ' || SQLERRM;
      RETURN l_return;
  END disp_max_numbers
  ;

  FUNCTION disp_max_abs_number( p_none_option  IN VARCHAR2 DEFAULT 'N/A'
                              , p_error_option IN VARCHAR2 DEFAULT 'ERROR'
                              )
    RETURN VARCHAR2
  IS
    l_return  VARCHAR2(4000);
    l_hasdata NUMBER;
  BEGIN
    l_hasdata := usim_dbif.has_basedata;
    IF l_hasdata = 1
    THEN
      l_return := TRIM(TO_CHAR(usim_base.get_abs_max_number));
    ELSIF l_hasdata = 0
    THEN
      l_return := NVL(p_none_option, 'N/A');
    ELSE
      usim_erl.log_error('usim_apex.disp_max_abs_number', 'ERROR: Invalid return value from usim_dbif.has_basedata: ' || l_hasdata);
      l_return := NVL(p_error_option, 'ERROR') || ': invalid return value: ' || CASE WHEN l_hasdata IS NULL THEN 'NULL' ELSE TO_CHAR(l_hasdata) END;
    END IF;
    RETURN l_return;
  EXCEPTION
    WHEN OTHERS THEN
      usim_erl.log_error('usim_apex.disp_max_abs_number', 'ERROR: unexpected application error ' || SQLERRM);
      l_return := NVL(p_error_option, 'ERROR') || ': unexpected application error ' || SQLERRM;
      RETURN l_return;
  END disp_max_abs_number
  ;

  FUNCTION disp_last_processed( p_none_option   IN VARCHAR2 DEFAULT 'N/A'
                              , p_format_option IN VARCHAR2 DEFAULT 'DD.MM.YYYY HH24:MI:SS'
                              , p_error_option  IN VARCHAR2 DEFAULT 'ERROR'
                              )
    RETURN VARCHAR2
  IS
    l_return  VARCHAR2(4000);
    l_hasdata NUMBER;
    l_date    DATE;
    l_planck  NUMBER;
    l_format  VARCHAR2(100);
  BEGIN
    l_format  := NVL(p_format_option, 'DD.MM.YYYY HH24:MI:SS');
    l_hasdata := usim_dbif.has_data_spr;
    IF l_hasdata = 1
    THEN
        WITH procs AS
             (SELECT TO_NUMBER(SUBSTR(spr.usim_id_spr, 1, 17)) AS id_date_part
                   , TO_NUMBER(SUBSTR(spr.usim_id_spr, 18)) AS id_sequence
                   , spr.*
                FROM usim_spc_process spr
             )
      SELECT usim_real_time
           , usim_planck_time
        INTO l_date
           , l_planck
        FROM procs
       ORDER BY id_date_part DESC
              , id_sequence DESC
       FETCH NEXT 1 ROWS ONLY
      ;
      l_return := TO_CHAR(l_date, l_format) || ' (planck tick: ' || l_planck || ')';
    ELSIF l_hasdata = 0
    THEN
      l_return := NVL(p_none_option, 'N/A');
    ELSE
      usim_erl.log_error('usim_apex.disp_last_processed', 'ERROR: Invalid return value from usim_dbif.has_data_spr: ' || l_hasdata);
      l_return := NVL(p_error_option, 'ERROR') || ': invalid return value: ' || CASE WHEN l_hasdata IS NULL THEN 'NULL' ELSE TO_CHAR(l_hasdata) END;
    END IF;
    RETURN l_return;
  EXCEPTION
    WHEN OTHERS THEN
      usim_erl.log_error('usim_apex.disp_last_processed', 'ERROR: unexpected application error ' || SQLERRM);
      l_return := NVL(p_error_option, 'ERROR') || ': format option: ' || p_format_option || ' unexpected application error ' || SQLERRM;
      RETURN l_return;
  END disp_last_processed
  ;

  FUNCTION disp_since_last_processed( p_none_option   IN VARCHAR2 DEFAULT 'N/A'
                                    , p_error_option  IN VARCHAR2 DEFAULT 'ERROR'
                                    )
    RETURN VARCHAR2
  IS
    l_return  VARCHAR2(4000);
    l_hasdata NUMBER;
  BEGIN
    l_hasdata := usim_dbif.has_data_spr;
    IF l_hasdata = 1
    THEN
        WITH procs AS
             (SELECT TO_NUMBER(SUBSTR(spr.usim_id_spr, 1, 17)) AS id_date_part
                   , TO_NUMBER(SUBSTR(spr.usim_id_spr, 18)) AS id_sequence
                   , spr.*
                FROM usim_spc_process spr
             )
      SELECT TO_CHAR(SYSTIMESTAMP - usim_real_time)
        INTO l_return
        FROM procs
       ORDER BY id_date_part DESC
              , id_sequence DESC
       FETCH NEXT 1 ROWS ONLY
      ;
    ELSIF l_hasdata = 0
    THEN
      l_return := NVL(p_none_option, 'N/A');
    ELSE
      usim_erl.log_error('usim_apex.disp_since_last_processed', 'ERROR: Invalid return value from usim_dbif.has_data_spr: ' || l_hasdata);
      l_return := NVL(p_error_option, 'ERROR') || ': invalid return value: ' || CASE WHEN l_hasdata IS NULL THEN 'NULL' ELSE TO_CHAR(l_hasdata) END;
    END IF;
    RETURN l_return;
  EXCEPTION
    WHEN OTHERS THEN
      usim_erl.log_error('usim_apex.disp_since_last_processed', 'ERROR: unexpected application error ' || SQLERRM);
      l_return := NVL(p_error_option, 'ERROR') || ': unexpected application error ' || SQLERRM;
      RETURN l_return;
  END disp_since_last_processed
  ;

  FUNCTION disp_processed( p_total_option IN VARCHAR2 DEFAULT 'total'
                         , p_error_option IN VARCHAR2 DEFAULT 'ERROR'
                         )
    RETURN VARCHAR2
  IS
    l_return      VARCHAR2(4000);
    l_hasdata     NUMBER;
    l_total       NUMBER;
    l_processed   NUMBER;
  BEGIN
    l_hasdata := usim_dbif.has_data_spr;
    IF l_hasdata = 1
    THEN
      SELECT COUNT(*) AS total
           , COUNT(CASE WHEN is_processed = 1 THEN 1 END) AS processed
        INTO l_total
           , l_processed
        FROM usim_spc_process
      ;
      l_return := TO_CHAR(l_processed) || ' (' || NVL(p_total_option, 'total') || ': ' || TO_CHAR(l_total) || ')';
    ELSIF l_hasdata = 0
    THEN
      l_return := '0 (' || NVL(p_total_option, 'total') || ': 0)';
    ELSE
      usim_erl.log_error('usim_apex.disp_processed', 'ERROR: Invalid return value from usim_dbif.has_data_spr: ' || l_hasdata);
      l_return := NVL(p_error_option, 'ERROR') || ': invalid return value: ' || CASE WHEN l_hasdata IS NULL THEN 'NULL' ELSE TO_CHAR(l_hasdata) END;
    END IF;
    RETURN l_return;
  EXCEPTION
    WHEN OTHERS THEN
      usim_erl.log_error('usim_apex.disp_processed', 'ERROR: unexpected application error ' || SQLERRM);
      l_return := NVL(p_error_option, 'ERROR') || ': unexpected application error ' || SQLERRM;
      RETURN l_return;
  END disp_processed
  ;

  FUNCTION disp_unprocessed(p_error_option IN VARCHAR2 DEFAULT 'ERROR')
    RETURN VARCHAR2
  IS
    l_return      VARCHAR2(4000);
    l_hasdata     NUMBER;
    l_unprocessed NUMBER;
  BEGIN
    l_hasdata := usim_dbif.has_data_spr;
    IF l_hasdata = 1
    THEN
      SELECT COUNT(*)
        INTO l_unprocessed
        FROM usim_spc_process
       WHERE is_processed != 1
      ;
      l_return := TO_CHAR(l_unprocessed);
    ELSIF l_hasdata = 0
    THEN
      l_return := '0';
    ELSE
      usim_erl.log_error('usim_apex.disp_unprocessed', 'ERROR: Invalid return value from usim_dbif.has_data_spr: ' || l_hasdata);
      l_return := NVL(p_error_option, 'ERROR') || ': invalid return value: ' || CASE WHEN l_hasdata IS NULL THEN 'NULL' ELSE TO_CHAR(l_hasdata) END;
    END IF;
    RETURN l_return;
  EXCEPTION
    WHEN OTHERS THEN
      usim_erl.log_error('usim_apex.disp_unprocessed', 'ERROR: unexpected application error ' || SQLERRM);
      l_return := NVL(p_error_option, 'ERROR') || ': unexpected application error ' || SQLERRM;
      RETURN l_return;
  END disp_unprocessed
  ;

  FUNCTION disp_total_nodes(p_error_option IN VARCHAR2 DEFAULT 'ERROR')
    RETURN VARCHAR2
  IS
    l_return  VARCHAR2(4000);
    l_nodes   NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO l_nodes
      FROM usim_node
    ;
    l_return := TO_CHAR(l_nodes);
    RETURN l_return;
  EXCEPTION
    WHEN OTHERS THEN
      usim_erl.log_error('usim_apex.disp_total_nodes', 'ERROR: unexpected application error ' || SQLERRM);
      l_return := NVL(p_error_option, 'ERROR') || ': unexpected application error ' || SQLERRM;
      RETURN l_return;
  END disp_total_nodes
  ;

  FUNCTION disp_total_universes(p_error_option IN VARCHAR2 DEFAULT 'ERROR')
    RETURN VARCHAR2
  IS
    l_return    VARCHAR2(4000);
    l_universes NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO l_universes
      FROM usim_multiverse
    ;
    l_return := TO_CHAR(l_universes);
    RETURN l_return;
  EXCEPTION
    WHEN OTHERS THEN
      usim_erl.log_error('usim_apex.disp_total_universes', 'ERROR: unexpected application error ' || SQLERRM);
      l_return := NVL(p_error_option, 'ERROR') || ': unexpected application error ' || SQLERRM;
      RETURN l_return;
  END disp_total_universes
  ;

  FUNCTION disp_active_dimensions( p_none_option  IN VARCHAR2 DEFAULT 'N/A'
                                 , p_error_option IN VARCHAR2 DEFAULT 'ERROR'
                                 )
    RETURN VARCHAR2
  IS
    l_return      VARCHAR2(4000);
    l_dimensions  NUMBER;
    l_hasdata     NUMBER;
  BEGIN
    l_hasdata := usim_dbif.has_data_spc;
    IF l_hasdata = 1
    THEN
      SELECT MAX(usim_n_dimension)
        INTO l_dimensions
        FROM usim_spc_v
      ;
      l_return := TO_CHAR(l_dimensions);
    ELSIF l_hasdata = 0
    THEN
      l_return := NVL(p_none_option, 'N/A');
    ELSE
      usim_erl.log_error('usim_apex.disp_active_dimensions', 'ERROR: Invalid return value from usim_dbif.has_data_spc: ' || l_hasdata);
      l_return := NVL(p_error_option, 'ERROR') || ': invalid return value: ' || CASE WHEN l_hasdata IS NULL THEN 'NULL' ELSE TO_CHAR(l_hasdata) END;
    END IF;

    RETURN l_return;
  EXCEPTION
    WHEN OTHERS THEN
      usim_erl.log_error('usim_apex.disp_active_dimensions', 'ERROR: unexpected application error ' || SQLERRM);
      l_return := NVL(p_error_option, 'ERROR') || ': unexpected application error ' || SQLERRM;
      RETURN l_return;
  END disp_active_dimensions
  ;

  FUNCTION disp_minmax_energy( p_none_option  IN VARCHAR2 DEFAULT 'N/A'
                             , p_error_option IN VARCHAR2 DEFAULT 'ERROR'
                             )
    RETURN VARCHAR2
  IS
    l_return      VARCHAR2(4000);
    l_min_energy  NUMBER;
    l_max_energy  NUMBER;
    l_hasdata     NUMBER;
  BEGIN
    l_hasdata := usim_dbif.has_data_spc;
    IF l_hasdata = 1
    THEN
      SELECT MAX(usim_energy)
           , MIN(usim_energy)
        INTO l_max_energy
           , l_min_energy
        FROM usim_spc_v
      ;
      l_return := '+' || TO_CHAR(l_max_energy) ||
                  CHR(10) ||
                  TO_CHAR(l_min_energy)
      ;
    ELSIF l_hasdata = 0
    THEN
      l_return := NVL(p_none_option, 'N/A');
    ELSE
      usim_erl.log_error('usim_apex.disp_minmax_energy', 'ERROR: Invalid return value from usim_dbif.has_data_spc: ' || l_hasdata);
      l_return := NVL(p_error_option, 'ERROR') || ': invalid return value: ' || CASE WHEN l_hasdata IS NULL THEN 'NULL' ELSE TO_CHAR(l_hasdata) END;
    END IF;

    RETURN l_return;
  EXCEPTION
    WHEN OTHERS THEN
      usim_erl.log_error('usim_apex.disp_minmax_energy', 'ERROR: unexpected application error ' || SQLERRM);
      l_return := NVL(p_error_option, 'ERROR') || ': unexpected application error ' || SQLERRM;
      RETURN l_return;
  END disp_minmax_energy
  ;

  FUNCTION disp_minmax_coords( p_none_option  IN VARCHAR2 DEFAULT 'N/A'
                             , p_error_option IN VARCHAR2 DEFAULT 'ERROR'
                             )
    RETURN VARCHAR2
  IS
    l_return      VARCHAR2(4000);
    l_min_coord   NUMBER;
    l_max_coord   NUMBER;
    l_hasdata     NUMBER;
  BEGIN
    l_hasdata := usim_dbif.has_data_spc;
    IF l_hasdata = 1
    THEN
      SELECT MAX(usim_coordinate)
           , MIN(usim_coordinate)
        INTO l_max_coord
           , l_min_coord
        FROM usim_spc_v
      ;
      l_return := '+' || TO_CHAR(l_max_coord) ||
                  CHR(10) ||
                  TO_CHAR(l_min_coord)
      ;
    ELSIF l_hasdata = 0
    THEN
      l_return := NVL(p_none_option, 'N/A');
    ELSE
      usim_erl.log_error('usim_apex.disp_minmax_coords', 'ERROR: Invalid return value from usim_dbif.has_data_spc: ' || l_hasdata);
      l_return := NVL(p_error_option, 'ERROR') || ': invalid return value: ' || CASE WHEN l_hasdata IS NULL THEN 'NULL' ELSE TO_CHAR(l_hasdata) END;
    END IF;

    RETURN l_return;
  EXCEPTION
    WHEN OTHERS THEN
      usim_erl.log_error('usim_apex.disp_minmax_coords', 'ERROR: unexpected application error ' || SQLERRM);
      l_return := NVL(p_error_option, 'ERROR') || ': unexpected application error ' || SQLERRM;
      RETURN l_return;
  END disp_minmax_coords
  ;

  FUNCTION disp_max_overflow( p_none_option  IN VARCHAR2 DEFAULT 'N/A'
                            , p_error_option IN VARCHAR2 DEFAULT 'ERROR'
                            )
    RETURN VARCHAR2
  IS
    l_return  VARCHAR2(4000);
    l_hasdata NUMBER;
  BEGIN
    l_hasdata := usim_dbif.has_basedata;
    IF l_hasdata = 1
    THEN
      l_return := '+' || disp_max_abs_number;
    ELSIF l_hasdata = 0
    THEN
      l_return := NVL(p_none_option, 'N/A');
    ELSE
      usim_erl.log_error('usim_apex.disp_max_overflow', 'ERROR: Invalid return value from usim_dbif.has_basedata: ' || l_hasdata);
      l_return := NVL(p_error_option, 'ERROR') || ': invalid return value: ' || CASE WHEN l_hasdata IS NULL THEN 'NULL' ELSE TO_CHAR(l_hasdata) END;
    END IF;
    RETURN l_return;
  END disp_max_overflow
  ;

  FUNCTION disp_min_overflow( p_none_option  IN VARCHAR2 DEFAULT 'N/A'
                            , p_error_option IN VARCHAR2 DEFAULT 'ERROR'
                            )
    RETURN VARCHAR2
  IS
    l_return  VARCHAR2(4000);
    l_hasdata NUMBER;
  BEGIN
    l_hasdata := usim_dbif.has_basedata;
    IF l_hasdata = 1
    THEN
      l_return := '-' || disp_max_abs_number;
    ELSIF l_hasdata = 0
    THEN
      l_return := NVL(p_none_option, 'N/A');
    ELSE
      usim_erl.log_error('usim_apex.disp_min_overflow', 'ERROR: Invalid return value from usim_dbif.has_basedata: ' || l_hasdata);
      l_return := NVL(p_error_option, 'ERROR') || ': invalid return value: ' || CASE WHEN l_hasdata IS NULL THEN 'NULL' ELSE TO_CHAR(l_hasdata) END;
    END IF;
    RETURN l_return;
  END disp_min_overflow
  ;

  FUNCTION disp_max_underflow( p_prefix       IN VARCHAR2 DEFAULT NULL
                             , p_none_option  IN VARCHAR2 DEFAULT 'N/A'
                             , p_error_option IN VARCHAR2 DEFAULT 'ERROR'
                             )
    RETURN VARCHAR2
  IS
    l_return  VARCHAR2(4000);
    l_hasdata NUMBER;
  BEGIN
    l_hasdata := usim_dbif.has_basedata;
    IF l_hasdata = 1
    THEN
      IF p_prefix IS NOT NULL
      THEN
        l_return := p_prefix || '+' || TRIM(TO_CHAR(usim_base.get_max_underflow));
      ELSE
        l_return := '+' || TRIM(TO_CHAR(usim_base.get_max_underflow));
      END IF;
    ELSIF l_hasdata = 0
    THEN
      l_return := NVL(p_none_option, 'N/A');
    ELSE
      usim_erl.log_error('usim_apex.disp_max_underflow', 'ERROR: Invalid return value from usim_dbif.has_basedata: ' || l_hasdata);
      l_return := NVL(p_error_option, 'ERROR') || ': invalid return value: ' || CASE WHEN l_hasdata IS NULL THEN 'NULL' ELSE TO_CHAR(l_hasdata) END;
    END IF;
    RETURN l_return;
  END disp_max_underflow
  ;

  FUNCTION disp_min_underflow( p_none_option  IN VARCHAR2 DEFAULT 'N/A'
                             , p_error_option IN VARCHAR2 DEFAULT 'ERROR'
                             )
    RETURN VARCHAR2
  IS
    l_return  VARCHAR2(4000);
    l_hasdata NUMBER;
  BEGIN
    l_hasdata := usim_dbif.has_basedata;
    IF l_hasdata = 1
    THEN
      l_return := TRIM(TO_CHAR(usim_base.get_min_underflow));
    ELSIF l_hasdata = 0
    THEN
      l_return := NVL(p_none_option, 'N/A');
    ELSE
      usim_erl.log_error('usim_apex.disp_min_underflow', 'ERROR: Invalid return value from usim_dbif.has_basedata: ' || l_hasdata);
      l_return := NVL(p_error_option, 'ERROR') || ': invalid return value: ' || CASE WHEN l_hasdata IS NULL THEN 'NULL' ELSE TO_CHAR(l_hasdata) END;
    END IF;
    RETURN l_return;
  END disp_min_underflow
  ;

  FUNCTION has_dim_data
    RETURN NUMBER
  IS
  BEGIN
    RETURN usim_dim.has_data;
  END has_dim_data
  ;

END usim_apex;
/