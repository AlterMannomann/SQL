-- USIM_OUTPUT (outp)
CREATE TABLE usim_output
  ( usim_id_outp      NUMBER(38, 0)                         NOT NULL ENABLE
  , usim_id_source    NUMBER(38, 0)                         NOT NULL ENABLE
  , usim_id_target    NUMBER(38, 0)                         NOT NULL ENABLE
  , usim_plancktime   NUMBER(38, 0)                         NOT NULL ENABLE
  , usim_timestamp    TIMESTAMP       DEFAULT SYSTIMESTAMP  NOT NULL ENABLE
  , usim_direction    NUMBER(1, 0)    DEFAULT 0             NOT NULL ENABLE
  , usim_processed    NUMBER(1, 0)    DEFAULT 0             NOT NULL ENABLE
  , usim_energy       NUMBER
  , usim_amplitude    NUMBER
  , usim_wavelength   NUMBER
  )
;
COMMENT ON TABLE usim_output IS 'Keeps the outputs of every point with target. Will use the alias outp.';
COMMENT ON COLUMN usim_output.usim_id_outp IS 'Generic ID to identify the output.';
COMMENT ON COLUMN usim_output.usim_id_source IS 'The ID to identify the source point (poi).';
COMMENT ON COLUMN usim_output.usim_id_target IS 'The ID to identify the target point (poi). It is possible that source and target point are equal.';
COMMENT ON COLUMN usim_output.usim_plancktime IS 'The planck time tick the output is associated with.';
COMMENT ON COLUMN usim_output.usim_timestamp IS 'The timestamp of output generation.';
COMMENT ON COLUMN usim_output.usim_direction IS 'The direction for processing, any value >= 0 is interpreted as direction childs, values below 0 are interpreted direction parent.';
COMMENT ON COLUMN usim_output.usim_processed IS 'A flag to indicate that the output has been processed and is not needed any longer. 0 = not processed, 1 = processed.';
COMMENT ON COLUMN usim_output.usim_energy IS 'The output energy of the source point.';
COMMENT ON COLUMN usim_output.usim_amplitude IS 'The output amplitude of source point.';
COMMENT ON COLUMN usim_output.usim_wavelength IS 'The output wavelength of source point.';

-- pk
ALTER TABLE usim_output
  ADD CONSTRAINT usim_outp_pk
  PRIMARY KEY (usim_id_outp)
  ENABLE
;

-- seq
CREATE SEQUENCE usim_outp_id_seq
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
CREATE OR REPLACE TRIGGER usim_outp_id_trg
  BEFORE INSERT ON usim_output
    FOR EACH ROW
    BEGIN
      <<COLUMN_SEQUENCES>>
      BEGIN
        IF INSERTING AND :NEW.usim_id_outp IS NULL
        THEN
          SELECT usim_outp_id_seq.NEXTVAL INTO :NEW.usim_id_outp FROM SYS.dual;
        END IF;
      END COLUMN_SEQUENCES;
    END;
/
ALTER TRIGGER usim_outp_id_trg ENABLE;
