CREATE OR REPLACE PACKAGE BODY usim_process
IS
  -- see header for documentation

  FUNCTION place_start_node( p_max_dimension            IN NUMBER                                       DEFAULT 42
                           , p_usim_abs_max_number      IN NUMBER                                       DEFAULT 99999999999999999999999999999999999999
                           , p_usim_overflow_node_seed  IN NUMBER                                       DEFAULT 0
                           , p_usim_energy_start_value  IN usim_multiverse.usim_energy_start_value%TYPE DEFAULT 1
                           , p_usim_planck_time_unit    IN usim_multiverse.usim_planck_time_unit%TYPE   DEFAULT 1
                           , p_usim_planck_length_unit  IN usim_multiverse.usim_planck_length_unit%TYPE DEFAULT 1
                           , p_usim_planck_speed_unit   IN usim_multiverse.usim_planck_speed_unit%TYPE  DEFAULT 1
                           , p_usim_planck_stable       IN usim_multiverse.usim_planck_stable%TYPE      DEFAULT 1
                           , p_usim_ultimate_border     IN usim_multiverse.usim_ultimate_border%TYPE    DEFAULT 1
                           , p_do_commit                IN BOOLEAN                                      DEFAULT TRUE
                           )
    RETURN NUMBER
  IS
    l_source_G      NUMBER;
    l_distance      NUMBER;
    l_energy        NUMBER;
    l_start_value   NUMBER;
    l_target_energy NUMBER;
    l_resDimG       NUMBER;
    l_resR          NUMBER;
    l_resEnergy     NUMBER;
    l_return        NUMBER;
    l_planck_time   NUMBER;
    l_planck_aeon   usim_static.usim_id;
    l_state         usim_multiverse.usim_universe_status%TYPE;
    l_base_id       usim_space.usim_id_spc%TYPE;
    l_spr_id        usim_spc_process.usim_id_spr%TYPE;

    CURSOR cur_childs(cp_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    IS
      SELECT chi.usim_id_spc_child
           , spcv.usim_energy
           , spcv.dim_sign
        FROM usim_spc_child chi
       INNER JOIN usim_spc_v spcv
          ON chi.usim_id_spc_child = spcv.usim_id_spc
       WHERE chi.usim_id_spc = cp_usim_id_spc
    ;
  BEGIN
    IF usim_dbif.has_data_spr = 1
    THEN
      -- can't insert start node if data already exist
      usim_erl.log_error('usim_process.place_start_node', 'Process already initialized, no start node allowed.');
      RETURN 0;
    END IF;
    -- prepare base data if needed
    IF usim_dbif.has_basedata = 0
    THEN
      l_return := usim_dbif.init_basedata(p_max_dimension, p_usim_abs_max_number, p_usim_overflow_node_seed);
      IF l_return = 0
      THEN
        usim_erl.log_error('usim_process.place_start_node', 'Could not initialize base data with max dim [' || p_max_dimension || '], max_num [' || p_usim_abs_max_number || '] and overflow rule [' || p_usim_overflow_node_seed || '].');
        RETURN 0;
      END IF;
    END IF;
    -- check planck aeon
    l_planck_aeon := usim_dbif.get_planck_aeon_seq_current;
    IF l_planck_aeon = usim_static.usim_not_available
    THEN
      -- init planck aeon and time
      l_planck_time := usim_dbif.get_planck_time_next;
      IF l_planck_time IS NULL
      THEN
        usim_erl.log_error('usim_process.place_start_node', 'Could not initialize planck time.');
        RETURN 0;
      END IF;
      l_planck_aeon := usim_dbif.get_planck_aeon_seq_current;
      IF l_planck_aeon = usim_static.usim_not_available
      THEN
        usim_erl.log_error('usim_process.place_start_node', 'Could not initialize planck aeon with planck time next.');
        RETURN 0;
      END IF;
    ELSE
      -- we should have a planck time if aeon is set
      l_planck_time := usim_dbif.get_planck_time_current;
      IF l_planck_time IS NULL
      THEN
        usim_erl.log_error('usim_process.place_start_node', 'Could not get current planck time with planck aeon already set.');
        RETURN 0;
      END IF;
    END IF;
    -- check universe
    IF usim_dbif.has_data_mlv = 0
    THEN
      -- create base universe seed
      l_base_id := usim_creator.create_new_universe( p_usim_energy_start_value
                                                   , p_usim_planck_time_unit
                                                   , p_usim_planck_length_unit
                                                   , p_usim_planck_speed_unit
                                                   , p_usim_planck_stable
                                                   , p_usim_ultimate_border
                                                   , NULL
                                                   , TRUE
                                                   )
      ;
      IF l_base_id IS NULL
      THEN
        usim_erl.log_error('usim_process.place_start_node', 'Could not create missing base universe energy start [' || p_usim_energy_start_value || '],  planck time [' || p_usim_planck_time_unit || '],  planck length [' || p_usim_planck_length_unit || '], planck speed [' || p_usim_planck_speed_unit || '], planck stable [' || p_usim_planck_stable || '], border rule [' || p_usim_ultimate_border || '] and no parent.');
        -- rely on rollback of called function
        RETURN 0;
      END IF;
    ELSE
      -- universe exists, what about nodes?
      IF usim_dbif.has_data_spc = 0
      THEN
        usim_erl.log_error('usim_process.place_start_node', 'Initialization error. Existing universe but no space nodes available.');
        RETURN 0;
      END IF;
      l_base_id := usim_dbif.get_id_spc_base_universe;
      IF l_base_id IS NULL
      THEN
        usim_erl.log_error('usim_process.place_start_node', 'Initialization error. Could not fetch base universe seed.');
        RETURN 0;
      END IF;
    END IF;
    -- check childs of base universe
    IF usim_dbif.child_count(l_base_id) != 2
    THEN
      -- we expect exactly two childs for base universe seed
        usim_erl.log_error('usim_process.place_start_node', 'Initialization error. Base universe seed has not the correct amount of childs (2).');
        RETURN 0;
    END IF;
    -- activate seed universe, if not already done
    l_state := usim_dbif.set_seed_active(FALSE);
    IF l_state != usim_static.usim_multiverse_status_active
    THEN
      ROLLBACK;
      -- cannot start with this universe
      usim_erl.log_error('usim_process.place_start_node', 'Universe state error. Current universe cannot be switched to active, space id [' || l_base_id || '] state [' || l_state || '].');
      RETURN 0;
    END IF;
    -- ready to start
    SELECT usim_energy
         , usim_energy_start_value
      INTO l_energy
         , l_start_value
      FROM usim_spc_v
     WHERE usim_id_spc = l_base_id
    ;
    IF l_energy IS NULL
    THEN
      l_energy := l_start_value;
    END IF;
    l_resDimG := usim_dbif.get_dim_G(l_base_id, l_source_G);
    IF l_resDimG != 1
    THEN
      usim_erl.log_error('usim_process.place_start_node', 'Universe setup error. Calculate dimension G for space id [' || l_base_id || '] should not give error or overflow [' || l_resDimG || '].');
      usim_dbif.set_crashed;
      RETURN 0;
    END IF;
    l_resR := usim_dbif.get_outer_planck_r(l_base_id, l_distance);
    IF l_resR != 1
    THEN
      usim_erl.log_error('usim_process.place_start_node', 'Universe setup error. Calculate radius for space id [' || l_base_id || '] should not give error or overflow [' || l_resR || '].');
      usim_dbif.set_crashed;
      RETURN 0;
    END IF;
    l_resEnergy := usim_dbif.get_acceleration(l_energy, l_distance, l_source_G, l_target_energy);
    IF l_resEnergy != 1
    THEN
      usim_erl.log_error('usim_process.place_start_node', 'Universe setup error. Calculate energy for base seed space id [' || l_base_id || '] should not give error or overflow [' || l_resEnergy || ']. Energy [' || l_energy || '], distance [' || l_distance || '], G [' || l_source_G || '].');
      usim_dbif.set_crashed;
      RETURN 0;
    END IF;
    -- process childs
    FOR rec IN cur_childs(l_base_id)
    LOOP
      l_spr_id := usim_dbif.create_process(l_base_id, rec.usim_id_spc_child, l_energy, rec.usim_energy, l_target_energy * rec.dim_sign, FALSE);
      IF l_spr_id IS NULL
      THEN
        ROLLBACK;
        -- error insert
        usim_erl.log_error('usim_process.place_start_node', 'Could not insert process record.');
        usim_dbif.set_crashed;
        RETURN 0;
      END IF;
    END LOOP;
    -- commit everything if gone well
    IF p_do_commit
    THEN
      COMMIT;
    END IF;
    RETURN 1;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      -- write error might still work
      usim_erl.log_error('usim_process.place_start_node', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END place_start_node
  ;

  FUNCTION process_node( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                       , p_do_commit   IN BOOLEAN                     DEFAULT TRUE
                       )
    RETURN NUMBER
  IS
    l_source_G      NUMBER;
    l_distance      NUMBER;
    l_energy        NUMBER;
    l_start_value   NUMBER;
    l_target_energy NUMBER;
    l_resDimG       NUMBER;
    l_resR          NUMBER;
    l_resEnergy     NUMBER;
    l_is_base       INTEGER;
    l_result        INTEGER;
    l_spr_id        usim_spc_process.usim_id_spr%TYPE;
    l_executed      BOOLEAN;

    CURSOR cur_childs(cp_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    IS
      SELECT chi.usim_id_spc_child
           , spcv.usim_energy
           , spcv.dim_sign
        FROM usim_spc_child chi
       INNER JOIN usim_spc_v spcv
          ON chi.usim_id_spc_child = spcv.usim_id_spc
       WHERE chi.usim_id_spc = cp_usim_id_spc
    ;
    CURSOR cur_parent(cp_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    IS
      SELECT chi.usim_id_spc
           , spcv.usim_energy
           , spcv.dim_sign
        FROM usim_spc_child chi
       INNER JOIN usim_spc_v spcv
          ON chi.usim_id_spc = spcv.usim_id_spc
       WHERE chi.usim_id_spc_child = cp_usim_id_spc
    ;
  BEGIN
    IF usim_dbif.has_data_spc(p_usim_id_spc) = 0
    THEN
      usim_erl.log_error('usim_process.process_node', 'Used with invalid space id [' || p_usim_id_spc || '].');
      RETURN 0;
    END IF;
    IF usim_dbif.is_seed_active = 0
    THEN
      -- won't operate on universe not active
      usim_erl.log_error('usim_process.process_node', 'Current universe seed is not active. Node not processed space id [' || p_usim_id_spc || '].');
      RETURN 0;
    END IF;
    -- check border situation
    l_result := usim_dbif.check_border(p_usim_id_spc, FALSE);
    IF l_result != 1
    THEN
      usim_erl.log_error('usim_process.process_node', 'Check border failed with parameter [' || p_usim_id_spc || '].');
      RETURN 0;
    END IF;
    -- operate on node
    SELECT usim_energy
         , usim_energy_start_value
      INTO l_energy
         , l_start_value
      FROM usim_spc_v
     WHERE usim_id_spc = p_usim_id_spc
    ;
    l_is_base := usim_dbif.is_universe_base_type(p_usim_id_spc);
    IF l_is_base = 1
    THEN
      IF l_energy IS NULL
      THEN
        l_energy := l_start_value;
      END IF;
    END IF;
    l_resDimG := usim_dbif.get_dim_G(p_usim_id_spc, l_source_G);
    IF l_resDimG != 1
    THEN
      IF l_resDimG = 0
      THEN
        usim_erl.log_error('usim_process.process_node', 'Overflow for space id [' || p_usim_id_spc || '] usim_dbif.get_dim_G. Set G to default 1.');
        l_result   := usim_creator.handle_overflow(p_usim_id_spc, FALSE);
        IF l_result = 0
        THEN
          ROLLBACK;
          usim_erl.log_error('usim_process.process_node', 'usim_creator.handle_overflow failed for space id [' || p_usim_id_spc || '] usim_dbif.get_dim_G.');
          usim_dbif.set_crashed;
          RETURN 0;
        END IF;
        -- set to default
        l_source_G := 1;
      ELSE
        usim_erl.log_error('usim_process.process_node', 'Universe setup error. Calculate dimension G for space id [' || p_usim_id_spc || '] should not give error [' || l_resDimG || '].');
        usim_dbif.set_crashed;
        RETURN 0;
      END IF;
    END IF;
    l_resR := usim_dbif.get_outer_planck_r(p_usim_id_spc, l_distance);
    IF l_resR != 1
    THEN
      IF l_resR = 0
      THEN
        usim_erl.log_error('usim_process.process_node', 'Overflow for space id [' || p_usim_id_spc || '] usim_dbif.get_outer_planck_r. Set distance to default 1.');
        l_result   := usim_creator.handle_overflow(p_usim_id_spc, FALSE);
        IF l_result = 0
        THEN
          ROLLBACK;
          usim_erl.log_error('usim_process.process_node', 'usim_creator.handle_overflow failed for space id [' || p_usim_id_spc || '] usim_dbif.get_outer_planck_r.');
          usim_dbif.set_crashed;
          RETURN 0;
        END IF;
        -- set to default
        l_distance := 1;
      ELSE
        usim_erl.log_error('usim_process.process_node', 'Universe setup error. Calculate radius for space id [' || p_usim_id_spc || '] should not give error [' || l_resR || '].');
        usim_dbif.set_crashed;
        RETURN 0;
      END IF;
    END IF;
    l_resEnergy := usim_dbif.get_acceleration(l_energy, l_distance, l_source_G, l_target_energy);
    IF l_resEnergy != 1
    THEN
      IF l_resEnergy = 0
      THEN
        usim_erl.log_error('usim_process.process_node', 'Overflow for space id [' || p_usim_id_spc || '] usim_dbif.get_acceleration. Set target energy to 0.');
        l_result        := usim_creator.handle_overflow(p_usim_id_spc, FALSE);
        IF l_result = 0
        THEN
          ROLLBACK;
          usim_erl.log_error('usim_process.process_node', 'usim_creator.handle_overflow failed for space id [' || p_usim_id_spc || '] usim_dbif.get_acceleration.');
          usim_dbif.set_crashed;
          RETURN 0;
        END IF;
        l_target_energy := 0;
      ELSE
        usim_erl.log_error('usim_process.process_node', 'Universe setup error. Calculate acceleration energy for space id [' || p_usim_id_spc || '] should not give error [' || l_resEnergy || ']. With energy [' || l_energy || '], distance [' || l_distance || '], G [' || l_source_G || '].');
        usim_dbif.set_crashed;
        RETURN 0;
      END IF;
    END IF;
    -- process after checks decide direction
    IF usim_dbif.get_process_spin(p_usim_id_spc) = 1
    THEN
      -- childs
      l_executed := FALSE;
      FOR rec IN cur_childs(p_usim_id_spc)
      LOOP
        l_executed := TRUE;
        l_spr_id := usim_dbif.create_process( p_usim_id_spc
                                            , rec.usim_id_spc_child
                                            , l_energy
                                            , rec.usim_energy
                                            , CASE
                                                WHEN l_is_base = 1
                                                THEN l_target_energy * rec.dim_sign
                                                ELSE l_target_energy
                                              END
                                            , FALSE
                                            )
        ;
        IF l_spr_id IS NULL
        THEN
          ROLLBACK;
          -- error insert
          usim_erl.log_error('usim_process.process_node', 'Could not insert process record for space id [' || p_usim_id_spc || '].');
          usim_dbif.set_crashed;
          RETURN 0;
        END IF;
      END LOOP;
      IF NOT l_executed
      THEN
        usim_erl.log_error('usim_process.process_node', 'ERROR Child cursors had no data. cur_childs(' || p_usim_id_spc || ') process spin 1');
        usim_dbif.set_crashed;
        RETURN 0;
      END IF;
    ELSIF usim_dbif.get_process_spin(p_usim_id_spc) = -1
    THEN
      -- parents
      l_executed := FALSE;
      FOR rec IN cur_parent(p_usim_id_spc)
      LOOP
        l_executed := TRUE;
        l_spr_id := usim_dbif.create_process( p_usim_id_spc
                                            , rec.usim_id_spc
                                            , l_energy
                                            , rec.usim_energy
                                            , CASE
                                                WHEN l_is_base = 1
                                                THEN l_target_energy * rec.dim_sign
                                                ELSE l_target_energy
                                              END
                                            , FALSE
                                            )
        ;
        IF l_spr_id IS NULL
        THEN
          ROLLBACK;
          -- error insert
          usim_erl.log_error('usim_process.process_node', 'Could not insert process record for space id [' || p_usim_id_spc || '].');
          usim_dbif.set_crashed;
          RETURN 0;
        END IF;
      END LOOP;
      IF NOT l_executed
      THEN
        usim_erl.log_error('usim_process.process_node', 'ERROR Parent cursor had no data. cur_parent(' || p_usim_id_spc || ') process spin -1');
        usim_dbif.set_crashed;
        RETURN 0;
      END IF;
    ELSE
      -- invalid space id or process spin
      ROLLBACK;
      -- error insert
      usim_erl.log_error('usim_process.process_node', 'Invalid space id [' || p_usim_id_spc || '] no process direction found.');
      usim_dbif.set_crashed;
      RETURN 0;
    END IF;
    IF p_do_commit
    THEN
      COMMIT;
    END IF;
    RETURN 1;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      -- write error might still work
      usim_erl.log_error('usim_process.process_node', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END process_node
  ;

  FUNCTION process_queue(p_do_commit IN BOOLEAN DEFAULT TRUE)
    RETURN NUMBER
  IS
    l_energy      NUMBER;
    l_energy_set  NUMBER;
    l_result      NUMBER;
    l_planck_tick NUMBER;
    l_usim_id_nod usim_node.usim_id_nod%TYPE;
    l_planck_aeon usim_spc_process.usim_planck_aeon%TYPE;
    l_planck_time usim_spc_process.usim_planck_time%TYPE;
    l_cur_aeon    usim_spc_process.usim_planck_aeon%TYPE;
    l_cur_time    usim_spc_process.usim_planck_time%TYPE;
    l_usim_id_spr usim_spc_process.usim_id_spr%TYPE;
    l_executed    BOOLEAN;
    l_exec_inner  BOOLEAN;

    CURSOR cur_targets
    IS
      SELECT usim_id_spc_target
           , usim_planck_aeon
           , usim_planck_time
        FROM usim_spc_process
       WHERE is_processed = 0
       GROUP BY usim_id_spc_target
              , usim_planck_aeon
              , usim_planck_time
    ;
    CURSOR cur_old_targets( cp_planck_aeon IN usim_spc_process.usim_planck_aeon%TYPE
                          , cp_planck_time IN usim_spc_process.usim_planck_time%TYPE
                          )
    IS
      SELECT usim_id_spc_target
           , usim_planck_aeon
           , usim_planck_time
        FROM usim_spc_process
       WHERE is_processed      = 0
         AND usim_planck_aeon  = cp_planck_aeon
         AND usim_planck_time  = cp_planck_time
       GROUP BY usim_id_spc_target
              , usim_planck_aeon
              , usim_planck_time
    ;
    CURSOR cur_target_energies( cp_usim_id_spc_target IN usim_space.usim_id_spc%TYPE
                              , cp_planck_aeon        IN usim_spc_process.usim_planck_aeon%TYPE
                              , cp_planck_time        IN usim_spc_process.usim_planck_time%TYPE
                              )
    IS
      SELECT usim_id_spr
           , usim_energy_output
           , usim_id_spc_source
        FROM usim_spc_process
       WHERE is_processed       = 0
         AND usim_id_spc_target = cp_usim_id_spc_target
         AND usim_planck_aeon   = cp_planck_aeon
         AND usim_planck_time   = cp_planck_time
    ;
  BEGIN
    l_result := usim_dbif.has_unprocessed;
    IF l_result = 0
    THEN
      usim_erl.log_error('usim_process.process_queue', 'ERROR No targets found. Exit process.');
      usim_dbif.set_crashed;
      RETURN 0;
    END IF;
    l_result := usim_dbif.is_queue_valid;
    IF l_result != 1
    THEN
      usim_erl.log_error('usim_process.process_queue', 'Current process queue is not valid. State [' || l_result || '].');
      RETURN 0;
    END IF;
    -- get aeon and time
    l_result := usim_dbif.get_unprocessed_planck(l_cur_aeon, l_cur_time);
    IF l_result != 1
    THEN
      usim_erl.log_error('usim_process.process_queue', 'Could not fetch current planck aeon and time. State [' || l_result || '].');
      RETURN 0;
    END IF;
    -- update current targets within current planck time tick
    l_executed := FALSE;
    FOR recmain IN cur_targets
    LOOP
      l_executed := TRUE;
      -- check target, if the universe seed state is invalid, do not process it
      IF usim_dbif.is_seed_active = 1
      THEN
        l_usim_id_nod := usim_dbif.get_id_nod(recmain.usim_id_spc_target);
        IF l_usim_id_nod IS NULL
        THEN
          usim_erl.log_error('usim_process.process_queue', 'Could not get node for target id [' || recmain.usim_id_spc_target || '].');
          usim_dbif.set_crashed;
          RETURN 0;
        END IF;
        IF l_result = 0
        THEN
          ROLLBACK;
          usim_erl.log_error('usim_process.process_queue', 'usim_process.check_border failed. Could not flip direction of space id [' || recmain.usim_id_spc_target || '].');
          usim_dbif.set_crashed;
          RETURN 0;
        END IF;
        l_energy := NVL(usim_nod.get_energy(l_usim_id_nod), 0);
        -- sum up energy for every position to be able to identify the process causing overflow
        l_exec_inner := FALSE;
        FOR rec IN cur_target_energies(recmain.usim_id_spc_target, recmain.usim_planck_aeon, recmain.usim_planck_time)
        LOOP
          l_exec_inner := TRUE;
          IF usim_dbif.is_overflow_energy_add(rec.usim_energy_output, l_energy) = 1
          THEN
            -- overflow energy
            usim_erl.log_error('usim_process.process_queue', 'Overflow for target space id [' || recmain.usim_id_spc_target || '] with energy [' || rec.usim_energy_output || '] and current target energy [' || l_energy || ']. Set energy to 0.');
            -- handle overflow and create a new universe
            l_result := usim_creator.handle_overflow(recmain.usim_id_spc_target, FALSE);
            IF l_result = 0
            THEN
              ROLLBACK;
              usim_erl.log_error('usim_process.process_queue', 'usim_creator.handle_overflow failed for space id [' || recmain.usim_id_spc_target || '] usim_dbif.is_overflow_energy_add.');
              usim_dbif.set_crashed;
              RETURN 0;
            END IF;
            -- set energy to zero and do not add any more energy
            l_energy := 0;
            EXIT;
          ELSE
            l_energy := l_energy + NVL(rec.usim_energy_output, 0);
          END IF;
        END LOOP;
        IF NOT l_exec_inner
        THEN
          usim_erl.log_error('usim_process.process_queue', 'Cursor cur_target_energies has no data paramenters [' || recmain.usim_id_spc_target || '], [' || recmain.usim_planck_aeon || '], [' || recmain.usim_planck_time || '].');
          usim_dbif.set_crashed;
          RETURN 0;
        END IF;
        -- update energies on target
        l_energy_set := usim_nod.update_energy(l_energy, l_usim_id_nod, FALSE);
        IF l_energy_set != l_energy
        THEN
          usim_erl.log_error('usim_process.process_queue', 'Database storage issue for target id [' || recmain.usim_id_spc_target || '] and node id [' || l_usim_id_nod || '] as stored energy [' || l_energy_set || '] does not match energy set [' || l_energy || '].');
          usim_dbif.set_crashed;
          RETURN 0;
        END IF;
      ELSE
        usim_erl.log_error('usim_process.process_queue', 'No processing of targets as universe seed is not active any longer.');
        RETURN 0;
      END IF;
    END LOOP;
    IF NOT l_executed
    THEN
      usim_erl.log_error('usim_process.process_queue', 'Cursor cur_targets has no data.');
      usim_dbif.set_crashed;
      RETURN 0;
    END IF;
    -- done all
    -- change planck tick, next processing step
    l_planck_tick := usim_dbif.get_planck_time_next;
    -- get current aeon after update
    l_planck_aeon := usim_dbif.get_planck_aeon_seq_current;
    -- create new processes and update old processes
    l_executed := FALSE;
    FOR recmain IN cur_old_targets(l_cur_aeon, l_cur_time)
    LOOP
      l_executed := TRUE;
      -- create new process with childs of target
      l_result := usim_process.process_node(recmain.usim_id_spc_target, FALSE);
      IF l_result = 0
      THEN
        usim_erl.log_error('usim_process.process_queue', 'Unable to process next nodes for target id [' || recmain.usim_id_spc_target || '].');
        usim_dbif.set_crashed;
        RETURN 0;
      END IF;
      -- now update old processes
      l_exec_inner := FALSE;
      FOR rec IN cur_target_energies(recmain.usim_id_spc_target, recmain.usim_planck_aeon, recmain.usim_planck_time)
      LOOP
        l_exec_inner := TRUE;
        IF usim_dbif.is_universe_active(recmain.usim_id_spc_target) = 1
        THEN
          l_result := usim_dbif.set_processed(rec.usim_id_spr, 1, FALSE);
        ELSE
          -- if universe is invalid, sets process code 2
          l_result := usim_dbif.set_processed(rec.usim_id_spr, 2, FALSE);
        END IF;
        IF l_result = 0
        THEN
          usim_erl.log_error('usim_process.process_queue', 'Unable to set processed for process id [' || rec.usim_id_spr || '].');
          usim_dbif.set_crashed;
          RETURN 0;
        END IF;
        -- flip direction for processed
        l_result := usim_dbif.flip_process_spin(rec.usim_id_spc_source, FALSE);
        IF l_result = 0
        THEN
          ROLLBACK;
          usim_erl.log_error('usim_process.process_queue', 'Could not flip direction of space id [' || rec.usim_id_spc_source || '].');
          usim_dbif.set_crashed;
          RETURN 0;
        END IF;
      END LOOP;
      IF NOT l_exec_inner
      THEN
        usim_erl.log_error('usim_process.process_queue', 'Cursor cur_target_energies in old targets has no data paramenters [' || recmain.usim_id_spc_target || '], [' || recmain.usim_planck_aeon || '], [' || recmain.usim_planck_time || '].');
        usim_dbif.set_crashed;
        RETURN 0;
      END IF;
      -- handle border
      l_result := usim_dbif.check_border(recmain.usim_id_spc_target, FALSE);
      IF l_result != 1
      THEN
        usim_erl.log_error('usim_process.process_queue', 'Check border failed with parameter [' || recmain.usim_id_spc_target || '].');
        usim_dbif.set_crashed;
        RETURN 0;
      END IF;
    END LOOP;
    IF NOT l_executed
    THEN
      usim_erl.log_error('usim_process.process_queue', 'Cursor cur_old_targets has no data for parameters [' || l_cur_aeon || '], [' || l_cur_time || '].');
      usim_dbif.set_crashed;
      RETURN 0;
    END IF;
    -- everything gone well, commit if defined
    IF p_do_commit
    THEN
      COMMIT;
    END IF;
    RETURN 1;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      -- write error might still work
      usim_erl.log_error('usim_process.process_queue', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END process_queue
  ;

  FUNCTION update_universe_states(p_do_commit IN BOOLEAN DEFAULT TRUE)
    RETURN NUMBER
  IS
    l_return NUMBER;

    CURSOR cur_universes
    IS
      SELECT usim_id_mlv
        FROM usim_multiverse
    ;
  BEGIN
    FOR rec IN cur_universes
    LOOP
      l_return := usim_dbif.set_universe_state(rec.usim_id_mlv, FALSE);
      IF l_return IS NULL
      THEN
        ROLLBACK;
        usim_erl.log_error('usim_process.update_universe_states', 'Universe setting state error.');
        usim_dbif.set_crashed;
        RETURN 0;
      END IF;
    END LOOP;
    IF p_do_commit
    THEN
      COMMIT;
    END IF;
    RETURN 1;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      -- write error might still work
      usim_erl.log_error('usim_process.update_universe_states', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END update_universe_states
  ;

  FUNCTION run_samples( p_run_count IN NUMBER
                      , p_do_commit IN BOOLEAN DEFAULT TRUE
                      )
    RETURN NUMBER
  IS
    l_return NUMBER;
  BEGIN
    FOR l_idx IN 1..p_run_count
    LOOP
      -- check system with every loop
      IF usim_dbif.is_seed_active != 1
      THEN
        ROLLBACK;
        usim_erl.log_error('usim_process.run_samples', 'Universe seed is not active. Run index: [' || l_idx || '].');
        usim_dbif.set_crashed;
        RETURN 0;
      END IF;
      IF usim_dbif.is_queue_valid != 1
      THEN
        ROLLBACK;
        usim_erl.log_error('usim_process.run_samples', 'Process queue is not valid [' || usim_dbif.is_queue_valid || ']. Run index: [' || l_idx || '].');
        usim_dbif.set_crashed;
        RETURN 0;
      END IF;
      -- now process
      l_return := usim_process.process_queue(p_do_commit);
      IF l_return = 0
      THEN
        ROLLBACK;
        usim_erl.log_error('usim_process.run_samples', 'Error running process_queue. Run index: [' || l_idx || '].');
        usim_dbif.set_crashed;
        RETURN 0;
      END IF;
      l_return := usim_process.update_universe_states(p_do_commit);
      IF l_return = 0
      THEN
        ROLLBACK;
        usim_erl.log_error('usim_process.run_samples', 'Error running update_universe_states. Run index: [' || l_idx || '].');
        usim_dbif.set_crashed;
        RETURN 0;
      END IF;
      -- commit every successful process
      IF p_do_commit
      THEN
        COMMIT;
      END IF;
    END LOOP;
    RETURN 1;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      -- write error might still work
      usim_erl.log_error('usim_process.run_samples', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
      -- try to set all to crashed
      usim_dbif.set_crashed;
      -- raise in any case
      RAISE;
  END run_samples
  ;

END usim_process;
/
