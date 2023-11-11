CREATE OR REPLACE PACKAGE BODY usim_base
IS
  -- see header for documentation
  FUNCTION has_basedata
    RETURN NUMBER
  IS
    l_result  NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_basedata;
    RETURN l_result;
  END has_basedata
  ;

  PROCEDURE init_basedata( p_max_dimension            IN NUMBER DEFAULT 42
                         , p_usim_abs_max_number      IN NUMBER DEFAULT 99999999999999999999999999999999999999
                         , p_usim_overflow_node_seed  IN NUMBER DEFAULT 0
                         )
  IS
    l_max_dimension           NUMBER := 42;
    l_usim_abs_max_number     NUMBER := 99999999999999999999999999999999999999;
    l_usim_overflow_node_seed NUMBER := 0;
  BEGIN
    IF usim_base.has_basedata = 0
    THEN
      IF      p_max_dimension IS NOT NULL
         AND  p_max_dimension >= 0
      THEN
        l_max_dimension := p_max_dimension;
      END IF;
      IF      p_usim_abs_max_number IS NOT NULL
         AND  p_usim_abs_max_number >= 0
      THEN
        l_usim_abs_max_number := p_usim_abs_max_number;
      END IF;
      IF p_usim_overflow_node_seed IN (0, 1)
      THEN
        l_usim_overflow_node_seed := p_usim_overflow_node_seed;
      END IF;
      INSERT INTO usim_basedata
        ( usim_max_dimension
        , usim_abs_max_number
        , usim_overflow_node_seed
        )
        VALUES
        ( l_max_dimension
        , l_usim_abs_max_number
        , l_usim_overflow_node_seed
        )
      ;
      COMMIT;
    END IF;
  END init_basedata
  ;

  FUNCTION get_max_dimension
    RETURN NUMBER
  IS
    l_result  NUMBER;
  BEGIN
    IF usim_base.has_basedata = 1
    THEN
      SELECT usim_max_dimension INTO l_result FROM usim_basedata WHERE usim_id_bda = 1;
    ELSE
      usim_erl.log_error('usim_base.get_max_dimension', 'Used without initializing base data');
    END IF;
    RETURN l_result;
  END get_max_dimension
  ;

  FUNCTION get_abs_max_number
    RETURN NUMBER
  IS
    l_result  NUMBER;
  BEGIN
    IF usim_base.has_basedata = 1
    THEN
      SELECT usim_abs_max_number INTO l_result FROM usim_basedata WHERE usim_id_bda = 1;
    ELSE
      usim_erl.log_error('usim_base.get_abs_max_number', 'Used without initializing base data');
    END IF;
    RETURN l_result;
  END get_abs_max_number
  ;

  FUNCTION get_min_number
    RETURN NUMBER
  IS
  BEGIN
    RETURN usim_base.get_abs_max_number * -1;
  END get_min_number
  ;

  FUNCTION get_max_underflow
    RETURN NUMBER
  IS
    l_result    NUMBER;
    l_decimals  INTEGER;
  BEGIN
    IF usim_base.has_basedata = 1
    THEN
      -- build number by number of digits
      l_decimals := LENGTH(TRIM(TO_CHAR(usim_base.get_abs_max_number)));
      l_result := TO_NUMBER(RPAD('0.', 1 + l_decimals, '0') || '1');
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_base.get_max_underflow', 'Used without initializing base data');
      RETURN NULL;
    END IF;
  END get_max_underflow
  ;

  FUNCTION get_min_underflow
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    RETURN usim_base.get_max_underflow * -1;
  END get_min_underflow
  ;

  FUNCTION num_has_overflow(p_check_number IN NUMBER)
    RETURN NUMBER
  IS
  BEGIN
    IF usim_base.has_basedata = 0
    THEN
      usim_erl.log_error('usim_base.num_has_overflow', 'Used without initializing base data');
      RETURN NULL;
    END IF;
    IF p_check_number IS INFINITE
    THEN
      RETURN 0;
    END IF;
    IF ABS(p_check_number) >= 1
    THEN
      -- overflow
      IF ABS(p_check_number) > usim_base.get_abs_max_number
      THEN
        RETURN 1;
      ELSE
        RETURN 0;
      END IF;
    ELSE
      -- underflow
      IF p_check_number > 0
      THEN
        IF p_check_number < usim_base.get_max_underflow
        THEN
          RETURN 1;
        ELSE
          RETURN 0;
        END IF;
      ELSIF p_check_number < 0
      THEN
        IF p_check_number > usim_base.get_min_underflow
        THEN
          RETURN 1;
        ELSE
          RETURN 0;
        END IF;
      ELSE
        RETURN 0;
      END IF;
    END IF;
  END num_has_overflow
  ;

  FUNCTION num_add_has_overflow( p_check_number IN NUMBER
                               , p_add_number   IN NUMBER
                               )
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    l_result := p_check_number + p_add_number;
    RETURN num_has_overflow(l_result);
  END num_add_has_overflow
  ;

  FUNCTION get_overflow_node_seed
    RETURN NUMBER
  IS
    l_result  NUMBER;
  BEGIN
    IF usim_base.has_basedata = 1
    THEN
      SELECT usim_overflow_node_seed INTO l_result FROM usim_basedata WHERE usim_id_bda = 1;
    ELSE
      usim_erl.log_error('usim_base.get_overflow_node_seed', 'Used without initializing base data');
    END IF;
    RETURN l_result;
  END get_overflow_node_seed
  ;

  FUNCTION planck_time_seq_exists
    RETURN BOOLEAN
  IS
    l_result  NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO l_result
      FROM user_sequences
     WHERE sequence_name = usim_static.get_planck_time_seq_name
    ;
    RETURN (l_result = 1);
  END planck_time_seq_exists
  ;

  FUNCTION get_planck_time_current
    RETURN NUMBER
  IS
    l_result  NUMBER;
  BEGIN
    IF usim_base.has_basedata = 1
    THEN
      SELECT usim_planck_time_seq_curr INTO l_result FROM usim_basedata WHERE usim_id_bda = 1;
    ELSE
      usim_erl.log_error('usim_base.get_planck_time_current', 'Used without initializing base data');
    END IF;
    RETURN l_result;
  END get_planck_time_current
  ;

  FUNCTION get_planck_time_last
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    IF usim_base.has_basedata = 1
    THEN
      SELECT usim_planck_time_seq_last INTO l_result FROM usim_basedata WHERE usim_id_bda = 1;
    ELSE
      usim_erl.log_error('usim_base.get_planck_time_last', 'Used without initializing base data');
    END IF;
    RETURN l_result;
  END get_planck_time_last
  ;

  FUNCTION get_planck_time_next
    RETURN NUMBER
  IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_result      VARCHAR2(55);
    l_statement     VARCHAR2(1000);
    l_seq_number    NUMBER;
    l_max_value     NUMBER;
    l_current_tick  NUMBER;
    l_current_aeon  CHAR(55);
    l_update_aeon   BOOLEAN;
  BEGIN
    IF     usim_base.planck_time_seq_exists
       AND usim_base.has_basedata = 1
    THEN
      -- if aeon and time initialized
      l_current_aeon := usim_base.get_planck_aeon_seq_current;
      IF l_current_aeon = usim_static.usim_not_available
      THEN
        -- initialize aeon by update
        l_update_aeon := TRUE;
      END IF;
      l_current_tick := usim_base.get_planck_time_current;
      IF l_current_tick IS NOT NULL
      THEN
        -- check tick overflow
        SELECT max_value
          INTO l_max_value
          FROM user_sequences
         WHERE sequence_name = usim_static.get_planck_time_seq_name
        ;
        IF l_current_tick = l_max_value
        THEN
          l_update_aeon := TRUE;
        END IF;
      ELSE
        l_update_aeon := FALSE;
      END IF;
      -- get sequence
      l_statement := 'SELECT ' || usim_static.get_planck_time_seq_name || '.NEXTVAL FROM dual';
      EXECUTE IMMEDIATE l_statement INTO l_seq_number;
      -- update base data
      UPDATE usim_basedata
         SET usim_planck_time_seq_curr  = l_seq_number
           , usim_updated_by            = SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA')
       WHERE usim_id_bda = 1
      ;
      COMMIT;
      IF l_update_aeon
      THEN
        l_current_aeon := usim_base.get_planck_aeon_seq_next;
      END IF;
      -- return new current value
      RETURN usim_base.get_planck_time_current;
    ELSE
      usim_erl.log_error('usim_base.get_planck_time_next', 'Used without initializing base data or planck time sequence does not exist.');
      RETURN NULL;
    END IF;
  END get_planck_time_next
  ;

  FUNCTION planck_aeon_seq_exists
    RETURN BOOLEAN
  IS
    l_result  NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO l_result
      FROM user_sequences
     WHERE sequence_name = usim_static.get_planck_aeon_seq_name
    ;
    RETURN (l_result = 1);
  END planck_aeon_seq_exists
  ;

  FUNCTION get_planck_aeon_seq_current
    RETURN VARCHAR2
  IS
    l_result  VARCHAR2(55);
  BEGIN
    IF usim_base.has_basedata = 1
    THEN
      SELECT TRIM(usim_planck_aeon_seq_curr) INTO l_result FROM usim_basedata WHERE usim_id_bda = 1;
    ELSE
      usim_erl.log_error('usim_base.get_planck_aeon_seq_current', 'Used without initializing base data.');
    END IF;
    RETURN l_result;
  END get_planck_aeon_seq_current
  ;

  FUNCTION get_planck_aeon_seq_last
    RETURN VARCHAR2
  IS
    l_result  VARCHAR2(55);
  BEGIN
    IF usim_base.has_basedata = 1
    THEN
      SELECT TRIM(usim_planck_aeon_seq_last) INTO l_result FROM usim_basedata WHERE usim_id_bda = 1;
    ELSE
      usim_erl.log_error('usim_base.get_planck_aeon_seq_last', 'Used without initializing base data.');
    END IF;
    RETURN l_result;
  END get_planck_aeon_seq_last
  ;

  FUNCTION get_planck_aeon_seq_next
    RETURN VARCHAR2
  IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_result      VARCHAR2(55);
    l_statement   VARCHAR2(1000);
    l_seq_number  NUMBER;
  BEGIN
    IF     usim_base.planck_aeon_seq_exists
       AND usim_base.has_basedata = 1
    THEN
      -- get sequence
      l_statement := 'SELECT ' || usim_static.get_planck_aeon_seq_name || '.NEXTVAL FROM dual';
      EXECUTE IMMEDIATE l_statement INTO l_seq_number;
      -- build big planck time id
      l_result := usim_static.get_big_pk(l_seq_number);
      -- update base data
      UPDATE usim_basedata
         SET usim_planck_aeon_seq_curr = l_result
           , usim_updated_by           = SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA')
       WHERE usim_id_bda = 1
      ;
      COMMIT;
      -- return new current value
      RETURN usim_base.get_planck_aeon_seq_current;
    ELSE
      usim_erl.log_error('usim_base.get_planck_aeon_seq_next', 'Used without initializing base data or planck aeon sequence does not exist.');
      RETURN NULL;
    END IF;
  END get_planck_aeon_seq_next
  ;

END usim_base;
/