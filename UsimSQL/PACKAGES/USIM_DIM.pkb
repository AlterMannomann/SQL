CREATE OR REPLACE PACKAGE BODY usim_dim
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

  FUNCTION overflow_reached
    RETURN NUMBER
  IS
    l_max_dim   NUMBER;
  BEGIN
    IF      usim_base.has_basedata  = 1
       AND  usim_dim.has_data       = 1
    THEN
      SELECT MAX(usim_n_dimension) INTO l_max_dim FROM usim_dimension;
      IF l_max_dim >= usim_base.get_max_dimension
      THEN
        RETURN 1;
      ELSE
        RETURN 0;
      END IF;
    ELSE
      RETURN 0;
    END IF;
  END overflow_reached
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

  FUNCTION dimension_exists(p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE)
    RETURN NUMBER
  IS
    l_result  NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_dimension WHERE usim_n_dimension = p_usim_n_dimension;
    RETURN l_result;
  END dimension_exists
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

  FUNCTION insert_next_dimension(p_do_commit IN BOOLEAN DEFAULT TRUE)
    RETURN usim_dimension.usim_id_dim%TYPE
  IS
    l_new_dimension NUMBER;
    l_result        usim_dimension.usim_id_dim%TYPE;
  BEGIN
    IF usim_dim.overflow_reached = 0
    THEN
      l_new_dimension := usim_dim.get_max_dimension + 1;
      INSERT INTO usim_dimension
        (usim_n_dimension)
        VALUES
        (l_new_dimension)
        RETURNING usim_id_dim INTO l_result
      ;
      IF p_do_commit
      THEN
        COMMIT;
      END IF;
      RETURN l_result;
    ELSE
      RETURN NULL;
    END IF;
  END insert_next_dimension
  ;

END usim_dim;
/