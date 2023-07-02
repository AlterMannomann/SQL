CREATE OR REPLACE PACKAGE BODY usim_base IS
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
    END IF;
    RETURN l_result;
  END get_abs_max_number
  ;

  FUNCTION get_overflow_node_seed
    RETURN NUMBER
  IS
    l_result  NUMBER;
  BEGIN
    IF usim_base.has_basedata = 1
    THEN
      SELECT usim_overflow_node_seed INTO l_result FROM usim_basedata WHERE usim_id_bda = 1;
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
    END IF;
    RETURN l_result;
  END get_planck_time_last
  ;

  FUNCTION get_planck_time_next
    RETURN NUMBER
  IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_result      VARCHAR2(55);
    l_statement   VARCHAR2(1000);
    l_seq_number  NUMBER;
  BEGIN
    IF     usim_base.planck_time_seq_exists
       AND usim_base.has_basedata = 1
    THEN
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
      -- return new current value
      RETURN usim_base.get_planck_time_current;
    ELSE
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
      RETURN NULL;
    END IF;
  END get_planck_aeon_seq_next
  ;

END usim_base;
/