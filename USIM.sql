-- drop section
DROP SEQUENCE usim_dim_id_seq;
DROP SEQUENCE usim_poi_id_seq;
DROP SEQUENCE usim_pos_id_seq;
DROP SEQUENCE usim_ovr_id_seq;
DROP SEQUENCE usim_dpo_id_seq;
DROP SEQUENCE usim_pdp_id_seq;
-- reverse order for tables
DROP TABLE usim_pdp_parent;
DROP TABLE usim_poi_dim_position;
DROP TABLE usim_dim_point;
DROP TABLE usim_overflow;
DROP TABLE usim_position;
DROP TABLE usim_point;
DROP TABLE usim_dimension;
-- views
DROP VIEW usim_poi_dim_position_v;
DROP VIEW usim_dim_stats_v;
DROP VIEW usim_dim_pos_coords_v;
DROP VIEW usim_coords_unique_cnt_v;
DROP VIEW usim_invalid_coords_v;
DROP VIEW usim_tree_status_v;

-- create section, basic table definitions

-- USIM_DIMENSION (dim)
CREATE TABLE usim_dimension
  ( usim_id_dim     NUMBER(38, 0)               NOT NULL ENABLE
  , usim_dimension  NUMBER(2, 0)                NOT NULL ENABLE
  )
;
COMMENT ON TABLE usim_dimension IS 'Keeps the possible dimensions. Will use the alias dim.';
COMMENT ON COLUMN usim_dimension.usim_id_dim IS 'Generic ID to identify a dimension.';
COMMENT ON COLUMN usim_dimension.usim_dimension IS 'The n-sphere dimension 0-99 for space simulation';

-- pk
ALTER TABLE usim_dimension
  ADD CONSTRAINT usim_dim_pk
  PRIMARY KEY (usim_id_dim)
  ENABLE
;

-- uk - dimension must be unique
ALTER TABLE usim_dimension
  ADD CONSTRAINT usim_dim_uk
  UNIQUE (usim_dimension)
  ENABLE
;

-- chk - dimension must be >= 0
ALTER TABLE usim_dimension
  ADD CONSTRAINT usim_dim_dimension_chk
  CHECK (usim_dimension >= 0)
  ENABLE
;

-- seq
CREATE SEQUENCE usim_dim_id_seq
  MINVALUE 1
  INCREMENT BY 1
  START WITH 1
  CACHE 20
  NOORDER
  NOCYCLE
  NOKEEP
  NOSCALE
  GLOBAL
;

-- id trigger
CREATE OR REPLACE TRIGGER usim_dim_id_trg
  BEFORE INSERT ON usim_dimension
    FOR EACH ROW
    BEGIN
      <<COLUMN_SEQUENCES>>
      BEGIN
        IF INSERTING AND :NEW.usim_id_dim IS NULL
        THEN
          SELECT usim_dim_id_seq.NEXTVAL INTO :NEW.usim_id_dim FROM SYS.dual;
        END IF;
      END COLUMN_SEQUENCES;
    END;
/
ALTER TRIGGER usim_dim_id_trg ENABLE;

-- USIM_POINT (poi)
CREATE TABLE usim_point
  ( usim_id_poi     NUMBER(38, 0)               NOT NULL ENABLE
  , usim_energy     NUMBER
  , usim_amplitude  NUMBER
  , usim_wavelength NUMBER
  )
;
COMMENT ON TABLE usim_point IS 'Keeps all points with their energy attributes. Will use the alias poi.';
COMMENT ON COLUMN usim_point.usim_id_poi IS 'Generic ID to identify a point.';
COMMENT ON COLUMN usim_point.usim_energy IS 'The current energy of the point.';
COMMENT ON COLUMN usim_point.usim_amplitude IS 'The current amplitude of the point.';
COMMENT ON COLUMN usim_point.usim_wavelength IS 'The current wavelength of the point.';

-- pk
ALTER TABLE usim_point
  ADD CONSTRAINT usim_poi_pk
  PRIMARY KEY (usim_id_poi)
  ENABLE
;

-- seq
CREATE SEQUENCE usim_poi_id_seq
  MINVALUE 1
  INCREMENT BY 1
  START WITH 1
  CACHE 20
  NOORDER
  NOCYCLE
  NOKEEP
  NOSCALE
  GLOBAL
;

