CREATE OR REPLACE PACKAGE BODY usim_rmd
IS
  -- see header for documentation
  FUNCTION has_data
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_rel_mlv_dim;
    RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
  END has_data
  ;

  FUNCTION has_data(p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_rel_mlv_dim WHERE usim_id_rmd = p_usim_id_rmd;
    RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
  END has_data
  ;

  FUNCTION has_data( p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE
                   , p_usim_id_dim IN usim_dimension.usim_id_dim%TYPE
                   )
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_rel_mlv_dim WHERE usim_id_mlv = p_usim_id_mlv AND usim_id_dim = p_usim_id_dim;
    RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
  END has_data
  ;

  FUNCTION has_data( p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE
                   , p_usim_id_dim IN usim_dimension.usim_id_dim%TYPE
                   , p_usim_sign   IN usim_rel_mlv_dim.usim_sign%TYPE
                   )
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    -- we expect one axis or nothing
    SELECT COUNT(*) INTO l_result FROM usim_rel_mlv_dim WHERE usim_id_mlv = p_usim_id_mlv AND usim_id_dim = p_usim_id_dim AND usim_sign = p_usim_sign;
    RETURN l_result;
  END has_data
  ;

  FUNCTION get_max_dimension(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN usim_dimension.usim_n_dimension%TYPE
  IS
    l_result usim_dimension.usim_n_dimension%TYPE;
  BEGIN
      SELECT MAX(usim_n_dimension) INTO l_result FROM usim_rmd_v WHERE usim_id_mlv = p_usim_id_mlv;
      RETURN NVL(l_result, -1);
  END get_max_dimension
  ;

  FUNCTION overflow_reached(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN NUMBER
  IS
  BEGIN
    IF      usim_base.has_basedata  = 1
       AND  usim_rmd.has_data       = 1
    THEN
      IF usim_rmd.get_max_dimension(p_usim_id_mlv) >= usim_base.get_max_dimension
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

  FUNCTION dimension_exists( p_usim_id_mlv      IN usim_multiverse.usim_id_mlv%TYPE
                           , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                           )
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_rmd_v WHERE usim_id_mlv = p_usim_id_mlv AND usim_n_dimension = p_usim_n_dimension;
    RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
  END dimension_exists
  ;

  FUNCTION dimension_exists( p_usim_id_mlv      IN usim_multiverse.usim_id_mlv%TYPE
                           , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                           , p_usim_sign        IN usim_rel_mlv_dim.usim_sign%TYPE
                           )
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_rmd_v WHERE usim_id_mlv = p_usim_id_mlv AND usim_n_dimension = p_usim_n_dimension AND usim_sign = p_usim_sign;
    RETURN l_result;
  END dimension_exists
  ;

  FUNCTION get_dimension(p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE)
    RETURN usim_dimension.usim_n_dimension%TYPE
  IS
    l_result usim_dimension.usim_n_dimension%TYPE;
  BEGIN
    IF usim_rmd.has_data(p_usim_id_rmd) = 1
    THEN
      SELECT usim_n_dimension INTO l_result FROM usim_rmd_v WHERE usim_id_rmd = p_usim_id_rmd;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_rmd.get_dimension', 'Used with not existing id [' || p_usim_id_rmd || '].');
      RETURN NULL;
    END IF;
  END get_dimension
  ;

  FUNCTION get_ultimate_border(p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE)
    RETURN usim_multiverse.usim_ultimate_border%TYPE
  IS
    l_result usim_multiverse.usim_id_mlv%TYPE;
  BEGIN
    IF usim_rmd.has_data(p_usim_id_rmd) = 1
    THEN
      SELECT usim_id_mlv INTO l_result FROM usim_rel_mlv_dim WHERE usim_id_rmd = p_usim_id_rmd;
      RETURN usim_mlv.get_ultimate_border(l_result);
    ELSE
      usim_erl.log_error('usim_rmd.get_ultimate_border', 'Used with not existing id [' || p_usim_id_rmd || '].');
      RETURN -1;
    END IF;
  END get_ultimate_border
  ;

  FUNCTION get_id_rmd( p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE
                     , p_usim_id_dim IN usim_dimension.usim_id_dim%TYPE
                     , p_usim_sign   IN usim_rel_mlv_dim.usim_sign%TYPE   DEFAULT 1
                     )
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
  IS
    l_result usim_rel_mlv_dim.usim_id_rmd%TYPE;
  BEGIN
    IF usim_rmd.has_data(p_usim_id_mlv, p_usim_id_dim, p_usim_sign) = 1
    THEN
      SELECT usim_id_rmd INTO l_result FROM usim_rel_mlv_dim WHERE usim_id_mlv = p_usim_id_mlv AND usim_id_dim = p_usim_id_dim AND usim_sign = p_usim_sign;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_rmd.get_id_rmd', 'Used with not existing universe id [' || p_usim_id_mlv || '] and dimension id [' || p_usim_id_dim || '].');
      RETURN NULL;
    END IF;
  END get_id_rmd
  ;

  FUNCTION get_id_rmd( p_usim_id_mlv      IN usim_multiverse.usim_id_mlv%TYPE
                     , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                     , p_usim_sign        IN usim_rel_mlv_dim.usim_sign%TYPE      DEFAULT 1
                     )
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
  IS
    l_result usim_rel_mlv_dim.usim_id_rmd%TYPE;
  BEGIN
    IF usim_rmd.dimension_exists(p_usim_id_mlv, p_usim_n_dimension, p_usim_sign) = 1
    THEN
      SELECT usim_id_rmd INTO l_result FROM usim_rmd_v WHERE usim_id_mlv = p_usim_id_mlv AND usim_n_dimension = p_usim_n_dimension AND usim_sign = p_usim_sign;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_rmd.get_id_rmd', 'Used with not existing universe id [' || p_usim_id_mlv || '] and dimension [' || p_usim_n_dimension || '].');
      RETURN NULL;
    END IF;
  END get_id_rmd
  ;

  FUNCTION insert_rmd( p_usim_id_mlv  IN usim_multiverse.usim_id_mlv%TYPE
                     , p_usim_id_dim  IN usim_dimension.usim_id_dim%TYPE
                     , p_usim_sign    IN usim_rel_mlv_dim.usim_sign%TYPE
                     , p_usim_n1_sign IN usim_rel_mlv_dim.usim_n1_sign%TYPE
                     , p_do_commit    IN BOOLEAN                           DEFAULT TRUE
                     )
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
  IS
    l_result usim_rel_mlv_dim.usim_id_rmd%TYPE;
  BEGIN
    IF     usim_dim.get_dimension(p_usim_id_dim) = 0
       AND p_usim_sign                          != 0
    THEN
      usim_erl.log_error('usim_rmd.insert_rmd', 'Used with wrong dimension id [' || p_usim_id_dim || '] for sign [' || p_usim_sign || '].');
      RETURN NULL;
    END IF;
    IF (    usim_dim.get_dimension(p_usim_id_dim) > 1
        AND p_usim_n1_sign                   NOT IN (1, -1)
       ) OR
       (    usim_dim.get_dimension(p_usim_id_dim) <= 1
        AND p_usim_n1_sign                        IS NOT NULL
       )
    THEN
      usim_erl.log_error('usim_rmd.insert_rmd', 'Used with wrong dimension id [' || p_usim_id_dim || '] for ancestor sign n = 1 [' || p_usim_n1_sign || '].');
      RETURN NULL;
    END IF;
    IF usim_rmd.has_data(p_usim_id_mlv, p_usim_id_dim, p_usim_sign) = 1
    THEN
      RETURN usim_rmd.get_id_rmd(p_usim_id_mlv, p_usim_id_dim);
    ELSE
      IF     usim_mlv.has_data(p_usim_id_mlv)         = 1
         AND usim_dim.has_data(p_usim_id_dim)         = 1
         AND usim_rmd.overflow_reached(p_usim_id_mlv) = 0
         AND p_usim_sign                             IN (0, 1, -1)
      THEN
        INSERT INTO usim_rel_mlv_dim
          ( usim_id_mlv
          , usim_id_dim
          , usim_sign
          , usim_n1_sign
          )
          VALUES
          ( p_usim_id_mlv
          , p_usim_id_dim
          , p_usim_sign
          , p_usim_n1_sign
          )
          RETURNING usim_id_rmd INTO l_result
        ;
        IF p_do_commit
        THEN
          COMMIT;
        END IF;
        RETURN l_result;
      ELSE
        usim_erl.log_error('usim_rmd.insert_rmd', 'Used with not existing universe id [' || p_usim_id_mlv || '],  dimension id [' || p_usim_id_dim || '] or sign [' || p_usim_sign || '].');
        RETURN NULL;
      END IF;
    END IF;
  END insert_rmd
  ;

  FUNCTION insert_rmd( p_usim_id_mlv      IN usim_multiverse.usim_id_mlv%TYPE
                     , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                     , p_usim_sign        IN usim_rel_mlv_dim.usim_sign%TYPE
                     , p_usim_n1_sign     IN usim_rel_mlv_dim.usim_n1_sign%TYPE
                     , p_do_commit        IN BOOLEAN                              DEFAULT TRUE
                     )
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
  IS
    l_result      usim_rel_mlv_dim.usim_id_rmd%TYPE;
    l_usim_id_dim usim_dimension.usim_id_dim%TYPE;
  BEGIN
    IF     p_usim_n_dimension = 0
       AND p_usim_sign       != 0
    THEN
      usim_erl.log_error('usim_rmd.insert_rmd', 'Used with wrong dimension [' || p_usim_n_dimension || '] for sign [' || p_usim_sign || '].');
      RETURN NULL;
    END IF;
    IF (    p_usim_n_dimension  > 1
        AND p_usim_n1_sign NOT IN (1, -1)
       ) OR
       (    p_usim_n_dimension <= 1
        AND p_usim_n1_sign IS NOT NULL
       )
    THEN
      usim_erl.log_error('usim_rmd.insert_rmd', 'Used with wrong dimension [' || p_usim_n_dimension || '] for ancestor sign n = 1 [' || p_usim_n1_sign || '].');
      RETURN NULL;
    END IF;
    IF usim_rmd.dimension_exists(p_usim_id_mlv, p_usim_n_dimension, p_usim_sign) = 1
    THEN
      RETURN usim_rmd.get_id_rmd(p_usim_id_mlv, p_usim_n_dimension, p_usim_sign);
    ELSE
      IF     usim_mlv.has_data(p_usim_id_mlv)              = 1
         AND usim_dim.dimension_exists(p_usim_n_dimension) = 1
         AND p_usim_sign                                  IN (0, 1, -1)
      THEN
        l_usim_id_dim := usim_dim.get_id_dim(p_usim_n_dimension);
        RETURN usim_rmd.insert_rmd(p_usim_id_mlv, l_usim_id_dim, p_usim_sign, p_usim_n1_sign, p_do_commit);
      ELSE
        usim_erl.log_error('usim_rmd.insert_rmd', 'Used with not existing universe id [' || p_usim_id_mlv || '], dimension [' || p_usim_n_dimension || '] or sign [' || p_usim_sign || '].');
        RETURN NULL;
      END IF;
    END IF;
  END insert_rmd
  ;

END usim_rmd;
/
