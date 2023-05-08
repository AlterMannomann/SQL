CREATE OR REPLACE PACKAGE BODY usim_trg IS
  -- see header for documentation
  FUNCTION get_usim_id_dim( p_usim_id_dim        IN usim_dimension.usim_id_dim%TYPE
                          , p_usim_dimension     IN usim_dimension.usim_dimension%TYPE
                          )
    RETURN usim_dimension.usim_id_dim%TYPE
  IS
    l_cnt_result      INTEGER;
    l_usim_id_dim     usim_dimension.usim_id_dim%TYPE;
  BEGIN
    IF p_usim_id_dim IS NOT NULL
    THEN
      SELECT COUNT(*) INTO l_cnt_result FROM usim_dimension WHERE usim_id_dim = p_usim_id_dim;
      IF l_cnt_result = 0
      THEN
        RAISE_APPLICATION_ERROR( num => -20100
                               , msg => 'Given dimension ID (' || p_usim_id_dim || ') does not exist.'
                               )
        ;
      END IF;
      l_usim_id_dim := p_usim_id_dim;
    ELSE
      SELECT COUNT(*) INTO l_cnt_result FROM usim_dimension WHERE usim_dimension = p_usim_dimension;
      IF l_cnt_result = 0
      THEN
        RAISE_APPLICATION_ERROR( num => -20101
                               , msg => 'Given dimension (' || p_usim_dimension || ') does not exist.'
                               )
        ;
      END IF;
      SELECT usim_id_dim INTO l_usim_id_dim FROM usim_dimension WHERE usim_dimension = p_usim_dimension;
    END IF;
    RETURN l_usim_id_dim;
  END get_usim_id_dim
  ;

  FUNCTION get_usim_id_parent(p_usim_id_parent IN usim_poi_dim_position.usim_id_pdp%TYPE)
    RETURN usim_poi_dim_position.usim_id_pdp%TYPE
  IS
    l_cnt_result      INTEGER;
    l_usim_id_parent  usim_poi_dim_position.usim_id_pdp%TYPE;
  BEGIN
    IF p_usim_id_parent IS NOT NULL
    THEN
      SELECT COUNT(*) INTO l_cnt_result FROM usim_poi_dim_position WHERE usim_id_pdp = p_usim_id_parent;
      IF l_cnt_result = 0
      THEN
        RAISE_APPLICATION_ERROR( num => -20200
                               , msg => 'Given parent point ID (' || CASE WHEN p_usim_id_parent IS NULL THEN 'NULL' ELSE p_usim_id_parent END || ') does not exist.'
                               )
        ;
      END IF;
      l_usim_id_parent := p_usim_id_parent;
    ELSE
      SELECT COUNT(*) INTO l_cnt_result FROM usim_poi_dim_position WHERE usim_id_pdp NOT IN (SELECT usim_id_pdp FROM usim_pdp_parent);
      IF l_cnt_result >= usim_static.usim_max_seeds
      THEN
        RAISE_APPLICATION_ERROR( num => -20201
                               , msg => 'A basic seed point already exists. USIM_ID_PARENT cannot be NULL.'
                               )
        ;
      END IF;
      l_usim_id_parent := NULL;
    END IF;
    RETURN l_usim_id_parent;
  END get_usim_id_parent
  ;

  PROCEDURE chk_parent_dimension( p_usim_id_dim       IN usim_dimension.usim_id_dim%TYPE
                                , p_usim_id_parent    IN usim_poi_dim_position.usim_id_pdp%TYPE
                                )
  IS
    l_child_dimension     usim_dimension.usim_dimension%TYPE;
    l_parent_dimension    usim_dimension.usim_dimension%TYPE;
  BEGIN
    SELECT usim_dimension INTO l_child_dimension FROM usim_dimension WHERE usim_id_dim = p_usim_id_dim;
    IF p_usim_id_parent IS NOT NULL
    THEN
      SELECT usim_dimension INTO l_parent_dimension FROM usim_poi_dim_position_v WHERE usim_id_pdp = p_usim_id_parent;
      IF l_child_dimension != (l_parent_dimension + 1)
      THEN
        RAISE_APPLICATION_ERROR( num => -20102
                               , msg => 'Given child dimension (' || l_child_dimension || ') does not match parent dimension (' || l_parent_dimension || ') + 1.'
                               )
        ;
      END IF;
    ELSE
      IF l_child_dimension != 0
      THEN
        RAISE_APPLICATION_ERROR( num => -20103
                               , msg => 'Given dimension (' || l_child_dimension || ') must be 0 if point has no parent.'
                               )
        ;
      END IF;
    END IF;
  END chk_parent_dimension
  ;

  FUNCTION get_usim_id_pos( p_usim_id_pos             IN usim_position.usim_id_pos%TYPE
                          , p_usim_coordinate         IN usim_position.usim_coordinate%TYPE
                          )
    RETURN usim_position.usim_id_pos%TYPE
  IS
    l_cnt_result      INTEGER;
    l_usim_id_pos     usim_position.usim_id_pos%TYPE;
  BEGIN
    IF p_usim_coordinate IS NOT NULL
    THEN
      SELECT COUNT(*) INTO l_cnt_result FROM usim_position WHERE usim_coordinate = p_usim_coordinate;
      IF l_cnt_result = 0
      THEN
        INSERT INTO usim_position (usim_coordinate) VALUES (p_usim_coordinate);
        SELECT usim_id_pos INTO l_usim_id_pos FROM usim_position WHERE usim_coordinate = p_usim_coordinate;
      ELSE
        SELECT usim_id_pos INTO l_usim_id_pos FROM usim_position WHERE usim_coordinate = p_usim_coordinate;
      END IF;
    ELSE
      SELECT COUNT(*) INTO l_cnt_result FROM usim_position WHERE usim_id_pos = p_usim_id_pos;
      IF l_cnt_result = 0
      THEN
        RAISE_APPLICATION_ERROR( num => -20300
                               , msg => 'Given position ID (' || p_usim_id_pos || ') does not exist.'
                               )
        ;
      END IF;
      l_usim_id_pos := p_usim_id_pos;
    END IF;
    RETURN l_usim_id_pos;
  END get_usim_id_pos
  ;

  FUNCTION get_usim_id_psc( p_usim_id_psc             IN usim_poi_structure.usim_id_psc%TYPE
                          , p_usim_point_name         IN usim_poi_structure.usim_point_name%TYPE
                          )
    RETURN usim_poi_structure.usim_id_psc%TYPE
  IS
    l_cnt_result      INTEGER;
    l_usim_id_psc     usim_poi_structure.usim_id_psc%TYPE;
  BEGIN
    IF    p_usim_id_psc      IS NOT NULL
       OR p_usim_point_name  IS NOT NULL
    THEN
      IF p_usim_id_psc IS NOT NULL
      THEN
        SELECT COUNT(*) INTO l_cnt_result FROM usim_poi_structure WHERE usim_id_psc = p_usim_id_psc;
        IF l_cnt_result = 0
        THEN
          RAISE_APPLICATION_ERROR( num => -20400
                                 , msg => 'Given point structure ID (' || p_usim_id_psc || ') does not exist.'
                                 )
          ;
        END IF;
        SELECT usim_id_psc INTO l_usim_id_psc FROM usim_poi_structure WHERE usim_id_psc = p_usim_id_psc;
      ELSE
        SELECT COUNT(*) INTO l_cnt_result FROM usim_poi_structure WHERE usim_point_name = p_usim_point_name;
        IF l_cnt_result = 0
        THEN
          INSERT INTO usim_poi_structure (usim_point_name) VALUES (p_usim_point_name);
        END IF;
        SELECT usim_id_psc INTO l_usim_id_psc FROM usim_poi_structure WHERE usim_point_name = p_usim_point_name;
      END IF;
    ELSE
      SELECT usim_id_psc INTO l_usim_id_psc FROM usim_poi_structure WHERE usim_point_name = usim_static.usim_seed_name;
    END IF;

    RETURN l_usim_id_psc;
  END get_usim_id_psc
  ;

  PROCEDURE chk_parent_childs( p_usim_id_parent       IN usim_poi_dim_position.usim_id_pdp%TYPE
                             , p_usim_id_psc          IN usim_poi_structure.usim_id_psc%TYPE
                             )
  IS
    l_cnt_result      INTEGER;
  BEGIN
    SELECT COUNT(*) INTO l_cnt_result
      FROM usim_pdp_childs pdc
      LEFT OUTER JOIN usim_poi_dim_position pdp
        ON pdc.usim_id_child  = pdp.usim_id_pdp
     WHERE pdc.usim_id_pdp    = p_usim_id_parent
       AND pdp.usim_id_psc    = p_usim_id_psc
    ;
    IF l_cnt_result >= usim_static.usim_max_childs
    THEN
      RAISE_APPLICATION_ERROR( num => -20202
                             , msg => 'Given parent ID (' || p_usim_id_parent || ') has already the maximum of allowed childs.'
                             )
      ;
    END IF;
  END chk_parent_childs
  ;

  FUNCTION get_usim_coords( p_usim_id_pos             IN usim_position.usim_id_pos%TYPE
                          , p_usim_id_parent          IN usim_poi_dim_position.usim_id_pdp%TYPE
                          )
    RETURN usim_poi_dim_position.usim_coords%TYPE
  IS
    l_coords        usim_poi_dim_position.usim_coords%TYPE;
    l_coord_base    usim_poi_dim_position.usim_coords%TYPE;
    l_coords_parent usim_poi_dim_position.usim_coords%TYPE;
  BEGIN
    -- build coords
    SELECT TRIM(TO_CHAR(usim_coordinate)) INTO l_coord_base FROM usim_position WHERE usim_id_pos = p_usim_id_pos;
    -- if has parent fetch this value first
    IF p_usim_id_parent IS NOT NULL
    THEN
      SELECT usim_coords INTO l_coords_parent FROM usim_poi_dim_position WHERE usim_id_pdp = p_usim_id_parent;
      l_coords := l_coords_parent || ',' || l_coord_base;
    ELSE
      l_coords := l_coord_base;
    END IF;
    RETURN l_coords;
  END get_usim_coords
  ;

  PROCEDURE insert_point( p_usim_id_dim        IN usim_dimension.usim_id_dim%TYPE
                        , p_usim_dimension     IN usim_dimension.usim_dimension%TYPE
                        , p_usim_id_pos        IN usim_position.usim_id_pos%TYPE
                        , p_usim_coordinate    IN usim_position.usim_coordinate%TYPE
                        , p_usim_id_psc        IN usim_poi_structure.usim_id_psc%TYPE
                        , p_usim_point_name    IN usim_poi_structure.usim_point_name%TYPE
                        , p_usim_id_parent     IN usim_poi_dim_position.usim_id_pdp%TYPE
                        , p_usim_energy        IN usim_point.usim_energy%TYPE
                        , p_usim_amplitude     IN usim_point.usim_amplitude%TYPE
                        , p_usim_wavelength    IN usim_point.usim_wavelength%TYPE
                        )
  IS
    l_usim_id_dim           usim_dimension.usim_id_dim%TYPE;
    l_usim_id_parent        usim_poi_dim_position.usim_id_pdp%TYPE;
    l_usim_id_pos           usim_position.usim_id_pos%TYPE;
    l_usim_id_psc           usim_poi_structure.usim_id_psc%TYPE;
    l_coords                usim_poi_dim_position.usim_coords%TYPE;
    l_usim_id_poi           usim_point.usim_id_poi%TYPE;
    l_usim_id_dpo           usim_dim_point.usim_id_dpo%TYPE;
    l_usim_id_pdp           usim_poi_dim_position.usim_id_pdp%TYPE;
  BEGIN
    l_usim_id_dim     := get_usim_id_dim(p_usim_id_dim, p_usim_dimension);
    l_usim_id_parent  := get_usim_id_parent(p_usim_id_parent);
    l_usim_id_pos     := get_usim_id_pos(p_usim_id_pos, p_usim_coordinate);
    l_usim_id_psc     := get_usim_id_psc(p_usim_id_psc, p_usim_point_name);
    l_coords          := get_usim_coords(l_usim_id_pos, l_usim_id_parent);
    -- additional checks will throw error if not fitting
    chk_parent_dimension(l_usim_id_dim, l_usim_id_parent);
    chk_parent_childs(l_usim_id_parent, l_usim_id_psc);
    -- point insert
    l_usim_id_poi := usim_poi_id_seq.NEXTVAL;
    INSERT INTO usim_point (usim_id_poi, usim_energy, usim_amplitude, usim_wavelength) VALUES (l_usim_id_poi, p_usim_energy, p_usim_amplitude, p_usim_amplitude);
    -- point dimension insert
    l_usim_id_dpo := usim_dpo_id_seq.NEXTVAL;
    INSERT INTO usim_dim_point (usim_id_dpo, usim_id_poi, usim_id_dim) VALUES (l_usim_id_dpo, l_usim_id_poi, l_usim_id_dim);
    -- point, dimension and position insert
    l_usim_id_pdp := usim_pdp_id_seq.NEXTVAL;
    INSERT INTO usim_poi_dim_position (usim_id_pdp, usim_id_dpo, usim_id_pos, usim_coords, usim_id_psc) VALUES (l_usim_id_pdp, l_usim_id_dpo, l_usim_id_pos, l_coords, l_usim_id_psc);

    -- parent and child inserts
    IF l_usim_id_parent IS NOT NULL
    THEN
      INSERT INTO usim_pdp_parent (usim_id_pdp, usim_id_parent) VALUES (l_usim_id_pdp, l_usim_id_parent);
      INSERT INTO usim_pdp_childs (usim_id_pdp, usim_id_child) VALUES (l_usim_id_parent, l_usim_id_pdp);
    END IF;
  END insert_point
  ;

END usim_trg;
/