-- id trigger
CREATE OR REPLACE TRIGGER usim_poi_id_trg
  BEFORE INSERT ON usim_point
    FOR EACH ROW
    BEGIN
      <<COLUMN_SEQUENCES>>
      BEGIN
        IF INSERTING AND :NEW.usim_id_poi IS NULL
        THEN
          SELECT usim_poi_id_seq.NEXTVAL INTO :NEW.usim_id_poi FROM SYS.dual;
        END IF;
      END COLUMN_SEQUENCES;
    END;
/
ALTER TRIGGER usim_poi_id_trg ENABLE;

-- USIM_POSITION (pos)
CREATE TABLE usim_position
  ( usim_id_pos     NUMBER(38, 0)               NOT NULL ENABLE
  , usim_position   NUMBER(38, 0)               NOT NULL ENABLE
  )
;
COMMENT ON TABLE usim_position IS 'Keeps unique positions which may be used more than one time. Will use the alias pos.';
COMMENT ON COLUMN usim_position.usim_id_pos IS 'Generic ID to identify a position.';
COMMENT ON COLUMN usim_position.usim_position IS 'The unique space position.';

-- pk
ALTER TABLE usim_position
  ADD CONSTRAINT usim_pos_pk
  PRIMARY KEY (usim_id_pos)
  ENABLE
;
-- uk
ALTER TABLE usim_position
  ADD CONSTRAINT usim_pos_uk
  UNIQUE (usim_position)
  ENABLE
;

-- seq
CREATE SEQUENCE usim_pos_id_seq
  MINVALUE 1
  INCREMENT BY 1
  START WITH 1
  CACHE 20
  NOORDER
  NOCYCLE
  NOKEEP
  NOSCALE
  GLOBAL
;

-- id trigger
CREATE OR REPLACE TRIGGER usim_pos_id_trg
  BEFORE INSERT ON usim_position
    FOR EACH ROW
    BEGIN
      <<COLUMN_SEQUENCES>>
      BEGIN
        IF INSERTING AND :NEW.usim_id_pos IS NULL
        THEN
          SELECT usim_pos_id_seq.NEXTVAL INTO :NEW.usim_id_pos FROM SYS.dual;
        END IF;
      END COLUMN_SEQUENCES;
    END;
/
ALTER TRIGGER usim_pos_id_trg ENABLE;

-- USIM_OVERFLOW (ovr)
CREATE TABLE usim_overflow
  ( usim_id_ovr     NUMBER(38, 0)               NOT NULL ENABLE
  , usim_energy     NUMBER
  , usim_amplitude  NUMBER
  , usim_wavelength NUMBER
  )
;
COMMENT ON TABLE usim_overflow IS 'Keeps overflows of points. Will use the alias ovr.';
COMMENT ON COLUMN usim_overflow.usim_energy IS 'The energy potential which would have caused an overflow, if any.';
COMMENT ON COLUMN usim_overflow.usim_amplitude IS 'The amplitude potential which would have caused an overflow, if any.';
COMMENT ON COLUMN usim_overflow.usim_wavelength IS 'The wavelength potential which would have caused an overflow, if any.';

-- pk
ALTER TABLE usim_overflow
  ADD CONSTRAINT usim_ovr_pk
  PRIMARY KEY (usim_id_ovr)
  ENABLE
;

-- seq
CREATE SEQUENCE usim_ovr_id_seq
  MINVALUE 1
  INCREMENT BY 1
  START WITH 1
  CACHE 20
  NOORDER
  NOCYCLE
  NOKEEP
  NOSCALE
  GLOBAL
;

-- id trigger
CREATE OR REPLACE TRIGGER usim_ovr_id_trg
  BEFORE INSERT ON usim_overflow
    FOR EACH ROW
    BEGIN
      <<COLUMN_SEQUENCES>>
      BEGIN
        IF INSERTING AND :NEW.usim_id_ovr IS NULL
        THEN
          SELECT usim_ovr_id_seq.NEXTVAL INTO :NEW.usim_id_ovr FROM SYS.dual;
        END IF;
      END COLUMN_SEQUENCES;
    END;
/
ALTER TRIGGER usim_ovr_id_trg ENABLE;

-- create tables for relations
-- USIM_DIM_POINT (dpo)
CREATE TABLE usim_dim_point
  ( usim_id_dpo     NUMBER(38, 0)               NOT NULL ENABLE
  , usim_id_poi     NUMBER(38, 0)               NOT NULL ENABLE
  , usim_id_dim     NUMBER(38, 0)               NOT NULL ENABLE
  )
