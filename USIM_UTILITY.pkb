CREATE OR REPLACE PACKAGE BODY usim_utility IS
  -- documentation see header
  FUNCTION getX(p_usim_coords IN usim_poi_dim_position.usim_coords%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
  IS
    l_usim_coordinate   usim_position.usim_coordinate%TYPE;
    l_start             INTEGER;
    l_end               INTEGER;
    l_length            INTEGER;
  BEGIN
    l_start := INSTR(p_usim_coords, ',', 1, 1);
    l_usim_coordinate := NULL;
    IF l_start > 0
    THEN
      l_end := INSTR(p_usim_coords, ',', 1, 2);
      IF l_end = 0
      THEN
        l_usim_coordinate := TO_NUMBER(SUBSTR(p_usim_coords, l_start + 1));
      ELSE
        l_length := l_end - l_start - 1;
        l_usim_coordinate := TO_NUMBER(SUBSTR(p_usim_coords, l_start + 1, l_length));
      END IF;
    END IF;
    RETURN l_usim_coordinate;
  END getX
  ;

  FUNCTION getY(p_usim_coords IN usim_poi_dim_position.usim_coords%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
  IS
    l_usim_coordinate   usim_position.usim_coordinate%TYPE;
    l_start             INTEGER;
    l_end               INTEGER;
    l_length            INTEGER;
  BEGIN
    l_start := INSTR(p_usim_coords, ',', 1, 2);
    l_usim_coordinate := NULL;
    IF l_start > 0
    THEN
      l_end := INSTR(p_usim_coords, ',', 1, 3);
      IF l_end = 0
      THEN
        l_usim_coordinate := TO_NUMBER(SUBSTR(p_usim_coords, l_start + 1));
      ELSE
        l_length := l_end - l_start - 1;
        l_usim_coordinate := TO_NUMBER(SUBSTR(p_usim_coords, l_start + 1, l_length));
      END IF;
    END IF;
    RETURN l_usim_coordinate;
  END getY
  ;

  FUNCTION getZ(p_usim_coords IN usim_poi_dim_position.usim_coords%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
  IS
    l_usim_coordinate   usim_position.usim_coordinate%TYPE;
    l_start             INTEGER;
    l_end               INTEGER;
    l_length            INTEGER;
  BEGIN
    l_start := INSTR(p_usim_coords, ',', 1, 3);
    l_usim_coordinate := NULL;
    IF l_start > 0
    THEN
      l_end := INSTR(p_usim_coords, ',', 1, 4);
      IF l_end = 0
      THEN
        l_usim_coordinate := TO_NUMBER(SUBSTR(p_usim_coords, l_start + 1));
      ELSE
        l_length := l_end - l_start - 1;
        l_usim_coordinate := TO_NUMBER(SUBSTR(p_usim_coords, l_start + 1, l_length));
      END IF;
    END IF;
    RETURN l_usim_coordinate;
  END getZ
  ;

END usim_utility;
/