CREATE OR REPLACE PACKAGE BODY usim_utility IS
  -- documentation see header
  FUNCTION extract_coordinate( p_string         IN usim_poi_dim_position.usim_coords%TYPE
                             , p_position       IN NUMBER
                             , p_delimiter      IN VARCHAR2 DEFAULT ','
                             , p_ignore_start   IN VARCHAR2 DEFAULT '('
                             , p_ignore_end     IN VARCHAR2 DEFAULT ')'
                             )
    RETURN VARCHAR2
  IS
    l_result            usim_poi_dim_position.usim_coords%TYPE;
    l_pos_string        usim_poi_dim_position.usim_coords%TYPE;
    l_start             INTEGER;
    l_end               INTEGER;
    l_position          INTEGER;
    l_has_delimiter     BOOLEAN;
    l_req_delimiter     BOOLEAN;
    l_debug_id          usim_debug_log.usim_id_dlg%TYPE;
    l_debug_object      usim_debug_log.usim_log_object%TYPE := 'USIM_UTILITY.EXTRACT_COORDINATE';
    l_debug_content     usim_debug_log.usim_log_content%TYPE;
  BEGIN
    l_debug_id      := usim_debug.start_debug;
    l_debug_content := 'PARAMETER: p_string[' || p_string || '] p_position[' || p_position || '] p_delimiter[' || p_delimiter || '] p_ignore_start[' || p_ignore_start || '] p_ignore_end[' || p_ignore_end || ']';
    usim_debug.debug_log(l_debug_id, usim_static.usim_status_success, l_debug_object, l_debug_content);
    l_result        := NULL;
    l_position      := CASE WHEN p_position < 0 THEN 0 ELSE p_position END;
    l_has_delimiter := INSTR(p_string, p_delimiter, 1) > 0;
    -- do we have required delimiters for desired position
    IF p_position > 0
    THEN
      l_req_delimiter := INSTR(p_string, p_delimiter, 1, p_position) > 0;
    ELSE
      l_req_delimiter := TRUE;
    END IF;
    -- get the position substr, consider that delimiter could be missing
    IF l_req_delimiter
    THEN
      IF l_has_delimiter
      THEN
        IF l_position = 0
        THEN
          l_end         := INSTR(p_string, p_delimiter, 1) - 1;
          l_pos_string  := SUBSTR(p_string, 1, l_end);
        ELSE
          l_start       := INSTR(p_string, p_delimiter, 1, p_position) + 1;
          l_end         := INSTR(p_string, p_delimiter, 1, p_position + 1);
          IF l_end > l_start
          THEN
            l_pos_string  := SUBSTR(p_string, l_start, l_end - l_start);
          ELSE
            -- no final delimiter
            l_pos_string  := SUBSTR(p_string, l_start);
          END IF;
        END IF;
      ELSE
        l_pos_string  := p_string;
      END IF;
    ELSE
      -- we have no fitting position
      l_pos_string := '';
    END IF;
    l_debug_content := 'STATE: l_pos_string[' || l_pos_string || '] l_position[' || l_position || '] l_has_delimiter[' || usim_static.get_bool_str(l_has_delimiter) || '] l_rec_delimiter[' || usim_static.get_bool_str(l_req_delimiter) || '] l_start[' || l_start || '] l_end[' || l_end || ']';
    usim_debug.debug_log(l_debug_id, usim_static.usim_status_success, l_debug_object, l_debug_content);
    -- discard the level, if present
    IF INSTR(l_pos_string, p_ignore_start, 1) > 0
    THEN
      l_end     := INSTR(l_pos_string, p_ignore_start, 1) - 1;
      -- remove any non number char
      l_result  := TRIM(REGEXP_REPLACE(SUBSTR(l_pos_string, 1, l_end), '[^0-9]', ''));
    ELSE
      -- remove any non number char
      l_result  := TRIM(REGEXP_REPLACE(l_pos_string, '[^0-9]', ''));
    END IF;
    l_debug_content := 'RESULT: l_result[' || l_result || '] l_end[' || l_end || ']';
    usim_debug.debug_log(l_debug_id, usim_static.usim_status_success, l_debug_object, l_debug_content);
    RETURN l_result;
  END extract_coordinate
  ;

  FUNCTION extract_number_level( p_string         IN usim_poi_dim_position.usim_coords%TYPE
                               , p_position       IN NUMBER
                               , p_delimiter      IN VARCHAR2 DEFAULT ','
                               , p_level_start    IN VARCHAR2 DEFAULT '('
                               , p_level_end      IN VARCHAR2 DEFAULT ')'
                               )
    RETURN VARCHAR2
  IS
    l_result            usim_poi_dim_position.usim_coords%TYPE;
    l_pos_string        usim_poi_dim_position.usim_coords%TYPE;
    l_level_string      usim_poi_dim_position.usim_coords%TYPE;
    l_start             INTEGER;
    l_end               INTEGER;
    l_position          INTEGER;
    l_has_delimiter     BOOLEAN;
    l_req_delimiter     BOOLEAN;
    l_debug_id          usim_debug_log.usim_id_dlg%TYPE;
    l_debug_object      usim_debug_log.usim_log_object%TYPE := 'USIM_UTILITY.EXTRACT_NUMBER_LEVEL';
    l_debug_content     usim_debug_log.usim_log_content%TYPE;
  BEGIN
    l_debug_id      := usim_debug.start_debug;
    l_debug_content := 'PARAMETER: p_string[' || p_string || '] p_position[' || p_position || '] p_delimiter[' || p_delimiter || '] p_level_start[' || p_level_start || '] p_level_end[' || p_level_end || ']';
    usim_debug.debug_log(l_debug_id, usim_static.usim_status_success, l_debug_object, l_debug_content);
    l_result        := NULL;
    l_position      := CASE WHEN p_position < 0 THEN 0 ELSE p_position END;
    l_has_delimiter := INSTR(p_string, p_delimiter, 1) > 0;
    -- do we have required delimiters for desired position
    IF p_position > 0
    THEN
      l_req_delimiter := INSTR(p_string, p_delimiter, 1, p_position) > 0;
    ELSE
      l_req_delimiter := TRUE;
    END IF;
    -- get the position substr, consider that delimiter could be missing
    IF l_req_delimiter
    THEN
      IF l_has_delimiter
      THEN
        IF l_position = 0
        THEN
          l_end         := INSTR(p_string, p_delimiter, 1) - 1;
          l_pos_string  := SUBSTR(p_string, 1, l_end);
        ELSE
          l_start       := INSTR(p_string, p_delimiter, 1, p_position) + 1;
          l_end         := INSTR(p_string, p_delimiter, 1, p_position + 1);
          IF l_end > l_start
          THEN
            l_pos_string  := SUBSTR(p_string, l_start, l_end - l_start);
          ELSE
            -- no final delimiter
            l_pos_string  := SUBSTR(p_string, l_start);
          END IF;
        END IF;
      ELSE
        l_pos_string  := p_string;
      END IF;
    ELSE
      -- we have no fitting position
      l_pos_string := '';
    END IF;
    l_debug_content := 'STATE: l_pos_string[' || l_pos_string || '] l_position[' || l_position || '] l_has_delimiter[' || usim_static.get_bool_str(l_has_delimiter) || '] l_rec_delimiter[' || usim_static.get_bool_str(l_req_delimiter) || '] l_start[' || l_start || '] l_end[' || l_end || ']';
    usim_debug.debug_log(l_debug_id, usim_static.usim_status_success, l_debug_object, l_debug_content);
    -- extract the level
    l_start := INSTR(l_pos_string, p_level_start, 1);
    l_end   := INSTR(l_pos_string, p_level_end, 1);
    IF l_start > 0 AND l_end > 0
    THEN
      l_level_string := SUBSTR(l_pos_string, l_start + 1);
      -- remove any non number char
      l_result := TRIM(REGEXP_REPLACE(l_level_string, '[^0-9]', ''));
    END IF;
    l_debug_content := 'RESULT: l_result[' || l_result || '] l_start[' || l_start || '] l_end[' || l_end || '] l_level_string[' || l_level_string || ']';
    usim_debug.debug_log(l_debug_id, usim_static.usim_status_success, l_debug_object, l_debug_content);
    RETURN l_result;
  END extract_number_level
  ;

  FUNCTION get_coordinate( p_string         IN usim_poi_dim_position.usim_coords%TYPE
                         , p_position       IN NUMBER
                         )
    RETURN NUMBER
  IS
  BEGIN
    RETURN NVL(TO_NUMBER(extract_coordinate(p_string, p_position)), 0);
  END get_coordinate
  ;

  FUNCTION get_number_level( p_string         IN usim_poi_dim_position.usim_coords%TYPE
                           , p_position       IN NUMBER
                           )
    RETURN NUMBER
  IS
  BEGIN
    RETURN NVL(TO_NUMBER(extract_number_level(p_string, p_position)), 0);
  END get_number_level
  ;


  FUNCTION get_x(p_usim_coords IN usim_poi_dim_position.usim_coords%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
  IS
  BEGIN
    RETURN get_coordinate(p_usim_coords, 1);
  END get_x
  ;

  FUNCTION get_x_level(p_usim_coords IN usim_poi_dim_position.usim_coords%TYPE)
    RETURN usim_position.usim_coord_level%TYPE
  IS
  BEGIN
    RETURN get_number_level(p_usim_coords, 1);
  END get_x_level
  ;

  FUNCTION get_y(p_usim_coords IN usim_poi_dim_position.usim_coords%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
  IS
  BEGIN
    RETURN get_coordinate(p_usim_coords, 2);
  END get_y
  ;

  FUNCTION get_y_level(p_usim_coords IN usim_poi_dim_position.usim_coords%TYPE)
    RETURN usim_position.usim_coord_level%TYPE
  IS
  BEGIN
    RETURN get_number_level(p_usim_coords, 2);
  END get_y_level
  ;

  FUNCTION get_z(p_usim_coords IN usim_poi_dim_position.usim_coords%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
  IS
  BEGIN
    RETURN get_coordinate(p_usim_coords, 3);
  END get_z
  ;

  FUNCTION get_z_level(p_usim_coords IN usim_poi_dim_position.usim_coords%TYPE)
    RETURN usim_position.usim_coord_level%TYPE
  IS
  BEGIN
    RETURN get_number_level(p_usim_coords, 3);
  END get_z_level
  ;

  FUNCTION next_planck_time
    RETURN VARCHAR2
  IS
  BEGIN
    -- update table to cause next value
    UPDATE usim_planck_time
       SET usim_last_planck_time = 'NEW'
     WHERE usim_id_plt = usim_static.usim_planck_timer
    ;
    COMMIT;
    RETURN current_planck_time;
  END next_planck_time
  ;

  FUNCTION current_planck_time
    RETURN VARCHAR2
  IS
    l_result  usim_planck_time.usim_current_planck_time%TYPE;
  BEGIN
    SELECT usim_current_planck_time INTO l_result FROM usim_planck_time WHERE usim_id_plt = usim_static.usim_planck_timer;
    RETURN l_result;
  END current_planck_time
  ;

  FUNCTION last_planck_time
    RETURN VARCHAR2
  IS
    l_result  usim_planck_time.usim_last_planck_time%TYPE;
  BEGIN
    SELECT usim_last_planck_time INTO l_result FROM usim_planck_time WHERE usim_id_plt = usim_static.usim_planck_timer;
    RETURN l_result;
  END last_planck_time
  ;

  FUNCTION coords_diff( p_usim_coords1  IN usim_poi_dim_position.usim_coords%TYPE
                      , p_usim_coords2  IN usim_poi_dim_position.usim_coords%TYPE
                      )
    RETURN NUMBER
  IS
    l_coord1            NUMBER;
    l_coord2            NUMBER;
    l_level1            NUMBER;
    l_level2            NUMBER;
    l_result            NUMBER;
    l_debug_id          usim_debug_log.usim_id_dlg%TYPE;
    l_debug_object      usim_debug_log.usim_log_object%TYPE := 'USIM_UTILITY.COORDS_DIFF';
    l_debug_content     usim_debug_log.usim_log_content%TYPE;
  BEGIN
    l_debug_id      := usim_debug.start_debug;
    l_debug_content := 'PARAMETER: p_usim_coords1[' || p_usim_coords1 || '] p_usim_coords1[' || p_usim_coords1 || ']';
    usim_debug.debug_log(l_debug_id, usim_static.usim_status_success, l_debug_object, l_debug_content);
    l_coord1 := get_coordinate(p_usim_coords1, 0);
    l_level1 := get_number_level(p_usim_coords1, 0);
    l_coord2 := get_coordinate(p_usim_coords2, 0);
    l_level2 := get_number_level(p_usim_coords2, 0);
    l_debug_content := 'VARIABLES: l_coord1[' || l_coord1 || '] l_level1[' || l_level1 || '] l_coord2[' || l_coord2 || '] l_level2[' || l_level2 || ']';
    usim_debug.debug_log(l_debug_id, usim_static.usim_status_success, l_debug_object, l_debug_content);
    IF ABS(l_level1 - l_level2) > 1
    THEN
      l_result := 0;
    ELSIF ABS(l_level1 - l_level2) = 1
    THEN
      IF l_level2 > l_level1
      THEN
        l_result := (l_coord1 - usim_static.usim_max_number) - l_coord2;
      ELSE
        l_result := l_coord1 - (l_coord2 - usim_static.usim_max_number);
      END IF;
    ELSE
      l_result := l_coord1 - l_coord2;
    END IF;
    l_debug_content := 'RESULT: l_result[' || l_result || ']';
    usim_debug.debug_log(l_debug_id, usim_static.usim_status_success, l_debug_object, l_debug_content);
    RETURN l_result;
  END
  ;

  FUNCTION vector_distance( p_usim_coords1  IN usim_poi_dim_position.usim_coords%TYPE
                          , p_usim_coords2  IN usim_poi_dim_position.usim_coords%TYPE
                          )
    RETURN NUMBER
  IS
    l_min_vector        usim_poi_dim_position.usim_coords%TYPE;
    l_max_vector        usim_poi_dim_position.usim_coords%TYPE;
    l_sum_vector1       NUMBER;
    l_sum_vector2       NUMBER;
    l_distance          NUMBER;
    l_debug_id          usim_debug_log.usim_id_dlg%TYPE;
    l_debug_object      usim_debug_log.usim_log_object%TYPE := 'USIM_UTILITY.VECTOR_DISTANCE';
    l_debug_content     usim_debug_log.usim_log_content%TYPE;

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
                     -- square of difference between vec1 - vec2 (if NULL use 0 coordinate at level 1)
              SELECT POWER(usim_utility.coords_diff(cmax.coord, NVL(cmin.coord, '0(1)')), 2) AS diff_vec_sq
                FROM cmax
                LEFT OUTER JOIN cmin
                  ON cmax.lvl = cmin.lvl
             )
    ;
  BEGIN
    l_debug_id      := usim_debug.start_debug;
    l_debug_content := 'PARAMETER: p_usim_coords1[' || p_usim_coords1 || '] p_usim_coords2[' || p_usim_coords2 || ']';
    usim_debug.debug_log(l_debug_id, usim_static.usim_status_success, l_debug_object, l_debug_content);
    -- if no values in both coords return 0
    IF     (p_usim_coords1 IS NULL OR LENGTH(p_usim_coords1) = 0)
       AND (p_usim_coords2 IS NULL OR LENGTH(p_usim_coords2) = 0)
    THEN
      l_debug_content := 'RETURN: [0]';
      usim_debug.debug_log(l_debug_id, usim_static.usim_status_success, l_debug_object, l_debug_content);
      RETURN 0;
    END IF;
    -- find the bigger one (the one with more elements)
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
    l_debug_content := 'RETURN: [' || l_distance || ']';
    usim_debug.debug_log(l_debug_id, usim_static.usim_status_success, l_debug_object, l_debug_content);
    RETURN l_distance;
  END vector_distance
  ;
  -- see header for documentation
  FUNCTION energy_force( p_usim_energy_source         IN usim_point.usim_energy%TYPE
                       , p_usim_energy_target         IN usim_point.usim_energy%TYPE
                       , p_usim_distance              IN NUMBER
                       , p_usim_target_sign           IN NUMBER
                       , p_usim_gravitation_constant  IN NUMBER
                       )
    RETURN NUMBER
  IS
    l_usim_energy_force   NUMBER;
    l_result              NUMBER;
    l_debug_id            usim_debug_log.usim_id_dlg%TYPE;
    l_debug_object        usim_debug_log.usim_log_object%TYPE := 'USIM_UTILITY.ENERGY_FORCE';
    l_debug_content       usim_debug_log.usim_log_content%TYPE;
  BEGIN
    l_debug_id      := usim_debug.start_debug;
    l_debug_content := 'PARAMETER: p_usim_energy_source[' || p_usim_energy_source || '] p_usim_energy_target[' || p_usim_energy_target || '] p_usim_distance[' || p_usim_distance || '] p_usim_target_sign[' || p_usim_target_sign || '] p_usim_gravitation_constant[' || p_usim_gravitation_constant || ']';
    usim_debug.debug_log(l_debug_id, usim_static.usim_status_success, l_debug_object, l_debug_content);
    -- first special case distance = 0
    IF p_usim_distance = 0
    THEN
      -- setting values, no calculation
      l_result := NVL(p_usim_energy_source, 0);
    ELSE
      l_usim_energy_force := ABS(NVL(p_usim_gravitation_constant, 1)) * ((ABS(NVL(p_usim_energy_source, 1)) * ABS(NVL(p_usim_energy_target, 1))) / POWER(p_usim_distance, 2));
      -- handle sign
      l_usim_energy_force := l_usim_energy_force * CASE WHEN p_usim_target_sign = 0 THEN 1 ELSE p_usim_target_sign END;
      l_result := l_usim_energy_force;
    END IF;
    l_debug_content := 'RETURN: [' || l_result || '] l_usim_energy_force[' || l_usim_energy_force || ']';
    usim_debug.debug_log(l_debug_id, usim_static.usim_status_success, l_debug_object, l_debug_content);
    RETURN l_result;
  END energy_force
  ;

  FUNCTION get_max_position(p_sign IN NUMBER DEFAULT 1)
    RETURN NUMBER
  IS
    l_result        NUMBER;
    l_curr_val      INTEGER;
    l_has_values    INTEGER ;
    l_debug_id      usim_debug_log.usim_id_dlg%TYPE;
    l_debug_object  usim_debug_log.usim_log_object%TYPE := 'USIM_UTILITY.GET_MAX_POSITION';
    l_debug_content usim_debug_log.usim_log_content%TYPE;
  BEGIN
    l_debug_id      := usim_debug.start_debug;
    l_debug_content := 'PARAMETER: p_sign[' || p_sign || ']';
    usim_debug.debug_log(l_debug_id, usim_static.usim_status_success, l_debug_object, l_debug_content);
    IF p_sign >= 0
    THEN
      SELECT usim_level_positive INTO l_curr_val FROM usim_levels WHERE usim_id_lvl = 1;
    ELSE
      SELECT usim_level_negative INTO l_curr_val FROM usim_levels WHERE usim_id_lvl = 1;
    END IF;
    -- check if we have values for current level
    SELECT COUNT(*) INTO l_has_values FROM usim_position WHERE usim_coord_level = l_curr_val;
    IF l_has_values > 0
    THEN
      SELECT CASE WHEN p_sign >= 0 THEN MAX(usim_coordinate) ELSE MIN(usim_coordinate) END INTO l_result FROM usim_position WHERE usim_coord_level = l_curr_val;
    ELSE
      SELECT COUNT(*) INTO l_has_values FROM usim_position;
      -- if empty return NULL otherwise 0
      IF l_has_values > 0
      THEN
        l_result := 0;
      ELSE
        l_result := NULL;
      END IF;
    END IF;
    l_debug_content := 'RETURN: [' || l_result || ']';
    usim_debug.debug_log(l_debug_id, usim_static.usim_status_success, l_debug_object, l_debug_content);
    RETURN l_result;
  END get_max_position
  ;

  FUNCTION get_max_position_1st(p_sign IN NUMBER DEFAULT 1)
    RETURN NUMBER
  IS
    l_return        NUMBER;
    l_cur_max       NUMBER;
    l_debug_id      usim_debug_log.usim_id_dlg%TYPE;
    l_debug_object  usim_debug_log.usim_log_object%TYPE := 'USIM_UTILITY.GET_MAX_POSITION_1ST';
    l_debug_content usim_debug_log.usim_log_content%TYPE;
  BEGIN
    l_debug_id      := usim_debug.start_debug;
    l_debug_content := 'PARAMETER: p_sign[' || p_sign || ']';
    usim_debug.debug_log(l_debug_id, usim_static.usim_status_success, l_debug_object, l_debug_content);
    l_cur_max := get_max_position(p_sign);
    IF l_cur_max IS NULL
    THEN
      -- initial value, only used, if no entries exist
      l_return := 0;
    ELSE
      IF p_sign >= 0
      THEN
        -- simulate overflow switch of number level
        IF usim_static.is_overflow_reached(l_cur_max)
        THEN
          l_return := 1;
        ELSE
          l_return := l_cur_max + 1;
        END IF;
      ELSE
        -- simulate overflow switch of number level
        IF usim_static.is_overflow_reached(l_cur_max)
        THEN
          l_return := -1;
        ELSE
          l_return := l_cur_max - 1;
        END IF;
      END IF;
    END IF;
    l_debug_content := 'RETURN: [' || l_return || '] l_cur_max[' || l_cur_max || ']';
    usim_debug.debug_log(l_debug_id, usim_static.usim_status_success, l_debug_object, l_debug_content);
    RETURN l_return;
  END get_max_position_1st
  ;

  FUNCTION get_max_position_2nd(p_sign IN NUMBER DEFAULT 1)
    RETURN NUMBER
  IS
    l_return        NUMBER;
    l_debug_id      usim_debug_log.usim_id_dlg%TYPE;
    l_debug_object  usim_debug_log.usim_log_object%TYPE := 'USIM_UTILITY.GET_MAX_POSITION_2ND';
    l_debug_content usim_debug_log.usim_log_content%TYPE;
  BEGIN
    l_debug_id      := usim_debug.start_debug;
    l_debug_content := 'PARAMETER: p_sign[' || p_sign || ']';
    usim_debug.debug_log(l_debug_id, usim_static.usim_status_success, l_debug_object, l_debug_content);
    IF p_sign >= 0
    THEN
      IF usim_static.is_overflow_reached(get_max_position_1st(p_sign))
      THEN
        l_return := 1;
      ELSE
        l_return := get_max_position_1st + 1;
      END IF;
    ELSE
      IF usim_static.is_overflow_reached(get_max_position_1st(p_sign))
      THEN
        l_return := -1;
      ELSE
        l_return := get_max_position_1st(-1) - 1;
      END IF;
    END IF;
    l_debug_content := 'RETURN: [' || l_return || ']';
    usim_debug.debug_log(l_debug_id, usim_static.usim_status_success, l_debug_object, l_debug_content);
    RETURN l_return;
  END get_max_position_2nd
  ;

  FUNCTION amplitude( p_usim_energy_source      IN usim_point.usim_energy%TYPE
                    , p_usim_angular_frequency  IN NUMBER
                    )
    RETURN NUMBER
  IS
  BEGIN
    RETURN NULL;
  END amplitude
  ;

  FUNCTION wavelength( p_usim_angular_frequency   IN NUMBER
                     , p_usim_velocity            IN NUMBER DEFAULT 1
                     )
    RETURN NUMBER
  IS
  BEGIN
    RETURN p_usim_velocity / p_usim_angular_frequency;
  END wavelength
  ;
END usim_utility;
/