CREATE OR REPLACE PACKAGE BODY usim_mlv
IS
  -- see header for documentation
  FUNCTION has_data
    RETURN NUMBER
  IS
    l_result  NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_multiverse;
    RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
  END has_data
  ;

  FUNCTION has_data(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN NUMBER
  IS
    l_result  NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_multiverse WHERE usim_id_mlv = p_usim_id_mlv;
    RETURN l_result;
  END has_data
  ;

  FUNCTION has_base
    RETURN NUMBER
  IS
    l_result  NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_multiverse WHERE usim_is_base_universe = 1;
    RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
  END has_base
  ;

  FUNCTION is_base(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    IF usim_mlv.has_data(p_usim_id_mlv) = 1
    THEN
      SELECT usim_is_base_universe INTO l_result FROM usim_multiverse WHERE usim_id_mlv = p_usim_id_mlv;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_mlv.is_base', 'Used with not existing universe id [' || p_usim_id_mlv || '].');
      RETURN NULL;
    END IF;
  END is_base
  ;

  FUNCTION get_state(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN usim_multiverse.usim_universe_status%TYPE
  IS
    l_result usim_multiverse.usim_universe_status%TYPE;
  BEGIN
    IF usim_mlv.has_data(p_usim_id_mlv) = 1
    THEN
      SELECT usim_universe_status INTO l_result FROM usim_multiverse WHERE usim_id_mlv = p_usim_id_mlv;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_mlv.get_state', 'Used with not existing universe id [' || p_usim_id_mlv || '].');
      RETURN NULL;
    END IF;
  END get_state
  ;

  FUNCTION get_planck_stable(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN NUMBER
  IS
    l_result usim_multiverse.usim_planck_stable%TYPE;
  BEGIN
    l_result := -1;
    IF usim_mlv.has_data(p_usim_id_mlv) = 1
    THEN
      SELECT usim_planck_stable INTO l_result FROM usim_multiverse WHERE usim_id_mlv = p_usim_id_mlv;
    ELSE
      usim_erl.log_error('usim_mlv.get_planck_stable', 'Used with not existing universe id [' || p_usim_id_mlv || '].');
    END IF;
    RETURN l_result;
  END get_planck_stable
  ;

  FUNCTION get_ultimate_border(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN usim_multiverse.usim_ultimate_border%TYPE
  IS
    l_result usim_multiverse.usim_ultimate_border%TYPE;
  BEGIN
    l_result := -1;
    IF usim_mlv.has_data(p_usim_id_mlv) = 1
    THEN
      SELECT usim_ultimate_border INTO l_result FROM usim_multiverse WHERE usim_id_mlv = p_usim_id_mlv;
    ELSE
      usim_erl.log_error('usim_mlv.get_ultimate_border', 'Used with not existing universe id [' || p_usim_id_mlv || '].');
    END IF;
    RETURN l_result;
  END get_ultimate_border
  ;

  FUNCTION insert_universe( p_usim_energy_start_value IN usim_multiverse.usim_energy_start_value%TYPE DEFAULT 1
                          , p_usim_planck_time_unit   IN usim_multiverse.usim_planck_time_unit%TYPE   DEFAULT 1
                          , p_usim_planck_length_unit IN usim_multiverse.usim_planck_length_unit%TYPE DEFAULT 1
                          , p_usim_planck_speed_unit  IN usim_multiverse.usim_planck_speed_unit%TYPE  DEFAULT 1
                          , p_usim_planck_stable      IN usim_multiverse.usim_planck_stable%TYPE      DEFAULT 1
                          , p_usim_ultimate_border    IN usim_multiverse.usim_ultimate_border%TYPE    DEFAULT 1
                          , p_do_commit               IN BOOLEAN                                      DEFAULT TRUE
                          )
    RETURN usim_multiverse.usim_id_mlv%TYPE
  IS
    l_usim_energy_start_value usim_multiverse.usim_energy_start_value%TYPE;
    l_usim_planck_time_unit   usim_multiverse.usim_planck_time_unit%TYPE;
    l_usim_planck_length_unit usim_multiverse.usim_planck_length_unit%TYPE;
    l_usim_planck_speed_unit  usim_multiverse.usim_planck_speed_unit%TYPE;
    l_usim_planck_stable      usim_multiverse.usim_planck_stable%TYPE;
    l_usim_ultimate_border    usim_multiverse.usim_ultimate_border%TYPE;
    l_usim_is_base_universe   usim_multiverse.usim_is_base_universe%TYPE;
    l_usim_id_mlv             usim_multiverse.usim_id_mlv%TYPE;
  BEGIN
    l_usim_id_mlv := NULL;
    -- check value constraints and set defaults
    IF usim_mlv.has_base = 1
    THEN
      l_usim_is_base_universe := 0;
    ELSE
      l_usim_is_base_universe := 1;
    END IF;
    IF p_usim_ultimate_border IN (0, 1)
    THEN
      l_usim_ultimate_border := p_usim_ultimate_border;
    ELSE
      l_usim_ultimate_border := 1;
    END IF;
    IF p_usim_planck_stable IN (0, 1)
    THEN
      l_usim_planck_stable := p_usim_planck_stable;
    ELSE
      l_usim_planck_stable := 1;
    END IF;
    IF NVL(p_usim_planck_time_unit, 0) = 0
    THEN
      l_usim_planck_time_unit := 1;
    ELSE
      l_usim_planck_time_unit := ABS(p_usim_planck_time_unit);
    END IF;
    IF NVL(p_usim_planck_length_unit, 0) = 0
    THEN
      l_usim_planck_length_unit := 1;
    ELSE
      l_usim_planck_length_unit := ABS(p_usim_planck_length_unit);
    END IF;
    IF NVL(p_usim_planck_speed_unit, 0) = 0
    THEN
      l_usim_planck_speed_unit := 1;
    ELSE
      l_usim_planck_speed_unit := ABS(p_usim_planck_speed_unit);
    END IF;
    IF NVL(p_usim_energy_start_value, 0) = 0
    THEN
      l_usim_energy_start_value := 1;
    ELSE
      l_usim_energy_start_value := ABS(p_usim_energy_start_value);
    END IF;
    -- insert the found values
    INSERT INTO usim_multiverse
      ( usim_is_base_universe
      , usim_energy_start_value
      , usim_planck_time_unit
      , usim_planck_length_unit
      , usim_planck_speed_unit
      , usim_planck_stable
      , usim_ultimate_border
      )
      VALUES
      ( l_usim_is_base_universe
      , l_usim_energy_start_value
      , l_usim_planck_time_unit
      , l_usim_planck_length_unit
      , l_usim_planck_speed_unit
      , l_usim_planck_stable
      , l_usim_ultimate_border
      )
      RETURNING usim_id_mlv INTO l_usim_id_mlv
    ;
    IF p_do_commit
    THEN
      COMMIT;
    END IF;
    RETURN l_usim_id_mlv;
  END insert_universe
  ;

  FUNCTION update_state( p_usim_id_mlv          IN usim_multiverse.usim_id_mlv%TYPE
                       , p_usim_universe_status IN usim_multiverse.usim_universe_status%TYPE
                       , p_do_commit            IN BOOLEAN                                   DEFAULT TRUE
                       )
    RETURN usim_multiverse.usim_universe_status%TYPE
  IS
  BEGIN
    IF     usim_mlv.has_data(p_usim_id_mlv)  = 1
       AND p_usim_universe_status           IN ( usim_static.usim_multiverse_status_dead
                                               , usim_static.usim_multiverse_status_crashed
                                               , usim_static.usim_multiverse_status_active
                                               , usim_static.usim_multiverse_status_inactive
                                               )
    THEN
      UPDATE usim_multiverse
         SET usim_universe_status = p_usim_universe_status
       WHERE usim_id_mlv = p_usim_id_mlv
      ;
      IF p_do_commit
      THEN
        COMMIT;
      END IF;
      RETURN p_usim_universe_status;
    ELSE
      usim_erl.log_error('usim_mlv.update_state', 'Used with not existing universe id [' || p_usim_id_mlv || '] or wrong state [' || p_usim_universe_status || '].');
      RETURN NULL;
    END IF;
  END update_state
  ;

  FUNCTION update_planck_unit_time_speed( p_usim_id_mlv             IN usim_multiverse.usim_id_mlv%TYPE
                                        , p_usim_planck_time_unit   IN usim_multiverse.usim_planck_time_unit%TYPE
                                        , p_usim_planck_speed_unit  IN usim_multiverse.usim_planck_speed_unit%TYPE
                                        , p_do_commit               IN BOOLEAN                                      DEFAULT TRUE
                                        )
    RETURN NUMBER
  IS
    l_velocity  NUMBER;
    l_length    NUMBER;
    l_time      NUMBER;
  BEGIN
    IF     usim_mlv.has_data(p_usim_id_mlv)   = 1
       AND usim_mlv.get_planck_stable(p_usim_id_mlv) = 0
    THEN
      IF NVL(p_usim_planck_time_unit, 0) = 0
      THEN
        l_time := 1;
      ELSE
        l_time := ABS(p_usim_planck_time_unit);
      END IF;
      IF NVL(p_usim_planck_speed_unit, 0) = 0
      THEN
        l_velocity := 1;
      ELSE
        l_velocity := ABS(p_usim_planck_speed_unit);
      END IF;
      l_length := l_velocity * l_time;
      UPDATE usim_multiverse
         SET usim_planck_time_unit    = l_time
           , usim_planck_length_unit  = l_length
           , usim_planck_speed_unit   = l_velocity
       WHERE usim_id_mlv = p_usim_id_mlv
      ;
      IF p_do_commit
      THEN
        COMMIT;
      END IF;
      RETURN 1;
    ELSE
      usim_erl.log_error('usim_mlv.update_planck_unit_time_speed', 'Used with not existing universe id [' || p_usim_id_mlv || '] or planck stable is set.');
      RETURN 0;
    END IF;
  END update_planck_unit_time_speed
  ;

  FUNCTION update_planck_unit_time_length( p_usim_id_mlv             IN usim_multiverse.usim_id_mlv%TYPE
                                         , p_usim_planck_time_unit   IN usim_multiverse.usim_planck_time_unit%TYPE
                                         , p_usim_planck_length_unit IN usim_multiverse.usim_planck_length_unit%TYPE
                                         , p_do_commit               IN BOOLEAN                                      DEFAULT TRUE
                                         )
    RETURN NUMBER
  IS
    l_velocity  NUMBER;
    l_length    NUMBER;
    l_time      NUMBER;
  BEGIN
    IF     usim_mlv.has_data(p_usim_id_mlv)   = 1
       AND usim_mlv.get_planck_stable(p_usim_id_mlv) = 0
    THEN
      IF NVL(p_usim_planck_time_unit, 0) = 0
      THEN
        l_time := 1;
      ELSE
        l_time := ABS(p_usim_planck_time_unit);
      END IF;
      IF NVL(p_usim_planck_length_unit, 0) = 0
      THEN
        l_length := 1;
      ELSE
        l_length := ABS(p_usim_planck_length_unit);
      END IF;
      l_velocity := l_length / l_time;
      UPDATE usim_multiverse
         SET usim_planck_time_unit    = l_time
           , usim_planck_length_unit  = l_length
           , usim_planck_speed_unit   = l_velocity
       WHERE usim_id_mlv = p_usim_id_mlv
      ;
      IF p_do_commit
      THEN
        COMMIT;
      END IF;
      RETURN 1;
    ELSE
      usim_erl.log_error('usim_mlv.update_planck_unit_time_length', 'Used with not existing universe id [' || p_usim_id_mlv || '] or planck stable is set.');
      RETURN 0;
    END IF;
  END update_planck_unit_time_length
  ;

  FUNCTION update_planck_unit_speed_length( p_usim_id_mlv             IN usim_multiverse.usim_id_mlv%TYPE
                                          , p_usim_planck_speed_unit  IN usim_multiverse.usim_planck_speed_unit%TYPE
                                          , p_usim_planck_length_unit IN usim_multiverse.usim_planck_length_unit%TYPE
                                          , p_do_commit               IN BOOLEAN                                      DEFAULT TRUE
                                         )
    RETURN NUMBER
  IS
    l_velocity  NUMBER;
    l_length    NUMBER;
    l_time      NUMBER;
  BEGIN
    IF     usim_mlv.has_data(p_usim_id_mlv)   = 1
       AND usim_mlv.get_planck_stable(p_usim_id_mlv) = 0
    THEN
      IF NVL(p_usim_planck_speed_unit, 0) = 0
      THEN
        l_velocity := 1;
      ELSE
        l_velocity := ABS(p_usim_planck_speed_unit);
      END IF;
      IF NVL(p_usim_planck_length_unit, 0) = 0
      THEN
        l_length := 1;
      ELSE
        l_length := ABS(p_usim_planck_length_unit);
      END IF;
      l_time := l_length / l_velocity;
      UPDATE usim_multiverse
         SET usim_planck_time_unit    = l_time
           , usim_planck_length_unit  = l_length
           , usim_planck_speed_unit   = l_velocity
       WHERE usim_id_mlv = p_usim_id_mlv
      ;
      IF p_do_commit
      THEN
        COMMIT;
      END IF;
      RETURN 1;
    ELSE
      usim_erl.log_error('usim_mlv.update_planck_unit_speed_length', 'Used with not existing universe id [' || p_usim_id_mlv || '] or planck stable is set.');
      RETURN 0;
    END IF;
  END update_planck_unit_speed_length
  ;

END usim_mlv;
/