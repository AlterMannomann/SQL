-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
CREATE OR REPLACE PACKAGE BODY &USIM_SCHEMA..usim_dim
IS
  -- see header for documentation
  FUNCTION has_data
    RETURN NUMBER
  IS
    l_result  NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_dimension;
    RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
  END has_data
  ;

  FUNCTION has_data(p_usim_id_dim IN usim_dimension.usim_id_dim%TYPE)
    RETURN NUMBER
  IS
    l_result  NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_dimension WHERE usim_id_dim = p_usim_id_dim;
    RETURN l_result;
  END has_data
  ;

  FUNCTION has_data(p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE)
    RETURN NUMBER
  IS
    l_result  NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_dimension WHERE usim_n_dimension = p_usim_n_dimension;
    RETURN l_result;
  END has_data
  ;

  FUNCTION get_max_dimension
    RETURN usim_dimension.usim_n_dimension%TYPE
  IS
    l_result  NUMBER;
  BEGIN
    IF usim_dim.has_data = 1
    THEN
      SELECT MAX(usim_n_dimension) INTO l_result FROM usim_dimension;
      RETURN l_result;
    ELSE
      RETURN -1;
    END IF;
  END get_max_dimension
  ;

  FUNCTION get_id_dim(p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE)
    RETURN usim_dimension.usim_id_dim%TYPE
  IS
    l_usim_id_dim   usim_dimension.usim_id_dim%TYPE;
  BEGIN
    IF usim_dim.has_data(p_usim_n_dimension) = 1
    THEN
      SELECT usim_id_dim INTO l_usim_id_dim FROM usim_dimension WHERE usim_n_dimension = p_usim_n_dimension;
      RETURN l_usim_id_dim;
    ELSE
      usim_erl.log_error('usim_dim.get_id_dim', 'Used with not existing dimension [' || p_usim_n_dimension || '].');
      RETURN NULL;
    END IF;
  END get_id_dim
  ;

  FUNCTION get_dimension(p_usim_id_dim IN usim_dimension.usim_id_dim%TYPE)
    RETURN usim_dimension.usim_n_dimension%TYPE
  IS
    l_result usim_dimension.usim_n_dimension%TYPE;
  BEGIN
    IF usim_dim.has_data(p_usim_id_dim) = 1
    THEN
      SELECT usim_n_dimension INTO l_result FROM usim_dimension WHERE usim_id_dim = p_usim_id_dim;
      RETURN l_result;
    ELSE
      RETURN -1;
    END IF;
  END get_dimension
  ;

  FUNCTION insert_dimension( p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                           , p_do_commit        IN BOOLEAN                              DEFAULT TRUE
                           )
    RETURN usim_dimension.usim_id_dim%TYPE
  IS
    l_new_dimension NUMBER;
    l_result        usim_dimension.usim_id_dim%TYPE;
  BEGIN
    IF usim_dim.has_data(p_usim_n_dimension) = 1
    THEN
      RETURN usim_dim.get_id_dim(p_usim_n_dimension);
    ELSIF p_usim_n_dimension IS NOT NULL
    THEN
      INSERT INTO usim_dimension (usim_n_dimension) VALUES (ABS(p_usim_n_dimension))
        RETURNING usim_id_dim INTO l_result
      ;
      IF p_do_commit
      THEN
        COMMIT;
      END IF;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_dim.insert_dimension', 'Used with invalid dimension [' || p_usim_n_dimension || '].');
      RETURN NULL;
    END IF;
  END insert_dimension
  ;

  FUNCTION init_dimensions( p_max_dimension IN usim_dimension.usim_n_dimension%TYPE
                          , p_do_commit     IN BOOLEAN                              DEFAULT TRUE
                          )
    RETURN NUMBER
  IS
    l_usim_id_dim usim_dimension.usim_id_dim%TYPE;
  BEGIN
    IF p_max_dimension IS NULL
    THEN
      usim_erl.log_error('usim_dim.init_dimensions', 'Used with invalid max dimension [' || p_max_dimension || '].');
      RETURN 0;
    END IF;
    FOR l_dim IN 0..ABS(p_max_dimension)
    LOOP
      l_usim_id_dim := usim_dim.insert_dimension(l_dim, p_do_commit);
      IF l_usim_id_dim IS NULL
      THEN
        usim_erl.log_error('usim_dim.init_dimensions', 'Error inserting dimension [' || l_dim || '].');
        RETURN 0;
      END IF;
    END LOOP;
    RETURN 1;
  END init_dimensions
  ;

END usim_dim;
/