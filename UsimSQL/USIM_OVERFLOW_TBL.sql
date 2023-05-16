-- USIM_OVERFLOW (ovr)
CREATE TABLE usim_overflow
  ( usim_id_ovr     NUMBER(38, 0)               NOT NULL ENABLE
  , usim_id_pdp     NUMBER(38, 0)               NOT NULL ENABLE
  , usim_energy     NUMBER
  , usim_amplitude  NUMBER
  , usim_wavelength NUMBER
  )
;
COMMENT ON TABLE usim_overflow IS 'Keeps overflows of points. Will use the alias ovr.';
COMMENT ON COLUMN usim_overflow.usim_id_pdp IS 'ID in USIM_POI_DIM_POSITION to identify a point with position in a dimension.';
COMMENT ON COLUMN usim_overflow.usim_energy IS 'The energy potential which would have caused an overflow, if any.';
COMMENT ON COLUMN usim_overflow.usim_amplitude IS 'The amplitude potential which would have caused an overflow, if any.';
COMMENT ON COLUMN usim_overflow.usim_wavelength IS 'The wavelength potential which would have caused an overflow, if any.';

-- pk - only one overflow per point with position in a dimension
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
