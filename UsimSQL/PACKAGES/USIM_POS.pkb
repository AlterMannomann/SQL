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

  FUNCTION coordinate_exists(p_usim_coordinate IN usim_position.usim_coordinate%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_position WHERE usim_coordinate = p_usim_coordinate;
    RETURN l_result;
  END coordinate_exists
  ;

  FUNCTION overflow_reached
    RETURN NUMBER
  IS
    l_pos_max       usim_position.usim_coordinate%TYPE;
    l_neg_max       usim_position.usim_coordinate%TYPE;
  BEGIN
    IF      usim_pos.has_data       = 1
       AND  usim_base.has_basedata  = 1
    THEN
      SELECT MAX(usim_coordinate) INTO l_pos_max FROM usim_position WHERE usim_coordinate >= 0;
      SELECT MIN(usim_coordinate) INTO l_neg_max FROM usim_position WHERE usim_coordinate <= 0;
      IF      ABS(l_pos_max) = usim_base.get_abs_max_number
         AND  ABS(l_neg_max) = usim_base.get_abs_max_number
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

  FUNCTION get_max_coordinate(p_sign IN NUMBER DEFAULT 1)
    RETURN usim_position.usim_coordinate%TYPE
  IS
    l_sign    NUMBER;
    l_result  usim_position.usim_coordinate%TYPE;
  BEGIN
    IF usim_pos.has_data = 1
    THEN
      IF NVL(p_sign, 0) = 0
      THEN
        l_sign := 1;
      ELSE
        l_sign := SIGN(p_sign);
      END IF;
      IF l_sign > 0
      THEN
        SELECT MAX(usim_coordinate) INTO l_result FROM usim_position;
      ELSE
        SELECT MIN(usim_coordinate) INTO l_result FROM usim_position;
      END IF;
      RETURN l_result;
    ELSE
      RETURN -1;
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

  FUNCTION get_id_pos(p_usim_coordinate IN usim_position.usim_coordinate%TYPE)
    RETURN usim_position.usim_id_pos%TYPE
  IS
    l_result usim_position.usim_id_pos%TYPE;
  BEGIN
    IF usim_pos.coordinate_exists(p_usim_coordinate) = 1
    THEN
      SELECT usim_id_pos INTO l_result FROM usim_position WHERE usim_coordinate = p_usim_coordinate;
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
    IF usim_pos.overflow_reached = 0
    THEN
      IF    NVL(p_sign, 0) = 0
         OR usim_pos.has_data = 0
      THEN
        -- ignore the sign for 0 or adding first coordinate 0
        l_sign := 1;
      ELSE
        l_sign := SIGN(p_sign);
      END IF;
      l_new_coordinate := usim_pos.get_max_coordinate(l_sign) + l_sign;
      INSERT INTO usim_position (usim_coordinate) VALUES (l_new_coordinate) RETURNING usim_id_pos INTO l_result;
      IF p_do_commit
      THEN
        COMMIT;
      END IF;
      RETURN l_result;
    ELSE
      -- max reached, do nothing
      RETURN NULL;
    END IF;
  END insert_next_position
  ;

END usim_pos;
/