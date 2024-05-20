-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
CREATE OR REPLACE PACKAGE BODY &USIM_SCHEMA..usim_spo
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

  FUNCTION has_axis_max_pos_parent(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result            NUMBER;
  BEGIN
    -- fetch count
      WITH known AS
           (SELECT usim_id_spc
                 , usim_spo.is_axis_pos(usim_id_spc) AS is_axis
                 , usim_coordinate
                 , usim_id_rmd
                 , dim_sign
              FROM usim_spc_v
             WHERE usim_id_rmd = (SELECT usim_id_rmd FROM usim_space WHERE usim_id_spc = p_usim_id_spc)
           )
         , maxpos AS
           (SELECT CASE
                     WHEN dim_sign >= 0
                     THEN MAX(usim_coordinate)
                     ELSE MIN(usim_coordinate)
                   END                         AS parent_pos
                 , usim_id_rmd
                 , dim_sign
              FROM known
             WHERE is_axis = 1
             GROUP BY usim_id_rmd
                    , dim_sign
           )
    SELECT COUNT(*)
      INTO l_result
      FROM known
     INNER JOIN maxpos
        ON known.usim_coordinate  = maxpos.parent_pos
       AND known.usim_id_rmd      = maxpos.usim_id_rmd
       AND known.dim_sign         = maxpos.dim_sign
     WHERE known.is_axis = 1
    ;
    -- do not mimic count to 0 and 1 as any value > 1 is a dimension symmetry error
    RETURN l_result;
  END has_axis_max_pos_parent
  ;


  FUNCTION get_xyz(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN VARCHAR2
  IS
    l_result VARCHAR2(32000);
  BEGIN
    IF usim_spo.has_data(p_usim_id_spc) = 1
    THEN
      l_result := '' || usim_spo.get_dim_coord(p_usim_id_spc, 1) || ',' || usim_spo.get_dim_coord(p_usim_id_spc, 2) || ',' || usim_spo.get_dim_coord(p_usim_id_spc, 3);
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
      usim_erl.log_error('usim_spo.get_dim_coord', 'Used with space id [' || p_usim_id_spc || '] not in USIM_SPC_POS or not available dimension [' || p_usim_n_dimension || '].');
      RETURN NULL;
    END IF;
  END get_dim_coord
  ;

  FUNCTION get_magnitude( p_usim_id_spc      IN usim_space.usim_id_spc%TYPE
                        , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                        )
    RETURN NUMBER
  IS
    l_sum    NUMBER;
    l_result NUMBER;
  BEGIN
    IF usim_spc.has_data(p_usim_id_spc) = 0
    THEN
      usim_erl.log_error('usim_spo.get_magnitude', 'Used with not existing space id [' || p_usim_id_spc || ']');
    END IF;
    l_result := 0;
    l_sum    := 0;
    FOR l_idx IN 1..p_usim_n_dimension
    LOOP
      l_sum := l_sum + POWER(usim_spo.get_dim_coord(p_usim_id_spc, l_idx), 2);
    END LOOP;
    l_result := SQRT(l_sum);
    RETURN l_result;
  END get_magnitude
  ;

  FUNCTION get_coord_id(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN VARCHAR2
  IS
    l_coord_id VARCHAR2(32767);
    l_max_dim  NUMBER;
  BEGIN
    IF usim_spo.has_data(p_usim_id_spc) = 1
    THEN
      l_max_dim  := usim_base.get_max_dimension;
      l_coord_id := '';
      FOR l_dim IN 0..l_max_dim
      LOOP
        -- check size before
        IF LENGTH(l_coord_id) + LENGTH(',' || usim_spo.get_dim_coord(p_usim_id_spc, l_dim)) > 32767
        THEN
          usim_erl.log_error('usim_spo.get_coord_id', 'Too much dimensions to build coordinate id within system limits for space id [' || p_usim_id_spc || '].');
          RETURN NULL;
        END IF;
        IF l_dim = 0
        THEN
          l_coord_id := l_coord_id || usim_spo.get_dim_coord(p_usim_id_spc, l_dim);
        ELSE
          l_coord_id := l_coord_id || ',' || usim_spo.get_dim_coord(p_usim_id_spc, l_dim);
        END IF;
      END LOOP;
      RETURN l_coord_id;
    ELSE
      usim_erl.log_error('usim_spo.get_coord_id', 'Used with invalid space id [' || p_usim_id_spc || '].');
      RETURN NULL;
    END IF;
  END get_coord_id
  ;

  FUNCTION is_axis_zero_pos(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    SELECT COUNT(*)
      INTO l_result
      FROM usim_spo_v
     WHERE usim_id_spc      = p_usim_id_spc
       AND usim_coordinate != 0
    ;

    RETURN (CASE WHEN l_result > 0 THEN 0 ELSE 1 END);
  END is_axis_zero_pos
  ;

  FUNCTION is_axis_pos(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    -- zero axis is axis
    IF usim_spo.is_axis_zero_pos(p_usim_id_spc) = 1
    THEN
      RETURN 1;
    END IF;
    -- get axis if not zero axis
    SELECT COUNT(*)
      INTO l_result
      FROM usim_spo_v
     WHERE usim_coordinate != 0
       AND usim_id_spc      = p_usim_id_spc
     GROUP BY usim_id_spc
    ;
    IF l_result = 1
    THEN
      RETURN 1;
    ELSE
      RETURN 0;
    END IF;
  END is_axis_pos
  ;

  FUNCTION get_axis_max_pos_parent(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_space.usim_id_spc%TYPE
  IS
    l_result            usim_space.usim_id_spc%TYPE;
  BEGIN
    IF usim_spo.has_axis_max_pos_parent(p_usim_id_spc) = 1
    THEN
      -- fetch data
        WITH known AS
             (SELECT usim_id_spc
                   , usim_spo.is_axis_pos(usim_id_spc) AS is_axis
                   , usim_coordinate
                   , usim_id_rmd
                   , dim_sign
                FROM usim_spc_v
               WHERE usim_id_rmd = (SELECT usim_id_rmd FROM usim_space WHERE usim_id_spc = p_usim_id_spc)
             )
           , maxpos AS
             (SELECT CASE
                       WHEN dim_sign >= 0
                       THEN MAX(usim_coordinate)
                       ELSE MIN(usim_coordinate)
                     END                         AS parent_pos
                   , usim_id_rmd
                   , dim_sign
                FROM known
               WHERE is_axis = 1
               GROUP BY usim_id_rmd
                      , dim_sign
             )
      SELECT known.usim_id_spc
        INTO l_result
        FROM known
       INNER JOIN maxpos
          ON known.usim_coordinate  = maxpos.parent_pos
         AND known.usim_id_rmd      = maxpos.usim_id_rmd
         AND known.dim_sign         = maxpos.dim_sign
       WHERE known.is_axis = 1
      ;
      RETURN l_result;
    ELSE
      RETURN NULL;
    END IF;
  END get_axis_max_pos_parent
  ;

  FUNCTION get_axis_zero_pos_parent(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_space.usim_id_spc%TYPE
  IS
    l_result            usim_space.usim_id_spc%TYPE;
  BEGIN
    -- fetch data
      WITH known AS
           (SELECT usim_id_spc
                 , usim_spo.is_axis_pos(usim_id_spc) AS is_axis
                 , usim_coordinate
                 , usim_id_rmd
                 , dim_sign
              FROM usim_spc_v
             WHERE usim_id_rmd     = (SELECT usim_id_rmd FROM usim_space WHERE usim_id_spc = p_usim_id_spc)
               AND usim_coordinate = 0
           )
    SELECT known.usim_id_spc
      INTO l_result
      FROM known
     WHERE known.is_axis = 1
    ;
    RETURN l_result;
  END get_axis_zero_pos_parent
  ;

  FUNCTION insert_spc_pos( p_usim_id_spc        IN usim_space.usim_id_spc%TYPE
                         , p_usim_id_spc_parent IN usim_space.usim_id_spc%TYPE
                         , p_do_commit          IN BOOLEAN                     DEFAULT TRUE
                         )
    RETURN NUMBER
  IS
    l_dim     usim_dimension.usim_n_dimension%TYPE;
    l_id_mlv  usim_multiverse.usim_id_mlv%TYPE;

    CURSOR cur_dims( cp_usim_id_spc        IN usim_space.usim_id_spc%TYPE
                   , cp_usim_id_spc_parent IN usim_space.usim_id_spc%TYPE
                   , cp_usim_id_mlv        IN usim_multiverse.usim_id_mlv%TYPE
                   )
    IS
        WITH org_dim AS
             (SELECT /*+MATERIALIZE */
                     usim_n_dimension
                FROM usim_spo_v
               WHERE usim_id_spc = cp_usim_id_spc
                     -- consider only the universe of the given new space id
                 AND usim_id_mlv = cp_usim_id_mlv
             )
      SELECT usim_id_rmd
           , usim_id_pos
        FROM usim_spo_v
             -- parent might be in a different universe, so no positions are added from other universes
       WHERE usim_id_spc           = cp_usim_id_spc_parent
         AND usim_id_mlv           = cp_usim_id_mlv
         AND usim_n_dimension NOT IN (SELECT usim_n_dimension FROM org_dim)
-- not sure if to exclude 0 coordinates and dimensions
--         AND (   usim_coordinate  != 0
--              OR usim_n_dimension  = 0
--             )
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
        SELECT usim_id_spc
             , usim_id_rmd
             , usim_id_pos
          FROM usim_space
         WHERE usim_id_spc = p_usim_id_spc
      ;
    END IF;
    -- check parent
    IF usim_spo.has_data(p_usim_id_spc_parent) = 1
    THEN
      l_id_mlv := usim_spc.get_id_mlv(p_usim_id_spc);
      -- only lower dimension not present and position > 0, missing dimensions means 0 position in this dimension
      FOR rec IN cur_dims(p_usim_id_spc, p_usim_id_spc_parent, l_id_mlv)
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
      IF p_usim_id_spc_parent IS NOT NULL
      THEN
        SELECT usim_n_dimension INTO l_dim FROM usim_spc_v WHERE usim_id_spc = p_usim_id_spc;
        IF l_dim != 0
        THEN
          ROLLBACK;
          usim_erl.log_error('usim_spo.insert_spc_pos', 'Used with invalid parent space id [' || p_usim_id_spc_parent || '] or wrong dimension > 0.');
          RETURN 0;
        END IF;
      END IF;
    END IF;
    -- everything done, do commit if needed
    IF p_do_commit
    THEN
      COMMIT;
    END IF;
    RETURN 1;
  END insert_spc_pos
  ;

END usim_spo;
/