-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
CREATE OR REPLACE PACKAGE BODY &USIM_SCHEMA..usim_dbif
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
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      -- write error might still work
      usim_erl.log_error('usim_dbif.set_crashed', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END set_crashed
  ;

  FUNCTION set_universe_state( p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE
                             , p_do_commit   IN BOOLEAN                          DEFAULT TRUE
                             )
    RETURN usim_multiverse.usim_universe_status%TYPE
  IS
    l_return            NUMBER;
    l_status_valid      NUMBER;
    l_status_calculated usim_multiverse.usim_universe_status%TYPE;
  BEGIN
    -- check parameter
    IF usim_mlv.has_data(p_usim_id_mlv) = 1
    THEN
      -- check state and correct it if mismatch
      SELECT status_valid, status_calculated INTO l_status_valid, l_status_calculated FROM usim_mlv_state_v WHERE usim_id_mlv = p_usim_id_mlv;
      IF l_status_calculated != usim_static.usim_multiverse_status_active
      THEN
        -- we have an error in the universe
        usim_erl.log_error('usim_dbif.set_universe_state', 'Current invalid status not running for mlv id [' || p_usim_id_mlv || '] is [' || l_status_valid || '] calculated [' || l_status_calculated || '].');
        IF l_status_valid != 1
        THEN
          l_return := usim_mlv.update_state(p_usim_id_mlv, l_status_calculated, FALSE);
          IF l_return IS NULL
          THEN
            ROLLBACK;
            usim_erl.log_error('usim_dbif.set_universe_state', 'Could not update state for mlv id [' || p_usim_id_mlv || '].');
          END IF;
          RETURN l_return;
        ELSE
          RETURN l_status_calculated;
        END IF;
      ELSE
        -- update state, if current state not valid
        IF l_status_valid != 1
        THEN
          l_return := usim_mlv.update_state(p_usim_id_mlv, l_status_calculated, FALSE);
          IF l_return IS NULL
          THEN
            ROLLBACK;
            usim_erl.log_error('usim_dbif.set_universe_state', 'Could not update state for mlv id [' || p_usim_id_mlv || '].');
          END IF;
          RETURN l_return;
        ELSE
          RETURN l_status_calculated;
        END IF;
      END IF;
    ELSE
      usim_erl.log_error('usim_dbif.set_universe_state', 'Invalid parameter mlv id [' || p_usim_id_mlv || '].');
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

  FUNCTION set_universe_state_spc( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                                 , p_do_commit   IN BOOLEAN                     DEFAULT TRUE
                                 )
    RETURN usim_multiverse.usim_universe_status%TYPE
  IS
    l_usim_id_mlv       usim_multiverse.usim_id_mlv%TYPE;
    l_status_calculated usim_multiverse.usim_universe_status%TYPE;
    l_return            NUMBER;
    l_status_valid      NUMBER;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      l_usim_id_mlv := usim_spc.get_id_mlv(p_usim_id_spc);
      IF l_usim_id_mlv IS NULL
      THEN
        usim_erl.log_error('usim_dbif.set_universe_state_spc', 'No valid universe found for space id [' || p_usim_id_spc || '].');
        RETURN NULL;
      END IF;
      -- check state and correct it if mismatch
      SELECT status_valid, status_calculated INTO l_status_valid, l_status_calculated FROM usim_mlv_state_v WHERE usim_id_mlv = l_usim_id_mlv;
      -- do only something, is status is not valid
      IF l_status_valid = 0
      THEN
        l_return := usim_mlv.update_state(l_usim_id_mlv, l_status_calculated, FALSE);
        IF l_return IS NULL
        THEN
          ROLLBACK;
          usim_erl.log_error('usim_dbif.set_universe_state_spc', 'Could not update state for mlv id [' || l_usim_id_mlv || '].');
        ELSE
          IF p_do_commit
          THEN
            COMMIT;
          END IF;
        END IF;
        RETURN l_return;
      ELSIF l_status_valid = -1
      THEN
        usim_erl.log_error('usim_dbif.set_universe_state_spc', 'Invalid calculation state for mlv id [' || l_usim_id_mlv || '].');
        RETURN NULL;
      ELSE
        RETURN l_status_calculated;
      END IF;
    ELSE
      usim_erl.log_error('usim_dbif.set_universe_state_spc', 'Invalid parameter space id [' || p_usim_id_spc || '].');
      RETURN NULL;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.set_universe_state_spc', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END set_universe_state_spc
  ;

  FUNCTION set_seed_active(p_do_commit IN BOOLEAN DEFAULT TRUE)
    RETURN usim_multiverse.usim_universe_status%TYPE
  IS
    l_return      usim_multiverse.usim_universe_status%TYPE;
    l_usim_id_mlv usim_multiverse.usim_id_mlv%TYPE;
  BEGIN
    IF usim_mlv.has_base = 1
    THEN
      SELECT usim_id_mlv INTO l_usim_id_mlv FROM usim_multiverse WHERE usim_is_base_universe = 1;
      l_return := usim_mlv.update_state(l_usim_id_mlv, usim_static.usim_multiverse_status_active, FALSE);
      IF l_return != usim_static.usim_multiverse_status_active
      THEN
        ROLLBACK;
        usim_erl.log_error('usim_dbif.set_seed_active', 'Could not update state to active on universe seed id [' || l_usim_id_mlv || '] getting status [' || l_return || '].');
        RETURN NULL;
      ELSE
        IF p_do_commit
        THEN
          COMMIT;
        END IF;
        RETURN l_return;
      END IF;
    ELSE
      usim_erl.log_error('usim_dbif.set_seed_active', 'No base universe found.');
      RETURN NULL;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      -- write error might still work
      usim_erl.log_error('usim_dbif.set_seed_active', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END set_seed_active
  ;

  FUNCTION init_basedata( p_max_dimension            IN NUMBER DEFAULT 42
                        , p_usim_abs_max_number      IN NUMBER DEFAULT 99999999999999999999999999999999999999
                        , p_usim_overflow_node_seed  IN NUMBER DEFAULT 0
                        )
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    IF usim_base.has_basedata = 0
    THEN
      usim_base.init_basedata(p_max_dimension, p_usim_abs_max_number, p_usim_overflow_node_seed);
    END IF;
    IF usim_base.has_basedata = 0
    THEN
      usim_erl.log_error('usim_dbif.init_basedata', 'Could not initialize base data for max dim [' || p_max_dimension || '] max num [' || p_usim_abs_max_number || '] and overflow seed [' || p_usim_overflow_node_seed || '].');
    END IF;
    l_result := usim_base.has_basedata;
    RETURN l_result;
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

  FUNCTION has_basedata
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    l_result := usim_base.has_basedata;
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      -- write error might still work
      usim_erl.log_error('usim_dbif.has_basedata', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END has_basedata
  ;

  FUNCTION has_data_spc
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    l_result := usim_spc.has_data;
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      -- write error might still work
      usim_erl.log_error('usim_dbif.has_data_spc', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END has_data_spc
  ;

  FUNCTION has_data_spc(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    l_result := usim_spc.has_data(p_usim_id_spc);
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      -- write error might still work
      usim_erl.log_error('usim_dbif.has_data_spc', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END has_data_spc
  ;

  FUNCTION has_data_spr
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    l_result := usim_spr.has_data;
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.has_data_spr', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END has_data_spr
  ;

  FUNCTION has_data_spr(p_usim_id_spr IN usim_spc_process.usim_id_spr%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    l_result := usim_spr.has_data(p_usim_id_spr);
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.has_data_spr', 'Unexpected error for id [' || p_usim_id_spr || '], SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END has_data_spr
  ;

  FUNCTION has_unprocessed
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    l_result := usim_spr.has_unprocessed;
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.has_unprocessed', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END has_unprocessed
  ;

  FUNCTION has_data_mlv
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    l_result := usim_mlv.has_data;
    RETURN l_result;
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

  FUNCTION has_data_mlv(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    l_result := usim_mlv.has_data(p_usim_id_mlv);
    RETURN l_result;
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

  FUNCTION has_axis_max_pos_parent(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    l_result := usim_spo.has_axis_max_pos_parent(p_usim_id_spc);
    IF l_result > 1
    THEN
      usim_erl.log_error('usim_dbif.has_axis_max_pos_parent', 'Error dimension symmetry, more than one maximum position on dimension axis found for space node [' || p_usim_id_spc || '].');
      usim_dbif.set_crashed;
      RETURN -1;
    ELSE
      RETURN l_result;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.has_axis_max_pos_parent', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END has_axis_max_pos_parent
  ;

  FUNCTION has_free_between(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
  BEGIN
    -- if not related to all dimensions, relying on dimensions are built and assigned in order
    IF usim_chi.get_cur_max_dimension(p_usim_id_spc) < usim_spc.get_cur_max_dim_n1(p_usim_id_spc)
    THEN
      RETURN 1;
    ELSE
      RETURN 0;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.has_free_between', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END has_free_between
  ;

  FUNCTION is_seed_active
    RETURN NUMBER
  IS
    l_status_calculated NUMBER;
    l_planck_aeon       usim_static.usim_id;
    l_planck_time       NUMBER;
    l_energy_total      NUMBER;
    l_energy_positive   NUMBER;
    l_energy_negative   NUMBER;
    l_has_process_data  NUMBER;
    l_has_unprocessed   NUMBER;
  BEGIN
    IF usim_mlv.has_base = 1
    THEN
      SELECT status_calculated INTO l_status_calculated FROM usim_mlv_state_v WHERE usim_is_base_universe = 1;
      IF l_status_calculated = usim_static.usim_multiverse_status_active
      THEN
        RETURN 1;
      ELSE
        SELECT planck_aeon
             , planck_time
             , energy_base
             , energy_positive
             , energy_negative
             , has_process_data
             , has_unprocessed
          INTO l_planck_aeon
             , l_planck_time
             , l_energy_total
             , l_energy_positive
             , l_energy_negative
             , l_has_process_data
             , l_has_unprocessed
          FROM usim_mlv_state_v
         WHERE usim_is_base_universe = 1
        ;
        usim_erl.log_error('usim_dbif.is_seed_active', 'Seed not active at planck aeon [' || l_planck_aeon || '], time [' || l_planck_time || '], total e [' || l_energy_total || '], e+ [' || l_energy_positive || '], e- [' || l_energy_negative || '], process data [' || l_has_process_data || '], unprocessed [' || l_has_unprocessed || '].');
        RETURN 0;
      END IF;
    ELSE
      usim_erl.log_error('usim_dbif.is_seed_active', 'No base universe found.');
      RETURN 0;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.is_seed_active', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END is_seed_active
  ;

  FUNCTION is_universe_active(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_mlv_id    usim_multiverse.usim_id_mlv%TYPE;
    l_state     usim_multiverse.usim_universe_status%TYPE;
  BEGIN
    -- get universe
    l_mlv_id := usim_spc.get_id_mlv(p_usim_id_spc);
    IF l_mlv_id IS NULL
    THEN
      RETURN 0;
    END IF;
    l_state  := usim_mlv.get_state(l_mlv_id);
    IF l_state = usim_static.usim_multiverse_status_active
    THEN
      RETURN 1;
    ELSE
      RETURN 0;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.is_universe_active', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END is_universe_active
  ;

  FUNCTION is_universe_base_type(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_return NUMBER;
  BEGIN
    l_return := usim_spc.is_universe_base(p_usim_id_spc);
    RETURN l_return;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.is_universe_base', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END is_universe_base_type
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
      ROLLBACK;
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
    l_max_dim     NUMBER;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      l_usim_id_mlv := usim_spc.get_id_mlv(p_usim_id_spc);
      IF l_usim_id_mlv IS NULL
      THEN
        -- no overflow for not existing mlv
        RETURN 0;
      END IF;
      -- check if is base at dimension 0 and has two childs = overflow
      IF     usim_spc.is_universe_base(p_usim_id_spc) = 1
         AND usim_chi.child_count(p_usim_id_spc)      = 2
      THEN
        RETURN 1;
      ELSIF usim_spc.is_universe_base(p_usim_id_spc) = 1
      THEN
        RETURN 0;
      ELSE
        -- check if is not base and childs have all dimensions = overflow
        SELECT MAX(usim_n_dimension)
          INTO l_max_dim
          FROM usim_spo_v
         WHERE usim_id_spc = p_usim_id_spc
           AND usim_id_mlv = l_usim_id_mlv
        ;
        IF l_max_dim >= usim_base.get_max_dimension
        THEN
          RETURN 1;
        ELSE
          RETURN 0;
        END IF;
      END IF;
    ELSE
      -- no overflow for not existing space id
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

  FUNCTION is_overflow_pos_spc(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      -- no position free on base
      IF usim_spc.is_universe_base(p_usim_id_spc) = 1
      THEN
        -- base node has no position free
        RETURN 1;
      END IF;
      -- if child in same dimension we are in overflow
      IF     usim_chi.has_child_same_dim(p_usim_id_spc) = 1
             -- if node is on position 0 on all axis, the node can trigger position extension, so it should not be a zero axis position
         AND usim_spo.is_axis_zero_pos(p_usim_id_spc)   = 0
      THEN
        RETURN 1;
      ELSE
        RETURN 0;
      END IF;
    ELSE
      -- no overflow if space id does not exist
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
  END is_overflow_pos_spc
  ;

  FUNCTION is_overflow_energy(p_energy IN NUMBER)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    IF usim_base.has_basedata = 1
    THEN
      l_result := usim_base.num_has_overflow(p_energy);
      IF l_result = 1
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
      IF SQLCODE IN (-6502, -1426, -1428, -1476, -1487)
      THEN
        -- -6502 numeric value error POWER etc. or -1426 overflow or -1428 value range, -1476 zero divide, -1401: inserted value too large for column
        -- -1487: packed decimal number too large
        usim_erl.log_error('usim_dbif.is_overflow_energy', 'Numerical error on energy overflow check for [' || SQLCODE || '] error message: ' || SQLERRM);
        RETURN 1;
      ELSE
        -- write error might still work
        usim_erl.log_error('usim_dbif.is_overflow_energy', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
        -- try to set all to crashed
        usim_dbif.set_crashed;
        -- raise in any case
        RAISE;
      END IF;
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
      l_result := usim_base.num_add_has_overflow(p_energy, p_add);
      RETURN l_result;
    ELSE
      -- check against system, if fails with numerical exception we have overflow state
      l_result := p_energy + p_add;
      RETURN 0;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE IN (-6502, -1426, -1428, -1476, -1487)
      THEN
        -- -6502 numeric value error POWER etc. or -1426 overflow or -1428 value range, -1476 zero divide, -1401: inserted value too large for column
        -- -1487: packed decimal number too large
        usim_erl.log_error('usim_dbif.is_overflow_energy_add', 'Numerical error on add energy overflow check [' || SQLCODE || '] error message: ' || SQLERRM);
        RETURN 1;
      ELSE
        -- write error might still work
        usim_erl.log_error('usim_dbif.is_overflow_energy_add', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
        -- try to set all to crashed
        usim_dbif.set_crashed;
        -- raise in any case
        RAISE;
      END IF;
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

  FUNCTION is_queue_valid
    RETURN NUMBER
  IS
    l_return NUMBER;
  BEGIN
    l_return := usim_spr.is_queue_valid;
    RETURN l_return;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.is_queue_valid', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END is_queue_valid
  ;

  FUNCTION is_pos_extendable(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
  BEGIN
    IF usim_chi.has_child_same_dim(p_usim_id_spc) = 0
    THEN
      RETURN 1;
    END IF;
    IF usim_spo.is_axis_zero_pos(p_usim_id_spc) = 1
    THEN
      RETURN 2;
    END IF;
    -- no check passed
    usim_erl.log_error('usim_dbif.is_pos_extendable', 'Given space node id [' || p_usim_id_spc || '] is not extendable on position.');
    RETURN 0;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.is_pos_extendable', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END is_pos_extendable
  ;

  FUNCTION is_dim_extendable( p_usim_id_spc IN  usim_space.usim_id_spc%TYPE
                            , p_use_parent  OUT usim_space.usim_id_spc%TYPE
                            , p_next_dim    OUT usim_dimension.usim_n_dimension%TYPE
                            )
    RETURN NUMBER
  IS
    l_max_cur_dim NUMBER;
    l_max_chi_dim NUMBER;
    l_max_dim     NUMBER;
  BEGIN
    l_max_cur_dim := usim_spc.get_cur_max_dim_n1(p_usim_id_spc);
    l_max_chi_dim := usim_chi.get_cur_max_dimension(p_usim_id_spc);
    l_max_dim     := usim_base.get_max_dimension;
    IF usim_spo.is_axis_zero_pos(p_usim_id_spc) = 1
    THEN
      IF l_max_chi_dim < l_max_dim
      THEN
        p_use_parent := p_usim_id_spc;
        p_next_dim   := l_max_chi_dim + 1;
        RETURN 2;
      ELSE
        -- no dimension left
        p_use_parent := NULL;
        p_next_dim   := NULL;
        RETURN 0;
      END IF;
    END IF;
    IF l_max_chi_dim < l_max_cur_dim
    THEN
      -- free available dimensions
      p_use_parent := p_usim_id_spc;
      p_next_dim   := l_max_chi_dim + 1;
      RETURN 1;
    ELSIF l_max_chi_dim < l_max_dim
    THEN
      -- free dimension, but dimension has to be build
      p_use_parent := usim_spo.get_axis_zero_pos_parent(p_usim_id_spc);
      p_next_dim   := l_max_chi_dim + 1;
      RETURN 2;
    ELSE
      p_use_parent := NULL;
      p_next_dim   := NULL;
      RETURN 0;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.is_dim_extendable', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END is_dim_extendable
  ;

  FUNCTION child_count( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                      , p_ignore_mlv  IN NUMBER                      DEFAULT 0
                      )
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    IF p_ignore_mlv = 0
    THEN
      l_result := usim_chi.child_count(p_usim_id_spc);
    ELSE
      l_result := usim_chi.child_count_all(p_usim_id_spc);
    END IF;
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.child_count', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END child_count
  ;

  FUNCTION parent_count( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                       , p_ignore_mlv  IN NUMBER                      DEFAULT 0
                       )
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    IF p_ignore_mlv = 0
    THEN
      l_result := usim_chi.parent_count(p_usim_id_spc);
    ELSE
      l_result := usim_chi.parent_count_all(p_usim_id_spc);
    END IF;
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.parent_count', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END parent_count
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

  FUNCTION create_space_node( p_usim_id_rmd  IN usim_rel_mlv_dim.usim_id_rmd%TYPE
                            , p_usim_id_pos  IN usim_position.usim_id_pos%TYPE
                            , p_usim_parents IN usim_static.usim_ids_type
                            , p_do_commit    IN BOOLEAN                           DEFAULT TRUE
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
      -- pos and rmd not unique, inbetween nodes
      -- check situation
      l_usim_id_mlv     := usim_rmd.get_id_mlv(p_usim_id_rmd);
      IF l_usim_id_mlv IS NULL
      THEN
        usim_erl.log_error('usim_dbif.create_space_node', 'Could not get universe for rmd [' || p_usim_id_rmd || '].');
        usim_dbif.set_crashed;
        RETURN NULL;
      END IF;
      l_usim_coordinate := usim_pos.get_coordinate(p_usim_id_pos);
      IF l_usim_coordinate IS NULL
      THEN
        usim_erl.log_error('usim_dbif.create_space_node', 'Could not get coordinate for pos [' || p_usim_id_pos || '].');
        usim_dbif.set_crashed;
        RETURN NULL;
      END IF;
      IF     usim_mlv.is_base(l_usim_id_mlv) = 0
         AND l_usim_coordinate              != 0
         AND p_usim_parents.COUNT            = 0
      THEN
        usim_erl.log_error('usim_dbif.create_space_node', 'Missing parent for not base universe and position not 0.');
        RETURN NULL;
      END IF;
      IF p_usim_parents.COUNT = 0
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
      END IF;
      -- define process spin, new childs normally are at the end of the row, so direction would be -1 (parent)
      -- whereas a node without parent is always in direction 1 (childs). The sign is initially direction child. As soon as
      -- processing begins, it will be flipped by processing to the correct direction, whenever the process encounters
      -- a border space node as defined by border rule.
      l_spin := 1;
      -- all checks passed, create node, do not commit until all is done
      l_usim_id_nod := usim_nod.insert_node(FALSE);
      l_usim_id_spc := usim_spc.insert_spc(p_usim_id_rmd, p_usim_id_pos, l_usim_id_nod, l_spin, FALSE);
      IF l_usim_id_spc IS NULL
      THEN
        ROLLBACK;
        usim_erl.log_error('usim_dbif.create_space_node', 'Could not create space node for rmd [' || p_usim_id_rmd || '] and position [' || p_usim_id_pos || '] .');
        usim_dbif.set_crashed;
        RETURN NULL;
      END IF;
      -- update position for parents
      IF p_usim_parents.COUNT > 0
      THEN
        FOR i IN p_usim_parents.FIRST..p_usim_parents.LAST
        LOOP
          l_return := usim_spo.insert_spc_pos(l_usim_id_spc, p_usim_parents(i), FALSE);
          IF l_return = 0
          THEN
            ROLLBACK;
            usim_erl.log_error('usim_dbif.create_space_node', 'Could not create space node position for spc [' || l_usim_id_spc || '] and parent [' || p_usim_parents(i) || '] .');
            usim_dbif.set_crashed;
            RETURN NULL;
          END IF;
          -- check parent child relation only same n1 sign apart from base universe nodes
          IF    usim_spc.get_dim_n1_sign(p_usim_parents(i))  = usim_spc.get_dim_n1_sign(l_usim_id_spc)
             OR usim_spc.is_universe_base(p_usim_parents(i)) = 1
             OR usim_spc.is_universe_base(l_usim_id_spc)     = 1
          THEN
            -- define relationship if parent is set
            l_return := usim_chi.insert_chi(p_usim_parents(i), l_usim_id_spc, FALSE);
            IF l_return = 0
            THEN
              ROLLBACK;
              usim_erl.log_error('usim_dbif.create_space_node', 'Could not create space node relation for spc [' || l_usim_id_spc || '] and parent [' || p_usim_parents(i) || '] .');
              usim_dbif.set_crashed;
              RETURN NULL;
            END IF;
          ELSE
            ROLLBACK;
            usim_erl.log_error('usim_dbif.create_space_node', 'Space node relation not allowed due to different n1 sign for spc [' || l_usim_id_spc || '] and parent [' || p_usim_parents(i) || '] not base node.');
            usim_dbif.set_crashed;
            RETURN NULL;
          END IF;
        END LOOP;
      ELSE
        l_return := usim_spo.insert_spc_pos(l_usim_id_spc, NULL, FALSE);
        IF l_return = 0
        THEN
          ROLLBACK;
          usim_erl.log_error('usim_dbif.create_space_node', 'Could not create space node position for spc [' || l_usim_id_spc || '] and parent NULL.');
          usim_dbif.set_crashed;
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

  FUNCTION create_process( p_usim_id_spc_source IN usim_space.usim_id_spc%TYPE
                         , p_usim_id_spc_target IN usim_space.usim_id_spc%TYPE
                         , p_usim_energy_source IN usim_spc_process.usim_energy_source%TYPE
                         , p_usim_energy_target IN usim_spc_process.usim_energy_target%TYPE
                         , p_usim_energy_output IN usim_spc_process.usim_energy_output%TYPE
                         , p_do_commit          IN BOOLEAN                                  DEFAULT TRUE
                         )
    RETURN usim_spc_process.usim_id_spr%TYPE
  IS
    l_result usim_spc_process.usim_id_spr%TYPE;
  BEGIN
    l_result := usim_spr.insert_spr(p_usim_id_spc_source, p_usim_id_spc_target, p_usim_energy_source, p_usim_energy_target, p_usim_energy_output, FALSE);
    IF l_result IS NOT NULL
    THEN
      IF p_do_commit
      THEN
        COMMIT;
      END IF;
    ELSE
      usim_erl.log_error('usim_dbif.create_process', 'Failed to insert process record.');
      ROLLBACK;
    END IF;
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      -- write error might still work
      usim_erl.log_error('usim_dbif.create_process', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END create_process
  ;

  FUNCTION flip_process_spin( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                            , p_do_commit   IN BOOLEAN                     DEFAULT TRUE
                            )
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    l_result := usim_spc.flip_process_spin(p_usim_id_spc, FALSE);
    IF l_result = 0
    THEN
      ROLLBACK;
      usim_erl.log_error('usim_dbif.flip_process_spin', 'Failed to flip process spin for space id [' || p_usim_id_spc || '].');
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
      usim_erl.log_error('usim_dbif.flip_process_spin', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END flip_process_spin
  ;

  FUNCTION set_processed( p_usim_id_spr   IN usim_spc_process.usim_id_spr%TYPE
                        , p_process_state IN usim_spc_process.is_processed%TYPE DEFAULT 1
                        , p_do_commit     IN BOOLEAN                            DEFAULT TRUE
                        )
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    l_result := usim_spr.set_processed(p_usim_id_spr, p_process_state, FALSE);
    IF l_result = 0
    THEN
      ROLLBACK;
      usim_erl.log_error('usim_dbif.set_processed', 'Failed to set processed state for id [' || p_usim_id_spr || '] and state [' || p_process_state || '].');
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
      usim_erl.log_error('usim_dbif.set_processed', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END set_processed
  ;

  FUNCTION check_border( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                       , p_do_commit   IN BOOLEAN                     DEFAULT TRUE
                       )
    RETURN NUMBER
  IS
    l_usim_id_mlv   usim_multiverse.usim_id_mlv%TYPE;
    l_border_rule   usim_multiverse.usim_ultimate_border%TYPE;
    l_process_spin  usim_space.usim_process_spin%TYPE;
    l_result        INTEGER;
  BEGIN
    l_usim_id_mlv  := usim_spc.get_id_mlv(p_usim_id_spc);
    l_border_rule  := usim_mlv.get_ultimate_border(l_usim_id_mlv);
    l_process_spin := usim_spc.get_process_spin(p_usim_id_spc);
    IF l_border_rule = 1
    THEN
      -- if no child and direction is child flip to parent
      IF     usim_chi.child_count(p_usim_id_spc) = 0
         AND l_process_spin                      = 1
      THEN
        l_result := usim_spc.flip_process_spin(p_usim_id_spc, FALSE);
        -- check fail
        IF l_result = 1
        THEN
          IF p_do_commit
          THEN
            COMMIT;
          END IF;
          RETURN 1;
        ELSE
          usim_erl.log_error('usim_dbif.check_border', 'Could not flip process spin on space id [' || p_usim_id_spc || '].');
          -- set all to crashed
          usim_dbif.set_crashed;
          ROLLBACK;
          RETURN 0;
        END IF;
      ELSE
        RETURN 1;
      END IF;
    ELSE
      -- if no child in dimension and direction is child flip to parent
      IF     usim_chi.has_child_same_dim(p_usim_id_spc) = 0
         AND l_process_spin                             = 1
      THEN
        l_result := usim_spc.flip_process_spin(p_usim_id_spc, FALSE);
        -- check fail
        IF l_result = 1
        THEN
          IF p_do_commit
          THEN
            COMMIT;
          END IF;
          RETURN 1;
        ELSE
          usim_erl.log_error('usim_dbif.check_border', 'Could not flip process spin on space id [' || p_usim_id_spc || '].');
          -- set all to crashed
          usim_dbif.set_crashed;
          ROLLBACK;
          RETURN 0;
        END IF;
      END IF;
    END IF;
    RETURN 1;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      -- write error might still work
      usim_erl.log_error('usim_dbif.check_border', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END check_border
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
      -- write error might still work
      usim_erl.log_error('usim_dbif.get_id_pos', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END get_id_pos
  ;

  FUNCTION get_id_nod(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_node.usim_id_nod%TYPE
  IS
    l_result usim_node.usim_id_nod%TYPE;
  BEGIN
    l_result := usim_spc.get_id_nod(p_usim_id_spc);
    IF l_result IS NULL
    THEN
      usim_erl.log_error('usim_dbif.get_id_nod', 'Invalid space id [' || p_usim_id_spc || '] or no node found.');
      usim_dbif.set_crashed;
    END IF;
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.get_id_nod', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END get_id_nod
  ;

  FUNCTION get_id_mlv(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_multiverse.usim_id_mlv%TYPE
  IS
    l_result usim_multiverse.usim_id_mlv%TYPE;
  BEGIN
    l_result := usim_spc.get_id_mlv(p_usim_id_spc);
    IF l_result IS NULL
    THEN
      usim_erl.log_error('usim_dbif.get_id_mlv', 'Invalid space id [' || p_usim_id_spc || '] or no node found.');
      usim_dbif.set_crashed;
    END IF;
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.get_id_mlv', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END get_id_mlv
  ;

  FUNCTION get_id_spc_base_universe
    RETURN usim_space.usim_id_spc%TYPE
  IS
    l_result usim_space.usim_id_spc%TYPE;
  BEGIN
    l_result := usim_spc.get_id_spc_base_universe;
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.get_id_spc_base_universe', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END get_id_spc_base_universe
  ;

  FUNCTION get_spc_dim_details( p_usim_id_spc  IN  usim_space.usim_id_spc%TYPE
                              , p_usim_id_mlv  OUT usim_multiverse.usim_id_mlv%TYPE
                              , p_usim_id_rmd  OUT usim_rel_mlv_dim.usim_id_rmd%TYPE
                              , p_usim_sign    OUT usim_rel_mlv_dim.usim_sign%TYPE
                              , p_usim_n1_sign OUT usim_rel_mlv_dim.usim_n1_sign%TYPE
                              )
    RETURN NUMBER
  IS
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      p_usim_id_mlv   := usim_spc.get_id_mlv(p_usim_id_spc);
      p_usim_id_rmd   := usim_spc.get_id_rmd(p_usim_id_spc);
      p_usim_sign     := usim_spc.get_dim_sign(p_usim_id_spc);
      p_usim_n1_sign  := usim_spc.get_dim_n1_sign(p_usim_id_spc);
      RETURN 1;
    ELSE
      usim_erl.log_error('usim_dbif.get_spc_dim_details', 'Not existing space id [' || p_usim_id_spc || '].');
      usim_dbif.set_crashed;
      RETURN 0;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.get_spc_dim_details', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END get_spc_dim_details
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
      -- write error might still work
      usim_erl.log_error('usim_dbif.get_dim_sign', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END get_dim_sign
  ;

  FUNCTION get_dim_n1_sign(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_rel_mlv_dim.usim_n1_sign%TYPE
  IS
    l_result usim_rel_mlv_dim.usim_n1_sign%TYPE;
  BEGIN
    l_result := usim_spc.get_dim_n1_sign(p_usim_id_spc);
    IF l_result IS NULL
    THEN
      usim_erl.log_error('usim_dbif.get_dim_n1_sign', 'Invalid space id [' || p_usim_id_spc || '].');
    END IF;
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.get_dim_n1_sign', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END get_dim_n1_sign
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
      -- write error might still work
      usim_erl.log_error('usim_dbif.get_xyz', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END get_xyz
  ;

  FUNCTION get_magnitude( p_usim_id_spc      IN usim_space.usim_id_spc%TYPE
                        , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                        )
    RETURN NUMBER
  IS
    l_result  NUMBER;
  BEGIN
    l_result := usim_spo.get_magnitude(p_usim_id_spc, p_usim_n_dimension);
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.get_magnitude', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END get_magnitude
  ;

  FUNCTION get_process_spin(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_space.usim_process_spin%TYPE
  IS
    l_result usim_space.usim_process_spin%TYPE;
  BEGIN
    l_result := usim_spc.get_process_spin(p_usim_id_spc);
    IF l_result IS NULL
    THEN
      usim_erl.log_error('usim_dbif.get_process_spin', 'Used with invalid space id [' || p_usim_id_spc || '].');
    END IF;
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.get_process_spin', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END get_process_spin
  ;

  FUNCTION get_universe_state_desc(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN VARCHAR2
  IS
    l_mlv_id    usim_multiverse.usim_id_mlv%TYPE;
    l_state     usim_multiverse.usim_universe_status%TYPE;
    l_result    VARCHAR2(8);
  BEGIN
    -- get universe
    l_mlv_id := usim_spc.get_id_mlv(p_usim_id_spc);
    IF l_mlv_id IS NULL
    THEN
      RETURN 'UNKNOWN';
    END IF;
    l_state  := usim_mlv.get_state(l_mlv_id);
    l_result := usim_static.get_multiverse_status(l_state);
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.get_universe_state_desc', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END get_universe_state_desc
  ;

  FUNCTION get_planck_time_current
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    l_result := usim_base.get_planck_time_current;
    IF l_result IS NULL
    THEN
      usim_erl.log_error('usim_dbif.get_planck_time_current', 'Planck time not initialized.');
      usim_dbif.set_crashed;
    END IF;
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.get_planck_time_current', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END get_planck_time_current
  ;

  FUNCTION get_planck_aeon_seq_current
    RETURN VARCHAR2
  IS
    l_result CHAR(55);
  BEGIN
    l_result := usim_base.get_planck_aeon_seq_current;
    IF l_result IS NULL
    THEN
      usim_erl.log_error('usim_dbif.get_planck_aeon_seq_current', 'Planck aeon not initialized.');
      usim_dbif.set_crashed;
    END IF;
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.get_planck_aeon_seq_current', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END get_planck_aeon_seq_current
  ;

  FUNCTION get_planck_time_next
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    l_result := usim_base.get_planck_time_next;
    IF l_result IS NULL
    THEN
      usim_erl.log_error('usim_dbif.get_planck_time_next', 'Planck time initialization error.');
      usim_dbif.set_crashed;
    END IF;
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.get_planck_time_next', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END get_planck_time_next
  ;

  FUNCTION get_unprocessed_planck( p_usim_planck_aeon OUT usim_spc_process.usim_planck_aeon%TYPE
                                 , p_usim_planck_time OUT usim_spc_process.usim_planck_time%TYPE
                                 )
    RETURN NUMBER
  IS
    l_return NUMBER;
  BEGIN
    l_return := usim_spr.get_unprocessed_planck(p_usim_planck_aeon, p_usim_planck_time);
    RETURN l_return;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.get_unprocessed_planck', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END get_unprocessed_planck
  ;

  FUNCTION get_axis_max_pos_parent(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_space.usim_id_spc%TYPE
  IS
    l_result usim_space.usim_id_spc%TYPE;
  BEGIN
    l_result := usim_spo.get_axis_max_pos_parent(p_usim_id_spc);
    RETURN l_result;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.get_axis_max_pos_parent', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END get_axis_max_pos_parent
  ;

  FUNCTION get_axis_max_pos_dim1(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
  IS
    l_id_mlv  usim_multiverse.usim_id_mlv%TYPE;
    l_n1_sign usim_rel_mlv_dim.usim_n1_sign%TYPE;
    l_id_spc  usim_space.usim_id_spc%TYPE;
    l_parent  usim_space.usim_id_spc%TYPE;
    l_max_pos usim_position.usim_coordinate%TYPE;
  BEGIN
    l_id_mlv  := usim_spc.get_id_mlv(p_usim_id_spc);
    l_n1_sign := usim_spc.get_dim_n1_sign(p_usim_id_spc);
    IF usim_spc.get_cur_max_dim_n1(p_usim_id_spc) > 0
    THEN
      -- get dimension 1 by universe parent
      WITH rmd AS
           (SELECT usim_id_rmd
              FROM usim_rmd_v
             WHERE usim_id_mlv = l_id_mlv
               AND usim_n_dimension = 0
           )
         , spc AS
           (SELECT spcv.usim_id_spc
              FROM usim_spc_v spcv
             INNER JOIN rmd
                ON spcv.usim_id_rmd = rmd.usim_id_rmd
           )
      SELECT chiv.usim_id_spc_child
        INTO l_id_spc
        FROM usim_chi_v chiv
       INNER JOIN spc
          ON chiv.usim_id_spc = spc.usim_id_spc
       WHERE child_dim_n1_sign = l_n1_sign
      ;
      l_parent  := usim_spo.get_axis_max_pos_parent(l_id_spc);
      IF l_parent IS NULL
      THEN
        usim_erl.log_error('usim_dbif.get_axis_max_pos_dim1', 'Could not get max axis dimension 1 coordinate for [' || p_usim_id_spc || '] axis 1 pos 0 id [' || l_id_spc || '].');
        usim_dbif.set_crashed;
      END IF;
      l_max_pos := usim_spc.get_coordinate(l_parent);
      IF l_max_pos IS NULL
      THEN
        usim_erl.log_error('usim_dbif.get_axis_max_pos_dim1', 'Could not get max coordinate for [' || p_usim_id_spc || '] max pos space id [' || l_parent || '].');
        usim_dbif.set_crashed;
      END IF;
      RETURN l_max_pos;
    ELSE
      RETURN 0;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.get_axis_max_pos_dim1', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END get_axis_max_pos_dim1
  ;

  FUNCTION get_next_pos_on_axis( p_usim_id_spc IN  usim_space.usim_id_spc%TYPE
                               , p_usim_id_pos OUT usim_position.usim_id_pos%TYPE
                               , p_usim_id_rmd OUT usim_rel_mlv_dim.usim_id_rmd%TYPE
                               )
    RETURN NUMBER
  IS
    l_new_pos NUMBER;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      -- determine the sign of the coordinate by dim sign
      IF usim_spc.get_dim_sign(p_usim_id_spc) = 1
      THEN
        l_new_pos := usim_spc.get_coordinate(p_usim_id_spc) + 1;
      ELSE
        l_new_pos := usim_spc.get_coordinate(p_usim_id_spc) - 1;
      END IF;
      p_usim_id_pos := usim_pos.get_id_pos(l_new_pos);
      p_usim_id_rmd := usim_spc.get_id_rmd(p_usim_id_spc);
      RETURN 1;
    ELSE
      usim_erl.log_error('usim_dbif.get_next_pos_on_axis', 'Invalid space id [' || p_usim_id_spc || '].');
      RETURN 0;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      -- write error might still work
      usim_erl.log_error('usim_dbif.get_next_pos_on_axis', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END get_next_pos_on_axis
  ;

  FUNCTION overflow_rating(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
  BEGIN
    -- do we have overflow on dimensions and positions
    IF      usim_dbif.is_overflow_dim_spc(p_usim_id_spc) = 1
       AND  usim_dbif.is_overflow_pos_spc(p_usim_id_spc) = 1
    THEN
      -- total overflow, no possible dimension or position open
      RETURN 0;
    ELSIF usim_dbif.max_childs(p_usim_id_spc) = usim_dbif.child_count(p_usim_id_spc)
    THEN
      -- total overflow, all possible childs connected
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
      l_max_dim := NVL(usim_spc.get_cur_max_dim_n1(p_usim_id_spc), 0) + 1;
      IF usim_base.get_max_dimension < l_max_dim
      THEN
        l_max_dim := usim_base.get_max_dimension;
      END IF;
      IF     l_n_dimension = 1
         AND l_coordinate  = 0
      THEN
        -- zero pos dimension axis at dimension 1
        -- all dimension axis and position on dimension axis: (max n - n) x 2 + 1 axis child
        p_max_childs := ((l_max_dim - l_n_dimension) * 2) + 1;
        RETURN 1;
      END IF;
      IF     l_n_dimension > 1
         AND l_coordinate  = 0
      THEN
        -- zero pos dimension axis dimension > 1
        -- only position on dimension axis and 1 inbetween node: 2 childs
        p_max_childs := 2;
        RETURN 2;
      END IF;
      -- count coordinates not 0 for space id
      SELECT COUNT(*) INTO l_count FROM usim_spo_v WHERE usim_id_spc = p_usim_id_spc AND usim_coordinate != 0;
      IF     l_count       = 1
         AND l_coordinate != 0
      THEN
        -- pure dimension axis, possible childs: (max n - n) + 1 axis child
        p_max_childs := (l_max_dim  - l_n_dimension) + 1;
        RETURN 3;
      ELSE
        -- anywhere, possible childs: max n
        p_max_childs := l_max_dim;
        RETURN 4;
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
    l_dimension    NUMBER;
    l_max_pos      NUMBER;
    l_has_n1       NUMBER;
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
    IF l_dim_rating = 0 -- center of a universe dimension
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
    ELSIF l_dim_rating = 1 -- center dimension axis with pos 0 dimension > 0
    THEN
      -- only 2 childs possible
      IF l_child_count = l_max_child
      THEN
        -- fully connected
        RETURN 0;
      ELSE
        IF l_child_count > 0
        THEN
          -- find free node
          IF usim_chi.has_child_same_dim(p_usim_id_spc) = 1
          THEN
            -- if the position number on x axis that equals next dimension does not exist only position on X axis possible
            l_dimension := usim_spc.get_dimension(p_usim_id_spc) + 1;
            l_max_pos := ABS(NVL(usim_spc.get_coordinate(usim_spo.get_axis_max_pos_parent(p_usim_id_spc)), 1));
            IF l_max_pos >= l_dimension
            THEN
              -- only next dimension possible
              RETURN 2;
            ELSE
              -- first extend dimension axis
              RETURN 4;
            END IF;
          ELSE
            -- position or dimension (not checking upper dimensions available)
            RETURN 1;
          END IF;
        ELSE
          -- no childs at all
          -- position or dimension (not checking upper dimensions available)
          RETURN 1;
        END IF;
      END IF;
    ELSIF l_dim_rating = 2 -- on dimension axis pos > 0
    THEN
      IF l_child_count = l_max_child
      THEN
        -- fully connected
        RETURN 0;
      ELSE
        -- find free node
        IF l_child_count > 0
        THEN
          IF usim_chi.has_child_same_dim(p_usim_id_spc) = 1
          THEN
            -- only next dimension possible
            RETURN 2;
          ELSE
            -- position or dimension (not checking upper dimensions available)
            RETURN 1;
          END IF;
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
        IF usim_chi.has_child_same_dim(p_usim_id_spc) = 1
        THEN
          -- only next dimension possible
          RETURN 2;
        ELSE
          -- position or dimension (not checking upper dimensions available)
          RETURN 1;
        END IF;
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
    l_parent_classification NUMBER;
    l_max_dim               NUMBER;
    l_max_cur_dim           NUMBER;
    l_max_pos               NUMBER;
    l_max_cur_pos           NUMBER;
    l_max_n1_pos            NUMBER;
    l_max_childs            NUMBER;
    l_childs                NUMBER;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 1
    THEN
      l_max_dim               := usim_base.get_max_dimension;
      l_max_pos               := usim_base.get_abs_max_number;
      l_max_cur_dim           := usim_spc.get_cur_max_dim_n1(p_usim_id_spc);
      l_max_cur_pos           := usim_spc.get_cur_max_pos(p_usim_id_spc);
      l_max_childs            := usim_dbif.max_childs(p_usim_id_spc);
      l_childs                := usim_dbif.child_count(p_usim_id_spc);
      l_parent_classification := usim_dbif.classify_parent(p_usim_id_spc);
      l_max_n1_pos            := ABS(usim_dbif.get_axis_max_pos_dim1(p_usim_id_spc));

      -- check all classifications against all kinds of overflow
      IF l_parent_classification < 0
      THEN
        -- classification error, we should stop here
        usim_erl.log_error('usim_dbif.classify_escape', 'Classification error parent on id [' || p_usim_id_spc || '].');
        usim_dbif.set_crashed;
        RETURN -1;
      ELSIF l_parent_classification = 0
      THEN
        RETURN l_parent_classification;
      ELSIF l_parent_classification = 1
      THEN
        -- check if dimension and positions are over the max for n1 side of space node
        IF     l_max_cur_dim  < l_max_dim
           AND l_max_cur_pos  < l_max_pos
           AND l_max_n1_pos  >= l_max_cur_dim
        THEN
          -- everything available
          RETURN l_parent_classification;
        ELSIF     l_max_cur_dim  < l_max_dim
              AND l_max_n1_pos  >= l_max_cur_dim
        THEN
          -- only dimensions available
          RETURN 2;
        ELSIF     l_max_cur_dim < l_max_dim
              AND l_max_n1_pos  < l_max_cur_dim
        THEN
          IF usim_dbif.has_free_between(p_usim_id_spc) = 1
          THEN
            -- prefer filling between nodes
            RETURN 7;
          ELSE
            -- only position dim axis 1 delegate available
            RETURN 6;
          END IF;
        ELSIF l_max_cur_pos < l_max_pos
        THEN
          -- only positions available
          RETURN 3;
        -- full only new universe or delegate between
        ELSIF usim_dbif.has_free_between(p_usim_id_spc) = 1
        THEN
            -- delegate between
            RETURN 7;
        ELSE
          -- no delegate options
          RETURN 0;
        END IF;
      ELSIF l_parent_classification = 2
      THEN
        -- check
        IF     l_max_cur_dim  < l_max_dim
           AND l_max_n1_pos  >= l_max_cur_dim
        THEN
          -- everything available
          RETURN l_parent_classification;
        ELSIF     l_max_cur_dim < l_max_dim
              AND l_max_n1_pos  < l_max_cur_dim
        THEN
          IF usim_dbif.has_free_between(p_usim_id_spc) = 1
          THEN
            -- prefer filling between nodes
            RETURN 7;
          ELSE
            -- only position dim axis 1 delegate available
            RETURN 6;
          END IF;
        -- full only new universe or delegate
        ELSIF     l_max_cur_pos                             < l_max_pos
              AND usim_dbif.has_free_between(p_usim_id_spc) = 0
        THEN
          -- delegate position, if no between nodes are free
          RETURN 5;
        ELSIF usim_dbif.has_free_between(p_usim_id_spc) = 1
        THEN
          -- delegate between
          RETURN 7;
        ELSE
          -- no delegate options
          RETURN 0;
        END IF;
      ELSIF l_parent_classification IN (3, 4)
      THEN
        -- check
        IF l_max_cur_pos < l_max_pos
        THEN
          -- everything available
          RETURN l_parent_classification;
        -- full only new universe or delegate
        ELSIF     l_parent_classification                   = 4
              AND usim_dbif.has_free_between(p_usim_id_spc) = 0
        THEN
          RETURN l_parent_classification;
        ELSIF     l_max_cur_dim                             < l_max_dim
              AND usim_dbif.has_free_between(p_usim_id_spc) = 0
        THEN
          -- delegate new dimension, if no between nodes are free
          RETURN 4;
        ELSIF usim_dbif.has_free_between(p_usim_id_spc) = 1
        THEN
          -- delegate between
          RETURN 7;
        ELSE
          -- no delegate options
          RETURN 0;
        END IF;
      ELSE
        -- classification unknown
        usim_erl.log_error('usim_dbif.classify_escape', 'Unknown parent classfication [' || l_parent_classification || '] for id [' || p_usim_id_spc || '].');
        usim_dbif.set_crashed;
        RETURN -1;
      END IF;
    ELSE
      RETURN -1;
    END IF;
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

  FUNCTION get_dim_G( p_usim_id_spc IN  usim_space.usim_id_spc%TYPE
                    , p_node_G      OUT NUMBER
                    )
    RETURN NUMBER
  IS
    l_dimension   usim_dimension.usim_n_dimension%TYPE;
    l_G           NUMBER;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 0
    THEN
      usim_erl.log_error('usim_process.get_dim_G', 'Used with invalid space id [' || p_usim_id_spc || '].');
      RETURN -1;
    END IF;
    l_dimension := usim_spc.get_dimension(p_usim_id_spc);
    IF l_dimension = -1
    THEN
      usim_erl.log_error('usim_process.get_dim_G', 'Failed to get_dimension for space id [' || p_usim_id_spc || '].');
      RETURN -1;
    END IF;
    l_G := usim_maths.calc_dim_G(l_dimension);
    IF usim_base.num_has_overflow(l_G) = 1
    THEN
      usim_erl.log_error('usim_dbif.get_dim_G', 'Numerical overflow for l_G[' || l_G || '] overflow [' || usim_base.get_abs_max_number || ',-' || usim_base.get_abs_max_number || '] underflow[' || usim_base.get_max_underflow || ',' || usim_base.get_min_underflow || '].');
      RETURN 0;
    ELSE
      -- only set out value if valid value
      p_node_G := l_G;
      RETURN 1;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE IN (-6502, -1426, -1428, -1476, -1487)
      THEN
        -- -6502 numeric value error POWER etc. or -1426 overflow or -1428 value range, -1476 zero divide, -1401: inserted value too large for column
        -- -1487: packed decimal number too large
        usim_erl.log_error('usim_dbif.get_dim_G', 'Numerical error on G calculate [' || SQLCODE || '] error message: ' || SQLERRM);
        RETURN 0;
      ELSE
        usim_erl.log_error('usim_dbif.get_dim_G', 'Unknown error [' || SQLCODE || '] error message: ' || SQLERRM);
        -- try to set all to crashed
        usim_dbif.set_crashed;
        -- return -1 handling is up to caller
        RETURN -1;
      END IF;
  END get_dim_G
  ;

  FUNCTION get_outer_planck_r( p_usim_id_spc    IN  usim_space.usim_id_spc%TYPE
                             , p_outer_planck_r OUT NUMBER
                             )
    RETURN NUMBER
  IS
    l_planck_length NUMBER;
    l_radius        NUMBER;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 0
    THEN
      usim_erl.log_error('usim_process.get_dim_G', 'Used with invalid space id [' || p_usim_id_spc || '].');
      RETURN -1;
    END IF;
    SELECT usim_planck_length_unit
      INTO l_planck_length
      FROM usim_spc_v
     WHERE usim_id_spc = p_usim_id_spc
    ;
    l_radius := usim_maths.apply_planck(1, l_planck_length);
    IF usim_base.num_has_overflow(l_radius) = 1
    THEN
      usim_erl.log_error('usim_dbif.get_outer_planck_r', 'Numerical overflow for l_radius[' || l_radius || '] overflow [' || usim_base.get_abs_max_number || ',-' || usim_base.get_abs_max_number || '] underflow[' || usim_base.get_max_underflow || ',' || usim_base.get_min_underflow || '].');
      RETURN 0;
    ELSE
      -- only set out value if valid value
      p_outer_planck_r := l_radius;
      RETURN 1;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE IN (-6502, -1426, -1428, -1476, -1487)
      THEN
        -- -6502 numeric value error POWER etc. or -1426 overflow or -1428 value range, -1476 zero divide, -1401: inserted value too large for column
        -- -1487: packed decimal number too large
        usim_erl.log_error('usim_dbif.get_outer_planck_r', 'Numerical error on outer planck r calculation [' || SQLCODE || '] error message: ' || SQLERRM);
        RETURN 0;
      ELSE
        usim_erl.log_error('usim_process.get_outer_planck_r', 'Unknown error [' || SQLCODE || '] error message: ' || SQLERRM);
        -- try to set all to crashed
        usim_dbif.set_crashed;
        -- return -1 handling is up to caller
        RETURN -1;
      END IF;
  END get_outer_planck_r
  ;

  FUNCTION get_acceleration( p_energy         IN  NUMBER
                           , p_radius         IN  NUMBER
                           , p_G              IN  NUMBER
                           , p_target_energy  OUT NUMBER
                           )
    RETURN NUMBER
  IS
    l_energy NUMBER;
  BEGIN
    l_energy := usim_maths.calc_planck_a2(p_energy, p_radius, p_G);
    IF usim_base.num_has_overflow(l_energy) = 1
    THEN
      usim_debug.debug_log('usim_dbif.get_acceleration', 'Numerical overflow for l_energy[' || l_energy || '] overflow [' || usim_base.get_abs_max_number || ',-' || usim_base.get_abs_max_number || '] underflow[' || usim_base.get_max_underflow || ',' || usim_base.get_min_underflow || '].');
      RETURN 0;
    ELSE
      -- only set out value if valid value
      p_target_energy := l_energy;
      RETURN 1;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE IN (-6502, -1426, -1428, -1476, -1487)
      THEN
        -- -6502 numeric value error POWER etc. or -1426 overflow or -1428 value range, -1476 zero divide, -1401: inserted value too large for column
        -- -1487: packed decimal number too large
        usim_debug.debug_log('usim_dbif.get_acceleration', 'Numerical error on acceleration calculation [' || SQLCODE || '] error message: ' || SQLERRM);
        RETURN 0;
      ELSE
        usim_erl.log_error('usim_process.get_acceleration', 'Unknown error [' || SQLCODE || '] error message: ' || SQLERRM);
        -- try to set all to crashed
        usim_dbif.set_crashed;
        -- return -1 handling is up to caller
        RETURN -1;
      END IF;
  END get_acceleration
  ;

END usim_dbif;
/