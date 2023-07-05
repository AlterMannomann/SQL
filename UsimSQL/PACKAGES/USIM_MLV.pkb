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

  FUNCTION insert_universe( p_usim_energy_start_value IN usim_multiverse.usim_energy_start_value%TYPE DEFAULT 1
                          , p_usim_planck_time_unit   IN usim_multiverse.usim_planck_time_unit%TYPE   DEFAULT 1
                          , p_usim_planck_length_unit IN usim_multiverse.usim_planck_length_unit%TYPE DEFAULT 1
                          , p_usim_planck_speed_unit  IN usim_multiverse.usim_planck_speed_unit%TYPE  DEFAULT 1
                          , p_usim_planck_stable      IN usim_multiverse.usim_planck_stable%TYPE      DEFAULT 1
                          , p_usim_base_sign          IN usim_multiverse.usim_base_sign%TYPE          DEFAULT 1
                          , p_do_commit               IN BOOLEAN                                      DEFAULT TRUE
                          )
    RETURN usim_multiverse.usim_id_mlv%TYPE
  IS
    l_usim_energy_start_value usim_multiverse.usim_energy_start_value%TYPE;
    l_usim_planck_time_unit   usim_multiverse.usim_planck_time_unit%TYPE;
    l_usim_planck_length_unit usim_multiverse.usim_planck_length_unit%TYPE;
    l_usim_planck_speed_unit  usim_multiverse.usim_planck_speed_unit%TYPE;
    l_usim_planck_stable      usim_multiverse.usim_planck_stable%TYPE;
    l_usim_base_sign          usim_multiverse.usim_base_sign%TYPE;
    l_usim_mirror_sign        usim_multiverse.usim_mirror_sign%TYPE;
    l_usim_is_base_universe   usim_multiverse.usim_is_base_universe%TYPE;
    l_usim_id_mlv             usim_multiverse.usim_id_mlv%TYPE;
  BEGIN
    l_usim_id_mlv := NULL;
    IF usim_base.has_basedata = 1
    THEN
      -- check value constraints and set defaults
      IF usim_mlv.has_data = 1
      THEN
        l_usim_is_base_universe := 0;
      ELSE
        l_usim_is_base_universe := 1;
      END IF;
      IF NVL(p_usim_base_sign, 0) = 0
      THEN
        l_usim_base_sign    := 1;
        l_usim_mirror_sign  := -1;
      ELSE
        l_usim_base_sign    := SIGN(p_usim_base_sign);
        l_usim_mirror_sign  := l_usim_base_sign * -1;
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
        , usim_base_sign
        , usim_mirror_sign
        )
        VALUES
        ( l_usim_is_base_universe
        , l_usim_energy_start_value
        , l_usim_planck_time_unit
        , l_usim_planck_length_unit
        , l_usim_planck_speed_unit
        , l_usim_planck_stable
        , l_usim_base_sign
        , l_usim_mirror_sign
        )
        RETURNING usim_id_mlv INTO l_usim_id_mlv
      ;
      IF p_do_commit
      THEN
        COMMIT;
      END IF;
    END IF;
    RETURN l_usim_id_mlv;
  END insert_universe
  ;

  FUNCTION update_energy( p_usim_id_mlv          IN usim_multiverse.usim_id_mlv%TYPE
                        , p_usim_energy_positive IN usim_multiverse.usim_energy_positive%TYPE
                        , p_usim_energy_negative IN usim_multiverse.usim_energy_negative%TYPE
                        , p_do_commit            IN BOOLEAN                                    DEFAULT TRUE
                        )
    RETURN NUMBER
  IS
    l_usim_energy_positive usim_multiverse.usim_energy_positive%TYPE;
    l_usim_energy_negative usim_multiverse.usim_energy_negative%TYPE;
  BEGIN
    IF usim_mlv.has_data(p_usim_id_mlv) = 1
    THEN
      l_usim_energy_positive := NVL(p_usim_energy_positive, 0);
      l_usim_energy_negative := NVL(p_usim_energy_negative, 0);
      UPDATE usim_multiverse
         SET usim_energy_positive = l_usim_energy_positive
           , usim_energy_negative = l_usim_energy_negative
       WHERE usim_id_mlv = p_usim_id_mlv
      ;
      IF p_do_commit
      THEN
        COMMIT;
      END IF;
      RETURN 1;
    ELSE
      RETURN 0;
    END IF;
  END update_energy
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
    END IF;
    RETURN l_result;
  END get_planck_stable
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
      RETURN 0;
    END IF;
  END update_planck_unit_speed_length
  ;

END usim_mlv;
/