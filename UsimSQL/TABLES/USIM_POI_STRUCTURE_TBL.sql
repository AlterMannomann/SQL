-- USIM_POI_STRUCTURE (psc)
CREATE TABLE usim_poi_structure
  ( usim_id_psc       CHAR(55)        NOT NULL ENABLE
  , usim_point_name   VARCHAR2(4000)  NOT NULL ENABLE
  )
;
COMMENT ON TABLE usim_poi_structure IS 'Defines a point structure, keeping a points representation in different dimensions together. Will use the alias psc.';
COMMENT ON COLUMN usim_poi_structure.usim_id_psc IS 'Generic big ID to identify a point structure.';
COMMENT ON COLUMN usim_poi_structure.usim_point_name IS 'The unique name of the point structure.';

-- pk
ALTER TABLE usim_poi_structure
  ADD CONSTRAINT usim_psc_pk
  PRIMARY KEY (usim_id_psc)
  ENABLE
;

-- uk
ALTER TABLE usim_poi_structure
  ADD CONSTRAINT usim_psc_uk
  UNIQUE (usim_point_name)
  ENABLE
;

-- seq
CREATE SEQUENCE usim_psc_id_seq
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
CREATE OR REPLACE TRIGGER usim_psc_id_trg
  BEFORE INSERT ON usim_poi_structure
    FOR EACH ROW
    BEGIN
      <<COLUMN_SEQUENCES>>
      BEGIN
        IF INSERTING AND :NEW.usim_id_psc IS NULL
        THEN
          SELECT usim_static.get_big_pk(usim_psc_id_seq.NEXTVAL) INTO :NEW.usim_id_psc FROM SYS.dual;
        END IF;
      END COLUMN_SEQUENCES;
    END;
/
ALTER TRIGGER usim_psc_id_trg ENABLE;
