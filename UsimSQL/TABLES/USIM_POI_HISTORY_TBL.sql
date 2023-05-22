-- USIM_POI_HISTORY (phis)
CREATE TABLE usim_poi_history
  ( usim_id_phis                CHAR(55)                              NOT NULL ENABLE
  , usim_timestamp              TIMESTAMP       DEFAULT SYSTIMESTAMP  NOT NULL ENABLE
  , usim_id_poi_source          CHAR(55)                              NOT NULL ENABLE
  , usim_id_poi_target          CHAR(55)                              NOT NULL ENABLE
  , usim_planck_time            CHAR(55)
  , usim_energy_result          NUMBER
  , usim_energy_source          NUMBER
  , usim_energy_target          NUMBER
  , usim_amplitude_result       NUMBER
  , usim_amplitude_source       NUMBER
  , usim_amplitude_target       NUMBER
  , usim_wavelength_result      NUMBER
  , usim_wavelength_source      NUMBER
  , usim_wavelength_target      NUMBER
  , usim_frequency_result       NUMBER
  , usim_frequency_source       NUMBER
  , usim_frequency_target       NUMBER
  , usim_dimension_source       NUMBER
  , usim_dimension_target       NUMBER
  , usim_energy_force           NUMBER
  , usim_distance               NUMBER
  , usim_update_direction       NUMBER(1, 0)
  , usim_coords_source          VARCHAR2(4000)
  , usim_coords_target          VARCHAR2(4000)
  )
  PARTITION BY RANGE (usim_timestamp) INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
    (PARTITION p_first VALUES LESS THAN (TO_DATE('01.01.2023', 'DD.MM.YYYY')))
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
CREATE OR REPLACE TRIGGER usim_phis_id_trg
  BEFORE INSERT ON usim_poi_history
    FOR EACH ROW
    BEGIN
      <<COLUMN_SEQUENCES>>
      BEGIN
        IF INSERTING AND :NEW.usim_id_phis IS NULL
        THEN
          SELECT usim_static.get_big_pk(usim_phis_id_seq.NEXTVAL) INTO :NEW.usim_id_phis FROM SYS.dual;
        END IF;
        IF INSERTING AND :NEW.usim_timestamp IS NULL
        THEN
          SELECT SYSTIMESTAMP INTO :NEW.usim_timestamp FROM SYS.dual;
        END IF;
      END COLUMN_SEQUENCES;
    END;
/
ALTER TRIGGER usim_phis_id_trg ENABLE;
