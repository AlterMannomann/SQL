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

END usim_vol;