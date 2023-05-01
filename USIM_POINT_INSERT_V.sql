-- USIM_POINT_INSERT_V (poiv)
CREATE OR REPLACE FORCE NONEDITIONABLE VIEW usim_point_insert_v AS
  SELECT psc.usim_point_name
       , poi.usim_energy
       , poi.usim_amplitude
       , poi.usim_wavelength
       , dim.usim_dimension
       , pos.usim_coordinate
       , pdp.usim_coords
       , pdr.usim_id_parent
       , pdc.usim_id_child
       , poi.usim_id_poi
       , dim.usim_id_dim
       , dpo.usim_id_dpo
       , pos.usim_id_pos
       , pdp.usim_id_pdp
       , pdc.usim_id_pdc
       , pdp.usim_id_psc
    FROM usim_point poi
    LEFT OUTER JOIN usim_dim_point dpo
      ON poi.usim_id_poi = dpo.usim_id_poi
    LEFT OUTER JOIN usim_dimension dim
      ON dpo.usim_id_dim = dim.usim_id_dim
    LEFT OUTER JOIN usim_poi_dim_position pdp
      ON dpo.usim_id_dpo = pdp.usim_id_dpo
    LEFT OUTER JOIN usim_position pos
      ON pdp.usim_id_pos = pos.usim_id_pos
    LEFT OUTER JOIN usim_pdp_parent pdr
      ON pdp.usim_id_pdp = pdr.usim_id_pdp
    LEFT OUTER JOIN usim_pdp_childs pdc
      ON pdp.usim_id_pdp = pdc.usim_id_pdp
    LEFT OUTER JOIN usim_poi_structure psc
      ON pdp.usim_id_psc = psc.usim_id_psc
;
COMMENT ON COLUMN usim_point_insert_v.usim_dimension IS 'Dimension of the point. Dimension or dimension ID is MANDATORY on INSERT.';
COMMENT ON COLUMN usim_point_insert_v.usim_id_dim IS 'The ID of the dimension, related to the point. Dimension or dimension ID is MANDATORY on INSERT. If given, any given dimension is ignored.';
COMMENT ON COLUMN usim_point_insert_v.usim_coordinate IS 'The position coordinate of the point. Position coordinate or position ID is MANDATORY on INSERT.';
COMMENT ON COLUMN usim_point_insert_v.usim_id_pos IS 'The ID of a position. Position or position ID is MANDATORY on INSERT.';
COMMENT ON COLUMN usim_point_insert_v.usim_point_name IS 'The name of the associated point structure. Name or ID is MANDATORY on INSERT.';
COMMENT ON COLUMN usim_point_insert_v.usim_id_psc IS 'The ID of the associated point structure. Name or ID is optional on INSERT. IF NULL the universe seed is used.';
COMMENT ON COLUMN usim_point_insert_v.usim_id_parent IS 'The ID of a parent point (USIM_ID_PDP). Optional for first point, all other points MANDATORY NOT NULL. If given, the parent point with dimension and position must exist. Points can only have one parent.';
COMMENT ON COLUMN usim_point_insert_v.usim_energy IS 'The energy of the point. Optional on INSERT.';
COMMENT ON COLUMN usim_point_insert_v.usim_amplitude IS 'The amplitude of the point. Optional on INSERT.';
COMMENT ON COLUMN usim_point_insert_v.usim_wavelength IS 'The wavelength of the point. Optional on INSERT.';
COMMENT ON COLUMN usim_point_insert_v.usim_coords IS 'The xyz like coordinates of the point including parent coordinates. Never used on inserts. Build on insert.';
COMMENT ON COLUMN usim_point_insert_v.usim_id_pdp IS 'The ID of the point with dimension and position. Never used on inserts.';
COMMENT ON COLUMN usim_point_insert_v.usim_id_child IS 'The ID of a child point (USIM_ID_PDP). Never used on inserts.';
COMMENT ON COLUMN usim_point_insert_v.usim_id_poi IS 'The ID of the point. Never used on inserts.';
COMMENT ON COLUMN usim_point_insert_v.usim_id_dpo IS 'The ID of the point with dimension. Never used on inserts.';
COMMENT ON COLUMN usim_point_insert_v.usim_id_pdc IS 'The ID of the child of the point with dimension and position. Never used on inserts.';

