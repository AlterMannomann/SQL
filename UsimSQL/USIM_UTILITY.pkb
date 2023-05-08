CREATE OR REPLACE PACKAGE BODY usim_utility IS
  -- documentation see header
   FUNCTION extractValue( p_delimiter     IN VARCHAR2
                        , p_string        IN VARCHAR2
                        , p_position      IN NUMBER
                        )
    RETURN VARCHAR2
  IS
    l_result            VARCHAR2(4000);
    l_start             INTEGER;
    l_end               INTEGER;
    l_length            INTEGER;
    l_pos_start         INTEGER;
    l_pos_end           INTEGER;
  BEGIN
    l_pos_start := p_position;
    l_pos_end   := p_position + 1;
    l_start := INSTR(p_string, p_delimiter, 1, l_pos_start);
    l_result := NULL;
    IF l_start > 0
    THEN
      l_end := INSTR(p_string, p_delimiter, 1, l_pos_end);
      IF l_end = 0
      THEN
        l_result := SUBSTR(p_string, l_start + 1);
      ELSE
        l_length := l_end - l_start - 1;
        l_result := SUBSTR(p_string, l_start + 1, l_length);
      END IF;
    END IF;
    RETURN l_result;
  END extractValue
  ;

  FUNCTION getX(p_usim_coords IN usim_poi_dim_position.usim_coords%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
  IS
  BEGIN
    RETURN TO_NUMBER(extractValue(',', p_usim_coords, 1));
  END getX
  ;

  FUNCTION getY(p_usim_coords IN usim_poi_dim_position.usim_coords%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
  IS
  BEGIN
    RETURN TO_NUMBER(extractValue(',', p_usim_coords, 2));
  END getY
  ;

  FUNCTION getZ(p_usim_coords IN usim_poi_dim_position.usim_coords%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
  IS
  BEGIN
    RETURN TO_NUMBER(extractValue(',', p_usim_coords, 3));
  END getZ
  ;

END usim_utility;
/