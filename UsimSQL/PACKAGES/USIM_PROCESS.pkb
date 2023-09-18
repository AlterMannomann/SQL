CREATE OR REPLACE PACKAGE BODY usim_process
IS
  -- see header for documentation

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
      RETURN 0;
    ELSE
      usim_erl.log_error('usim_process.get_dim_G', 'Unknown error [' || SQLCODE || '] error message: ' || SQLERRM);
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
      RETURN 0;
    ELSE
      usim_erl.log_error('usim_process.get_outer_planck_r', 'Unknown error [' || SQLCODE || '] error message: ' || SQLERRM);
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
      RETURN 0;
    ELSE
      usim_erl.log_error('usim_process.get_acceleration', 'Unknown error [' || SQLCODE || '] error message: ' || SQLERRM);
      RETURN -1;
    END IF;
  END get_acceleration
  ;

  FUNCTION place_start_node( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
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
    IF     usim_spc.has_data(p_usim_id_spc)         = 1
       AND usim_spc.is_universe_base(p_usim_id_spc) = 1
    THEN
      SELECT usim_energy
           , usim_energy_start_value
        INTO l_energy
           , l_start_value
        FROM usim_spc_v
       WHERE usim_id_spc = p_usim_id_spc
      ;
      IF l_energy IS NULL
      THEN
        l_energy := l_start_value;
      END IF;
      l_resDimG := usim_process.get_dim_G(p_usim_id_spc, l_source_G);
      l_resR := usim_process.get_outer_planck_r(p_usim_id_spc, l_distance);
      l_resEnergy := usim_process.get_acceleration(l_energy, l_distance, l_source_G, l_target_energy);
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
        FOR rec IN cur_childs(p_usim_id_spc)
        LOOP
          INSERT INTO usim_spc_process
            ( usim_planck_aeon
            , usim_planck_time
            , usim_id_spc_source
            , usim_id_spc_target
            , usim_energy_source
            , usim_energy_target
            , usim_energy_output
            )
            VALUES
            ( usim_base.get_planck_aeon_seq_current
            , usim_base.get_planck_time_current
            , p_usim_id_spc
            , rec.usim_id_spc_child
            , l_energy
            , rec.usim_energy
            , l_target_energy * rec.dim_sign
            )
          ;
        END LOOP;
        -- flip direction for this node, if not base node, so no flip necessary
        IF p_do_commit
        THEN
          COMMIT;
        END IF;
        RETURN 1;
      END IF;
    ELSE
      usim_erl.log_error('usim_process.place_start_node', 'Used with invalid space id [' || p_usim_id_spc || '] not base universe or does not exist.');
      RETURN 0;
    END IF;
  END place_start_node
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
        l_result := usim_spc.flip_process_spin(p_usim_id_spc, p_do_commit);
        RETURN l_result;
      END IF;
    ELSE
      -- if no child in dimension and direction is child flip to parent
      IF     usim_chi.has_child_same_dim(p_usim_id_spc) = 0
         AND l_process_spin                             = 1
      THEN
        l_result := usim_spc.flip_process_spin(p_usim_id_spc, p_do_commit);
        RETURN l_result;
      END IF;
    END IF;
    RETURN 1;
  END check_border
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
    IF usim_spc.has_data(p_usim_id_spc) = 0
    THEN
      usim_erl.log_error('usim_process.process_node', 'Used with invalid space id [' || p_usim_id_spc || '].');
      RETURN 0;
    END IF;
    SELECT usim_energy
         , usim_energy_start_value
      INTO l_energy
         , l_start_value
      FROM usim_spc_v
     WHERE usim_id_spc = p_usim_id_spc
    ;
    l_is_base := usim_spc.is_universe_base(p_usim_id_spc);
    IF l_is_base = 1
    THEN
      IF l_energy IS NULL
      THEN
        l_energy := l_start_value;
      END IF;
    END IF;
    l_resDimG := usim_process.get_dim_G(p_usim_id_spc, l_source_G);
    l_resR := usim_process.get_outer_planck_r(p_usim_id_spc, l_distance);
    l_resEnergy := usim_process.get_acceleration(l_energy, l_distance, l_source_G, l_target_energy);
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
        usim_erl.log_error('usim_process.process_node', 'ERROR unexpected. usim_process.get_dim_G, get_outer_planck_r or get_acceleration failed for space id [' || p_usim_id_spc || '].');
        RETURN 0;
      ELSE
        -- overflow handling, expected
        l_result := usim_process.check_border(p_usim_id_spc, p_do_commit);
        IF l_result = 0
        THEN
          usim_erl.log_error('usim_process.process_node', 'usim_process.check_border failed. Could not flip direction of space id [' || p_usim_id_spc || '].');
          RETURN 0;
        END IF;
      END IF;
    ELSE
      -- decide direction
      IF usim_spc.get_process_spin(p_usim_id_spc) = 1
      THEN
        -- childs
        FOR rec IN cur_childs(p_usim_id_spc)
        LOOP
          INSERT INTO usim_spc_process
            ( usim_planck_aeon
            , usim_planck_time
            , usim_id_spc_source
            , usim_id_spc_target
            , usim_energy_source
            , usim_energy_target
            , usim_energy_output
            )
            VALUES
            ( usim_base.get_planck_aeon_seq_current
            , usim_base.get_planck_time_current
            , p_usim_id_spc
            , rec.usim_id_spc_child
            , l_energy
            , rec.usim_energy
            , CASE
                WHEN l_is_base = 1
                THEN l_target_energy * rec.dim_sign
                ELSE l_target_energy
              END
            )
          ;
        END LOOP;
      ELSE
        -- parents
        FOR rec IN cur_parent(p_usim_id_spc)
        LOOP
          INSERT INTO usim_spc_process
            ( usim_planck_aeon
            , usim_planck_time
            , usim_id_spc_source
            , usim_id_spc_target
            , usim_energy_source
            , usim_energy_target
            , usim_energy_output
            )
            VALUES
            ( usim_base.get_planck_aeon_seq_current
            , usim_base.get_planck_time_current
            , p_usim_id_spc
            , rec.usim_id_spc
            , l_energy
            , rec.usim_energy
            , CASE
                WHEN l_is_base = 1
                THEN l_target_energy * rec.dim_sign
                ELSE l_target_energy
              END
            )
          ;
        END LOOP;
      END IF;
    END IF;
    IF p_do_commit
    THEN
      COMMIT;
    END IF;
    -- flip direction after submit
    l_result := usim_spc.flip_process_spin(p_usim_id_spc, p_do_commit);
    IF l_result = 0
    THEN
      usim_erl.log_error('usim_process.process_node', 'Could not flip direction of space id [' || p_usim_id_spc || '].');
      RETURN 0;
    END IF;
    RETURN 1;
  END process_node
  ;

  FUNCTION process_queue(p_do_commit IN BOOLEAN DEFAULT TRUE)
    RETURN NUMBER
  IS
    l_energy      NUMBER;
    l_result      NUMBER;
    l_planck_tick NUMBER;
    l_usim_id_nod usim_node.usim_id_nod%TYPE;
    l_planck_aeon usim_spc_process.usim_planck_aeon%TYPE;
    l_planck_time usim_spc_process.usim_planck_time%TYPE;

    CURSOR cur_target
    IS
      SELECT usim_id_spc_target
           , SUM(usim_energy_output) AS energy_total
        FROM usim_spc_process
       WHERE is_processed = 0
       GROUP BY usim_id_spc_target
    ;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_spc_process WHERE is_processed = 0;
    IF l_result = 0
    THEN
      usim_erl.log_error('usim_process.process_queue', 'ERROR No targets found. Exit process.');
      RETURN 0;
    ELSE
      usim_erl.log_error('usim_process.process_queue', 'Process [' || l_result || '] targets.');
    END IF;
    -- update targets
    FOR rec IN cur_target
    LOOP
      l_usim_id_nod := usim_spc.get_id_nod(rec.usim_id_spc_target);
      usim_erl.log_error('usim_process.process_queue', 'Update target space id [' || rec.usim_id_spc_target || '] with energy [' || rec.energy_total || '] and source energy [' || usim_nod.get_energy(l_usim_id_nod) || '].');
      -- handle border
      l_result := usim_process.check_border(rec.usim_id_spc_target, p_do_commit);
      IF l_result = 0
      THEN
        usim_erl.log_error('usim_process.process_queue', 'usim_process.check_border failed. Could not flip direction of space id [' || rec.usim_id_spc_target || '].');
        RETURN 0;
      END IF;
      -- handle overflow
      IF usim_base.num_has_overflow(rec.energy_total + usim_nod.get_energy(l_usim_id_nod)) = 1
      THEN
        -- TODO
        usim_erl.log_error('usim_process.process_queue', 'Overflow for target space id [' || rec.usim_id_spc_target || '] with energy [' || rec.energy_total || '] and source energy [' || usim_nod.get_energy(l_usim_id_nod) || '].');
      END IF;
      l_energy := usim_nod.add_energy(rec.energy_total, l_usim_id_nod, p_do_commit);
    END LOOP;
    SELECT COUNT(*) INTO l_result FROM usim_spc_process WHERE is_processed = 0;
    usim_erl.log_error('usim_process.process_queue', 'Check target count after first processing [' || l_result || '] targets.');
    usim_erl.log_error('usim_process.process_queue', 'Before update planck aeon [' || usim_base.get_planck_aeon_seq_current || '] planck time [' || usim_base.get_planck_time_current || '].');
    l_planck_aeon := usim_base.get_planck_aeon_seq_current;
    l_planck_time := usim_base.get_planck_time_current;
    -- change planck tick
    l_planck_tick := usim_base.get_planck_time_next;
    usim_erl.log_error('usim_process.process_queue', 'After update planck aeon [' || usim_base.get_planck_aeon_seq_current || '] planck time [' || usim_base.get_planck_time_current || '].');
    -- process targets
    FOR rec IN cur_target
    LOOP
      usim_erl.log_error('usim_process.process_queue', 'Process target space id [' || rec.usim_id_spc_target || '] old process spin [' || usim_spc.get_process_spin(rec.usim_id_spc_target) || '].');
      l_result := usim_process.process_node(rec.usim_id_spc_target, p_do_commit);
      usim_erl.log_error('usim_process.process_queue', 'Processed target space id [' || rec.usim_id_spc_target || '] new process spin [' || usim_spc.get_process_spin(rec.usim_id_spc_target) || '].');
    END LOOP;
    -- update old targets
    SELECT COUNT(*) INTO l_result FROM usim_spc_process WHERE is_processed = 0;
    usim_erl.log_error('usim_process.process_queue', 'Check target count before update [' || l_result || '] targets.');
    usim_erl.log_error('usim_process.process_queue', 'Set old targets processed with planck aeon [' || l_planck_aeon || '] planck time [' || l_planck_time || '].');
    UPDATE usim_spc_process
       SET is_processed = 1
     WHERE usim_planck_aeon = l_planck_aeon
       AND usim_planck_time = l_planck_time
    ;
    IF p_do_commit
    THEN
      COMMIT;
    END IF;
    SELECT COUNT(*) INTO l_result FROM usim_spc_process WHERE is_processed = 0;
    usim_erl.log_error('usim_process.process_queue', 'Check target count after update [' || l_result || '] targets.');
    RETURN 1;
  END process_queue
  ;

END usim_process;
/
