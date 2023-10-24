CREATE OR REPLACE PACKAGE BODY usim_spr
IS
  -- see header for documentation

  FUNCTION has_data
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_spc_process;
    RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
  END has_data
  ;

  FUNCTION has_data(p_usim_id_spr IN usim_spc_process.usim_id_spr%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_spc_process WHERE usim_id_spr = p_usim_id_spr;
    RETURN l_result;
  END has_data
  ;

  FUNCTION has_unprocessed
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_spc_process WHERE is_processed = 0;
    RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
  END has_unprocessed
  ;

  FUNCTION is_queue_valid
    RETURN NUMBER
  IS
    l_count       NUMBER;
    l_planck_aeon usim_spc_process.usim_planck_aeon%TYPE;
    l_planck_time usim_spc_process.usim_planck_time%TYPE;
  BEGIN
    IF usim_spr.has_data = 0
    THEN
      RETURN 1;
    ELSE
      IF usim_spr.has_unprocessed = 0
      THEN
        RETURN 0;
      END IF;
      SELECT COUNT(*) INTO l_count FROM (SELECT usim_planck_aeon, usim_planck_time FROM usim_spc_process WHERE is_processed = 0 GROUP BY usim_planck_aeon, usim_planck_time);
      IF l_count != 1
      THEN
        RETURN -1;
      END IF;
      SELECT COUNT(*) INTO l_count FROM usim_spc_process WHERE is_processed = 0;
      IF MOD(l_count, 2) != 0
      THEN
        RETURN -2;
      END IF;
      SELECT usim_planck_aeon, usim_planck_time INTO l_planck_aeon, l_planck_time FROM usim_spc_process WHERE is_processed = 0 GROUP BY usim_planck_aeon, usim_planck_time;
      IF    usim_base.get_planck_aeon_seq_current != l_planck_aeon
         OR usim_base.get_planck_time_current     != l_planck_time
      THEN
        RETURN -1;
      END IF;
      -- all checks passed
      RETURN 1;
    END IF;
  END is_queue_valid
  ;

  FUNCTION get_unprocessed_planck( p_usim_planck_aeon OUT usim_spc_process.usim_planck_aeon%TYPE
                                 , p_usim_planck_time OUT usim_spc_process.usim_planck_time%TYPE
                                 )
    RETURN NUMBER
  IS
    l_return NUMBER;
  BEGIN
    -- can't process not existing data
    IF usim_spr.has_data = 0
    THEN
      RETURN 0;
    END IF;
    l_return := usim_spr.is_queue_valid;
    IF l_return = 1
    THEN
      SELECT usim_planck_aeon, usim_planck_time INTO p_usim_planck_aeon, p_usim_planck_time FROM usim_spc_process WHERE is_processed = 0 GROUP BY usim_planck_aeon, usim_planck_time;
    END IF;
    RETURN l_return;
  END get_unprocessed_planck
  ;

  FUNCTION insert_spr( p_usim_id_spc_source IN usim_space.usim_id_spc%TYPE
                     , p_usim_id_spc_target IN usim_space.usim_id_spc%TYPE
                     , p_usim_energy_source IN usim_spc_process.usim_energy_source%TYPE
                     , p_usim_energy_target IN usim_spc_process.usim_energy_target%TYPE
                     , p_usim_energy_output IN usim_spc_process.usim_energy_output%TYPE
                     , p_do_commit          IN BOOLEAN                                  DEFAULT TRUE
                     )
    RETURN usim_spc_process.usim_id_spr%TYPE
  IS
    l_result usim_spc_process.usim_id_spr%TYPE;
  BEGIN
    -- check parameters
    IF     usim_spc.has_data(p_usim_id_spc_source) = 1
       AND usim_spc.has_data(p_usim_id_spc_target) = 1
       AND p_usim_energy_source                   IS NOT NULL
       AND p_usim_energy_output                   IS NOT NULL
    THEN
      INSERT INTO usim_spc_process
        ( usim_planck_aeon
        , usim_planck_time
        , usim_id_spc_source
        , usim_id_spc_target
        , usim_energy_source
        , usim_energy_target
        , usim_energy_output
        )
        VALUES
        ( usim_base.get_planck_aeon_seq_current
        , usim_base.get_planck_time_current
        , p_usim_id_spc_source
        , p_usim_id_spc_target
        , p_usim_energy_source
        , p_usim_energy_target
        , p_usim_energy_output
        )
        RETURNING usim_id_spr INTO l_result
      ;
      IF p_do_commit
      THEN
        COMMIT;
      END IF;
      RETURN l_result;
    ELSE
      -- constraints not fulfilled
      usim_erl.log_error('usim_spr.insert_spr', 'Constraints not fulfilled for process insert of source id [' || p_usim_id_spc_source || '], target id [' || p_usim_id_spc_target || '], source energy [' || p_usim_energy_source || '] and output energy [' || p_usim_energy_output || '].');
      RETURN NULL;
    END IF;
  END insert_spr
  ;

  FUNCTION set_processed( p_usim_id_spr   IN usim_spc_process.usim_id_spr%TYPE
                        , p_process_state IN usim_spc_process.is_processed%TYPE DEFAULT 1
                        , p_do_commit     IN BOOLEAN                            DEFAULT TRUE
                        )
    RETURN NUMBER
  IS
    l_target_id usim_space.usim_id_spc%TYPE;
  BEGIN
    IF     usim_spr.has_data(p_usim_id_spr) = 1
       AND p_process_state                 IN (1, 2)
    THEN
      UPDATE usim_spc_process
         SET is_processed = p_process_state
       WHERE usim_id_spr = p_usim_id_spr
      ;
      IF p_do_commit
      THEN
        COMMIT;
      END IF;
      RETURN 1;
    ELSE
      usim_erl.log_error('usim_spr.set_processed', 'Used with invalid process id [' || p_usim_id_spr || '] or process state [' || p_process_state || '].');
      RETURN 0;
    END IF;
  END set_processed
  ;

END usim_spr;
/