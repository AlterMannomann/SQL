CREATE OR REPLACE PACKAGE BODY usim_rrpn
IS
  -- see header for documentation
  FUNCTION has_data
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_rel_rmd_pos_nod;
    RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
  END has_data
  ;

  FUNCTION has_data(p_usim_id_rrpn IN usim_rel_rmd_pos_nod.usim_id_rrpn%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_rel_rmd_pos_nod WHERE usim_id_rrpn = p_usim_id_rrpn;
    RETURN l_result;
  END has_data
  ;

  FUNCTION has_data( p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE
                   , p_usim_id_pos IN usim_position.usim_id_pos%TYPE
                   , p_usim_id_nod IN usim_node.usim_id_nod%TYPE
                   )
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_rel_rmd_pos_nod WHERE usim_id_rmd = p_usim_id_rmd AND usim_id_pos = p_usim_id_pos AND usim_id_nod = p_usim_id_nod;
    RETURN l_result;
  END has_data
  ;

  FUNCTION get_id_rrpn( p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE
                      , p_usim_id_pos IN usim_position.usim_id_pos%TYPE
                      , p_usim_id_nod IN usim_node.usim_id_nod%TYPE
                      )
    RETURN usim_rel_rmd_pos_nod.usim_id_rrpn%TYPE
  IS
    l_result usim_rel_rmd_pos_nod.usim_id_rrpn%TYPE;
  BEGIN
    IF usim_rrpn.has_data(p_usim_id_rmd, p_usim_id_pos, p_usim_id_nod) = 1
    THEN
      SELECT usim_id_rrpn INTO l_result FROM usim_rel_rmd_pos_nod WHERE usim_id_rmd = p_usim_id_rmd AND usim_id_pos = p_usim_id_pos ANd usim_id_nod = p_usim_id_nod;
      RETURN l_result;
    ELSE
      RETURN NULL;
    END IF;
  END get_id_rrpn
  ;

  FUNCTION insert_rrpn( p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE
                      , p_usim_id_pos IN usim_position.usim_id_pos%TYPE
                      , p_usim_id_nod IN usim_node.usim_id_nod%TYPE
                      , p_do_commit   IN BOOLEAN                            DEFAULT TRUE
                      )
    RETURN usim_rel_rmd_pos_nod.usim_id_rrpn%TYPE
  IS
    l_result usim_rel_rmd_pos_nod.usim_id_rrpn%TYPE;
  BEGIN
    IF      usim_rmd.has_data(p_usim_id_rmd) = 1
       AND  usim_pos.has_data(p_usim_id_pos) = 1
       AND  usim_nod.has_data(p_usim_id_nod) = 1
    THEN
      IF usim_rrpn.has_data(p_usim_id_rmd, p_usim_id_pos, p_usim_id_nod) = 1
      THEN
        RETURN usim_rrpn.get_id_rrpn(p_usim_id_rmd, p_usim_id_pos, p_usim_id_nod);
      ELSE
        INSERT INTO usim_rel_rmd_pos_nod
          ( usim_id_rmd
          , usim_id_pos
          , usim_id_nod
          )
          VALUES
          ( p_usim_id_rmd
          , p_usim_id_pos
          , p_usim_id_nod
          )
          RETURNING usim_id_rrpn INTO l_result
        ;
        IF p_do_commit
        THEN
          COMMIT;
        END IF;
        RETURN l_result;
      END IF;
    ELSE
      RETURN NULL;
    END IF;
  END insert_rrpn
  ;

END usim_rrpn;
/