;
COMMENT ON TABLE usim_dim_point IS 'Relates all points to a unique dimension. Will use the alias dpo.';
COMMENT ON COLUMN usim_dim_point.usim_id_dpo IS 'Generic ID to identify a point with dimension.';
COMMENT ON COLUMN usim_dim_point.usim_id_poi IS 'ID to identify the point for a dimension.';
COMMENT ON COLUMN usim_dim_point.usim_id_dim IS 'ID to identify the dimension for a point.';

-- pk
ALTER TABLE usim_dim_point
  ADD CONSTRAINT usim_dpo_pk
  PRIMARY KEY (usim_id_dpo)
  ENABLE
;

-- uk
ALTER TABLE usim_dim_point
  ADD CONSTRAINT usim_dpo_uk
  UNIQUE (usim_id_poi, usim_id_dim)
  ENABLE
;

-- seq
CREATE SEQUENCE usim_dpo_id_seq
  MINVALUE 1
  INCREMENT BY 1
  START WITH 1
  CACHE 20
  NOORDER
  NOCYCLE
  NOKEEP
  NOSCALE
  GLOBAL
;

-- id trigger
CREATE OR REPLACE TRIGGER usim_dpo_id_trg
  BEFORE INSERT ON usim_dim_point
    FOR EACH ROW
    BEGIN
      <<COLUMN_SEQUENCES>>
      BEGIN
        IF INSERTING AND :NEW.usim_id_dpo IS NULL
        THEN
          SELECT usim_dpo_id_seq.NEXTVAL INTO :NEW.usim_id_dpo FROM SYS.dual;
        END IF;
      END COLUMN_SEQUENCES;
    END;
/
ALTER TRIGGER usim_dpo_id_trg ENABLE;

-- USIM_POI_DIM_POSITION (pdp)
CREATE TABLE usim_poi_dim_position
  ( usim_id_pdp     NUMBER(38, 0)               NOT NULL ENABLE
  , usim_id_dpo     NUMBER(38, 0)               NOT NULL ENABLE
  , usim_id_pos     NUMBER(38, 0)               NOT NULL ENABLE
  )
  PARTITION BY RANGE (usim_id_dpo) INTERVAL (1)
    (PARTITION p_first VALUES LESS THAN (0))
;
COMMENT ON TABLE usim_poi_dim_position IS 'Relates all point/dimension to a position. Will use the alias pdp.';
COMMENT ON COLUMN usim_poi_dim_position.usim_id_pdp IS 'Generic ID to identify a position for a point in a dimension.';
COMMENT ON COLUMN usim_poi_dim_position.usim_id_dpo IS 'ID to identify the point with dimension.';
COMMENT ON COLUMN usim_poi_dim_position.usim_id_pos IS 'ID to identify the position of a point with dimension.';

-- pk
ALTER TABLE usim_poi_dim_position
  ADD CONSTRAINT usim_pdp_pk
  PRIMARY KEY (usim_id_pdp)
  ENABLE
;

-- idx
CREATE INDEX usim_pdp_dpo_pos_idx
          ON usim_poi_dim_position (usim_id_dpo, usim_id_pos)
;

-- seq
CREATE SEQUENCE usim_pdp_id_seq
  MINVALUE 1
  INCREMENT BY 1
  START WITH 1
  CACHE 20
  NOORDER
  NOCYCLE
  NOKEEP
  NOSCALE
  GLOBAL
;

-- id trigger
CREATE OR REPLACE TRIGGER usim_pdp_id_trg
  BEFORE INSERT ON usim_poi_dim_position
    FOR EACH ROW
    BEGIN
      <<COLUMN_SEQUENCES>>
      BEGIN
        IF INSERTING AND :NEW.usim_id_pdp IS NULL
        THEN
          SELECT usim_pdp_id_seq.NEXTVAL INTO :NEW.usim_id_pdp FROM SYS.dual;
        END IF;
      END COLUMN_SEQUENCES;
    END;
/
ALTER TRIGGER usim_pdp_id_trg ENABLE;

-- USIM_PDP_PARENT (par)
CREATE TABLE usim_pdp_parent
  ( usim_id_pdp     NUMBER(38, 0)               NOT NULL ENABLE
  , usim_id_parent  NUMBER(38, 0)
  )
;
COMMENT ON TABLE usim_pdp_parent IS 'Relates all point/dimension to a position. Will use the alias pdp.';
COMMENT ON COLUMN usim_pdp_parent.usim_id_pdp IS 'ID to identify a position for a point in a dimension.';
COMMENT ON COLUMN usim_pdp_parent.usim_id_parent IS 'Parent ID in USIM_POI_DIM_POSITION for USIM_ID_PDP. If NULL, the point has no parent.';

