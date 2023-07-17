CREATE OR REPLACE PACKAGE BODY usim_vol
IS
  -- see header for documentation
  FUNCTION has_data
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_volume;
    RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
  END has_data
  ;

  FUNCTION has_data(p_usim_id_vol IN usim_volume.usim_id_vol%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_volume WHERE usim_id_vol = p_usim_id_vol;
    RETURN l_result;
  END has_data
  ;

  FUNCTION has_data( p_usim_id_mlv              IN usim_multiverse.usim_id_mlv%TYPE
                   , p_usim_id_pos_base_from    IN usim_position.usim_id_pos%TYPE
                   , p_usim_id_pos_base_to      IN usim_position.usim_id_pos%TYPE
                   , p_usim_id_pos_mirror_from  IN usim_position.usim_id_pos%TYPE
                   , p_usim_id_pos_mirror_to    IN usim_position.usim_id_pos%TYPE
                   )
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result
      FROM usim_volume
     WHERE usim_id_mlv              = p_usim_id_mlv
       AND usim_id_pos_base_from    = p_usim_id_pos_base_from
       AND usim_id_pos_base_to      = p_usim_id_pos_base_to
       AND usim_id_pos_mirror_from  = p_usim_id_pos_mirror_from
       AND usim_id_pos_mirror_to    = p_usim_id_pos_mirror_to
    ;
    RETURN l_result;
  END has_data
  ;

  FUNCTION overflow_reached(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN NUMBER
  IS
    l_base_max    NUMBER;
  BEGIN
    IF      usim_base.has_basedata  = 1
       AND  usim_vol.has_data       = 1
    THEN
      SELECT CASE
               WHEN MAX(usim_base_sign) > 0
               THEN MAX(usim_coordinate_base_to)
               ELSE MIN(usim_coordinate_base_to)
             END
             INTO l_base_max
        FROM usim_vol_v
       WHERE usim_id_mlv = p_usim_id_mlv
      ;
      IF ABS(l_base_max) >= usim_base.get_abs_max_number
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

  FUNCTION get_id_vol( p_usim_id_mlv              IN usim_multiverse.usim_id_mlv%TYPE
                     , p_usim_id_pos_base_from    IN usim_position.usim_id_pos%TYPE
                     , p_usim_id_pos_base_to      IN usim_position.usim_id_pos%TYPE
                     , p_usim_id_pos_mirror_from  IN usim_position.usim_id_pos%TYPE
                     , p_usim_id_pos_mirror_to    IN usim_position.usim_id_pos%TYPE
                     )
    RETURN usim_volume.usim_id_vol%TYPE
  IS
    l_result usim_volume.usim_id_vol%TYPE;
  BEGIN
    IF usim_vol.has_data(p_usim_id_mlv, p_usim_id_pos_base_from, p_usim_id_pos_base_to, p_usim_id_pos_mirror_from, p_usim_id_pos_mirror_to) = 1
    THEN
      SELECT usim_id_vol INTO l_result
        FROM usim_volume
       WHERE usim_id_mlv              = p_usim_id_mlv
         AND usim_id_pos_base_from    = p_usim_id_pos_base_from
         AND usim_id_pos_base_to      = p_usim_id_pos_base_to
         AND usim_id_pos_mirror_from  = p_usim_id_pos_mirror_from
         AND usim_id_pos_mirror_to    = p_usim_id_pos_mirror_to
      ;
      RETURN l_result;
    ELSE
      RETURN NULL;
    END IF;
  END get_id_vol
  ;

  FUNCTION get_id_mlv(p_usim_id_vol IN usim_volume.usim_id_vol%TYPE)
    RETURN usim_multiverse.usim_id_mlv%TYPE
  IS
    l_result usim_multiverse.usim_id_mlv%TYPE;
  BEGIN
    IF usim_vol.has_data(p_usim_id_vol) = 1
    THEN
      SELECT usim_id_mlv INTO l_result FROM usim_volume WHERE usim_id_vol = p_usim_id_vol;
      RETURN l_result;
    ELSE
      RETURN NULL;
    END IF;
  END get_id_mlv
  ;

  FUNCTION get_next_base_from(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
  IS
    l_result usim_position.usim_coordinate%TYPE;
  BEGIN
    IF      usim_mlv.has_data(p_usim_id_mlv)          = 1
       AND  usim_vol.overflow_reached(p_usim_id_mlv)  = 0
    THEN
      SELECT CASE
               WHEN MAX(usim_base_sign) > 0
               THEN NVL(MAX(usim_coordinate_base_to), 0)
               ELSE NVL(MIN(usim_coordinate_base_to), 0)
             END
             INTO l_result
        FROM usim_vol_v
       WHERE usim_id_mlv = p_usim_id_mlv
      ;
      RETURN l_result;
    ELSE
      RETURN NULL;
    END IF;
  END get_next_base_from
  ;

  FUNCTION get_next_mirror_from(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
  IS
    l_result usim_position.usim_coordinate%TYPE;
  BEGIN
    IF      usim_mlv.has_data(p_usim_id_mlv)          = 1
       AND  usim_vol.overflow_reached(p_usim_id_mlv)  = 0
    THEN
      SELECT CASE
               WHEN MAX(usim_mirror_sign) > 0
               THEN NVL(MAX(usim_coordinate_mirror_to), 0)
               ELSE NVL(MIN(usim_coordinate_mirror_to), 0)
             END
             INTO l_result
        FROM usim_vol_v
       WHERE usim_id_mlv = p_usim_id_mlv
      ;
      RETURN l_result;
    ELSE
      RETURN NULL;
    END IF;
  END get_next_mirror_from
  ;

  FUNCTION insert_vol( p_usim_id_mlv              IN usim_multiverse.usim_id_mlv%TYPE
                     , p_usim_id_pos_base_from    IN usim_position.usim_id_pos%TYPE
                     , p_usim_id_pos_base_to      IN usim_position.usim_id_pos%TYPE
                     , p_usim_id_pos_mirror_from  IN usim_position.usim_id_pos%TYPE
                     , p_usim_id_pos_mirror_to    IN usim_position.usim_id_pos%TYPE
                     , p_do_commit                IN BOOLEAN                            DEFAULT TRUE
                     )
    RETURN usim_volume.usim_id_vol%TYPE
  IS
    l_usim_id_vol usim_volume.usim_id_vol%TYPE;
  BEGIN
    IF usim_vol.has_data(p_usim_id_mlv, p_usim_id_pos_base_from, p_usim_id_pos_base_to, p_usim_id_pos_mirror_from, p_usim_id_pos_mirror_to) = 1
    THEN
      RETURN usim_vol.get_id_vol(p_usim_id_mlv, p_usim_id_pos_base_from, p_usim_id_pos_base_to, p_usim_id_pos_mirror_from, p_usim_id_pos_mirror_to);
    ELSE
      -- constraint and exist check
      IF      usim_mlv.has_data(p_usim_id_mlv)              = 1
         AND  usim_pos.has_data(p_usim_id_pos_base_from)    = 1
         AND  usim_pos.has_data(p_usim_id_pos_base_to)      = 1
         AND  usim_pos.has_data(p_usim_id_pos_mirror_from)  = 1
         AND  usim_pos.has_data(p_usim_id_pos_mirror_to)    = 1
         AND  usim_vol.overflow_reached(p_usim_id_mlv)      = 0
         AND  (ABS(usim_pos.get_coordinate(p_usim_id_pos_base_to)) - ABS(usim_pos.get_coordinate(p_usim_id_pos_base_from))) = 1
         AND  (ABS(usim_pos.get_coordinate(p_usim_id_pos_mirror_to)) - ABS(usim_pos.get_coordinate(p_usim_id_pos_mirror_from))) = 1
         AND  usim_pos.get_sign(p_usim_id_pos_base_from) = usim_pos.get_sign(p_usim_id_pos_base_to)
         AND  usim_pos.get_sign(p_usim_id_pos_mirror_from) = usim_pos.get_sign(p_usim_id_pos_mirror_to)
         AND  usim_mlv.get_base_sign(p_usim_id_mlv) = usim_pos.get_sign(p_usim_id_pos_base_from)
      THEN
        INSERT INTO usim_volume
          ( usim_id_mlv
          , usim_id_pos_base_from
          , usim_id_pos_base_to
          , usim_id_pos_mirror_from
          , usim_id_pos_mirror_to
          )
          VALUES
          ( p_usim_id_mlv
          , p_usim_id_pos_base_from
          , p_usim_id_pos_base_to
          , p_usim_id_pos_mirror_from
          , p_usim_id_pos_mirror_to
          )
          RETURNING usim_id_vol INTO l_usim_id_vol
        ;
        IF p_do_commit
        THEN
          COMMIT;
        END IF;
        RETURN l_usim_id_vol;
      ELSE
        RETURN NULL;
      END IF;
    END IF;
  END
  ;

END usim_vol;
/