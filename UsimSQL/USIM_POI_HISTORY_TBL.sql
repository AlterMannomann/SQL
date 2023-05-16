-- USIM_POI_HISTORY (phis)
CREATE TABLE usim_poi_history
  ( usim_id_phis                NUMBER(38, 0)                         NOT NULL ENABLE
  , usim_timestamp              TIMESTAMP       DEFAULT SYSTIMESTAMP  NOT NULL ENABLE
  , usim_id_poi                 NUMBER(38, 0)                         NOT NULL ENABLE
  , usim_id_poi_source          NUMBER(38, 0)                         NOT NULL ENABLE
  , usim_energy                 NUMBER
  , usim_energy_source          NUMBER
  , usim_amplitude              NUMBER
  , usim_amplitude_source       NUMBER
  , usim_wavelength             NUMBER
  , usim_wavelength_source      NUMBER
  , usim_energy_force           NUMBER
  , usim_distance               NUMBER
  , usim_planck_time            NUMBER(38, 0)
  , usim_update_direction       NUMBER(1, 0)
  , usim_id_pdp                 NUMBER(38, 0)
  , usim_id_pdp_source          NUMBER(38, 0)
  )
  PARTITION BY RANGE (usim_planck_time) INTERVAL (1)
    (PARTITION p_first VALUES LESS THAN (1))
;

-- pk
ALTER TABLE usim_poi_history
  ADD CONSTRAINT usim_phis_pk
  PRIMARY KEY (usim_id_phis)
  ENABLE
;

-- seq
CREATE SEQUENCE usim_phis_id_seq
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
CREATE OR REPLACE TRIGGER usim_phis_id_trg
  BEFORE INSERT ON usim_poi_history
    FOR EACH ROW
    BEGIN
      <<COLUMN_SEQUENCES>>
      BEGIN
        IF INSERTING AND :NEW.usim_id_phis IS NULL
        THEN
          SELECT usim_phis_id_seq.NEXTVAL INTO :NEW.usim_id_phis FROM SYS.dual;
        END IF;
        IF INSERTING AND :NEW.usim_timestamp IS NULL
        THEN
          SELECT SYSTIMESTAMP INTO :NEW.usim_timestamp FROM SYS.dual;
        END IF;
      END COLUMN_SEQUENCES;
    END;
/
ALTER TRIGGER usim_phis_id_trg ENABLE;