-- pk
ALTER TABLE usim_pdp_parent
  ADD CONSTRAINT usim_par_pk
  PRIMARY KEY (usim_id_pdp)
  ENABLE
;

-- uk
ALTER TABLE usim_pdp_parent
  ADD CONSTRAINT usim_par_uk
  UNIQUE (usim_id_pdp, usim_id_parent)
  ENABLE
;

-- create foreign keys after creating all tables
-- USIM_DIM_POINT
-- fk point
ALTER TABLE usim_dim_point
  ADD CONSTRAINT usim_dpo_poi_fk
  FOREIGN KEY (usim_id_poi) REFERENCES usim_point (usim_id_poi) ON DELETE CASCADE
  ENABLE
;
-- fk dimension
ALTER TABLE usim_dim_point
  ADD CONSTRAINT usim_dpo_dim_fk
  FOREIGN KEY (usim_id_dim) REFERENCES usim_dimension (usim_id_dim) ON DELETE CASCADE
  ENABLE
;
-- USIM_POI_DIM_POSITION
-- fk dimension point
ALTER TABLE usim_poi_dim_position
  ADD CONSTRAINT usim_pdp_dpo_fk
  FOREIGN KEY (usim_id_dpo) REFERENCES usim_dim_point (usim_id_dpo) ON DELETE CASCADE
  ENABLE
;
-- fk dimension point
ALTER TABLE usim_poi_dim_position
  ADD CONSTRAINT usim_pdp_pos_fk
  FOREIGN KEY (usim_id_pos) REFERENCES usim_position (usim_id_pos) ON DELETE CASCADE
  ENABLE
;

-- Views
-- USIM_POI_DIM_POSITION_V (vpdp)
CREATE OR REPLACE VIEW usim_poi_dim_position_v AS
  SELECT dim.usim_dimension
       , pos.usim_position
       , poi.usim_energy
       , poi.usim_amplitude
       , poi.usim_wavelength
       , pdp.usim_id_pdp
       , dpo.usim_id_dpo
       , dim.usim_id_dim
       , poi.usim_id_poi
       , pos.usim_id_pos
       , ROW_NUMBER() OVER (PARTITION BY poi.usim_id_poi
                                       , dim.usim_dimension
                                ORDER BY pdp.usim_id_pdp
                           ) AS usim_dim_child
    FROM usim_poi_dim_position pdp
    LEFT OUTER JOIN usim_position pos
      ON pdp.usim_id_pos = pos.usim_id_pos
    LEFT OUTER JOIN usim_dim_point dpo
      ON pdp.usim_id_dpo = dpo.usim_id_dpo
    LEFT OUTER JOIN usim_dimension dim
      ON dpo.usim_id_dim = dim.usim_id_dim
    LEFT OUTER JOIN usim_point poi
      ON dpo.usim_id_poi = poi.usim_id_poi
   ORDER
      BY poi.usim_id_poi
       , dim.usim_dimension
       , pdp.usim_id_pdp
;
COMMENT ON COLUMN usim_poi_dim_position_v.usim_dimension IS 'The dimension for the position of a point identified by USIM_ID_POI.';
COMMENT ON COLUMN usim_poi_dim_position_v.usim_position IS 'The position in the related dimension of a point identified by USIM_ID_POI.';
COMMENT ON COLUMN usim_poi_dim_position_v.usim_energy IS 'The current energy of a point at position and dimension identified by USIM_ID_POI.';
COMMENT ON COLUMN usim_poi_dim_position_v.usim_amplitude IS 'The current amplitude of a point at position and dimension identified by USIM_ID_POI.';
COMMENT ON COLUMN usim_poi_dim_position_v.usim_wavelength IS 'The current wavelength of a point at position and dimension identified by USIM_ID_POI.';
COMMENT ON COLUMN usim_poi_dim_position_v.usim_id_pdp IS 'The generic ID referring to a point with attributes, dimension and position in table USIM_POI_DIM_POSITION.';
COMMENT ON COLUMN usim_poi_dim_position_v.usim_id_dpo IS 'The generic ID referring to a point with dimension in table USIM_DIM_POINT.';
COMMENT ON COLUMN usim_poi_dim_position_v.usim_id_dim IS 'The generic ID referring to a dimension in table USIM_DIMENSION.';
COMMENT ON COLUMN usim_poi_dim_position_v.usim_id_poi IS 'The generic ID referring to a point in table USIM_POINT.';
COMMENT ON COLUMN usim_poi_dim_position_v.usim_id_pos IS 'The generic ID referring to a position in table USIM_POSITION.';
COMMENT ON COLUMN usim_poi_dim_position_v.usim_dim_child IS 'The dimension child number the position has for dimension and point.';

