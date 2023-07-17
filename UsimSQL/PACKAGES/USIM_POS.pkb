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

  FUNCTION coordinate_exists( p_usim_coordinate IN usim_position.usim_coordinate%TYPE
                            , p_sign_default    IN NUMBER                             DEFAULT 1
                            )
    RETURN NUMBER
  IS
    l_result NUMBER;
    l_sign   NUMBER;
  BEGIN
    IF      p_usim_coordinate = 0
       AND  p_sign_default    = 0
    THEN
      l_sign := p_sign_default;
    ELSE
      l_sign := usim_pos.get_sign(p_usim_coordinate, p_sign_default);
    END IF;
    SELECT COUNT(*) INTO l_result FROM usim_position WHERE usim_coordinate = p_usim_coordinate AND usim_sign = l_sign;
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
    l_sign  NUMBER;
    l_max   NUMBER;
  BEGIN
    l_sign := usim_pos.get_sign(0, p_sign);
    SELECT MAX(ABS(usim_coordinate)) INTO l_max FROM usim_position WHERE usim_sign = l_sign;
    IF l_max >= usim_base.get_abs_max_number
    THEN
      RETURN 1;
    ELSE
      RETURN 0;
    END IF;
  END overflow_reached
  ;

  FUNCTION get_max_coordinate(p_sign IN NUMBER DEFAULT 1)
    RETURN usim_position.usim_coordinate%TYPE
  IS
    l_sign    NUMBER;
    l_result  usim_position.usim_coordinate%TYPE;
  BEGIN
    IF usim_pos.has_data = 1
    THEN
      l_sign := usim_pos.get_sign(0, p_sign);
      IF l_sign > 0
      THEN
        SELECT MAX(usim_coordinate) INTO l_result FROM usim_position WHERE usim_sign = l_sign;
      ELSE
        SELECT MIN(usim_coordinate) INTO l_result FROM usim_position WHERE usim_sign = l_sign;
      END IF;
      RETURN l_result;
    ELSE
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
      RETURN NULL;
    END IF;
  END get_coordinate
  ;

  FUNCTION get_coord_sign(p_usim_id_pos IN usim_position.usim_id_pos%TYPE)
    RETURN usim_position.usim_sign%TYPE
  IS
    l_result usim_position.usim_sign%TYPE;
  BEGIN
    IF usim_pos.has_data(p_usim_id_pos) = 1
    THEN
      SELECT usim_sign INTO l_result FROM usim_position WHERE usim_id_pos = p_usim_id_pos;
      RETURN l_result;
    ELSE
      RETURN NULL;
    END IF;
  END get_coord_sign
  ;

  FUNCTION get_id_pos( p_usim_coordinate  IN usim_position.usim_coordinate%TYPE
                     , p_usim_sign        IN usim_position.usim_sign%TYPE
                     )
    RETURN usim_position.usim_id_pos%TYPE
  IS
    l_result  usim_position.usim_id_pos%TYPE;
  BEGIN
    IF usim_pos.coordinate_exists(p_usim_coordinate, p_usim_sign) = 1
    THEN
      SELECT usim_id_pos INTO l_result FROM usim_position WHERE usim_coordinate = p_usim_coordinate AND usim_sign = p_usim_sign;
      RETURN l_result;
    ELSE
      RETURN NULL;
    END IF;
  END get_id_pos
  ;

  FUNCTION insert_next_position( p_sign       IN NUMBER   DEFAULT 1
                               , p_do_commit  IN BOOLEAN  DEFAULT TRUE
                               )
    RETURN usim_position.usim_id_pos%TYPE
  IS
    l_sign            NUMBER;
    l_new_coordinate  usim_position.usim_coordinate%TYPE;
    l_result          usim_position.usim_id_pos%TYPE;
  BEGIN
    -- get a valid default sign for parameter
    l_sign := usim_pos.get_sign(p_sign, p_sign);
    IF usim_pos.has_data = 0
    THEN
      INSERT INTO usim_position (usim_coordinate, usim_sign) VALUES (0, 0) RETURNING usim_id_pos INTO l_result;
      IF p_do_commit
      THEN
        COMMIT;
      END IF;
      RETURN l_result;
    ELSIF usim_pos.overflow_reached = 0
    THEN
      IF l_sign = 0
      THEN
        l_sign := usim_pos.get_sign(NULL, p_sign);
      END IF;
      IF usim_pos.overflow_reached(l_sign) = 0
      THEN
        l_new_coordinate := usim_pos.get_max_coordinate(l_sign);
        IF l_new_coordinate IS NULL
        THEN
          l_new_coordinate := 0;
        ELSE
          l_new_coordinate := l_new_coordinate + l_sign;
        END IF;
        INSERT INTO usim_position (usim_coordinate, usim_sign) VALUES (l_new_coordinate, l_sign) RETURNING usim_id_pos INTO l_result;
        IF p_do_commit
        THEN
          COMMIT;
        END IF;
        RETURN l_result;
      END IF;
    ELSE
      -- max reached, do nothing
      RETURN NULL;
    END IF;
  END insert_next_position
  ;

  FUNCTION insert_next_position( p_usim_coordinate  IN usim_position.usim_coordinate%TYPE
                               , p_sign             IN NUMBER                             DEFAULT 1
                               , p_do_commit        IN BOOLEAN                            DEFAULT TRUE
                               )
    RETURN usim_position.usim_id_pos%TYPE
  IS
    l_sign            NUMBER;
    l_new_coordinate  usim_position.usim_coordinate%TYPE;
    l_result          usim_position.usim_id_pos%TYPE;
    l_next_coordinate usim_position.usim_coordinate%TYPE;
  BEGIN
    -- get a valid default sign for parameter
    l_sign := usim_pos.get_sign(p_usim_coordinate, p_sign);
    IF usim_pos.coordinate_exists(p_usim_coordinate, l_sign) = 1
    THEN
      RETURN usim_pos.get_id_pos(p_usim_coordinate, l_sign);
    ELSE
      IF l_sign > 0
      THEN
        l_next_coordinate := NVL(usim_pos.get_max_coordinate(l_sign), -1) + 1;
      ELSIF l_sign < 0
      THEN
        l_next_coordinate := NVL(usim_pos.get_max_coordinate(l_sign), 1) - 1;
      ELSE
        l_next_coordinate := 0;
      END IF;
      IF     p_usim_coordinate         = l_next_coordinate
         AND usim_pos.overflow_reached = 0
         AND usim_pos.has_data         = 1
      THEN
        INSERT INTO usim_position (usim_coordinate, usim_sign) VALUES (p_usim_coordinate, l_sign) RETURNING usim_id_pos INTO l_result;
        IF p_do_commit
        THEN
          COMMIT;
        END IF;
        RETURN l_result;
      ELSIF usim_pos.has_data = 0
      THEN
        INSERT INTO usim_position (usim_coordinate, usim_sign) VALUES (0, 0) RETURNING usim_id_pos INTO l_result;
        IF p_do_commit
        THEN
          COMMIT;
        END IF;
        RETURN l_result;
      ELSE
        RETURN NULL;
      END IF;
    END IF;
  END insert_next_position
  ;

END usim_pos;
/