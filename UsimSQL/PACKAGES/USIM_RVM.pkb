CREATE OR REPLACE PACKAGE BODY usim_rvm
IS
  -- see header for documentation
  FUNCTION has_data
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_rel_vol_mlv;
    RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
  END has_data
  ;

  FUNCTION has_data(p_usim_id_vol IN usim_volume.usim_id_vol%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_rel_vol_mlv WHERE usim_id_vol = p_usim_id_vol;
    RETURN l_result;
  END has_data
  ;

  FUNCTION has_data_mlv(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_rel_vol_mlv WHERE usim_id_mlv = p_usim_id_mlv;
    RETURN l_result;
  END has_data_mlv
  ;

  FUNCTION insert_relation( p_usim_id_vol IN usim_volume.usim_id_vol%TYPE
                          , p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE
                          , p_do_commit   IN BOOLEAN                          DEFAULT TRUE
                          )
    RETURN usim_volume.usim_id_vol%TYPE
  IS
    l_usim_id_mlv usim_multiverse.usim_id_mlv%TYPE;
    l_usim_id_vol usim_volume.usim_id_vol%TYPE;
  BEGIN
    IF      usim_vol.has_data(p_usim_id_vol) = 1
       AND  usim_mlv.has_data(p_usim_id_mlv) = 1
    THEN
      -- get universe from volume
      l_usim_id_mlv := usim_vol.get_id_mlv(p_usim_id_vol);
              -- check overflow state
      IF      usim_base.has_basedata                   = 1
         AND  usim_rmd.overflow_reached(l_usim_id_mlv) = 1
         AND  usim_vol.overflow_reached(l_usim_id_mlv) = 1
              -- check base state of new universe and existance of ids
         AND  usim_mlv.is_base(p_usim_id_mlv)          = 0
         AND  usim_rvm.has_data(p_usim_id_vol)         = 0
         AND  usim_rvm.has_data_mlv(p_usim_id_mlv)     = 0
      THEN
        INSERT INTO usim_rel_vol_mlv (usim_id_vol, usim_id_mlv) VALUES (p_usim_id_vol, p_usim_id_mlv) RETURNING usim_id_vol INTO l_usim_id_vol;
        IF p_do_commit
        THEN
          COMMIT;
        END IF;
        RETURN l_usim_id_vol;
      ELSE
        RETURN NULL;
      END IF;
    ELSE
      RETURN NULL;
    END IF;
  END insert_relation
  ;

END usim_rvm;