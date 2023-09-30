CREATE OR REPLACE PACKAGE BODY usim_dbif
IS
  -- see header for documentation

  PROCEDURE set_crashed
  IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    UPDATE usim_multiverse
       SET usim_universe_status = usim_static.usim_multiverse_status_crashed
    ;
    COMMIT;
  END set_crashed
  ;

  FUNCTION set_universe_state( p_usim_id_mlv          IN usim_multiverse.usim_id_mlv%TYPE
                             , p_usim_universe_status IN usim_multiverse.usim_universe_status%TYPE
                             )
    RETURN usim_multiverse.usim_universe_status%TYPE
  IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_return NUMBER;
  BEGIN
    -- check parameters
    IF     usim_mlv.has_data(p_usim_id_mlv) = 1
       AND p_usim_universe_status          IN ( usim_static.usim_multiverse_status_dead
                                              , usim_static.usim_multiverse_status_crashed
                                              , usim_static.usim_multiverse_status_active
                                              , usim_static.usim_multiverse_status_inactive
                                              )
    THEN
      l_return := usim_mlv.update_state(p_usim_id_mlv, p_usim_universe_status);
      RETURN l_return;
    ELSE
      usim_erl.log_error('usim_dbif.set_universe_state', 'Invalid parameter mlv id [' || p_usim_id_mlv || '] or state [' || p_usim_universe_status || '].');
      RETURN NULL;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.set_universe_state', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END set_universe_state
  ;

  FUNCTION set_universe_state(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_multiverse.usim_universe_status%TYPE
  IS
    l_usim_id_mlv usim_multiverse.usim_id_mlv%TYPE;
    l_state       usim_multiverse.usim_universe_status%TYPE;
    l_count       NUMBER;
    l_return      NUMBER;
    l_pos_result  NUMBER;
    l_neg_result  NUMBER;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      l_usim_id_mlv := usim_spc.get_id_mlv(p_usim_id_spc);
      l_state       := usim_mlv.get_state(l_usim_id_mlv);
      IF l_state = usim_static.usim_multiverse_status_inactive
      THEN
        -- set active
        l_state := usim_dbif.set_universe_state(l_usim_id_mlv, usim_static.usim_multiverse_status_active);
        IF l_state IS NULL
        THEN
          usim_erl.log_error('usim_dbif.set_universe_state', 'Could not update state to active for space id [' || p_usim_id_spc || '].');
          RETURN NULL;
        ELSE
          RETURN l_state;
        END IF;
      ELSIF l_state = usim_static.usim_multiverse_status_active
      THEN
        -- check state
        SELECT COUNT(*) INTO l_count FROM usim_spc_process WHERE is_processed = 1;
        IF l_count > 0
        THEN
          -- only check if at least some nodes are processed
          SELECT NVL(SUM(usim_energy), 0) INTO l_pos_result FROM usim_spc_v WHERE usim_id_mlv = l_usim_id_mlv AND dim_n1_sign = 1;
          SELECT NVL(SUM(usim_energy), 0) INTO l_neg_result FROM usim_spc_v WHERE usim_id_mlv = l_usim_id_mlv AND dim_n1_sign = -1;
          IF     l_pos_result = 0
             AND l_neg_result = 0
          THEN
            -- set dead
            l_state := usim_dbif.set_universe_state(l_usim_id_mlv, usim_static.usim_multiverse_status_dead);
            IF l_state IS NULL
            THEN
              usim_erl.log_error('usim_dbif.set_universe_state', 'Could not update state to dead for space id [' || p_usim_id_spc || '].');
              RETURN NULL;
            ELSE
              RETURN l_state;
            END IF;
          ELSE
            RETURN usim_static.usim_multiverse_status_active;
          END IF;
        ELSE
          RETURN usim_static.usim_multiverse_status_active;
        END IF;
      ELSE
        RETURN l_state;
      END IF;
    ELSE
      usim_erl.log_error('usim_dbif.set_universe_state', 'Invalid parameter space id [' || p_usim_id_spc || '].');
      RETURN NULL;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.set_universe_state', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END set_universe_state
  ;

  FUNCTION init_basedata( p_max_dimension            IN NUMBER DEFAULT 42
                        , p_usim_abs_max_number      IN NUMBER DEFAULT 99999999999999999999999999999999999999
                        , p_usim_overflow_node_seed  IN NUMBER DEFAULT 0
                        )
    RETURN NUMBER
  IS
  BEGIN
    IF usim_base.has_basedata = 0
    THEN
      usim_base.init_basedata(p_max_dimension, p_usim_abs_max_number, p_usim_overflow_node_seed);
    END IF;
    IF usim_base.has_basedata = 0
    THEN
      usim_erl.log_error('usim_dbif.init_basedata', 'Could not initialize base data for max dim [' || p_max_dimension || '] max num [' || p_usim_abs_max_number || '] and overflow seed [' || p_usim_overflow_node_seed || '].');
    END IF;
    RETURN usim_base.has_basedata;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.init_basedata', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END init_basedata
  ;

  FUNCTION init_dimensions(p_do_commit IN BOOLEAN DEFAULT TRUE)
    RETURN NUMBER
  IS
    l_max_dim usim_dimension.usim_n_dimension%TYPE;
    l_return  NUMBER;
  BEGIN
    IF usim_base.has_basedata = 1
    THEN
      l_max_dim := usim_base.get_max_dimension;
      l_return  := usim_dim.init_dimensions(l_max_dim, FALSE);
      IF l_return != 1
      THEN
        ROLLBACK;
        usim_erl.log_error('usim_dbif.init_dimensions', 'Could not init dimensions up to max [' || l_max_dim || '].');
        RETURN -1;
      ELSE
        IF p_do_commit
        THEN
          COMMIT;
         END IF;
      END IF;
      RETURN l_return;
    ELSE
      RETURN 0;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.init_dimensions', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END init_dimensions
  ;

  FUNCTION has_data_spc
    RETURN NUMBER
  IS
  BEGIN
    RETURN usim_spc.has_data;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.has_data_spc', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END has_data_spc
  ;

  FUNCTION has_data_mlv(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN NUMBER
  IS
  BEGIN
    RETURN usim_mlv.has_data(p_usim_id_mlv);
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.has_data_mlv', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END has_data_mlv
  ;

  FUNCTION init_positions(p_do_commit IN BOOLEAN DEFAULT TRUE)
    RETURN NUMBER
  IS
    l_max_pos usim_position.usim_coordinate%TYPE;
    l_return  NUMBER;
  BEGIN
    IF usim_base.has_basedata = 1
    THEN
      l_max_pos := usim_base.get_abs_max_number;
      l_return  := usim_pos.init_positions(l_max_pos, FALSE);
      IF l_return != 1
      THEN
        ROLLBACK;
        usim_erl.log_error('usim_dbif.init_positions', 'Could not init positions up to max [' || l_max_pos || '].');
        RETURN -1;
      ELSE
        IF p_do_commit
        THEN
          COMMIT;
        END IF;
      END IF;
      RETURN l_return;
    ELSE
      RETURN 0;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.init_positions', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END init_positions
  ;

  FUNCTION is_overflow_pos(p_usim_coordinate IN usim_position.usim_coordinate%TYPE)
    RETURN NUMBER
  IS
  BEGIN
    IF usim_pos.has_data = 0
    THEN
      -- no data
      RETURN 0;
    END IF;
    IF usim_pos.has_data(p_usim_coordinate) = 1
    THEN
      RETURN 0;
    ELSE
      RETURN 1;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.is_overflow_pos', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END is_overflow_pos
  ;

  FUNCTION is_overflow_pos_mlv(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN NUMBER
  IS
    l_max_pos1 usim_position.usim_coordinate%TYPE;
    l_max_neg1 usim_position.usim_coordinate%TYPE;
    l_max_pos2 usim_position.usim_coordinate%TYPE;
    l_max_neg2 usim_position.usim_coordinate%TYPE;
    l_max      NUMBER;
  BEGIN
    IF usim_mlv.has_data(p_usim_id_mlv) = 1
    THEN
      -- universe does not exist
      RETURN 0;
    END IF;
    IF usim_base.has_basedata = 1
    THEN
      SELECT MAX(usim_n_dimension) INTO l_max_pos1 FROM usim_spc_v WHERE usim_id_mlv = p_usim_id_mlv AND dim_n1_sign = 1 AND usim_coordinate >= 0;
      SELECT MIN(usim_n_dimension) INTO l_max_neg1 FROM usim_spc_v WHERE usim_id_mlv = p_usim_id_mlv AND dim_n1_sign = 1 AND usim_coordinate <= 0;
      SELECT MAX(usim_n_dimension) INTO l_max_pos2 FROM usim_spc_v WHERE usim_id_mlv = p_usim_id_mlv AND dim_n1_sign = -1 AND usim_coordinate >= 0;
      SELECT MIN(usim_n_dimension) INTO l_max_neg2 FROM usim_spc_v WHERE usim_id_mlv = p_usim_id_mlv AND dim_n1_sign = -1 AND usim_coordinate <= 0;
      l_max := usim_base.get_abs_max_number;
      IF     l_max_pos1      >= l_max
         AND ABS(l_max_neg1) >= l_max
         AND l_max_pos2      >= l_max
         AND ABS(l_max_neg2) >= l_max
      THEN
        RETURN 1;
      ELSE
        RETURN 0;
      END IF;
    ELSE
      -- can't check
      RETURN 0;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.is_overflow_pos_mlv', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END is_overflow_pos_mlv
  ;

  FUNCTION is_overflow_pos_spc(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_usim_id_mlv usim_multiverse.usim_id_mlv%TYPE;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      l_usim_id_mlv := usim_spc.get_id_mlv(p_usim_id_spc);
      IF l_usim_id_mlv IS NULL
      THEN
        RETURN 0;
      END IF;
      RETURN usim_dbif.is_overflow_pos_mlv(l_usim_id_mlv);
    ELSE
      -- no universe no overflow
      RETURN 0;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.is_overflow_pos_spc', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END is_overflow_pos_spc
  ;

  FUNCTION is_overflow_dim(p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE)
    RETURN NUMBER
  IS
  BEGIN
    IF usim_dim.has_data = 0
    THEN
      -- no data
      RETURN 0;
    END IF;
    IF usim_dim.has_data(p_usim_n_dimension) = 1
    THEN
      RETURN 0;
    ELSE
      RETURN 1;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.is_overflow_dim', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END is_overflow_dim
  ;

  FUNCTION is_overflow_dim_mlv(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN NUMBER
  IS
    l_max_dim_pos usim_dimension.usim_n_dimension%TYPE;
    l_max_dim_neg usim_dimension.usim_n_dimension%TYPE;
    l_max         NUMBER;
  BEGIN
    IF usim_mlv.has_data(p_usim_id_mlv) = 1
    THEN
      -- universe does not exist
      RETURN 0;
    END IF;
    IF usim_base.has_basedata = 1
    THEN
      SELECT MAX(usim_n_dimension) INTO l_max_dim_pos FROM usim_rmd_v WHERE usim_id_mlv = p_usim_id_mlv AND usim_n1_sign = 1;
      SELECT MAX(usim_n_dimension) INTO l_max_dim_neg FROM usim_rmd_v WHERE usim_id_mlv = p_usim_id_mlv AND usim_n1_sign = -1;
      l_max := usim_base.get_max_dimension;
      IF     l_max_dim_neg >= l_max
         AND l_max_dim_pos >= l_max
      THEN
        RETURN 1;
      ELSE
        RETURN 0;
      END IF;
    ELSE
      -- can't check
      RETURN 0;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.is_overflow_dim_mlv', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END is_overflow_dim_mlv
  ;

  FUNCTION is_overflow_dim_spc(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_usim_id_mlv usim_multiverse.usim_id_mlv%TYPE;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      l_usim_id_mlv := usim_spc.get_id_mlv(p_usim_id_spc);
      IF l_usim_id_mlv IS NULL
      THEN
        RETURN 0;
      END IF;
      RETURN usim_dbif.is_overflow_dim_mlv(l_usim_id_mlv);
    ELSE
      -- no universe no overflow
      RETURN 0;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.is_overflow_dim_spc', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END is_overflow_dim_spc
  ;

  FUNCTION is_overflow_energy(p_energy IN NUMBER)
    RETURN NUMBER
  IS
  BEGIN
    IF usim_base.has_basedata = 1
    THEN
      IF ABS(p_energy) > usim_base.get_abs_max_number
      THEN
        RETURN 1;
      ELSE
        RETURN 0;
      END IF;
    ELSE
      -- we can't check
      RETURN 0;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.is_overflow_energy', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END is_overflow_energy
  ;

  FUNCTION is_overflow_energy_add( p_energy IN NUMBER
                                 , p_add    IN NUMBER
                                 )
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    IF usim_base.has_basedata = 1
    THEN
      -- check against base
      BEGIN
        l_result := p_energy + p_add;
        IF ABS(l_result) > usim_base.get_abs_max_number
        THEN
          RETURN 1;
        ELSE
          RETURN 0;
        END IF;
      EXCEPTION
        WHEN OTHERS THEN
          -- system can't handle it
          RETURN 1;
      END;
    ELSE
      -- check against system
      BEGIN
        l_result := p_energy + p_add;
        RETURN 0;
      EXCEPTION
        WHEN OTHERS THEN
          -- system can't handle it
          RETURN 1;
      END;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.is_overflow_energy_add', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END is_overflow_energy_add
  ;

  FUNCTION is_base_universe_seed(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
  BEGIN
    IF usim_spc.get_id_spc_base_universe = p_usim_id_spc
    THEN
      RETURN 1;
    ELSE
      IF usim_spc.has_base_universe = 0
      THEN
        usim_erl.log_error('usim_dbif.is_base_universe_seed', 'Used function without a base universe seed currently available.');
      END IF;
      RETURN 0;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.is_base_universe_seed', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END is_base_universe_seed
  ;

  FUNCTION create_universe( p_usim_energy_start_value IN usim_multiverse.usim_energy_start_value%TYPE DEFAULT 1
                          , p_usim_planck_time_unit   IN usim_multiverse.usim_planck_time_unit%TYPE   DEFAULT 1
                          , p_usim_planck_length_unit IN usim_multiverse.usim_planck_length_unit%TYPE DEFAULT 1
                          , p_usim_planck_speed_unit  IN usim_multiverse.usim_planck_speed_unit%TYPE  DEFAULT 1
                          , p_usim_planck_stable      IN usim_multiverse.usim_planck_stable%TYPE      DEFAULT 1
                          , p_usim_ultimate_border    IN usim_multiverse.usim_ultimate_border%TYPE    DEFAULT 1
                          , p_do_commit               IN BOOLEAN                                      DEFAULT TRUE
                          )
    RETURN usim_multiverse.usim_id_mlv%TYPE
  IS
    l_result usim_multiverse.usim_id_mlv%TYPE;
  BEGIN
    IF usim_mlv.has_data     = 1
       AND usim_mlv.has_base = 0
    THEN
      -- wrong state
      usim_erl.log_error('usim_dbif.create_universe', 'Unexpected multiverse state no base universe but universes exist.');
      usim_dbif.set_crashed;
      RETURN NULL;
    END IF;
    l_result := usim_mlv.insert_universe( p_usim_energy_start_value
                                        , p_usim_planck_time_unit
                                        , p_usim_planck_length_unit
                                        , p_usim_planck_speed_unit
                                        , p_usim_planck_stable
                                        , p_usim_ultimate_border
                                        , FALSE
                                        )
    ;
    IF l_result IS NULL
    THEN
      ROLLBACK;
      usim_erl.log_error('usim_dbif.create_universe', 'Could not insert new universe.');
    ELSE
      IF p_do_commit
      THEN
        COMMIT;
      END IF;
    END IF;
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      -- write error might still work
      usim_erl.log_error('usim_dbif.create_universe', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END create_universe
  ;

  FUNCTION create_dim_axis( p_usim_id_mlv        IN  usim_multiverse.usim_id_mlv%TYPE
                          , p_usim_n_dimension   IN  usim_dimension.usim_n_dimension%TYPE
                          , p_usim_id_rmd_parent IN  usim_rel_mlv_dim.usim_id_rmd%TYPE
                          , p_usim_id_rmd_pos    OUT usim_rel_mlv_dim.usim_id_rmd%TYPE
                          , p_usim_id_rmd_neg    OUT usim_rel_mlv_dim.usim_id_rmd%TYPE
                          , p_do_commit          IN  BOOLEAN                              DEFAULT TRUE
                          )
    RETURN NUMBER
  IS
    l_sign    usim_rel_mlv_dim.usim_sign%TYPE;
    l_n1_sign usim_rel_mlv_dim.usim_n1_sign%TYPE;
  BEGIN
    IF     usim_dim.has_data(p_usim_n_dimension) = 1
       AND usim_mlv.has_data(p_usim_id_mlv)      = 1
    THEN
      -- do not commit until everything is processed
      IF p_usim_n_dimension = 0
      THEN
        p_usim_id_rmd_pos := usim_rmd.insert_rmd(p_usim_id_mlv, p_usim_n_dimension, 0, NULL, FALSE);
        p_usim_id_rmd_neg := usim_rmd.get_id_rmd(p_usim_id_mlv, p_usim_n_dimension, 0, NULL);
      ELSE
        IF p_usim_n_dimension > 1
        THEN
          IF p_usim_id_rmd_parent IS NOT NULL
          THEN
            l_sign := usim_rmd.get_dim_n1_sign(p_usim_id_rmd_parent);
            IF l_sign != 0
            THEN
              p_usim_id_rmd_pos := usim_rmd.insert_rmd(p_usim_id_mlv, p_usim_n_dimension, 1, l_sign, FALSE);
              p_usim_id_rmd_neg := usim_rmd.insert_rmd(p_usim_id_mlv, p_usim_n_dimension, -1, l_sign, FALSE);
            ELSE
              usim_erl.log_error('usim_dbif.create_dim_axis', 'Pparent rmd id returns invalid n1 sign 0.');
              RETURN 0;
            END IF;
          ELSE
            usim_erl.log_error('usim_dbif.create_dim_axis', 'Dimension > 1 but NULL parent rmd id given.');
            RETURN 0;
          END IF;
        ELSIF p_usim_n_dimension = 1
        THEN
          p_usim_id_rmd_pos := usim_rmd.insert_rmd(p_usim_id_mlv, p_usim_n_dimension, 1, 1, FALSE);
          p_usim_id_rmd_neg := usim_rmd.insert_rmd(p_usim_id_mlv, p_usim_n_dimension, -1, -1, FALSE);
        ELSE
          usim_erl.log_error('usim_dbif.create_dim_axis', 'Invalid dimension [' || p_usim_n_dimension || '].');
          RETURN 0;
        END IF;
      END IF;
      -- now check out values if we arrive here
      IF      p_usim_id_rmd_pos IS NOT NULL
          AND p_usim_id_rmd_neg IS NOT NULL
      THEN
        -- commit everything
        IF p_do_commit
        THEN
          COMMIT;
        END IF;
        RETURN 1;
      ELSE
        ROLLBACK;
        usim_erl.log_error('usim_dbif.create_dim_axis', 'Error creating dimension axis for [' || p_usim_n_dimension || '].');
        RETURN 0;
      END IF;
    ELSE
      usim_erl.log_error('usim_dbif.create_dim_axis', 'Invalid mlv [' || p_usim_id_mlv || '] or dimension [' || p_usim_n_dimension || '].');
      RETURN 0;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      -- write error might still work
      usim_erl.log_error('usim_dbif.create_dim_axis', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END create_dim_axis
  ;

  FUNCTION create_space_node( p_usim_id_rmd        IN usim_rel_mlv_dim.usim_id_rmd%TYPE
                            , p_usim_id_pos        IN usim_position.usim_id_pos%TYPE
                            , p_usim_id_spc_parent IN usim_space.usim_id_spc%TYPE
                            , p_do_commit          IN BOOLEAN                           DEFAULT TRUE
                            )
    RETURN usim_space.usim_id_spc%TYPE
  IS
    l_usim_id_mlv     usim_multiverse.usim_id_mlv%TYPE;
    l_usim_id_nod     usim_node.usim_id_nod%TYPE;
    l_usim_id_spc     usim_space.usim_id_spc%TYPE;
    l_usim_coordinate usim_position.usim_coordinate%TYPE;
    l_count           NUMBER;
    l_spin            NUMBER;
    l_return          NUMBER;
  BEGIN
    IF     usim_rmd.has_data(p_usim_id_rmd) = 1
       AND usim_pos.has_data(p_usim_id_pos) = 1
    THEN
      -- exist, nothing to do
      IF usim_spc.has_data(p_usim_id_rmd, p_usim_id_pos) = 1
      THEN
        RETURN usim_spc.get_id_spc(p_usim_id_rmd, p_usim_id_pos);
      END IF;
      -- check situation
      l_usim_id_mlv     := usim_rmd.get_id_mlv(p_usim_id_rmd);
      IF l_usim_id_mlv IS NULL
      THEN
        usim_erl.log_error('usim_dbif.create_space_node', 'Could not get universe for rmd [' || p_usim_id_rmd || '].');
        RETURN NULL;
      END IF;
      l_usim_coordinate := usim_pos.get_coordinate(p_usim_id_pos);
      IF l_usim_coordinate IS NULL
      THEN
        usim_erl.log_error('usim_dbif.create_space_node', 'Could not get coordinate for pos [' || p_usim_id_pos || '].');
        RETURN NULL;
      END IF;
      IF     usim_mlv.is_base(l_usim_id_mlv) = 0
         AND l_usim_coordinate              != 0
         AND p_usim_id_spc_parent           IS NULL
      THEN
        usim_erl.log_error('usim_dbif.create_space_node', 'Missing parent for not base universe and position not 0.');
        RETURN NULL;
      END IF;
      IF p_usim_id_spc_parent IS NULL
      THEN
        -- check if not already set
        SELECT COUNT(*)
          INTO l_count
          FROM usim_spc_v
         WHERE usim_id_mlv           = l_usim_id_mlv
           AND usim_is_base_universe = 1
           AND dim_sign              = 0
           AND dim_n1_sign          IS NULL
           AND usim_coordinate       = 0
        ;
        IF l_count != 0
        THEN
          usim_erl.log_error('usim_dbif.create_space_node', 'Base universe node at position 0, dimension 0 already exists.');
          RETURN NULL;
        END IF;
        -- define process spin, new childs normally are at the end of the row, so direction -1 (parent)
        -- whereas a node without parent is in direction 1 (childs). If parent direction is -1 it has to
        -- change to child with a new child.
        l_spin := 1;
      ELSE
        l_spin := -1;
      END IF;
      -- all checks passed, create node, do not commit until all is done
      l_usim_id_nod := usim_nod.insert_node(FALSE);
      l_usim_id_spc := usim_spc.insert_spc(p_usim_id_rmd, p_usim_id_pos, l_usim_id_nod, l_spin, FALSE);
      IF l_usim_id_spc IS NULL
      THEN
        ROLLBACK;
        usim_erl.log_error('usim_dbif.create_space_node', 'Could not create space node for rmd [' || p_usim_id_rmd || '] and position [' || p_usim_id_pos || '] .');
        RETURN NULL;
      END IF;
      -- update position
      l_return := usim_spo.insert_spc_pos(l_usim_id_spc, p_usim_id_spc_parent, FALSE);
      IF l_return = 0
      THEN
        ROLLBACK;
        usim_erl.log_error('usim_dbif.create_space_node', 'Could not create space node position for spc [' || l_usim_id_spc || '] and parent [' || p_usim_id_spc_parent || '] .');
        RETURN NULL;
      END IF;
      -- define relationship if parent is set
      IF p_usim_id_spc_parent IS NOT NULL
      THEN
        l_return := usim_chi.insert_chi(p_usim_id_spc_parent, l_usim_id_spc, FALSE);
        IF l_return = 0
        THEN
          ROLLBACK;
          usim_erl.log_error('usim_dbif.create_space_node', 'Could not create space node relation for spc [' || l_usim_id_spc || '] and parent [' || p_usim_id_spc_parent || '] .');
          RETURN NULL;
        END IF;
      END IF;
      -- creation done, commit if given
      IF p_do_commit
      THEN
        COMMIT;
      END IF;
      RETURN l_usim_id_spc;
    ELSE
      usim_erl.log_error('usim_dbif.create_space_node', 'Invalid rmd [' || p_usim_id_rmd || '] or position [' || p_usim_id_pos || '].');
      RETURN NULL;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      -- write error might still work
      usim_erl.log_error('usim_dbif.create_space_node', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END create_space_node
  ;

  FUNCTION get_id_pos(p_usim_coordinate IN usim_position.usim_coordinate%TYPE)
    RETURN usim_position.usim_id_pos%TYPE
  IS
    l_usim_id_pos usim_position.usim_id_pos%TYPE;
  BEGIN
    IF usim_pos.has_data(p_usim_coordinate) = 1
    THEN
      l_usim_id_pos := usim_pos.get_id_pos(p_usim_coordinate);
      IF l_usim_id_pos IS NULL
      THEN
        usim_erl.log_error('usim_dbif.get_id_pos', 'Could not get position id for coordinate [' || p_usim_coordinate || '].');
      END IF;
      RETURN l_usim_id_pos;
    ELSE
      usim_erl.log_error('usim_dbif.get_id_pos', 'Invalid coordinate [' || p_usim_coordinate || '], maybe overflow.');
      RETURN NULL;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      -- write error might still work
      usim_erl.log_error('usim_dbif.get_id_pos', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END get_id_pos
  ;

  FUNCTION get_id_pos(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_position.usim_id_pos%TYPE
  IS
    l_usim_id_pos usim_position.usim_id_pos%TYPE;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      l_usim_id_pos := usim_spc.get_id_pos(p_usim_id_spc);
      IF l_usim_id_pos IS NULL
      THEN
        usim_erl.log_error('usim_dbif.get_id_pos', 'Could not get position id for space node [' || p_usim_id_spc || '].');
      END IF;
      RETURN l_usim_id_pos;
    ELSE
      usim_erl.log_error('usim_dbif.get_id_pos', 'Invalid space id [' || p_usim_id_spc || '].');
      RETURN NULL;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      -- write error might still work
      usim_erl.log_error('usim_dbif.get_id_pos', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END get_id_pos
  ;

  FUNCTION get_abs_max_number
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    l_result := usim_base.get_abs_max_number;
    IF l_result IS NULL
    THEN
      usim_erl.log_error('usim_dbif.get_abs_max_number', 'Base data not initialized.');
    END IF;
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      -- write error might still work
      usim_erl.log_error('usim_dbif.get_abs_max_number', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END get_abs_max_number
  ;

  FUNCTION get_dim_coord( p_usim_id_spc      IN usim_space.usim_id_spc%TYPE
                        , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                        )
    RETURN usim_position.usim_coordinate%TYPE
  IS
    l_result usim_position.usim_coordinate%TYPE;
  BEGIN
    l_result := usim_spo.get_dim_coord(p_usim_id_spc, p_usim_n_dimension);
    IF l_result IS NULL
    THEN
      usim_erl.log_error('usim_dbif.get_dim_coord', 'Invalid space id [' || p_usim_id_spc || '] or dimension [' || p_usim_n_dimension || '].');
    END IF;
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      -- write error might still work
      usim_erl.log_error('usim_dbif.get_dim_coord', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END get_dim_coord
  ;

  FUNCTION get_dimension(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_dimension.usim_n_dimension%TYPE
  IS
    l_result usim_dimension.usim_n_dimension%TYPE;
  BEGIN
    l_result := usim_spc.get_dimension(p_usim_id_spc);
    IF l_result = -1
    THEN
      usim_erl.log_error('usim_dbif.get_dimension', 'Invalid space id [' || p_usim_id_spc || '].');
    END IF;
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      -- write error might still work
      usim_erl.log_error('usim_dbif.get_dimension', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END get_dimension
  ;

  FUNCTION get_dim_sign(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_rel_mlv_dim.usim_sign%TYPE
  IS
    l_result usim_rel_mlv_dim.usim_sign%TYPE;
  BEGIN
    l_result := usim_spc.get_dim_sign(p_usim_id_spc);
    IF l_result IS NULL
    THEN
      usim_erl.log_error('usim_dbif.get_dim_sign', 'Invalid space id [' || p_usim_id_spc || '].');
    END IF;
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      -- write error might still work
      usim_erl.log_error('usim_dbif.get_dim_sign', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END get_dim_sign
  ;

  FUNCTION get_xyz(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN VARCHAR2
  IS
    l_result VARCHAR2(32000);
  BEGIN
    l_result := usim_spo.get_xyz(p_usim_id_spc);
    IF l_result IS NULL
    THEN
      usim_erl.log_error('usim_dbif.get_xyz', 'Invalid space id [' || p_usim_id_spc || '].');
    END IF;
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      -- write error might still work
      usim_erl.log_error('usim_dbif.get_xyz', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END get_xyz
  ;

  FUNCTION overflow_rating(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
  BEGIN
    -- do we have overflow on dimensions and positions
    IF      usim_dbif.is_overflow_dim_spc(p_usim_id_spc) = 1
       AND  usim_dbif.is_overflow_pos_spc(p_usim_id_spc) = 1
    THEN
      -- total overflow
      RETURN 0;
    ELSIF usim_dbif.is_overflow_pos_spc(p_usim_id_spc) = 1
    THEN
      -- position overflow
      RETURN 2;
    ELSIF usim_dbif.is_overflow_dim_spc(p_usim_id_spc) = 1
    THEN
      -- dimension overflow
      RETURN 3;
    ELSE
      -- no overflow
      RETURN 1;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.overflow_rating', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END overflow_rating
  ;

  FUNCTION dimension_rating( p_usim_id_spc IN  usim_space.usim_id_spc%TYPE
                           , p_max_childs  OUT NUMBER
                           )
    RETURN NUMBER
  IS
    l_return       NUMBER;
    l_count        NUMBER;
    l_max_dim      NUMBER;
    l_usim_id_rmd  usim_rel_mlv_dim.usim_id_rmd%TYPE;
    l_usim_id_pos  usim_position.usim_id_pos%TYPE;
    l_usim_id_nod  usim_node.usim_id_nod%TYPE;
    l_process_spin usim_space.usim_process_spin%TYPE;
    l_usim_id_mlv  usim_multiverse.usim_id_mlv%TYPE;
    l_n_dimension  usim_dimension.usim_n_dimension%TYPE;
    l_dim_sign     usim_rel_mlv_dim.usim_sign%TYPE;
    l_dim_n1_sign  usim_rel_mlv_dim.usim_n1_sign%TYPE;
    l_coordinate   usim_position.usim_coordinate%TYPE;
    l_is_base      usim_multiverse.usim_is_base_universe%TYPE;
    l_energy       usim_node.usim_energy%TYPE;
   BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      -- get details
      l_return := usim_spc.get_spc_details( p_usim_id_spc
                                          , l_usim_id_rmd
                                          , l_usim_id_pos
                                          , l_usim_id_nod
                                          , l_process_spin
                                          , l_usim_id_mlv
                                          , l_n_dimension
                                          , l_dim_sign
                                          , l_dim_n1_sign
                                          , l_coordinate
                                          , l_is_base
                                          , l_energy
                                          )
      ;
      IF l_return = 0
      THEN
        usim_erl.log_error('usim_dbif.dimension_rating', 'Failed to get details for space id [' || p_usim_id_spc || '].');
        RETURN -1;
      END IF;
      IF     l_n_dimension = 0
         AND l_coordinate  = 0
      THEN
        -- only 2 special childs with opposite energy output sign possible
        p_max_childs := 2;
        RETURN 0;
      END IF;
      IF     l_n_dimension > 0
         AND l_coordinate  = 0
      THEN
        -- only 2 childs possible
        p_max_childs := 2;
        RETURN 1;
      END IF;
      -- count coordinates not 0 for space id
      SELECT COUNT(*) INTO l_count FROM usim_spo_v WHERE usim_id_spc = p_usim_id_spc AND usim_coordinate != 0;
      IF     l_count       = 1
         AND l_coordinate != 0
      THEN
        -- pure dimension axis, possible childs: n Dimension x 2 + 1 axis child
        l_max_dim := usim_spc.get_cur_max_dim_n1(p_usim_id_spc);
        p_max_childs := (l_max_dim * 2) + 1;
        RETURN 2;
      ELSE
        -- anywhere, possible childs: n Dimension x 2
        p_max_childs := (l_max_dim * 2);
        RETURN 3;
      END IF;
    ELSE
      usim_erl.log_error('usim_dbif.dimension_rating', 'Invalid space id [' || p_usim_id_spc || '].');
      RETURN -1;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.dimension_rating', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END dimension_rating
  ;

  FUNCTION dimension_rating(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_max_childs NUMBER;
    l_rating     NUMBER;
  BEGIN
    l_rating := usim_dbif.dimension_rating(p_usim_id_spc, l_max_childs);
    RETURN l_rating;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.dimension_rating', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END dimension_rating
  ;

  FUNCTION max_childs(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_max_childs NUMBER;
    l_rating     NUMBER;
  BEGIN
    l_rating := usim_dbif.dimension_rating(p_usim_id_spc, l_max_childs);
    RETURN l_max_childs;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.max_childs', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END max_childs
  ;

  FUNCTION classify_parent(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_count        NUMBER;
    l_return       NUMBER;
    l_dim_rating   NUMBER;
    l_parent_count NUMBER;
    l_child_count  NUMBER;
    l_connections  NUMBER;
    l_max_dim      NUMBER;
    l_max_child    NUMBER;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 0
    THEN
      RETURN -1;
    END IF;
    -- get details
    l_dim_rating := usim_dbif.dimension_rating(p_usim_id_spc, l_max_child);
    IF l_dim_rating = -1
    THEN
      usim_erl.log_error('usim_dbif.classify_parent', 'Failed to get a dimension rating for space id [' || p_usim_id_spc || '].');
      RETURN -1;
    END IF;
    -- ignore errors like no child or parent, we get values anyway
    l_return      := usim_chi.get_chi_details(p_usim_id_spc, l_parent_count, l_child_count);
    IF l_dim_rating = 0 -- center of a universe dimension 0,1
    THEN
      -- no more childs possible
      IF l_child_count = l_max_child
      THEN
        -- fully connected
        RETURN 0;
      ELSE
        -- only next dimension possible
        RETURN 2;
      END IF;
    ELSIF l_dim_rating = 1 -- center dimension axis with pos 0 dimension > 1
    THEN
      -- only 2 childs possible
      IF l_child_count = l_max_child
      THEN
        -- fully connected
        RETURN 0;
      ELSE
        -- find free node
        IF usim_chi.has_child_same_dim(p_usim_id_spc) = 1
        THEN
          -- only next dimension possible
          RETURN 2;
        ELSE
          -- no childs at all
          IF l_child_count = 0
          THEN
            -- position and dimension possible
            RETURN 1;
          ELSE
            -- only position possible
            RETURN 3;
          END IF;
        END IF;
      END IF;
    ELSIF l_dim_rating = 2 -- on dimension axis
    THEN
      IF l_child_count = l_max_child
      THEN
        -- fully connected
        RETURN 0;
      ELSE
        -- find free node
        IF usim_chi.has_child_same_dim(p_usim_id_spc) = 1
        THEN
          -- only next dimension possible
          RETURN 2;
        ELSE
          -- position or dimension (not checking upper dimensions available)
          RETURN 1;
        END IF;
      END IF;
    ELSE -- everywhere else
      IF l_child_count = l_max_child
      THEN
        -- fully connected
        RETURN 0;
      ELSE
        -- only position possible
        RETURN 3;
      END IF;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.classify_parent', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END classify_parent
  ;

  FUNCTION classify_escape(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
  BEGIN
    RETURN -1;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.classify_escape', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END classify_escape
  ;

END usim_dbif;
/