-- USIM_DIM_STATS_V (vdst)
CREATE OR REPLACE VIEW usim_dim_stats_v AS
  SELECT COUNT(*) AS usim_supported_dimensions
       , ',0' AS usim_default_coord
       , LENGTH(',0') AS usim_default_coord_len
    FROM usim_dimension
;
COMMENT ON COLUMN usim_dim_stats_v.usim_supported_dimensions IS 'The amount of n-sphere dimensions currently supported.';
COMMENT ON COLUMN usim_dim_stats_v.usim_default_coord IS 'The default coordinate for not assigned dimensions to build a coordinate string.';
COMMENT ON COLUMN usim_dim_stats_v.usim_default_coord_len IS 'The length of the default coordinate for not assigned dimensions to build a coordinate string.';

-- USIM_DIM_POS_COORDS_V (vdpc)
CREATE OR REPLACE VIEW usim_dim_pos_coords_v AS
  SELECT usim_id_poi
       , usim_dimension
       , usim_base_coords
       , usim_complete_coords
       , usim_dim_child
       , usim_supported_dimensions
       , usim_level
    FROM (SELECT coords.usim_id_poi
               , coords.usim_dimension
                 -- eliminate the first comma
               , SUBSTR(coords.usim_base_coords, 2) AS usim_base_coords
               , SUBSTR(RPAD(coords.usim_base_coords, coords.usim_coords_len, coords.usim_default_coord), 2) AS usim_complete_coords
               , coords.usim_supported_dimensions
               , coords.usim_level
               , ROW_NUMBER() OVER (PARTITION BY coords.usim_id_poi
                                               , coords.usim_dimension
                                        ORDER BY coords.usim_base_coords
                                   ) AS usim_dim_child
            FROM (SELECT vpdp.usim_id_poi
                       , vpdp.usim_dimension
                       , vpdp.usim_dim_child
                       , SYS_CONNECT_BY_PATH(vpdp.usim_position, ',') AS usim_base_coords
                       , LEVEL AS usim_level
                       , vdst.usim_default_coord
                       , vdst.usim_default_coord_len * (vdst.usim_supported_dimensions - LEVEL) + LENGTH(SYS_CONNECT_BY_PATH(vpdp.usim_position, ',')) AS usim_coords_len
                       , vdst.usim_supported_dimensions
                    FROM usim_poi_dim_position_v vpdp
                   CROSS JOIN usim_dim_stats_v vdst
                   START WITH     vpdp.usim_dimension = 0
                              AND vpdp.usim_id_poi    = (SELECT MIN(usim_id_poi) FROM usim_point)
                 CONNECT BY    PRIOR (vpdp.usim_id_poi || vpdp.usim_dimension) = (vpdp.usim_id_poi || vpdp.usim_dimension -1)
                            OR PRIOR vpdp.usim_id_poi                          < vpdp.usim_id_poi
                 ) coords
           GROUP
              BY coords.usim_id_poi
               , coords.usim_dimension
               , coords.usim_base_coords
               , coords.usim_default_coord
               , coords.usim_coords_len
               , coords.usim_supported_dimensions
               , coords.usim_level
         )
   ORDER
      BY usim_id_poi
       , usim_dimension
       , usim_dim_child
;
COMMENT ON COLUMN usim_dim_pos_coords_v.usim_id_poi IS 'The generic ID referring to a point in table USIM_POINT.';
COMMENT ON COLUMN usim_dim_pos_coords_v.usim_dimension IS 'The dimension of the point.';
COMMENT ON COLUMN usim_dim_pos_coords_v.usim_base_coords IS 'The base coordinates of the point filled up to the last filled dimension. Comma separated list of signed integer values.';
COMMENT ON COLUMN usim_dim_pos_coords_v.usim_complete_coords IS 'The complete coordinates of a point including not filled dimensions, which are set to 0. Comma separated list of signed integer values.';
COMMENT ON COLUMN usim_dim_pos_coords_v.usim_dim_child IS 'The child number within the dimension of the point.';
COMMENT ON COLUMN usim_dim_pos_coords_v.usim_supported_dimensions IS 'The maximum dimensions supported.';
COMMENT ON COLUMN usim_dim_pos_coords_v.usim_level IS 'The LEVEL of the hierarchical view.';

