CREATE OR REPLACE PACKAGE BODY usim_pos
IS
  -- see header for documentation

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

  FUNCTION has_data(p_usim_coordinate IN usim_position.usim_coordinate%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_position WHERE usim_coordinate = p_usim_coordinate;
    RETURN l_result;
  END has_data
  ;

  FUNCTION has_dim_pair(p_usim_coordinate IN usim_position.usim_coordinate%TYPE)
    RETURN NUMBER
  IS
  BEGIN
    IF      usim_pos.has_data(ABS(p_usim_coordinate))            = 1
       AND  usim_pos.has_data(ABS(p_usim_coordinate) + 1)        = 1
       AND  usim_pos.has_data(ABS(p_usim_coordinate) * -1)       = 1
       AND  usim_pos.has_data((ABS(p_usim_coordinate) + 1) * -1) = 1
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

  FUNCTION get_max_coordinate(p_sign IN NUMBER DEFAULT 1)
    RETURN usim_position.usim_coordinate%TYPE
  IS
    l_result  usim_position.usim_coordinate%TYPE;
  BEGIN
    IF     usim_pos.has_data = 1
       AND p_sign           IN (1, -1)
    THEN
      IF p_sign > 0
      THEN
        SELECT MAX(usim_coordinate) INTO l_result FROM usim_position WHERE SIGN(usim_coordinate) IN (0, 1);
      ELSE
        SELECT MIN(usim_coordinate) INTO l_result FROM usim_position WHERE SIGN(usim_coordinate) IN (0, -1);
      END IF;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_pos.get_max_coordinate', 'Used without position data or wrong sign [' || p_sign || '].');
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
    IF usim_pos.has_data(p_usim_coordinate) = 1
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
      IF usim_pos.has_data(l_coord) = 1
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

  FUNCTION insert_position( p_usim_coordinate IN usim_position.usim_coordinate%TYPE
                          , p_do_commit       IN BOOLEAN                            DEFAULT TRUE
                          )
    RETURN usim_position.usim_id_pos%TYPE
  IS
    l_result          usim_position.usim_id_pos%TYPE;
  BEGIN
    IF usim_pos.has_data(p_usim_coordinate) = 1
    THEN
      RETURN usim_pos.get_id_pos(p_usim_coordinate);
    ELSIF p_usim_coordinate IS NOT NULL
    THEN
      INSERT INTO usim_position (usim_coordinate) VALUES (p_usim_coordinate) RETURNING usim_id_pos INTO l_result;
      IF p_do_commit
      THEN
        COMMIT;
      END IF;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_pos.insert_position', 'Used with invalid position coordinate [' || p_usim_coordinate || '].');
      RETURN NULL;
    END IF;
  END insert_position
  ;

  FUNCTION init_positions( p_max_coordinate IN usim_position.usim_coordinate%TYPE
                         , p_do_commit      IN BOOLEAN                            DEFAULT TRUE
                         )
    RETURN NUMBER
  IS
    l_usim_id_pos usim_position.usim_id_pos%TYPE;
  BEGIN
    IF p_max_coordinate IS NULL
    THEN
      usim_erl.log_error('usim_dim.init_positions', 'Used with invalid max position [' || p_max_coordinate || '].');
      RETURN 0;
    END IF;
    FOR l_pos IN 0..ABS(p_max_coordinate)
    LOOP
      l_usim_id_pos := usim_pos.insert_position(l_pos, p_do_commit);
      IF l_usim_id_pos IS NULL
      THEN
        usim_erl.log_error('usim_dim.init_positions', 'Error inserting position [' || l_pos || '].');
        RETURN 0;
      END IF;
      IF l_pos != 0
      THEN
        -- insert negative value
        l_usim_id_pos := usim_pos.insert_position(-l_pos, p_do_commit);
        IF l_usim_id_pos IS NULL
        THEN
          usim_erl.log_error('usim_dim.init_positions', 'Error inserting position [' || -l_pos || '].');
          RETURN 0;
        END IF;
      END IF;
    END LOOP;
    RETURN 1;
  END init_positions
  ;

END usim_pos;
/
