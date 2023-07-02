CREATE OR REPLACE PACKAGE BODY usim_dim IS
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

  FUNCTION has_data(p_usim_id_mlv IN usim_dimension.usim_id_mlv%TYPE)
    RETURN NUMBER
  IS
    l_result  NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_dimension WHERE usim_id_mlv = p_usim_id_mlv;
    RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
  END has_data
  ;

  FUNCTION overflow_reached(p_usim_id_mlv IN usim_dimension.usim_id_mlv%TYPE)
    RETURN NUMBER
  IS
    l_max_dim   usim_dimension.usim_n_dimension%TYPE;
  BEGIN
    IF      usim_base.has_basedata            = 1
       AND  usim_dim.has_data(p_usim_id_mlv)  = 1
    THEN
      SELECT MAX(usim_n_dimension) INTO l_max_dim FROM usim_dimension WHERE usim_id_mlv = p_usim_id_mlv;
      IF l_max_dim = usim_base.get_max_dimension
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

  FUNCTION get_max_dimension(p_usim_id_mlv IN usim_dimension.usim_id_mlv%TYPE)
    RETURN usim_dimension.usim_n_dimension%TYPE
  IS
    l_result  NUMBER;
  BEGIN
    IF usim_dim.has_data(p_usim_id_mlv) = 1
    THEN
      SELECT MAX(usim_n_dimension) INTO l_result FROM usim_dimension WHERE usim_id_mlv = p_usim_id_mlv;
      RETURN l_result;
    ELSE
      RETURN -1;
    END IF;
  END get_max_dimension
  ;

  FUNCTION dimension_exists(p_usim_id_dim IN usim_dimension.usim_id_dim%TYPE)
    RETURN NUMBER
  IS
    l_result  NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_dimension WHERE usim_id_dim = p_usim_id_dim;
    RETURN l_result;
  END dimension_exists
  ;

  FUNCTION get_dimension(p_usim_id_dim IN usim_dimension.usim_id_dim%TYPE)
    RETURN usim_dimension.usim_n_dimension%TYPE
  IS
    l_result usim_dimension.usim_n_dimension%TYPE;
  BEGIN
    IF usim_dim.dimension_exists(p_usim_id_dim) = 1
    THEN
      SELECT usim_n_dimension INTO l_result FROM usim_dimension WHERE usim_id_dim = p_usim_id_dim;
      RETURN l_result;
    ELSE
      RETURN -1;
    END IF;
  END get_dimension
  ;

  FUNCTION insert_next_dimension( p_usim_id_mlv IN usim_dimension.usim_id_mlv%TYPE
                                , p_do_commit   IN BOOLEAN                          DEFAULT TRUE
                                )
    RETURN usim_dimension.usim_id_dim%TYPE
  IS
    l_new_dimension NUMBER;
    l_result        usim_dimension.usim_id_dim%TYPE;
  BEGIN
    IF     usim_mlv.universe_exists(p_usim_id_mlv)  = 1
       AND usim_dim.overflow_reached(p_usim_id_mlv) = 0
    THEN
      l_new_dimension := usim_dim.get_max_dimension(p_usim_id_mlv) + 1;
      INSERT INTO usim_dimension
        ( usim_id_mlv
        , usim_n_dimension
        )
        VALUES
        ( p_usim_id_mlv
        , l_new_dimension
        )
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

END;
/
