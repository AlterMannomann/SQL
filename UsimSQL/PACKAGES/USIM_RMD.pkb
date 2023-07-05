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

  FUNCTION dimension_exists( p_usim_id_mlv      IN usim_multiverse.usim_id_mlv%TYPE
                           , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                           )
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_rmd_v WHERE usim_id_mlv = p_usim_id_mlv AND usim_n_dimension = p_usim_n_dimension;
    RETURN l_result;
  END dimension_exists
  ;

  FUNCTION get_id_rmd( p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE
                     , p_usim_id_dim IN usim_dimension.usim_id_dim%TYPE
                     )
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
  IS
    l_result usim_rel_mlv_dim.usim_id_rmd%TYPE;
  BEGIN
    IF usim_rmd.has_data(p_usim_id_mlv, p_usim_id_dim) = 1
    THEN
      SELECT usim_id_rmd INTO l_result FROM usim_rel_mlv_dim WHERE usim_id_mlv = p_usim_id_mlv AND usim_id_dim = p_usim_id_dim;
      RETURN l_result;
    ELSE
      RETURN NULL;
    END IF;
  END get_id_rmd
  ;

  FUNCTION get_id_rmd( p_usim_id_mlv      IN usim_multiverse.usim_id_mlv%TYPE
                     , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                     )
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
  IS
    l_result usim_rel_mlv_dim.usim_id_rmd%TYPE;
  BEGIN
    IF usim_rmd.dimension_exists(p_usim_id_mlv, p_usim_n_dimension) = 1
    THEN
      SELECT usim_id_rmd INTO l_result FROM usim_rmd_v WHERE usim_id_mlv = p_usim_id_mlv AND usim_n_dimension = p_usim_n_dimension;
      RETURN l_result;
    ELSE
      RETURN NULL;
    END IF;
  END get_id_rmd
  ;

  FUNCTION insert_rmd( p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE
                     , p_usim_id_dim IN usim_dimension.usim_id_dim%TYPE
                     , p_do_commit   IN BOOLEAN                           DEFAULT TRUE
                     )
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
  IS
    l_result usim_rel_mlv_dim.usim_id_rmd%TYPE;
  BEGIN
    IF usim_rmd.has_data(p_usim_id_mlv, p_usim_id_dim) = 1
    THEN
      RETURN usim_rmd.get_id_rmd(p_usim_id_mlv, p_usim_id_dim);
    ELSE
      IF     usim_mlv.has_data(p_usim_id_mlv) = 1
         AND usim_dim.has_data(p_usim_id_dim) = 1
      THEN
        INSERT INTO usim_rel_mlv_dim (usim_id_mlv, usim_id_dim) VALUES (p_usim_id_mlv, p_usim_id_dim) RETURNING usim_id_rmd INTO l_result;
        IF p_do_commit
        THEN
          COMMIT;
        END IF;
        RETURN l_result;
      ELSE
        RETURN NULL;
      END IF;
    END IF;
  END insert_rmd
  ;

  FUNCTION insert_rmd( p_usim_id_mlv      IN usim_multiverse.usim_id_mlv%TYPE
                     , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                     , p_do_commit        IN BOOLEAN                              DEFAULT TRUE
                     )
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
  IS
    l_result      usim_rel_mlv_dim.usim_id_rmd%TYPE;
    l_usim_id_dim usim_dimension.usim_id_dim%TYPE;
  BEGIN
    IF usim_rmd.dimension_exists(p_usim_id_mlv, p_usim_n_dimension) = 1
    THEN
      RETURN usim_rmd.get_id_rmd(p_usim_id_mlv, p_usim_n_dimension);
    ELSE
      IF     usim_mlv.has_data(p_usim_id_mlv) = 1
         AND usim_dim.dimension_exists(p_usim_n_dimension) = 1
      THEN
        l_usim_id_dim := usim_dim.get_id_dim(p_usim_n_dimension);
        RETURN usim_rmd.insert_rmd(p_usim_id_mlv, l_usim_id_dim, p_do_commit);
      ELSE
        RETURN NULL;
      END IF;
    END IF;
  END insert_rmd
  ;

END usim_rmd;
/
