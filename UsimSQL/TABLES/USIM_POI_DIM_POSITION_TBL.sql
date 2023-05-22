-- USIM_POI_DIM_POSITION (pdp)
CREATE TABLE usim_poi_dim_position
  ( usim_id_pdp     CHAR(55)        NOT NULL ENABLE
  , usim_id_dpo     CHAR(55)        NOT NULL ENABLE
  , usim_id_pos     CHAR(55)        NOT NULL ENABLE
  , usim_id_psc     CHAR(55)        NOT NULL ENABLE
  , usim_coords     VARCHAR2(4000)  NOT NULL ENABLE
  , usim_abs_coords VARCHAR2(4000)  NOT NULL ENABLE
  )
;
COMMENT ON TABLE usim_poi_dim_position IS 'Relates all point/dimension to a position. Will use the alias pdp.';
COMMENT ON COLUMN usim_poi_dim_position.usim_id_pdp IS 'Generic big ID to identify a position for a point in a dimension.';
COMMENT ON COLUMN usim_poi_dim_position.usim_id_dpo IS 'Big ID to identify the point with dimension.';
COMMENT ON COLUMN usim_poi_dim_position.usim_id_pos IS 'Big ID to identify the position of a point with dimension.';
COMMENT ON COLUMN usim_poi_dim_position.usim_id_psc IS 'Big ID to identify the associated point structure.';
COMMENT ON COLUMN usim_poi_dim_position.usim_coords IS 'The dimensional coordinates like xyz for all current and parent dimensions as comma separated list.';
COMMENT ON COLUMN usim_poi_dim_position.usim_abs_coords IS 'The dimensional absolute coordinates like xyz for all current and parent dimensions as comma separated list.';

-- pk
ALTER TABLE usim_poi_dim_position
  ADD CONSTRAINT usim_pdp_pk
  PRIMARY KEY (usim_id_pdp)
  ENABLE
;

-- uk - point / dimension can only exist at one position
ALTER TABLE usim_poi_dim_position
  ADD CONSTRAINT usim_pdp_dpo_uk
  UNIQUE (usim_id_dpo)
  ENABLE
;
-- uk - full coordinates have to be unique
ALTER TABLE usim_poi_dim_position
  ADD CONSTRAINT usim_pdp_coords_uk
  UNIQUE (usim_coords)
  ENABLE
;

-- seq
CREATE SEQUENCE usim_pdp_id_seq
  MINVALUE 1
  MAXVALUE 99999999999999999999999999999999999999
  INCREMENT BY 1
  START WITH 1
  CACHE 20
  NOORDER
  CYCLE
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
          SELECT usim_static.get_big_pk(usim_pdp_id_seq.NEXTVAL) INTO :NEW.usim_id_pdp FROM SYS.dual;
        END IF;
      END COLUMN_SEQUENCES;
    END;
/
ALTER TRIGGER usim_pdp_id_trg ENABLE;
