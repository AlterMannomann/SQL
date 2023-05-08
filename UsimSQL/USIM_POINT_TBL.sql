-- USIM_POINT (poi)
CREATE TABLE usim_point
  ( usim_id_poi       NUMBER(38, 0)               NOT NULL ENABLE
  , usim_energy       NUMBER
  , usim_amplitude    NUMBER
  , usim_wavelength   NUMBER
  )
;
COMMENT ON TABLE usim_point IS 'Keeps all points with their attributes. Points are fixed in time and space. They represents the topology of the universe. Will use the alias poi.';
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
