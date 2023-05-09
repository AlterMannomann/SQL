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

  FUNCTION vector_distance( p_usim_coords1  IN usim_poi_dim_position.usim_coords%TYPE
                          , p_usim_coords2  IN usim_poi_dim_position.usim_coords%TYPE
                          )
    RETURN NUMBER
  IS
    l_min_vector    VARCHAR2(4000);
    l_max_vector    VARCHAR2(4000);
    l_sum_vector1   NUMBER;
    l_sum_vector2   NUMBER;
    l_distance      NUMBER;

    -- get the vector with more entries
    CURSOR cur_max_vector( cp_coords1 IN VARCHAR2
                         , cp_coords2 IN VARCHAR2
                         )
    IS
        WITH coord1 AS
             (SELECT TRIM(REGEXP_SUBSTR(str, '[^,]+', 1, LEVEL)) AS coord
                   , LEVEL AS lvl
                FROM (SELECT cp_coords1 AS str
                        FROM dual
                     )
             CONNECT BY LEVEL <= LENGTH(str) - LENGTH(REPLACE(str, ',')) + 1
             )
           , coord2 AS
             (SELECT TRIM(REGEXP_SUBSTR(str, '[^,]+', 1, LEVEL)) AS coord
                   , LEVEL AS lvl
                FROM (SELECT cp_coords2 AS str
                        FROM dual
                     )
             CONNECT BY LEVEL <= LENGTH(str) - LENGTH(REPLACE(str, ',')) + 1
             )
      SELECT (SELECT NVL(SUM(lvl), 0) FROM coord1) AS sum_coord1
           , (SELECT NVL(SUM(lvl), 0) FROM coord2) AS sum_coord2
        FROM dual
    ;
    CURSOR cur_distance( cp_coords_max IN VARCHAR2
                       , cp_coords_min IN VARCHAR2
                       )
    IS
      SELECT SQRT(SUM(diff_vec_sq)) AS distance
        FROM (  WITH cmax AS
                     (SELECT TRIM(REGEXP_SUBSTR(str, '[^,]+', 1, LEVEL)) AS coord
                           , LEVEL AS lvl
                        FROM (SELECT cp_coords_max AS str
                                FROM dual
                             )
                     CONNECT BY LEVEL <= LENGTH(str) - LENGTH(REPLACE(str, ',')) + 1
                     )
                   , cmin AS
                     (SELECT TRIM(REGEXP_SUBSTR(str, '[^,]+', 1, LEVEL)) AS coord
                           , LEVEL AS lvl
                        FROM (SELECT cp_coords_min AS str
                                FROM dual
                             )
                     CONNECT BY LEVEL <= LENGTH(str) - LENGTH(REPLACE(str, ',')) + 1
                     )
                     -- square of difference between vec1 - vec2
              SELECT POWER(NVL(TO_NUMBER(cmax.coord), 0) - NVL(TO_NUMBER(cmin.coord), 0), 2) AS diff_vec_sq
                FROM cmax
                LEFT OUTER JOIN cmin
                  ON cmax.lvl = cmax.lvl
             )
    ;
  BEGIN
    -- if no values in both coords return 0
    IF     (p_usim_coords1 IS NULL OR LENGTH(p_usim_coords1) = 0)
       AND (p_usim_coords2 IS NULL OR LENGTH(p_usim_coords2) = 0)
    THEN
      RETURN 0;
    END IF;
    -- find the bigger one
    OPEN cur_max_vector(p_usim_coords1, p_usim_coords2);
    FETCH cur_max_vector INTO l_sum_vector1, l_sum_vector2;
    CLOSE cur_max_vector;
    IF l_sum_vector1 > l_sum_vector2
    THEN
      l_max_vector := p_usim_coords1;
      l_min_vector := p_usim_coords2;
    ELSE
      l_max_vector := p_usim_coords2;
      l_min_vector := p_usim_coords1;
    END IF;
    OPEN cur_distance(l_max_vector, l_min_vector);
    FETCH cur_distance INTO l_distance;
    CLOSE cur_distance;
    RETURN l_distance;
  END vector_distance
  ;

END usim_utility;
/