-- INSTEAD OF Trigger filling all relevant tables
CREATE OR REPLACE TRIGGER usim_poiv_insert_trg
  INSTEAD OF INSERT ON usim_point_insert_v
  -- Use dimension, position, (parent), point structure to insert a new point.
  -- Checks if the parent has already the maximum of childs. Childs are relative to
  -- the associated point structure.
  --
  -- Insert Parameter:
  -- DIMENSION        - Either usim_dimension or usim_id_dim has to be given. No on the fly creation of dimensions.
  --                    Dimension must exists. usim_id_dim is preferred over usim_dimension.
  -- POSITION         - Either usim_coordinate or usim_id_pos. If usim_id_pos is given, the id must exist. If
  --                    usim_coordinate is given and does not exist, it is created.
  -- PARENT           - usim_id_pdp or NULL if it is the first record without parent. Must exist for all other points.
  --                    Only one point can exist, that has no parent.
  -- POINT STRUCTRUE  - Either usim_id_psc or usim_point_name. usim_id_psc must exist if given. If usim_point_name
  --                    does not exist, a new point structure is created. If NULL, the universe seed point structure
  --                    is selected (usim_static.usim_seed_name).
  DECLARE
    l_cnt_result      NUMBER;
    l_usim_id_dim     usim_dimension.usim_id_dim%TYPE;
    l_usim_id_pos     usim_position.usim_id_pos%TYPE;
    l_usim_id_poi     usim_point.usim_id_poi%TYPE;
    l_usim_id_dpo     usim_dim_point.usim_id_dpo%TYPE;
    l_usim_id_pdp     usim_poi_dim_position.usim_id_pdp%TYPE;
    l_usim_id_psc     usim_poi_structure.usim_id_psc%TYPE;
    l_insert_new_pos  BOOLEAN := FALSE;
    l_coords          VARCHAR2(4000);
    l_coords_parent   VARCHAR2(4000);
  BEGIN
    -- check inputs dimension
    IF :NEW.usim_id_dim IS NOT NULL
    THEN
      SELECT COUNT(*) INTO l_cnt_result FROM usim_dimension WHERE usim_id_dim = :NEW.usim_id_dim;
      IF l_cnt_result = 0
      THEN
        RAISE_APPLICATION_ERROR( num => -20100
                               , msg => 'Given dimension ID does not exist.'
                               )
        ;
      END IF;
      l_usim_id_dim := :NEW.usim_id_dim;
    ELSE
      SELECT COUNT(*) INTO l_cnt_result FROM usim_dimension WHERE usim_dimension = :NEW.usim_dimension;
      IF l_cnt_result = 0
      THEN
        RAISE_APPLICATION_ERROR( num => -20101
                               , msg => 'Given dimension does not exist.'
                               )
        ;
      END IF;
      SELECT usim_id_dim INTO l_usim_id_dim FROM usim_dimension WHERE usim_dimension = :NEW.usim_dimension;
    END IF;

    -- check inputs position and create if necessary
    IF :NEW.usim_coordinate IS NOT NULL
    THEN
      SELECT COUNT(*) INTO l_cnt_result FROM usim_position WHERE usim_coordinate = :NEW.usim_coordinate;
      IF l_cnt_result = 0
      THEN
        INSERT INTO usim_position (usim_coordinate) VALUES (:NEW.usim_coordinate);
        SELECT usim_id_pos INTO l_usim_id_pos FROM usim_position WHERE usim_coordinate = :NEW.usim_coordinate;
      ELSE
        SELECT usim_id_pos INTO l_usim_id_pos FROM usim_position WHERE usim_coordinate = :NEW.usim_coordinate;
      END IF;
    ELSE
      SELECT COUNT(*) INTO l_cnt_result FROM usim_position WHERE usim_id_pos = :NEW.usim_id_pos;
      IF l_cnt_result = 0
      THEN
        RAISE_APPLICATION_ERROR( num => -20101
                               , msg => 'Given position ID does not exist.'
                               )
        ;
      END IF;
      l_usim_id_pos := :NEW.usim_id_pos;
    END IF;

    -- check point structure and create if necessary
    IF    :NEW.usim_id_psc      IS NOT NULL
       OR :NEW.usim_point_name  IS NOT NULL
    THEN
      IF :NEW.usim_id_psc      IS NOT NULL
      THEN
        SELECT COUNT(*) INTO l_cnt_result FROM usim_poi_structure WHERE usim_id_psc = :NEW.usim_id_psc;
        IF l_cnt_result = 0
        THEN
          RAISE_APPLICATION_ERROR( num => -20300
                                 , msg => 'Given point structure ID does not exist.'
                                 )
          ;
        END IF;
        SELECT usim_id_psc INTO l_usim_id_psc FROM usim_poi_structure WHERE usim_id_psc = :NEW.usim_id_psc;
      ELSE
        SELECT COUNT(*) INTO l_cnt_result FROM usim_poi_structure WHERE usim_point_name = :NEW.usim_point_name;
        IF l_cnt_result = 0
        THEN
          INSERT INTO usim_poi_structure (usim_point_name) VALUES (:NEW.usim_point_name);
        END IF;
        SELECT usim_id_psc INTO l_usim_id_psc FROM usim_poi_structure WHERE usim_point_name = :NEW.usim_point_name;
      END IF;
    ELSE
      SELECT usim_id_psc INTO l_usim_id_psc FROM usim_poi_structure WHERE usim_point_name = usim_static.usim_seed_name;
    END IF;

    -- check inputs parent
    IF :NEW.usim_id_parent IS NOT NULL
    THEN
      SELECT COUNT(*) INTO l_cnt_result FROM usim_poi_dim_position WHERE usim_id_pdp = :NEW.usim_id_parent;
      IF l_cnt_result = 0
      THEN
        RAISE_APPLICATION_ERROR( num => -20200
                               , msg => 'Given parent point ID does not exist.'
                               )
        ;
      END IF;
      -- childs relative to point structure
      SELECT COUNT(*) INTO l_cnt_result
        FROM usim_pdp_childs pdc
        LEFT OUTER JOIN usim_poi_dim_position pdp
          ON pdc.usim_id_child  = pdp.usim_id_pdp
       WHERE pdc.usim_id_pdp    = :NEW.usim_id_parent
         AND pdp.usim_id_psc    = l_usim_id_psc
      ;
      IF l_cnt_result >= usim_static.usim_max_childs
      THEN
        RAISE_APPLICATION_ERROR( num => -20203
                               , msg => 'Given parent ID has already the maximum of allowed childs.'
                               )
        ;
      END IF;
    ELSE
      SELECT COUNT(*) INTO l_cnt_result FROM usim_poi_dim_position WHERE usim_id_pdp NOT IN (SELECT usim_id_pdp FROM usim_pdp_parent);
      IF l_cnt_result >= usim_static.usim_max_seeds
      THEN
        RAISE_APPLICATION_ERROR( num => -20204
                               , msg => 'A basic seed point already exists. USIM_ID_PARENT must be set.'
                               )
        ;
      END IF;
      -- childs relative to point structure
      SELECT COUNT(*) INTO l_cnt_result
        FROM usim_pdp_childs pdc
        LEFT OUTER JOIN usim_poi_dim_position pdp
          ON pdc.usim_id_child  = pdp.usim_id_pdp
       WHERE pdc.usim_id_pdp    = :NEW.usim_id_parent
         AND pdp.usim_id_psc    = l_usim_id_psc
      ;
      IF l_cnt_result >= usim_static.usim_max_childs
      THEN
        RAISE_APPLICATION_ERROR( num => -20203
                               , msg => 'Given parent ID has already the maximum of allowed childs.'
                               )
        ;
      END IF;
    END IF;

    -- build coords
    SELECT TRIM(TO_CHAR(usim_coordinate)) INTO l_coords FROM usim_position WHERE usim_id_pos = l_usim_id_pos;
    -- if has parent fetch this value first
    IF :NEW.usim_id_parent IS NOT NULL
    THEN
      SELECT usim_coords INTO l_coords_parent FROM usim_poi_dim_position WHERE usim_id_pdp = :NEW.usim_id_parent;
      l_coords := l_coords_parent || ',' || l_coords;
    END IF;

    -- point insert
    l_usim_id_poi := usim_poi_id_seq.NEXTVAL;
    INSERT INTO usim_point (usim_id_poi, usim_energy, usim_amplitude, usim_wavelength) VALUES (l_usim_id_poi, :NEW.usim_energy, :NEW.usim_amplitude, :NEW.usim_wavelength);

    -- point dimension insert
    l_usim_id_dpo := usim_dpo_id_seq.NEXTVAL;
    INSERT INTO usim_dim_point (usim_id_dpo, usim_id_poi, usim_id_dim) VALUES (l_usim_id_dpo, l_usim_id_poi, l_usim_id_dim);

    -- point, dimension and position insert
    l_usim_id_pdp := usim_pdp_id_seq.NEXTVAL;
    INSERT INTO usim_poi_dim_position (usim_id_pdp, usim_id_dpo, usim_id_pos, usim_coords, usim_id_psc) VALUES (l_usim_id_pdp, l_usim_id_dpo, l_usim_id_pos, l_coords, l_usim_id_psc);

    -- parent and child inserts
    IF :NEW.usim_id_parent IS NOT NULL
    THEN
      INSERT INTO usim_pdp_parent (usim_id_pdp, usim_id_parent) VALUES (l_usim_id_pdp, :NEW.usim_id_parent);
      INSERT INTO usim_pdp_childs (usim_id_pdp, usim_id_child) VALUES (:NEW.usim_id_parent, l_usim_id_pdp);
    END IF;

  END usim_point_insert_v
;
/