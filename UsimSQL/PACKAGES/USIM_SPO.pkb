CREATE OR REPLACE PACKAGE BODY usim_spo
IS
  -- see header for documentation
  FUNCTION has_data
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_spc_pos;
    RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
  END has_data
  ;

  FUNCTION has_data(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_spc_pos WHERE usim_id_spc = p_usim_id_spc;
    RETURN (CASE WHEN l_result = 0 THEN l_result ELSE 1 END);
  END has_data
  ;

  FUNCTION has_data( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                   , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                   )
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*) INTO l_result FROM usim_spo_v WHERE usim_id_spc = p_usim_id_spc and usim_n_dimension = p_usim_n_dimension;
    RETURN l_result;
  END has_data
  ;

  FUNCTION is_dim_axis(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    IF usim_spo.has_data(p_usim_id_spc) = 1
    THEN
      IF usim_pos.get_coordinate(usim_spc.get_id_pos(p_usim_id_spc)) = 0
      THEN
        RETURN 1;
      ELSE
        SELECT COUNT(*)
          INTO l_result
          FROM usim_spo_v
         WHERE usim_id_spc = p_usim_id_spc
           AND usim_coordinate != 0
        ;
        RETURN (CASE WHEN l_result = 1 THEN l_result ELSE 0 END);
      END IF;
    ELSE
      usim_erl.log_error('usim_spo.is_dim_axis', 'Used with space id [' || p_usim_id_spc || '] not in USIM_SPC_POS.');
      RETURN 0;
    END IF;
  END is_dim_axis
  ;

  FUNCTION get_xyz(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN VARCHAR2
  IS
    l_result VARCHAR2(32000);
  BEGIN
    IF usim_spo.has_data(p_usim_id_spc) = 1
    THEN
        WITH xyz AS
             (SELECT LEVEL AS usim_n_dimension
                FROM dual
              CONNECT BY LEVEL <= 3
             )
           , coords AS
             (SELECT usim_n_dimension
                   , usim_coordinate
                FROM usim_spo_v
               WHERE usim_id_spc = p_usim_id_spc
             )
      SELECT LISTAGG(NVL(coords.usim_coordinate, 0), ',')
        INTO l_result
        FROM xyz
        LEFT OUTER JOIN coords
          ON xyz.usim_n_dimension = coords.usim_n_dimension
       ORDER BY xyz.usim_n_dimension
      ;
      RETURN TRIM(l_result);
    ELSE
      usim_erl.log_error('usim_spo.get_xyz', 'Used with space id [' || p_usim_id_spc || '] not in USIM_SPC_POS.');
      RETURN NULL;
    END IF;
  END get_xyz
  ;

  FUNCTION get_dim_coord( p_usim_id_spc      IN usim_space.usim_id_spc%TYPE
                        , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                        )
    RETURN usim_position.usim_coordinate%TYPE
  IS
    l_result usim_position.usim_coordinate%TYPE;
  BEGIN
    IF usim_spo.has_data(p_usim_id_spc) = 1
    THEN
        WITH dim AS
             (SELECT p_usim_n_dimension AS usim_n_dimension FROM dual)
           , coords AS
             (SELECT usim_n_dimension
                   , usim_coordinate
                FROM usim_spo_v
               WHERE usim_id_spc = p_usim_id_spc
             )
      SELECT NVL(usim_coordinate, 0)
        INTO l_result
        FROM dim
        LEFT OUTER JOIN coords
          ON dim.usim_n_dimension = coords.usim_n_dimension
      ;
      RETURN l_result;
    ELSE
      usim_erl.log_error('usim_spo.get_xyz', 'Used with space id [' || p_usim_id_spc || '] not in USIM_SPC_POS or not available dimension [' || p_usim_n_dimension || '].');
      RETURN NULL;
    END IF;
  END get_dim_coord
  ;

  FUNCTION insert_spc_pos( p_usim_id_spc        IN usim_space.usim_id_spc%TYPE
                         , p_usim_id_spc_parent IN usim_space.usim_id_spc%TYPE
                         , p_do_commit          IN BOOLEAN                     DEFAULT TRUE
                         )
    RETURN NUMBER
  IS
    CURSOR cur_dims( cp_usim_id_spc        IN usim_space.usim_id_spc%TYPE
                   , cp_usim_id_spc_parent IN usim_space.usim_id_spc%TYPE
                   )
    IS
        WITH org_dim AS
             (SELECT /*+MATERIALIZE */
                     usim_n_dimension
                FROM usim_spo_v
               WHERE usim_id_spc = cp_usim_id_spc
             )
      SELECT usim_id_rmd
           , usim_id_pos
        FROM usim_spo_v
       WHERE usim_id_spc           = cp_usim_id_spc_parent
         AND usim_n_dimension NOT IN (SELECT usim_n_dimension FROM org_dim)
         AND (   usim_coordinate  != 0
              OR usim_n_dimension  = 0
             )
    ;
  BEGIN
    IF usim_spo.has_data(p_usim_id_spc) = 0
    THEN
      -- insert the new space id
      INSERT INTO usim_spc_pos
        ( usim_id_spc
        , usim_id_rmd
        , usim_id_pos
        )
        VALUES
        ( p_usim_id_spc
        , usim_spc.get_id_rmd(p_usim_id_spc)
        , usim_spc.get_id_pos(p_usim_id_spc)
        )
      ;
    END IF;
    -- check parent
    IF usim_spo.has_data(p_usim_id_spc_parent) = 1
    THEN
      -- only lower dimension not present and position > 0, missing dimensions means 0 position in this dimension
      FOR rec IN cur_dims(p_usim_id_spc, p_usim_id_spc_parent)
      LOOP
        INSERT INTO usim_spc_pos
          ( usim_id_spc
          , usim_id_rmd
          , usim_id_pos
          )
          VALUES
          ( p_usim_id_spc
          , rec.usim_id_rmd
          , rec.usim_id_pos
          )
        ;
      END LOOP;
    ELSE
      -- if parent is NULL and dimension is 0, everything okay, only one entry otherwise error
      IF    p_usim_id_spc_parent                  IS NOT NULL
         OR usim_spc.get_dimension(p_usim_id_spc) != 0
      THEN
        ROLLBACK;
        usim_erl.log_error('usim_spo.insert_spc_pos', 'Used with invalid parent space id [' || p_usim_id_spc_parent || '] or wrong dimension > 0.');
        RETURN 0;
      END IF;
    END IF;
    -- everything done, do commit if needed
    IF p_do_commit
    THEN
      COMMIT;
    END IF;
    RETURN 1;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      usim_erl.log_error('usim_spo.insert_spc_pos', 'Error executing function: ' || SQLERRM);
      RETURN 0;
  END insert_spc_pos
  ;

END usim_spo;
/