-- USIM_POINT (hpoi)
CREATE TABLE usim_point_h
  ( usim_timestamp    TIMESTAMP          DEFAULT SYSTIMESTAMP NOT NULL ENABLE
  , usim_planck_time  NUMBER(38, 0)                           NOT NULL ENABLE
  , usim_id_poi       NUMBER(38, 0)                           NOT NULL ENABLE
  , usim_energy       NUMBER
  , usim_amplitude    NUMBER
  , usim_wavelength   NUMBER
  )
  PARTITION BY RANGE (usim_planck_time) INTERVAL (1)
    (PARTITION p_first VALUES LESS THAN (0))
;
COMMENT ON TABLE usim_point_h IS 'History table of point attributes developing over time. Partitioned by usim_planck_time.';
COMMENT ON COLUMN usim_point_h.usim_timestamp IS 'The system time stamp of the history capture.';
COMMENT ON COLUMN usim_point_h.usim_planck_time IS 'The active planck time tick at history capture.';
COMMENT ON COLUMN usim_point_h.usim_id_poi IS 'ID to identify a point.';
COMMENT ON COLUMN usim_point_h.usim_energy IS 'The energy of the point at time stamp.';
COMMENT ON COLUMN usim_point_h.usim_amplitude IS 'The amplitude of the point at time stamp.';
COMMENT ON COLUMN usim_point_h.usim_wavelength IS 'The wavelength of the point at time stamp.';

-- time trigger
CREATE OR REPLACE TRIGGER usim_hpoi_id_trg
  BEFORE INSERT ON usim_point_h
    FOR EACH ROW
    BEGIN
      <<COLUMN_SEQUENCES>>
      BEGIN
        IF INSERTING AND :NEW.usim_timestamp IS NULL
        THEN
          SELECT SYSTIMESTAMP INTO :NEW.usim_timestamp FROM SYS.dual;
        END IF;
        IF INSERTING AND :NEW.usim_planck_time IS NULL
        THEN
          SELECT usim_planck_time_seq.CURRVAL INTO :NEW.usim_planck_time FROM SYS.dual;
        END IF;
      END COLUMN_SEQUENCES;
    END;
/
ALTER TRIGGER usim_hpoi_id_trg ENABLE;
