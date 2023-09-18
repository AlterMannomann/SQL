CREATE OR REPLACE PACKAGE BODY usim_spc
IS
  -- see header for documentation
  FUNCTION has_data
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_space;
    RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
  END has_data
  ;

  FUNCTION has_data(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_space WHERE usim_id_spc = p_usim_id_spc;
    RETURN l_result;
  END has_data
  ;

  FUNCTION has_data( p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE
                   , p_usim_id_pos IN usim_position.usim_id_pos%TYPE
                   )
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_spc_v WHERE usim_id_rmd = p_usim_id_rmd AND usim_id_pos = p_usim_id_pos;
    RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
  END has_data
  ;

  FUNCTION has_data( p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE
                   , p_usim_id_pos IN usim_position.usim_id_pos%TYPE
                   , p_usim_id_nod IN usim_node.usim_id_nod%TYPE
                   )
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_space WHERE usim_id_rmd = p_usim_id_rmd AND usim_id_pos = p_usim_id_pos AND usim_id_nod = p_usim_id_nod;
    RETURN l_result;
  END has_data
  ;

  FUNCTION has_free_dimension(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO l_result
      FROM usim_rmd_v rmdv
      LEFT OUTER JOIN usim_space spc
        ON rmdv.usim_id_rmd  = spc.usim_id_rmd
     WHERE rmdv.usim_id_mlv      = p_usim_id_mlv
       AND rmdv.usim_n_dimension > 0
       AND spc.usim_id_rmd      IS NULL
    ;
    RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
  END has_free_dimension
  ;

  FUNCTION has_base_universe
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_spc_v WHERE usim_is_base_universe = 1 AND usim_n_dimension = 0 AND usim_coordinate = 0;
    RETURN l_result;
  END has_base_universe
  ;

  FUNCTION is_universe_base(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_spc_v WHERE usim_id_spc = p_usim_id_spc AND usim_n_dimension = 0 AND usim_coordinate = 0;
    RETURN l_result;
  END is_universe_base
  ;

  FUNCTION is_from_type(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_space WHERE usim_id_spc = p_usim_id_spc;
    RETURN l_result;
  END is_from_type
  ;

  FUNCTION is_zero_from_type(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_spc_v WHERE usim_id_spc = p_usim_id_spc AND usim_n_dimension = 1 AND usim_coordinate = 0;
    RETURN l_result;
  END is_zero_from_type
  ;

  FUNCTION overflow_pos(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result      NUMBER;
    l_max         NUMBER;
    l_usim_id_rmd usim_rel_mlv_dim.usim_id_rmd%TYPE;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      -- fetch value before to avoid self join
      l_usim_id_rmd := usim_spc.get_id_rmd(p_usim_id_spc);
      SELECT MAX(ABS(usim_coordinate))
        INTO l_max
        FROM usim_spc_v
       WHERE usim_id_rmd = l_usim_id_rmd
      ;
      IF l_max >= usim_base.get_abs_max_number
      THEN
        RETURN 1;
      ELSE
        RETURN 0;
      END IF;
    ELSE
      RETURN 0;
    END IF;
  END overflow_pos
  ;

  FUNCTION overflow_mlv_pos(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result      NUMBER;
    l_max         NUMBER;
    l_usim_id_mlv usim_multiverse.usim_id_mlv%TYPE;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      -- fetch value before to avoid self join
      l_usim_id_mlv := usim_spc.get_id_mlv(p_usim_id_spc);
      SELECT MAX(ABS(usim_coordinate))
        INTO l_max
        FROM usim_spc_v
       WHERE usim_id_mlv = l_usim_id_mlv
      ;
      IF l_max >= usim_base.get_abs_max_number
      THEN
        RETURN 1;
      ELSE
        RETURN 0;
      END IF;
    ELSE
      RETURN 0;
    END IF;
  END overflow_mlv_pos
  ;

  FUNCTION overflow_mlv_dim(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result      NUMBER;
    l_max         NUMBER;
    l_usim_id_mlv usim_multiverse.usim_id_mlv%TYPE;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      -- fetch value before to avoid self join
      l_usim_id_mlv := usim_spc.get_id_mlv(p_usim_id_spc);
      SELECT MAX(usim_n_dimension)
        INTO l_max
        FROM usim_spc_v
       WHERE usim_id_mlv = l_usim_id_mlv
      ;
      IF l_max >= usim_base.get_max_dimension
      THEN
        RETURN 1;
      ELSE
        RETURN 0;
      END IF;
    ELSE
      RETURN 0;
    END IF;
  END overflow_mlv_dim
  ;

  FUNCTION get_max_dimension(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_dimension.usim_n_dimension%TYPE
  IS
    l_result      usim_dimension.usim_n_dimension%TYPE;
    l_usim_id_mlv usim_multiverse.usim_id_mlv%TYPE;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      l_usim_id_mlv := usim_spc.get_id_mlv(p_usim_id_spc);
      SELECT NVL(MAX(usim_n_dimension), -1)
        INTO l_result
        FROM usim_rmd_v
       WHERE usim_id_mlv = l_usim_id_mlv
      ;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_spc.get_max_dimension', 'Used not existing id [' || p_usim_id_spc || '].');
      RETURN NULL;
    END IF;
  END get_max_dimension
  ;

  FUNCTION get_cur_max_dimension(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_dimension.usim_n_dimension%TYPE
  IS
    l_result      usim_dimension.usim_n_dimension%TYPE;
    l_usim_id_mlv usim_multiverse.usim_id_mlv%TYPE;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      l_usim_id_mlv := usim_spc.get_id_mlv(p_usim_id_spc);
      SELECT NVL(MAX(usim_n_dimension), -1)
        INTO l_result
        FROM usim_spc_v
       WHERE usim_id_mlv = l_usim_id_mlv
      ;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_spc.get_cur_max_dimension', 'Used not existing id [' || p_usim_id_spc || '].');
      RETURN NULL;
    END IF;
  END get_cur_max_dimension
  ;

  FUNCTION get_id_rmd(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
  IS
    l_result usim_rel_mlv_dim.usim_id_rmd%TYPE;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      SELECT usim_id_rmd INTO l_result FROM usim_space WHERE usim_id_spc = p_usim_id_spc;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_spc.get_id_rmd', 'Used with not existing space id [' || p_usim_id_spc || '].');
      RETURN NULL;
    END IF;
  END get_id_rmd
  ;

  FUNCTION get_id_pos(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_position.usim_id_pos%TYPE
  IS
    l_result usim_position.usim_id_pos%TYPE;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      SELECT usim_id_pos INTO l_result FROM usim_space WHERE usim_id_spc = p_usim_id_spc;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_spc.get_id_pos', 'Used with not existing space id [' || p_usim_id_spc || '].');
      RETURN NULL;
    END IF;
  END get_id_pos
  ;

  FUNCTION get_id_mlv(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_multiverse.usim_id_mlv%TYPE
  IS
    l_result usim_multiverse.usim_id_mlv%TYPE;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      SELECT usim_id_mlv INTO l_result FROM usim_spc_v WHERE usim_id_spc = p_usim_id_spc;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_spc.get_id_mlv', 'Used with not existing space id [' || p_usim_id_spc || '].');
      RETURN NULL;
    END IF;
  END get_id_mlv
  ;

  FUNCTION get_id_nod(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_node.usim_id_nod%TYPE
  IS
    l_result usim_node.usim_id_nod%TYPE;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      SELECT usim_id_nod INTO l_result FROM usim_space WHERE usim_id_spc = p_usim_id_spc;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_spc.get_id_nod', 'Used with not existing space id [' || p_usim_id_spc || '].');
      RETURN NULL;
    END IF;
  END get_id_nod
  ;

  FUNCTION get_id_spc( p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE
                     , p_usim_id_pos IN usim_position.usim_id_pos%TYPE
                     , p_usim_id_nod IN usim_node.usim_id_nod%TYPE
                     )
    RETURN usim_space.usim_id_spc%TYPE
  IS
    l_result usim_space.usim_id_spc%TYPE;
  BEGIN
    IF usim_spc.has_data(p_usim_id_rmd, p_usim_id_pos, p_usim_id_nod) = 1
    THEN
      SELECT usim_id_spc INTO l_result FROM usim_space WHERE usim_id_rmd = p_usim_id_rmd AND usim_id_pos = p_usim_id_pos ANd usim_id_nod = p_usim_id_nod;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_spc.get_id_spc', 'Used with not existing rmd id [' || p_usim_id_rmd || '], pos id [' || p_usim_id_pos || '] or node id [' || p_usim_id_nod || '].');
      RETURN NULL;
    END IF;
  END get_id_spc
  ;

  FUNCTION get_id_spc_base_universe
    RETURN usim_space.usim_id_spc%TYPE
  IS
    l_result usim_space.usim_id_spc%TYPE;
  BEGIN
    IF usim_spc.has_base_universe = 1
    THEN
      SELECT usim_id_spc INTO l_result FROM usim_spc_v WHERE usim_is_base_universe = 1 AND usim_n_dimension = 0 AND usim_coordinate = 0;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_spc.get_id_spc_base_universe', 'Used with not existing base universe.');
      RETURN NULL;
    END IF;
  END get_id_spc_base_universe
  ;

  FUNCTION get_dim_sign(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_rel_mlv_dim.usim_sign%TYPE
  IS
    l_result usim_rel_mlv_dim.usim_sign%TYPE;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      SELECT dim_sign
        INTO l_result
        FROM usim_spc_v
       WHERE usim_id_spc = p_usim_id_spc
      ;
      RETURN l_result;
    ELSE
      -- no space node available
      usim_erl.log_error('usim_spc.get_sign', 'Not existing space id [' || p_usim_id_spc || '].');
      RETURN NULL;
    END IF;
  END get_dim_sign
  ;

  FUNCTION get_dimension(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_dimension.usim_n_dimension%TYPE
  IS
    l_result usim_dimension.usim_n_dimension%TYPE;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      SELECT usim_n_dimension
        INTO l_result
        FROM usim_spc_v
       WHERE usim_id_spc = p_usim_id_spc
      ;
      RETURN l_result;
    ELSE
      -- no space node available
      usim_erl.log_error('usim_spc.get_dimension', 'Not existing space id [' || p_usim_id_spc || '].');
      RETURN -1;
    END IF;
  END get_dimension
  ;

  FUNCTION get_coordinate(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
  IS
    l_result usim_position.usim_coordinate%TYPE;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      SELECT usim_coordinate
        INTO l_result
        FROM usim_spc_v
       WHERE usim_id_spc = p_usim_id_spc
      ;
      RETURN l_result;
    ELSE
      -- no space node available
      usim_erl.log_error('usim_spc.get_coordinate', 'Not existing space id [' || p_usim_id_spc || '].');
      RETURN NULL;
    END IF;
  END get_coordinate
  ;

  FUNCTION get_max_id_rmd(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
  IS
    l_result      usim_rel_mlv_dim.usim_id_rmd%TYPE;
    l_dim_max     usim_dimension.usim_n_dimension%TYPE;
    l_usim_id_mlv usim_multiverse.usim_id_mlv%TYPE;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      l_usim_id_mlv := usim_spc.get_id_mlv(p_usim_id_spc);
      l_dim_max     := usim_rmd.get_max_dimension(l_usim_id_mlv);
      l_result      := usim_rmd.get_id_rmd(l_usim_id_mlv, l_dim_max);
      RETURN l_result;
    ELSE
      -- no space node available
      usim_erl.log_error('usim_spc.get_max_id_rmd', 'Not existing space id [' || p_usim_id_spc || '].');
      RETURN NULL;
    END IF;
  END get_max_id_rmd
  ;

  FUNCTION get_process_spin(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_space.usim_process_spin%TYPE
  IS
    l_result usim_space.usim_process_spin%TYPE;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      SELECT usim_process_spin
        INTO l_result
        FROM usim_space
       WHERE usim_id_spc = p_usim_id_spc
      ;
      RETURN l_result;
    ELSE
      -- no space node available
      usim_erl.log_error('usim_spc.get_process_spin', 'Not existing space id [' || p_usim_id_spc || '].');
      RETURN NULL;
    END IF;
  END get_process_spin
  ;

  FUNCTION insert_spc( p_usim_id_rmd    IN usim_rel_mlv_dim.usim_id_rmd%TYPE
                     , p_usim_id_pos    IN usim_position.usim_id_pos%TYPE
                     , p_usim_id_nod    IN usim_node.usim_id_nod%TYPE
                     , p_do_commit      IN BOOLEAN                            DEFAULT TRUE
                     )
    RETURN usim_space.usim_id_spc%TYPE
  IS
    l_result usim_space.usim_id_spc%TYPE;
    l_spin   NUMBER;
  BEGIN
    IF      usim_rmd.has_data(p_usim_id_rmd)             = 1
       AND  usim_pos.has_data(p_usim_id_pos)             = 1
       AND  usim_nod.has_data(p_usim_id_nod)             = 1
    THEN
      IF usim_spc.has_data(p_usim_id_rmd, p_usim_id_pos, p_usim_id_nod) = 1
      THEN
        RETURN usim_spc.get_id_spc(p_usim_id_rmd, p_usim_id_pos, p_usim_id_nod);
      ELSE
        IF     usim_rmd.get_dimension(p_usim_id_rmd)  = 0
           AND usim_pos.get_coordinate(p_usim_id_pos) = 0
        THEN
          l_spin := 1;
        ELSE
          l_spin := -1;
        END IF;
        INSERT INTO usim_space
          ( usim_id_rmd
          , usim_id_pos
          , usim_id_nod
          , usim_process_spin
          )
          VALUES
          ( p_usim_id_rmd
          , p_usim_id_pos
          , p_usim_id_nod
          , l_spin
          )
          RETURNING usim_id_spc INTO l_result
        ;
        IF p_do_commit
        THEN
          COMMIT;
        END IF;
        RETURN l_result;
      END IF;
    ELSE
      usim_erl.log_error('usim_spc.insert_spc', 'Used with not existing rmd id [' || p_usim_id_rmd || '], pos id [' || p_usim_id_pos || '] or node id [' || p_usim_id_nod || '].');
      RETURN NULL;
    END IF;
  END insert_spc
  ;

  FUNCTION flip_process_spin( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                            , p_do_commit   IN BOOLEAN                     DEFAULT TRUE
                            )
    RETURN NUMBER
  IS
    l_spin usim_space.usim_process_spin%TYPE;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      IF usim_spc.is_universe_base(p_usim_id_spc) = 0
      THEN
        l_spin := usim_spc.get_process_spin(p_usim_id_spc) * -1;
        UPDATE usim_space
           SET usim_process_spin = l_spin
         WHERE usim_id_spc = p_usim_id_spc
        ;
        IF p_do_commit
        THEN
          COMMIT;
        END IF;
      END IF;
      RETURN 1;
    ELSE
      -- no space node available
      usim_erl.log_error('usim_spc.flip_process_spin', 'Not existing space id [' || p_usim_id_spc || '].');
      RETURN 0;
    END IF;

  END flip_process_spin
  ;

END usim_spc;
/