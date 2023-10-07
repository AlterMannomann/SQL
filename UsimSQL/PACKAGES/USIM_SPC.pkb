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

  FUNCTION get_cur_max_dim_n1(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_dimension.usim_n_dimension%TYPE
  IS
    l_result      usim_dimension.usim_n_dimension%TYPE;
    l_usim_id_mlv usim_multiverse.usim_id_mlv%TYPE;
    l_n1_sign     usim_rel_mlv_dim.usim_n1_sign%TYPE;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      l_usim_id_mlv := usim_spc.get_id_mlv(p_usim_id_spc);
      l_n1_sign     := usim_spc.get_dim_n1_sign(p_usim_id_spc);
      SELECT NVL(MAX(usim_n_dimension), -1)
        INTO l_result
        FROM usim_spc_v
       WHERE usim_id_mlv = l_usim_id_mlv
         AND dim_n1_sign = l_n1_sign
      ;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_spc.get_cur_max_dim_n1', 'Used not existing id [' || p_usim_id_spc || '].');
      RETURN NULL;
    END IF;
  END get_cur_max_dim_n1
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
                     )
    RETURN usim_space.usim_id_spc%TYPE
  IS
    l_result usim_space.usim_id_spc%TYPE;
  BEGIN
    IF usim_spc.has_data(p_usim_id_rmd, p_usim_id_pos) = 1
    THEN
      SELECT usim_id_spc INTO l_result FROM usim_space WHERE usim_id_rmd = p_usim_id_rmd AND usim_id_pos = p_usim_id_pos;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_spc.get_id_spc', 'Used with not existing rmd id [' || p_usim_id_rmd || '] or pos id [' || p_usim_id_pos || '].');
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
      usim_erl.log_error('usim_spc.get_dim_sign', 'Not existing space id [' || p_usim_id_spc || '].');
      RETURN NULL;
    END IF;
  END get_dim_sign
  ;

  FUNCTION get_dim_n1_sign(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_rel_mlv_dim.usim_sign%TYPE
  IS
    l_result usim_rel_mlv_dim.usim_sign%TYPE;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      SELECT dim_n1_sign
        INTO l_result
        FROM usim_spc_v
       WHERE usim_id_spc = p_usim_id_spc
      ;
      RETURN l_result;
    ELSE
      -- no space node available
      usim_erl.log_error('usim_spc.get_dim_n1_sign', 'Not existing space id [' || p_usim_id_spc || '].');
      RETURN NULL;
    END IF;
  END get_dim_n1_sign
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

  FUNCTION get_spc_details( p_usim_id_spc  IN  usim_space.usim_id_spc%TYPE
                          , p_usim_id_rmd  OUT usim_rel_mlv_dim.usim_id_rmd%TYPE
                          , p_usim_id_pos  OUT usim_position.usim_id_pos%TYPE
                          , p_usim_id_nod  OUT usim_node.usim_id_nod%TYPE
                          , p_process_spin OUT usim_space.usim_process_spin%TYPE
                          )
    RETURN NUMBER
  IS
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      SELECT usim_id_rmd
           , usim_id_pos
           , usim_id_nod
           , usim_process_spin
        INTO p_usim_id_rmd
           , p_usim_id_pos
           , p_usim_id_nod
           , p_process_spin
        FROM usim_space
       WHERE usim_id_spc = p_usim_id_spc
      ;
      RETURN 1;
    ELSE
      -- no space node available
      usim_erl.log_error('usim_spc.get_spc_details', 'Not existing space id [' || p_usim_id_spc || '].');
      RETURN 0;
    END IF;
  END get_spc_details
  ;

  FUNCTION get_spc_details( p_usim_id_spc  IN  usim_space.usim_id_spc%TYPE
                          , p_usim_id_rmd  OUT usim_rel_mlv_dim.usim_id_rmd%TYPE
                          , p_usim_id_pos  OUT usim_position.usim_id_pos%TYPE
                          , p_usim_id_nod  OUT usim_node.usim_id_nod%TYPE
                          , p_process_spin OUT usim_space.usim_process_spin%TYPE
                          , p_usim_id_mlv  OUT usim_multiverse.usim_id_mlv%TYPE
                          , p_n_dimension  OUT usim_dimension.usim_n_dimension%TYPE
                          , p_dim_sign     OUT usim_rel_mlv_dim.usim_sign%TYPE
                          , p_dim_n1_sign  OUT usim_rel_mlv_dim.usim_n1_sign%TYPE
                          , p_coordinate   OUT usim_position.usim_coordinate%TYPE
                          , p_is_base      OUT usim_multiverse.usim_is_base_universe%TYPE
                          , p_energy       OUT usim_node.usim_energy%TYPE
                          )
    RETURN NUMBER
  IS
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      SELECT usim_id_rmd
           , usim_id_pos
           , usim_id_nod
           , usim_process_spin
           , usim_id_mlv
           , usim_n_dimension
           , dim_sign
           , dim_n1_sign
           , usim_coordinate
           , usim_is_base_universe
           , usim_energy
        INTO p_usim_id_rmd
           , p_usim_id_pos
           , p_usim_id_nod
           , p_process_spin
           , p_usim_id_mlv
           , p_n_dimension
           , p_dim_sign
           , p_dim_n1_sign
           , p_coordinate
           , p_is_base
           , p_energy
        FROM usim_spc_v
       WHERE usim_id_spc = p_usim_id_spc
      ;
      RETURN 1;
    ELSE
      -- no space node available
      usim_erl.log_error('usim_spc.get_spc_details', 'Not existing space id [' || p_usim_id_spc || '].');
      RETURN 0;
    END IF;
  END get_spc_details
  ;

  FUNCTION insert_spc( p_usim_id_rmd       IN usim_rel_mlv_dim.usim_id_rmd%TYPE
                     , p_usim_id_pos       IN usim_position.usim_id_pos%TYPE
                     , p_usim_id_nod       IN usim_node.usim_id_nod%TYPE
                     , p_usim_process_spin IN usim_space.usim_process_spin%TYPE
                     , p_do_commit         IN BOOLEAN                           DEFAULT TRUE
                     )
    RETURN usim_space.usim_id_spc%TYPE
  IS
    l_result usim_space.usim_id_spc%TYPE;
  BEGIN
    IF     p_usim_id_rmd       IS NOT NULL
       AND p_usim_id_pos       IS NOT NULL
       AND p_usim_id_nod       IS NOT NULL
       AND p_usim_process_spin IN (1, -1)
    THEN
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
        , p_usim_process_spin
        )
        RETURNING usim_id_spc INTO l_result
      ;
      IF p_do_commit
      THEN
        COMMIT;
      END IF;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_spc.insert_spc', 'Used with invalid rmd id [' || p_usim_id_rmd || '], pos id [' || p_usim_id_pos || '], node id [' || p_usim_id_nod || '] or process spin [' || p_usim_process_spin || '].');
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