-- USIM_COORDS_UNIQUE_CNT_V (vcuq)
CREATE OR REPLACE VIEW usim_coords_unique_cnt_v AS
  SELECT usim_complete_coords
       , COUNT(*) AS usim_is_unique_cnt
    FROM usim_dim_pos_coords_v
   GROUP
      BY usim_complete_coords
;
COMMENT ON COLUMN usim_coords_unique_cnt_v.usim_complete_coords IS 'The complete coordinates used in the system.';
COMMENT ON COLUMN usim_coords_unique_cnt_v.usim_is_unique_cnt IS 'The count of the occurence of this coordinates. Should be 1 = unique.';

-- USIM_INVALID_COORDS_V (vivc)
CREATE OR REPLACE VIEW usim_invalid_coords_v AS
  SELECT DISTINCT
         vcuq.usim_complete_coords
       , vcuq.usim_is_unique_cnt
       , vcuq.usim_is_unique_cnt - 1 as usim_duplicates
       , vdpc.usim_id_poi
       , vdpc.usim_dimension
    FROM usim_coords_unique_cnt_v vcuq
    LEFT OUTER JOIN usim_dim_pos_coords_v vdpc
      ON vcuq.usim_complete_coords = vdpc.usim_complete_coords
   WHERE vcuq.usim_is_unique_cnt > 1
;
COMMENT ON COLUMN usim_invalid_coords_v.usim_complete_coords IS 'The complete coordinates used in the system per dimension and point.';
COMMENT ON COLUMN usim_invalid_coords_v.usim_is_unique_cnt IS 'The count of the occurence of this coordinates per dimension and point. Should be 1 = unique.';
COMMENT ON COLUMN usim_invalid_coords_v.usim_duplicates IS 'The amount of duplicte coordinates per dimension and point. Should be 0, no duplicates.';
COMMENT ON COLUMN usim_invalid_coords_v.usim_id_poi IS 'The generic ID referring to a point in table USIM_POINT.';
COMMENT ON COLUMN usim_invalid_coords_v.usim_dimension IS 'The dimension of the point.';

-- USIM_TREE_STATUS_V (vtrs)
CREATE OR REPLACE VIEW usim_tree_status_v AS
  SELECT vdpc.usim_id_poi
       , dim.usim_dimension
       , COUNT(*) AS usim_dim_tree_nodes
       , POWER(2, dim.usim_dimension) AS usim_dim_tree_max
       , CASE
           WHEN COUNT(*) = POWER(2, dim.usim_dimension)
           THEN 1
           WHEN COUNT(*) > POWER(2, dim.usim_dimension)
           THEN -1
           ELSE 0
         END usim_tree_level_filled
       , (SELECT NVL(SUM(vivc.usim_duplicates), 0) FROM usim_invalid_coords_v vivc
           WHERE vivc.usim_id_poi = vdpc.usim_id_poi
             AND vivc.usim_dimension = dim.usim_dimension
         ) AS usim_pos_duplicates
    FROM usim_dimension dim
    LEFT OUTER JOIN usim_dim_pos_coords_v vdpc
      ON dim.usim_dimension = vdpc.usim_dimension
   GROUP
      BY vdpc.usim_id_poi
       , dim.usim_dimension
   ORDER
      BY vdpc.usim_id_poi
       , dim.usim_dimension
;
COMMENT ON COLUMN usim_tree_status_v.usim_id_poi IS 'The generic ID referring to a point in table USIM_POINT.';
COMMENT ON COLUMN usim_tree_status_v.usim_dimension IS 'The dimension of the point.';
COMMENT ON COLUMN usim_tree_status_v.usim_dim_tree_nodes IS 'The amount of tree nodes for this dimension.';
COMMENT ON COLUMN usim_tree_status_v.usim_dim_tree_max IS 'The maximum amount of tree nodes for this dimension.';
COMMENT ON COLUMN usim_tree_status_v.usim_tree_level_filled IS 'Status tree filled: 1 = tree is filled in this dimension, 0 = tree is not filled for this dimension, -1 = tree is overfilled for this dimension.';
COMMENT ON COLUMN usim_tree_status_v.usim_pos_duplicates IS 'The amount of duplicates for this dimension, should be 0.';
