CREATE OR REPLACE PACKAGE BODY usim_pos
IS
  -- see header for documentation
  FUNCTION get_sign( p_number       IN NUMBER
                   , p_sign_default IN NUMBER DEFAULT 1
                   )
    RETURN NUMBER
  IS
    l_sign_default  NUMBER;
    l_sign          NUMBER;
  BEGIN
    l_sign_default := CASE WHEN NVL(p_sign_default, 0) NOT IN (1, -1) THEN 1 ELSE p_sign_default END;
    l_sign := CASE WHEN NVL(SIGN(p_number), 0) NOT IN (1, -1) THEN l_sign_default ELSE SIGN(p_number) END;
    RETURN l_sign;
  END get_sign
  ;

  FUNCTION has_data
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_position;
    RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
  END has_data
  ;

  FUNCTION has_data(p_usim_id_pos IN usim_position.usim_id_pos%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_position WHERE usim_id_pos = p_usim_id_pos;
    RETURN l_result;
  END has_data
  ;

  FUNCTION has_dim_pair(p_usim_coordinate IN usim_position.usim_coordinate%TYPE)
    RETURN NUMBER
  IS
  BEGIN
    IF      usim_pos.coordinate_exists(ABS(p_usim_coordinate))            = 1
       AND  usim_pos.coordinate_exists(ABS(p_usim_coordinate) + 1)        = 1
       AND  usim_pos.coordinate_exists(ABS(p_usim_coordinate) * -1)       = 1
       AND  usim_pos.coordinate_exists((ABS(p_usim_coordinate) + 1) * -1) = 1
    THEN
      RETURN 1;
    ELSE
      RETURN 0;
    END IF;
  END has_dim_pair
  ;

  FUNCTION has_dim_pair(p_usim_id_pos IN usim_position.usim_id_pos%TYPE)
    RETURN NUMBER
  IS
  BEGIN
    RETURN usim_pos.has_dim_pair(usim_pos.get_coordinate(p_usim_id_pos));
  END has_dim_pair
  ;

  FUNCTION coordinate_exists(p_usim_coordinate IN usim_position.usim_coordinate%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
    l_sign   NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_position WHERE usim_coordinate = p_usim_coordinate;
    RETURN l_result;
  END coordinate_exists
  ;

  FUNCTION overflow_reached
    RETURN NUMBER
  IS
    l_pos_max       NUMBER;
    l_neg_max       NUMBER;
  BEGIN
    IF      usim_pos.has_data       = 1
       AND  usim_base.has_basedata  = 1
    THEN
      SELECT MAX(usim_coordinate) INTO l_pos_max FROM usim_position WHERE usim_coordinate >= 0;
      SELECT MIN(usim_coordinate) INTO l_neg_max FROM usim_position WHERE usim_coordinate <= 0;
      IF      ABS(l_pos_max) >= usim_base.get_abs_max_number
         AND  ABS(l_neg_max) >= usim_base.get_abs_max_number
      THEN
        RETURN 1;
      ELSE
        RETURN 0;
      END IF;
    ELSE
      RETURN 0;
    END IF;
  END overflow_reached
  ;

  FUNCTION overflow_reached(p_sign IN NUMBER)
    RETURN NUMBER
  IS
    l_pos_max       NUMBER;
    l_neg_max       NUMBER;
  BEGIN
    IF      usim_pos.has_data       = 1
       AND  usim_base.has_basedata  = 1
    THEN
      IF p_sign = -1
      THEN
        SELECT MIN(usim_coordinate) INTO l_neg_max FROM usim_position WHERE usim_coordinate <= 0;
        IF ABS(l_neg_max) >= usim_base.get_abs_max_number
        THEN
          RETURN 1;
        ELSE
          RETURN 0;
        END IF;
      ELSE
        SELECT MAX(usim_coordinate) INTO l_pos_max FROM usim_position WHERE usim_coordinate >= 0;
        IF l_pos_max >= usim_base.get_abs_max_number
        THEN
          RETURN 1;
        ELSE
          RETURN 0;
        END IF;
      END IF;
    ELSE
      RETURN 0;
    END IF;
  END overflow_reached
  ;


  FUNCTION get_max_coordinate(p_sign IN NUMBER DEFAULT 1)
    RETURN usim_position.usim_coordinate%TYPE
  IS
    l_result  usim_position.usim_coordinate%TYPE;
  BEGIN
    IF usim_pos.has_data = 1
    THEN
      IF p_sign >= 0
      THEN
        SELECT MAX(usim_coordinate) INTO l_result FROM usim_position WHERE SIGN(usim_coordinate) IN (0, 1);
      ELSE
        SELECT MIN(usim_coordinate) INTO l_result FROM usim_position WHERE SIGN(usim_coordinate) IN (0, -1);
      END IF;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_pos.get_max_coordinate', 'Used without position data.');
      RETURN NULL;
    END IF;
  END get_max_coordinate
  ;

  FUNCTION get_coordinate(p_usim_id_pos IN usim_position.usim_id_pos%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
  IS
    l_result usim_position.usim_coordinate%TYPE;
  BEGIN
    IF usim_pos.has_data(p_usim_id_pos) = 1
    THEN
      SELECT usim_coordinate INTO l_result FROM usim_position WHERE usim_id_pos = p_usim_id_pos;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_pos.get_coordinate', 'Used with not existing pos id [' || p_usim_id_pos || '].');
      RETURN NULL;
    END IF;
  END get_coordinate
  ;

  FUNCTION get_coord_sign(p_usim_id_pos IN usim_position.usim_id_pos%TYPE)
    RETURN NUMBER
  IS
    l_result INTEGER;
  BEGIN
    IF usim_pos.has_data(p_usim_id_pos) = 1
    THEN
      SELECT SIGN(usim_coordinate) INTO l_result FROM usim_position WHERE usim_id_pos = p_usim_id_pos;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_pos.get_coord_sign', 'Used with not existing pos id [' || p_usim_id_pos || '].');
      RETURN NULL;
    END IF;
  END get_coord_sign
  ;

  FUNCTION get_id_pos(p_usim_coordinate  IN usim_position.usim_coordinate%TYPE)
    RETURN usim_position.usim_id_pos%TYPE
  IS
    l_result  usim_position.usim_id_pos%TYPE;
  BEGIN
    IF usim_pos.coordinate_exists(p_usim_coordinate) = 1
    THEN
      SELECT usim_id_pos INTO l_result FROM usim_position WHERE usim_coordinate = p_usim_coordinate;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_pos.get_id_pos', 'Used with not existing coordinate [' || p_usim_coordinate || '].');
      RETURN NULL;
    END IF;
  END get_id_pos
  ;

  FUNCTION get_dim_pos_rel( p_usim_id_pos IN usim_position.usim_id_pos%TYPE
                          , p_zero_sign   IN NUMBER                         DEFAULT 1
                          )
    RETURN usim_position.usim_id_pos%TYPE
  IS
    l_sign   NUMBER;
    l_coord  usim_position.usim_coordinate%TYPE;
    l_result usim_position.usim_id_pos%TYPE;
  BEGIN
    IF      usim_pos.has_dim_pair(p_usim_id_pos) = 1
       AND  p_zero_sign                         IN (1, -1)
    THEN
      l_sign  := usim_pos.get_coord_sign(p_usim_id_pos);
      l_coord := usim_pos.get_coordinate(p_usim_id_pos);
      -- handle sign by position
      IF l_sign = 1
      THEN
        l_result := usim_pos.get_id_pos(l_coord + 1);
      ELSIF l_sign = -1
      THEN
        l_result := usim_pos.get_id_pos(l_coord - 1);
      ELSE
        -- zero case
        l_result := usim_pos.get_id_pos(p_zero_sign);
      END IF;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_pos.get_vol_pos_rel', 'Position id has no dimension axis volume to position [' || p_usim_id_pos || '] or wrong zero sign [' || p_zero_sign || '].');
      RETURN NULL;
    END IF;
  END get_dim_pos_rel
  ;

  FUNCTION get_pos_mirror(p_usim_id_pos IN usim_position.usim_id_pos%TYPE)
    RETURN usim_position.usim_id_pos%TYPE
  IS
    l_coord  usim_position.usim_coordinate%TYPE;
    l_result usim_position.usim_id_pos%TYPE;
  BEGIN
    IF usim_pos.has_data(p_usim_id_pos) = 1
    THEN
      l_coord  := usim_pos.get_coordinate(p_usim_id_pos) * -1;
      IF usim_pos.coordinate_exists(l_coord) = 1
      THEN
        l_result := usim_pos.get_id_pos(l_coord);
        RETURN l_result;
      ELSE
        usim_erl.log_error('usim_pos.get_pos_mirror', 'Position id does not exist for coordinate [' || l_coord || '].');
        RETURN NULL;
      END IF;
    ELSE
      usim_erl.log_error('usim_pos.get_pos_mirror', 'Position id does not exist [' || p_usim_id_pos || '].');
      RETURN NULL;
    END IF;
  END get_pos_mirror
  ;

  FUNCTION insert_next_position( p_sign       IN NUMBER   DEFAULT 1
                               , p_do_commit  IN BOOLEAN  DEFAULT TRUE
                               )
    RETURN usim_position.usim_id_pos%TYPE
  IS
    l_new_coordinate  usim_position.usim_coordinate%TYPE;
    l_result          usim_position.usim_id_pos%TYPE;
  BEGIN
    IF usim_pos.has_data = 0
    THEN
      INSERT INTO usim_position (usim_coordinate) VALUES (0) RETURNING usim_id_pos INTO l_result;
      IF p_do_commit
      THEN
        COMMIT;
      END IF;
      RETURN l_result;
    ELSIF     usim_pos.overflow_reached = 0
          AND p_sign                   IN (1, -1)
    THEN
        l_new_coordinate := usim_pos.get_max_coordinate(p_sign) + p_sign;
        INSERT INTO usim_position (usim_coordinate) VALUES (l_new_coordinate) RETURNING usim_id_pos INTO l_result;
        IF p_do_commit
        THEN
          COMMIT;
        END IF;
        RETURN l_result;
    ELSE
      -- max reached, do nothing
      usim_erl.log_error('usim_pos.insert_next_position', 'Used with overflow reached or invalid sign [' || p_sign || '].');
      RETURN NULL;
    END IF;
  END insert_next_position
  ;

  FUNCTION insert_next_coord( p_usim_coordinate  IN usim_position.usim_coordinate%TYPE
                            , p_do_commit        IN BOOLEAN                            DEFAULT TRUE
                            )
    RETURN usim_position.usim_id_pos%TYPE
  IS
    l_sign            INTEGER;
    l_result          usim_position.usim_id_pos%TYPE;
    l_next_coordinate usim_position.usim_coordinate%TYPE;
  BEGIN
    -- get a valid default sign for parameter
    IF usim_pos.coordinate_exists(p_usim_coordinate) = 1
    THEN
      RETURN usim_pos.get_id_pos(p_usim_coordinate);
    ELSE
      IF     usim_pos.has_data = 0
         AND p_usim_coordinate = 0
      THEN
        l_result := usim_pos.insert_next_position(l_sign, p_do_commit);
        RETURN l_result;
      ELSE
        l_sign            := SIGN(p_usim_coordinate);
        l_next_coordinate := usim_pos.get_max_coordinate(l_sign) + l_sign;
        IF p_usim_coordinate = l_next_coordinate
        THEN
          l_result := usim_pos.insert_next_position(l_sign, p_do_commit);
          RETURN l_result;
        ELSE
          usim_erl.log_error('usim_pos.insert_next_coord', 'Used with constraints not fulfilled. Coordinate [' || p_usim_coordinate || '] sign [' || l_sign || '] is not next coordinate.');
          RETURN NULL;
        END IF;
      END IF;
    END IF;
  END insert_next_coord
  ;

  FUNCTION insert_dim_pair( p_usim_coordinate  IN usim_position.usim_coordinate%TYPE
                          , p_do_commit        IN BOOLEAN                            DEFAULT TRUE
                          )
    RETURN NUMBER
  IS
    l_usim_pos1   usim_position.usim_coordinate%TYPE;
    l_usim_pos2   usim_position.usim_coordinate%TYPE;
    l_usim_pos1m  usim_position.usim_coordinate%TYPE;
    l_usim_pos2m  usim_position.usim_coordinate%TYPE;
    l_usim_id_pos usim_position.usim_id_pos%TYPE;
  BEGIN
    IF usim_pos.has_dim_pair(p_usim_coordinate) = 1
    THEN
      RETURN 1;
    ELSE
      l_usim_pos1  := ABS(p_usim_coordinate);
      l_usim_pos2  := l_usim_pos1 + 1;
      l_usim_pos1m := ABS(p_usim_coordinate) * -1;
      l_usim_pos2m := l_usim_pos1m - 1;
      IF usim_pos.coordinate_exists(l_usim_pos1) = 0
      THEN
        l_usim_id_pos := usim_pos.insert_next_coord(l_usim_pos1, p_do_commit);
        IF l_usim_id_pos IS NULL
        THEN
          usim_erl.log_error('usim_pos.insert_vol_pair', 'Insert failed for coordinate [' || l_usim_pos1 || '].');
          RETURN 0;
        END IF;
      END IF;
      IF usim_pos.coordinate_exists(l_usim_pos1m) = 0
      THEN
        l_usim_id_pos := usim_pos.insert_next_coord(l_usim_pos1m, p_do_commit);
        IF l_usim_id_pos IS NULL
        THEN
          usim_erl.log_error('usim_pos.insert_vol_pair', 'Insert failed for coordinate [' || l_usim_pos1m || '].');
          RETURN 0;
        END IF;
      END IF;
      IF usim_pos.coordinate_exists(l_usim_pos2) = 0
      THEN
        l_usim_id_pos := usim_pos.insert_next_coord(l_usim_pos2, p_do_commit);
        IF l_usim_id_pos IS NULL
        THEN
          usim_erl.log_error('usim_pos.insert_vol_pair', 'Insert failed for coordinate [' || l_usim_pos2 || '].');
          RETURN 0;
        END IF;
      END IF;
      IF usim_pos.coordinate_exists(l_usim_pos2m) = 0
      THEN
        l_usim_id_pos := usim_pos.insert_next_coord(l_usim_pos2m, p_do_commit);
        IF l_usim_id_pos IS NULL
        THEN
          usim_erl.log_error('usim_pos.insert_vol_pair', 'Insert failed for coordinate [' || l_usim_pos2m || '].');
          RETURN 0;
        END IF;
      END IF;
      RETURN 1;
    END IF;
  END insert_dim_pair
  ;

  FUNCTION insert_dim_pair( p_usim_id_pos IN usim_position.usim_id_pos%TYPE
                          , p_do_commit   IN BOOLEAN                        DEFAULT TRUE
                          )
    RETURN NUMBER
  IS
  BEGIN
    RETURN usim_pos.insert_dim_pair(usim_pos.get_coordinate(p_usim_id_pos), p_do_commit);
  END insert_dim_pair
  ;

END usim_pos;
/
