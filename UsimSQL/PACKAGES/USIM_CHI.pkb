CREATE OR REPLACE PACKAGE BODY usim_chi
IS
  -- see header for documentation
  FUNCTION has_data
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_spc_child;
    RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
  END has_data
  ;

  FUNCTION has_data(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO l_result
      FROM usim_spc_child
     WHERE usim_id_spc       = p_usim_id_spc
        OR usim_id_spc_child = p_usim_id_spc
    ;
    RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
  END has_data
  ;

  FUNCTION has_data( p_usim_id_spc       IN usim_space.usim_id_spc%TYPE
                   , p_usim_id_spc_child IN usim_space.usim_id_spc%TYPE
                   )
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO l_result
      FROM usim_spc_child
     WHERE usim_id_spc       = p_usim_id_spc
       AND usim_id_spc_child = p_usim_id_spc_child
    ;
    RETURN l_result;
  END has_data
  ;

  FUNCTION has_parent(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_spc_child WHERE usim_id_spc_child = p_usim_id_spc;
    RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
  END has_parent
  ;

  FUNCTION has_child(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_spc_child WHERE usim_id_spc = p_usim_id_spc;
    RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
  END has_child
  ;

  FUNCTION has_child_same_universe(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result
      FROM usim_spc_child chi
      LEFT OUTER JOIN usim_spc_v spc_parent
        ON chi.usim_id_spc = spc_parent.usim_id_spc
      LEFT OUTER JOIN usim_spc_v spc_child
        ON chi.usim_id_spc_child = spc_child.usim_id_spc
     WHERE chi.usim_id_spc        = p_usim_id_spc
       AND spc_parent.usim_id_mlv = spc_child.usim_id_mlv
    ;
    RETURN l_result;
  END has_child_same_universe
  ;

  FUNCTION has_parent_same_universe(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result
      FROM usim_spc_child chi
      LEFT OUTER JOIN usim_spc_v spc_parent
        ON chi.usim_id_spc = spc_parent.usim_id_spc
      LEFT OUTER JOIN usim_spc_v spc_child
        ON chi.usim_id_spc_child = spc_child.usim_id_spc
     WHERE chi.usim_id_spc_child  = p_usim_id_spc
       AND spc_parent.usim_id_mlv = spc_child.usim_id_mlv
    ;
    RETURN l_result;
  END has_parent_same_universe
  ;

  FUNCTION has_child_next_dim(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result    NUMBER;
  BEGIN
    IF usim_chi.has_child(p_usim_id_spc) = 1
    THEN
      SELECT COUNT(*)
        INTO l_result
        FROM usim_chi_v
       WHERE usim_id_spc            = p_usim_id_spc
         AND (parent_dimension + 1) = child_dimension
      ;
      RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
    ELSE
      usim_erl.log_error('usim_chi.has_child_next_dim', 'No child for space id [' || p_usim_id_spc || '].');
      RETURN 0;
    END IF;
  END has_child_next_dim
  ;

  FUNCTION has_child_at_dim( p_usim_id_spc      IN usim_space.usim_id_spc%TYPE
                           , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                           )
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    IF usim_chi.has_child(p_usim_id_spc) = 1
    THEN
      SELECT COUNT(*)
        INTO l_result
        FROM usim_chi_v
       WHERE usim_id_spc     = p_usim_id_spc
         AND child_dimension = p_usim_n_dimension
      ;
      RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
    ELSE
      usim_erl.log_error('usim_chi.has_child_at_dim', 'No child for space id [' || p_usim_id_spc || '] at dimension [' || p_usim_n_dimension || '].');
      RETURN 0;
    END IF;
  END has_child_at_dim
  ;

  FUNCTION has_parent_at_dim( p_usim_id_spc      IN usim_space.usim_id_spc%TYPE
                            , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                            )
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    IF usim_chi.has_child(p_usim_id_spc) = 1
    THEN
      SELECT COUNT(*)
        INTO l_result
        FROM usim_chi_v
       WHERE usim_id_spc_child = p_usim_id_spc
         AND parent_dimension  = p_usim_n_dimension
      ;
      RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
    ELSE
      usim_erl.log_error('usim_chi.has_parent_at_dim', 'No parent for space id [' || p_usim_id_spc || '] at dimension [' || p_usim_n_dimension || '].');
      RETURN 0;
    END IF;
  END has_parent_at_dim
  ;

  FUNCTION has_child_same_dim(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result    NUMBER;
  BEGIN
    IF usim_chi.has_child(p_usim_id_spc) = 1
    THEN
      SELECT COUNT(*)
        INTO l_result
        FROM usim_chi_v
       WHERE usim_id_spc      = p_usim_id_spc
         AND parent_id_rmd    = child_id_rmd
      ;
      RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
    ELSE
      usim_erl.log_error('usim_chi.has_child_same_dim', 'No child for space id [' || p_usim_id_spc || '].');
      RETURN 0;
    END IF;
  END has_child_same_dim
  ;

  FUNCTION has_parent_same_dim(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
    l_id_rmd usim_rel_mlv_dim.usim_id_rmd%TYPE;
  BEGIN
    IF usim_chi.has_child(p_usim_id_spc) = 1
    THEN
      SELECT COUNT(*)
        INTO l_result
        FROM usim_chi_v
       WHERE usim_id_spc_child = p_usim_id_spc
         AND parent_id_rmd     = child_id_rmd
      ;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_chi.has_parent_same_dim', 'No child for space id [' || p_usim_id_spc || '].');
      RETURN 0;
    END IF;
  END has_parent_same_dim
  ;

  FUNCTION has_relation( p_usim_id_spc      IN usim_space.usim_id_spc%TYPE
                       , p_usim_id_spc_rel  IN usim_space.usim_id_spc%TYPE
                       )
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO l_result
      FROM usim_spc_child
     WHERE (    usim_id_spc       = p_usim_id_spc
            AND usim_id_spc_child = p_usim_id_spc_rel
           )
        OR (    usim_id_spc       = p_usim_id_spc_rel
            AND usim_id_spc_child = p_usim_id_spc
           )
    ;
    RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
  END has_relation
  ;

  FUNCTION child_count(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
      WITH src AS
           (SELECT spc.usim_id_spc
                 , rmd.usim_id_mlv
              FROM usim_space spc
             INNER JOIN usim_rel_mlv_dim rmd
                ON spc.usim_id_rmd = rmd.usim_id_rmd
             WHERE spc.usim_id_spc = p_usim_id_spc
           )
         , childs AS
           (SELECT chi.usim_id_spc
                 , chi.usim_id_spc_child
                 , rmd.usim_id_mlv AS usim_id_mlv_child
              FROM usim_spc_child chi
             INNER JOIN usim_space spc
                ON chi.usim_id_spc_child = spc.usim_id_spc
             INNER JOIN usim_rel_mlv_dim rmd
                ON spc.usim_id_rmd = rmd.usim_id_rmd
           )
    SELECT COUNT(*)
      INTO l_result
      FROM childs
     INNER JOIN src
        ON childs.usim_id_spc       = src.usim_id_spc
       AND childs.usim_id_mlv_child = src.usim_id_mlv
    ;
    RETURN l_result;
  END child_count
  ;

  FUNCTION child_count_all(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO l_result
      FROM usim_spc_child
     WHERE usim_id_spc   = p_usim_id_spc
    ;
    RETURN l_result;
  END child_count_all
  ;

  FUNCTION parent_count(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
      WITH src AS
           (SELECT spc.usim_id_spc
                 , rmd.usim_id_mlv
              FROM usim_space spc
             INNER JOIN usim_rel_mlv_dim rmd
                ON spc.usim_id_rmd = rmd.usim_id_rmd
             WHERE spc.usim_id_spc = p_usim_id_spc
           )
         , parents AS
           (SELECT chi.usim_id_spc
                 , chi.usim_id_spc_child
                 , rmd.usim_id_mlv AS usim_id_mlv_parent
              FROM usim_spc_child chi
             INNER JOIN usim_space spc
                ON chi.usim_id_spc = spc.usim_id_spc
             INNER JOIN usim_rel_mlv_dim rmd
                ON spc.usim_id_rmd = rmd.usim_id_rmd
           )
    SELECT COUNT(*)
      INTO l_result
      FROM parents
     INNER JOIN src
        ON parents.usim_id_spc_child  = src.usim_id_spc
       AND parents.usim_id_mlv_parent = src.usim_id_mlv
    ;
    RETURN l_result;
  END parent_count
  ;

  FUNCTION parent_count_all(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO l_result
      FROM usim_spc_child
     WHERE usim_id_spc_child = p_usim_id_spc
    ;
    RETURN l_result;
  END parent_count_all
  ;

  FUNCTION get_child_same_dimension(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_space.usim_id_spc%TYPE
  IS
    l_result usim_space.usim_id_spc%TYPE;
  BEGIN
    IF usim_chi.has_child_same_dim(p_usim_id_spc) = 1
    THEN
      SELECT usim_id_spc_child
        INTO l_result
        FROM usim_chi_v
       WHERE usim_id_spc      = p_usim_id_spc
         AND parent_id_rmd    = child_id_rmd
      ;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_chi.get_child_same_dimension', 'Used with space id [' || p_usim_id_spc || '] that has no child in the same dimension.');
      RETURN NULL;
    END IF;
  END get_child_same_dimension
  ;

  FUNCTION get_child_next_dimension(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_space.usim_id_spc%TYPE
  IS
    l_result usim_space.usim_id_spc%TYPE;
  BEGIN
    IF usim_chi.has_child_next_dim(p_usim_id_spc) = 1
    THEN
      SELECT usim_id_spc_child
        INTO l_result
        FROM usim_chi_v
       WHERE usim_id_spc            = p_usim_id_spc
         AND (parent_dimension + 1) = child_dimension
      ;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_chi.get_child_same_dimension', 'Used with space id [' || p_usim_id_spc || '] that has no child in the next dimension.');
      RETURN NULL;
    END IF;
  END get_child_next_dimension
  ;

  FUNCTION get_parent_same_dimension(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_space.usim_id_spc%TYPE
  IS
    l_return usim_space.usim_id_spc%TYPE;
  BEGIN
    IF usim_chi.has_parent_same_dim(p_usim_id_spc) = 1
    THEN
      SELECT usim_id_spc
        INTO l_return
        FROM usim_chi_v
       WHERE usim_id_spc_child = p_usim_id_spc
         AND parent_id_rmd     = child_id_rmd
      ;
      RETURN l_return;
    ELSE
      usim_erl.log_error('usim_chi.get_parent_same_dimension', 'Used with space id [' || p_usim_id_spc || '] that has no parent in the same dimension.');
      RETURN NULL;
    END IF;
  END get_parent_same_dimension
  ;

  FUNCTION get_cur_max_dimension(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_dimension.usim_n_dimension%TYPE
  IS
    l_max_dim usim_dimension.usim_n_dimension%TYPE;
    l_n1_sign usim_rel_mlv_dim.usim_n1_sign%TYPE;
  BEGIN
      SELECT dim_n1_sign INTO l_n1_sign FROM usim_spc_v WHERE usim_id_spc = p_usim_id_spc;
      WITH maxdim AS
           (SELECT MAX(child_dimension) AS max_dim
              FROM usim_chi_v
             WHERE usim_id_spc       = p_usim_id_spc
               AND child_dim_n1_sign = l_n1_sign
             UNION ALL
                   -- consider also possible parenting from higher dimensions
            SELECT MAX(parent_dimension) AS max_dim
              FROM usim_chi_v chip
             WHERE usim_id_spc_child  = p_usim_id_spc
               AND parent_dim_n1_sign = l_n1_sign
           )
    SELECT NVL(MAX(max_dim), 0)
      INTO l_max_dim
      FROM maxdim
    ;
    RETURN l_max_dim;
  END get_cur_max_dimension
  ;

  FUNCTION get_chi_details( p_usim_id_spc  IN  usim_space.usim_id_spc%TYPE
                          , p_parent_count OUT NUMBER
                          , p_child_count  OUT NUMBER
                          )
    RETURN NUMBER
  IS
  BEGIN
    IF usim_chi.has_data(p_usim_id_spc) = 1
    THEN
      SELECT COUNT(*) INTO p_parent_count FROM usim_spc_child WHERE usim_id_spc_child = p_usim_id_spc;
      SELECT COUNT(*) INTO p_child_count FROM usim_spc_child WHERE usim_id_spc = p_usim_id_spc;
      RETURN 1;
    ELSE
      p_parent_count := 0;
      p_child_count  := 0;
      RETURN 0;
    END IF;
  END get_chi_details
  ;

  FUNCTION insert_chi( p_usim_id_spc        IN usim_space.usim_id_spc%TYPE
                     , p_usim_id_spc_child  IN usim_space.usim_id_spc%TYPE
                     , p_do_commit          IN BOOLEAN                     DEFAULT TRUE
                     )
    RETURN NUMBER
  IS
  BEGIN
    IF usim_chi.has_data(p_usim_id_spc, p_usim_id_spc_child) = 1
    THEN
      RETURN 1;
    ELSIF p_usim_id_spc != p_usim_id_spc_child
    THEN
      INSERT INTO usim_spc_child (usim_id_spc, usim_id_spc_child) VALUES (p_usim_id_spc, p_usim_id_spc_child);
        IF p_do_commit
        THEN
          COMMIT;
        END IF;
        RETURN 1;
    ELSE
      usim_erl.log_error('usim_chi.insert_chi', 'Used with equal ids parent [' || p_usim_id_spc || '] child [' || p_usim_id_spc_child || '].');
      RETURN 0;
    END IF;
  END insert_chi
  ;

END usim_chi;
/