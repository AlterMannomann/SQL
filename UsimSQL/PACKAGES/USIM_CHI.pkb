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
     WHERE usim_id_spc       = NVL(p_usim_id_spc, 'N/A')
       AND usim_id_spc_child = NVL(p_usim_id_spc_child, 'N/A')
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

  FUNCTION has_free_child_dimension(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
    l_id_mlv usim_multiverse.usim_id_mlv%TYPE;
  BEGIN
    IF usim_spc.is_universe_base(p_usim_id_spc) = 1
    THEN
      IF usim_chi.child_count(p_usim_id_spc) < 2
      THEN
        -- if base and less than 2 childs in dimension 1 than dimension is free
        RETURN 1;
      ELSE
        -- if base and 2 childs in dimension 1 than dimension is not free
        RETURN 0;
      END IF;
    ELSE
      IF usim_spc.get_max_dimension(p_usim_id_spc) > usim_spc.get_dimension(p_usim_id_spc)
      THEN
        -- if max dimension is not free, than no dimension is free
        l_result := usim_chi.has_child_at_dim(p_usim_id_spc, usim_spc.get_max_id_rmd(p_usim_id_spc));
        IF l_result = 0
        THEN
          RETURN 1;
        ELSE
          RETURN 0;
        END IF;
      ELSE
        -- no free dimensions
        RETURN 0;
      END IF;
      -- find all dimensions not having childs in all higher available dimension
      SELECT COUNT(*)
        INTO l_result
        FROM usim_rel_mlv_dim rmd
        LEFT OUTER JOIN usim_spc_chi_v scv
          ON rmd.usim_id_rmd = scv.usim_id_rmd
       WHERE rmd.usim_id_mlv                     = l_id_mlv
         AND NVL(scv.usim_id_spc, p_usim_id_spc) = p_usim_id_spc
         AND scv.child_dimension                IS NULL
      ;
      RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
    END IF;
  END has_free_child_dimension
  ;

  FUNCTION has_free_child_position(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
    l_max    NUMBER;
  BEGIN
    IF usim_spc.is_universe_base(p_usim_id_spc) = 1
    THEN
      IF usim_chi.child_count(p_usim_id_spc) < 2
      THEN
        -- if base and less than 2 childs in dimension 1 than position is free
        RETURN 1;
      ELSE
        -- if base and 2 childs in dimension 1 than position is not free
        RETURN 0;
      END IF;
    ELSE
      IF usim_chi.child_count(p_usim_id_spc) < usim_spc.get_max_dimension(p_usim_id_spc)
      THEN
        -- not all childs for every available dimension, position is free
        RETURN 1;
      ELSE
        -- max childs for available dimensions reached
        RETURN 0;
      END IF;
    END IF;
  END has_free_child_position
  ;

  FUNCTION has_escape_situation(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
  BEGIN
    -- do we have overflow on dimensions and positions
    IF      usim_spc.overflow_mlv_dim(p_usim_id_spc) = 1
       AND  usim_spc.overflow_mlv_pos(p_usim_id_spc) = 1
    THEN
      -- total overflow, every node in escape situation
      RETURN 1;
    ELSIF     usim_chi.has_free_child_dimension(p_usim_id_spc) = 0
          AND usim_chi.has_free_child_position(p_usim_id_spc)  = 0
    THEN
      -- specific node in escape situation
      RETURN 1;
    ELSE
      RETURN 0;
    END IF;
  END has_escape_situation
  ;

  FUNCTION has_extend_situation(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_usim_id_mlv usim_multiverse.usim_id_mlv%TYPE;
  BEGIN
    -- do we have overflow on dimensions and positions
    IF      usim_spc.overflow_mlv_dim(p_usim_id_spc) = 1
       AND  usim_spc.overflow_mlv_pos(p_usim_id_spc) = 1
    THEN
      -- total overflow, no extension possible
      RETURN 0;
    END IF;
    IF usim_spc.is_universe_base(p_usim_id_spc) = 1
    THEN
      IF      usim_chi.child_count(p_usim_id_spc) = 0
         AND  usim_base.get_max_dimension         > 0
      THEN
        RETURN 1;
      ELSE
        RETURN 0;
      END IF;
    ELSE
      IF usim_base.get_max_dimension > usim_spc.get_max_dimension(p_usim_id_spc)
      THEN
        RETURN 1;
      END IF;
      IF    usim_base.get_abs_max_number > usim_pos.get_max_coordinate(1)
         OR usim_base.get_abs_max_number > ABS(usim_pos.get_max_coordinate(-1))
      THEN
        RETURN 1;
      END IF;
      RETURN 0;
    END IF;
  END has_extend_situation
  ;

  FUNCTION has_child_next_dim(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result    NUMBER;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      SELECT COUNT(*)
        INTO l_result
        FROM usim_chi_v
       WHERE usim_id_spc            = p_usim_id_spc
         AND (parent_dimension + 1) = child_dimension
      ;
      RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
    ELSE
      usim_erl.log_error('usim_chi.has_child_next_dim', 'Used with not existing space id [' || p_usim_id_spc || '].');
      RETURN 0;
    END IF;
  END has_child_next_dim
  ;

  FUNCTION has_child_same_dim(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result    NUMBER;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      SELECT COUNT(*)
        INTO l_result
        FROM usim_chi_v
       WHERE usim_id_spc      = p_usim_id_spc
         AND parent_id_rmd    = child_id_rmd
      ;
      RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
    ELSE
      usim_erl.log_error('usim_chi.has_child_same_dim', 'Used with not existing space id [' || p_usim_id_spc || '].');
      RETURN 0;
    END IF;
  END has_child_same_dim
  ;

  FUNCTION has_child_at_dim( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                           , p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE
                           )
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      SELECT COUNT(*)
        INTO l_result
        FROM usim_chi_v
       WHERE usim_id_spc  = p_usim_id_spc
         AND child_id_rmd = p_usim_id_rmd
      ;
      IF l_result > 1
      THEN
        IF usim_spc.is_universe_base(p_usim_id_spc) = 0
        THEN
          usim_erl.log_error('usim_chi.has_child_at_dim', 'Data model corrupt space id [' || p_usim_id_spc || '] can have only one child per dimension if not universe base node.');
        END IF;
        RETURN 1;
      ELSE
        RETURN l_result;
      END IF;
    ELSE
      usim_erl.log_error('usim_chi.has_child_at_dim', 'Used with not existing space id [' || p_usim_id_spc || '].');
      RETURN 0;
    END IF;
  END has_child_at_dim
  ;

  FUNCTION has_parent_same_dim(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
    l_id_rmd usim_rel_mlv_dim.usim_id_rmd%TYPE;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      SELECT COUNT(*)
        INTO l_result
        FROM usim_chi_v
       WHERE usim_id_spc_child = p_usim_id_spc
         AND parent_id_rmd    = child_id_rmd
      ;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_chi.has_parent_same_dim', 'Used with not existing space id [' || p_usim_id_spc || '].');
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
    IF     usim_spc.has_data(p_usim_id_spc)     = 1
       AND usim_spc.has_data(p_usim_id_spc_rel) = 1
    THEN
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
    ELSE
      usim_erl.log_error('usim_chi.has_relation', 'Used with not existing space id [' || p_usim_id_spc || '] or rel id [' || p_usim_id_spc_rel || '].');
      RETURN 0;
    END IF;
  END has_relation
  ;

  FUNCTION overflow_rating(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
  BEGIN
    -- do we have overflow on dimensions and positions
    IF      usim_spc.overflow_mlv_dim(p_usim_id_spc) = 1
       AND  usim_spc.overflow_mlv_pos(p_usim_id_spc) = 1
    THEN
      -- total overflow
      RETURN 0;
    ELSIF usim_spc.overflow_mlv_pos(p_usim_id_spc) = 1
    THEN
      -- position overflow
      RETURN 2;
    ELSIF usim_spc.overflow_mlv_dim(p_usim_id_spc) = 1
    THEN
      -- dimension overflow
      RETURN 3;
    ELSE
      -- no overflow
      RETURN 1;
    END IF;
  END overflow_rating
  ;

  FUNCTION child_count(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO l_result
      FROM usim_spc_child
     WHERE usim_id_spc = p_usim_id_spc
    ;
    RETURN l_result;
  END child_count
  ;

  FUNCTION max_child_dimension(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_dimension.usim_n_dimension%TYPE
  IS
    l_result usim_dimension.usim_n_dimension%TYPE;
  BEGIN
    IF usim_chi.child_count(p_usim_id_spc) = 0
    THEN
      l_result := usim_rmd.get_dimension(usim_spc.get_id_rmd(p_usim_id_spc));
    ELSE
      SELECT MAX(child_dimension)
        INTO l_result
        FROM usim_chi_v
       WHERE usim_id_spc = p_usim_id_spc
      ;
    END IF;
    RETURN l_result;
  END max_child_dimension
  ;

  FUNCTION classify_parent(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_count NUMBER;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 0
    THEN
      RETURN -1;
    END IF;
    -- check base entries first
    IF usim_spc.is_universe_base(p_usim_id_spc) = 1
    THEN
      l_count := usim_chi.child_count(p_usim_id_spc);
      IF l_count = 0
      THEN
        RETURN usim_chi.overflow_rating(p_usim_id_spc);
      ELSIF l_count != 2
      THEN
        usim_erl.log_error('usim_chi.classify_parent', 'Data model corrupt for base space id [' || p_usim_id_spc || ']. Either only one side filled or too much childs, count [' || l_count || '].');
        RETURN -1;
      ELSE
        RETURN 0;
      END IF;
    ELSE
      -- we have an entry in the middle of somewhere
      IF usim_chi.has_child(p_usim_id_spc) = 0
      THEN
        -- if no childs, check if the parent can be connected to somewhere
        IF usim_spc.is_from_type(p_usim_id_spc) = 1
        THEN
          -- from is only extendable for ancestors of zero position
          IF usim_spc.is_zero_from_type(p_usim_id_spc) = 1
          THEN
            RETURN usim_chi.overflow_rating(p_usim_id_spc);
          ELSE
            -- check ancestors
            IF usim_chi.has_parent(p_usim_id_spc) = 1
            THEN
              -- connect is possible
              RETURN usim_chi.overflow_rating(p_usim_id_spc);
            ELSE
              usim_erl.log_error('usim_chi.classify_parent', 'Data model corrupt for base space id [' || p_usim_id_spc || ']. From type should have a parent.');
              RETURN -1;
            END IF;
          END IF;
        ELSE
          -- handle to types no childs
          RETURN usim_chi.overflow_rating(p_usim_id_spc);
        END IF;
      ELSE
        -- handle existing childs
        IF usim_spc.is_from_type(p_usim_id_spc) = 1
        THEN
          -- from is only extendable for ancestors of zero position
          IF usim_spc.is_zero_from_type(p_usim_id_spc) = 1
          THEN
            -- can only connect to other dimensions, if no dimension overflow
            IF usim_spc.overflow_mlv_dim(p_usim_id_spc) = 0
            THEN
              RETURN 2;
            ELSE
              RETURN 0;
            END IF;
          ELSE
            -- check ancestors
            IF usim_chi.has_parent(p_usim_id_spc) = 1
            THEN
              IF usim_spc.overflow_mlv_dim(p_usim_id_spc) = 0
              THEN
                RETURN 2;
              ELSE
                RETURN 0;
              END IF;
            ELSE
              usim_erl.log_error('usim_chi.classify_parent', 'Data model corrupt for base space id [' || p_usim_id_spc || ']. From type should have a parent.');
              RETURN -1;
            END IF;
          END IF;
        ELSE
          -- to types
          IF      usim_chi.has_free_child_dimension(p_usim_id_spc) = 1
             AND  usim_chi.has_free_child_position(p_usim_id_spc)  = 1
          THEN
            RETURN 1;
          ELSIF usim_chi.has_free_child_dimension(p_usim_id_spc) = 1
          THEN
            RETURN 2;
          ELSIF usim_chi.has_free_child_position(p_usim_id_spc) = 1
          THEN
            RETURN 3;
          ELSE
            RETURN 0;
          END IF;
        END IF;
      END IF;
    END IF;
  END classify_parent
  ;

  FUNCTION classify_escape(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_class_parent  NUMBER;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 0
    THEN
      usim_erl.log_error('usim_chi.classify_escape', 'Used with not existing space id [' || p_usim_id_spc || '].');
      RETURN -1;
    END IF;
    l_class_parent := classify_parent(p_usim_id_spc);
    IF usim_chi.has_escape_situation(p_usim_id_spc) = 1
    THEN
      -- escape situation given
      IF usim_chi.has_extend_situation(p_usim_id_spc) = 0
      THEN
        -- deliver parent classification, if no extension possible
        IF l_class_parent != -1
        THEN
          RETURN l_class_parent;
        ELSE
          IF usim_spc.get_id_spc_base_universe = p_usim_id_spc
          THEN
            -- extend base universe with new universe
            RETURN 0;
          ELSE
            usim_erl.log_error('usim_chi.classify_escape', 'Used space id [' || p_usim_id_spc || '] is not base universe.');
            RETURN -1;
          END IF;
        END IF;
      ELSE
        -- extension possible
        IF l_class_parent = 0
        THEN
          -- find out possible extension
          IF      usim_base.get_max_dimension > usim_spc.get_max_dimension(p_usim_id_spc)
             AND  (   usim_base.get_abs_max_number > usim_pos.get_max_coordinate(1)
                   OR usim_base.get_abs_max_number > ABS(usim_pos.get_max_coordinate(-1))
                  )
          THEN
            RETURN 1;
          END IF;
          IF usim_base.get_max_dimension > usim_spc.get_max_dimension(p_usim_id_spc)
          THEN
            RETURN 2;
          END IF;
          IF    usim_base.get_abs_max_number > usim_pos.get_max_coordinate(1)
             OR usim_base.get_abs_max_number > ABS(usim_pos.get_max_coordinate(-1))
          THEN
            RETURN 3;
          END IF;
          -- only universe escape left
          RETURN 0;
        ELSE
          -- deliver parent classification already done
          RETURN l_class_parent;
        END IF;
      END IF;
    ELSE
      -- no escape situation
      IF usim_chi.has_extend_situation(p_usim_id_spc) = 0
      THEN
        -- deliver parent classification, if no extension possible
        RETURN l_class_parent;
      ELSE
        -- extension possible
        IF l_class_parent = 0
        THEN
          -- find out possible extension
          IF      usim_base.get_max_dimension > usim_spc.get_max_dimension(p_usim_id_spc)
             AND  (   usim_base.get_abs_max_number > usim_pos.get_max_coordinate(1)
                   OR usim_base.get_abs_max_number > ABS(usim_pos.get_max_coordinate(-1))
                  )
          THEN
            RETURN 1;
          END IF;
          IF usim_base.get_max_dimension > usim_spc.get_max_dimension(p_usim_id_spc)
          THEN
            RETURN 2;
          END IF;
          IF    usim_base.get_abs_max_number > usim_pos.get_max_coordinate(1)
             OR usim_base.get_abs_max_number > ABS(usim_pos.get_max_coordinate(-1))
          THEN
            RETURN 3;
          END IF;
          -- should not happen, no escape and no extension, if extension is possible
          RETURN -1;
        ELSE
          -- deliver parent classification already done
          RETURN l_class_parent;
        END IF;
      END IF;
    END IF;
  END classify_escape
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

  FUNCTION get_child_at_dimension( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                                 , p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE
                                 )
    RETURN usim_space.usim_id_spc%TYPE
  IS
    l_result usim_space.usim_id_spc%TYPE;
  BEGIN
    IF usim_chi.has_child_at_dim(p_usim_id_spc, p_usim_id_rmd) = 1
    THEN
      SELECT usim_id_spc_child
        INTO l_result
        FROM usim_chi_v
       WHERE usim_id_spc  = p_usim_id_spc
         AND child_id_rmd = p_usim_id_rmd
      ;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_chi.get_child_same_dimension', 'Used with space id [' || p_usim_id_spc || '] that has no child in the given dimension id [' || p_usim_id_rmd || '].');
      RETURN NULL;
    END IF;
  END get_child_at_dimension
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

  FUNCTION insert_chi( p_usim_id_spc        IN usim_space.usim_id_spc%TYPE
                     , p_usim_id_spc_child  IN usim_space.usim_id_spc%TYPE
                     , p_do_commit          IN BOOLEAN                     DEFAULT TRUE
                     )
    RETURN usim_space.usim_id_spc%TYPE
  IS
    l_usim_id_spc usim_space.usim_id_spc%TYPE;
    l_result      NUMBER;
  BEGIN
    IF      usim_spc.has_data(p_usim_id_spc)        = 1
       AND  usim_spc.has_data(p_usim_id_spc_child)  = 1
    THEN
      IF usim_chi.has_data(p_usim_id_spc, p_usim_id_spc_child) = 1
      THEN
        RETURN p_usim_id_spc;
      ELSIF p_usim_id_spc != p_usim_id_spc_child
      THEN
        IF     usim_chi.child_count(p_usim_id_spc)      = 0
           AND usim_spc.get_process_spin(p_usim_id_spc) = -1
        THEN
          l_result := usim_spc.flip_process_spin(p_usim_id_spc, p_do_commit);
          IF l_result = 0
          THEN
            usim_erl.log_error('usim_chi.insert_chi', 'Could not flip process spin for id parent [' || p_usim_id_spc || '].');
            RETURN NULL;
          END IF;
        END IF;
        INSERT INTO usim_spc_child (usim_id_spc, usim_id_spc_child) VALUES (p_usim_id_spc, p_usim_id_spc_child) RETURNING usim_id_spc INTO l_usim_id_spc;
        IF p_do_commit
        THEN
          COMMIT;
        END IF;
        RETURN l_usim_id_spc;
      ELSE
        usim_erl.log_error('usim_chi.insert_chi', 'Used with equal ids parent [' || p_usim_id_spc || '] child [' || p_usim_id_spc_child || '].');
        RETURN NULL;
      END IF;
    ELSE
      usim_erl.log_error('usim_chi.insert_chi', 'Used with either not existing or equal ids parent [' || p_usim_id_spc || '] child [' || p_usim_id_spc_child || '].');
      RETURN NULL;
    END IF;
  END insert_chi
  ;

END usim_chi;
/