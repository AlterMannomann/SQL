CREATE OR REPLACE PACKAGE BODY usim_process
IS
  -- see header for documentation

  FUNCTION place_start_node(p_do_commit IN BOOLEAN DEFAULT TRUE)
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
    l_base_id := usim_dbif.get_id_spc_base_universe;
    IF l_base_id IS NOT NULL
    THEN
      IF usim_dbif.is_universe_active(l_base_id) = 0
      THEN
        -- won't operate on universe not active
        usim_erl.log_error('usim_process.place_start_node', 'Current universe is not active. Process allowed only on active universe. State: ' || usim_dbif.get_universe_state_desc(l_base_id));
        RETURN 0;
      END IF;
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
      l_resR := usim_dbif.get_outer_planck_r(l_base_id, l_distance);
      l_resEnergy := usim_dbif.get_acceleration(l_energy, l_distance, l_source_G, l_target_energy);
      IF    l_resDimG   != 1
         OR l_resR      != 1
         OR l_resEnergy != 1
      THEN
        -- overflow handling or error
        IF    l_resDimG   != 0
           OR l_resR      != 0
           OR l_resEnergy != 0
        THEN
          -- error, not expected
          NULL; --TODO
          RETURN 0;
        ELSE
          -- overflow handling, not expected
          NULL; --TODO
        END IF;
      ELSE
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
      END IF;
    ELSE
      usim_erl.log_error('usim_process.place_start_node', 'Used without an existing base universe seed.');
      RETURN 0;
    END IF;
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
    IF usim_dbif.is_universe_active(p_usim_id_spc) = 0
    THEN
      -- won't operate on universe not active
      usim_erl.log_error('usim_process.process_node', 'Current universe is not active. Node not processed space id [' || p_usim_id_spc || '].');
      RETURN 0;
    END IF;
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
    l_resR := usim_dbif.get_outer_planck_r(p_usim_id_spc, l_distance);
    l_resEnergy := usim_dbif.get_acceleration(l_energy, l_distance, l_source_G, l_target_energy);
    IF    l_resDimG   != 1
       OR l_resR      != 1
       OR l_resEnergy != 1
    THEN
      -- overflow handling (0) or error (-1)
      IF    l_resDimG   = -1
         OR l_resR      = -1
         OR l_resEnergy = -1
      THEN
        -- error, not expected
        usim_erl.log_error('usim_process.process_node', 'ERROR unexpected. usim_process.get_dim_G[' || l_resDimG || '] g[' || l_source_G || '], get_outer_planck_r[' || l_resR || '] d[' || l_distance || '] or get_acceleration[' || l_resEnergy || '] e[' || l_energy || '] tgt e[' || l_target_energy || '] failed for space id [' || p_usim_id_spc || '].');
        usim_dbif.set_crashed;
        RETURN 0;
      ELSE
        -- we can't handle overflows on G or r
        IF    l_resDimG   = 0
           OR l_resR      = 0
        THEN
          -- error, not expected
          usim_erl.log_error('usim_process.process_node', 'ERROR system border definitions MAX. Over/underflow on usim_process.get_dim_G[' || l_resDimG || '] g[' || l_source_G || '] or get_outer_planck_r[' || l_resR || '] d[' || l_distance || '] failed for space id [' || p_usim_id_spc || '].');
          usim_dbif.set_crashed;
          RETURN 0;
        ELSE
          -- numerical over/underflow energy
          usim_erl.log_error('usim_process.process_node', 'TODO overflow handling. Over/underflow get_acceleration[' || l_resEnergy || '] e[' || l_energy || '] tgt e[' || l_target_energy || '] failed for space id [' || p_usim_id_spc || '].');
          -- get escape strategy
          -- create new nodes
          -- set energy of this node to 0 (or 1?)
          l_energy := 0;
          l_target_energy := 0;
        END IF;
      END IF;
    END IF;
    -- process after checks decide direction
    IF usim_dbif.get_process_spin(p_usim_id_spc) = 1
    THEN
      -- childs
      FOR rec IN cur_childs(p_usim_id_spc)
      LOOP
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
    ELSIF usim_dbif.get_process_spin(p_usim_id_spc) = -1
    THEN
      -- parents
      FOR rec IN cur_parent(p_usim_id_spc)
      LOOP
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
    l_usim_id_spr usim_spc_process.usim_id_spr%TYPE;

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
       WHERE is_processed                                   = 0
             -- exclude new processes created by current process
         AND (usim_planck_aeon || '.' || usim_planck_time) != (cp_planck_aeon || '.' || cp_planck_time)
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
    -- update current targets within current planck time tick
    FOR recmain IN cur_targets
    LOOP
      -- check target, if the universe state is invalid, do not process it
      IF usim_dbif.is_universe_active(recmain.usim_id_spc_target) = 1
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
        FOR rec IN cur_target_energies(recmain.usim_id_spc_target, recmain.usim_planck_aeon, recmain.usim_planck_time)
        LOOP
          IF usim_dbif.is_overflow_energy_add(rec.usim_energy_output, l_energy) = 1
          THEN
            -- overflow energy
            usim_erl.log_error('usim_process.process_queue', 'Overflow for target space id [' || recmain.usim_id_spc_target || '] with energy [' || rec.usim_energy_output || '] and current target energy [' || l_energy || '].');
            -- TODO handle overflow and create a new universe
          ELSE
            l_energy := l_energy + NVL(rec.usim_energy_output, 0);
          END IF;
        END LOOP;
        -- update energies on target
        l_energy_set := usim_nod.update_energy(l_energy, l_usim_id_nod, FALSE);
        IF l_energy_set != l_energy
        THEN
          usim_erl.log_error('usim_process.process_queue', 'Database storage issue for target id [' || recmain.usim_id_spc_target || '] and node id [' || l_usim_id_nod || '] as stored energy [' || l_energy_set || '] does not match energy set [' || l_energy || '].');
          usim_dbif.set_crashed;
          RETURN 0;
        END IF;
      END IF;
    END LOOP;
    -- done all
    -- change planck tick, next processing step
    l_planck_tick := usim_dbif.get_planck_time_next;
    -- get current aeon after update
    l_planck_aeon := usim_dbif.get_planck_aeon_seq_current;
    -- create new processes and update old processes
    FOR recmain IN cur_old_targets(l_planck_aeon, l_planck_tick)
    LOOP
      -- create new process with childs of target
      l_result := usim_process.process_node(recmain.usim_id_spc_target, FALSE);
      IF l_result = 0
      THEN
        usim_erl.log_error('usim_process.process_queue', 'Unable to process next nodes for target id [' || recmain.usim_id_spc_target || '].');
        usim_dbif.set_crashed;
        RETURN 0;
      END IF;
      -- now update old processes
      FOR rec IN cur_target_energies(recmain.usim_id_spc_target, recmain.usim_planck_aeon, recmain.usim_planck_time)
      LOOP
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
      -- handle border
      l_result := usim_dbif.check_border(recmain.usim_id_spc_target, FALSE);
    END LOOP;
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

END usim_process;
/
