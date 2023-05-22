-- USIM_OUTPUT (outp)
CREATE TABLE usim_output
  ( usim_id_outp            CHAR(55)                NOT NULL ENABLE
  , usim_id_source          CHAR(55)                NOT NULL ENABLE
  , usim_id_target          CHAR(55)                NOT NULL ENABLE
  , usim_plancktime         CHAR(55)                NOT NULL ENABLE
  , usim_direction          NUMBER(1, 0)  DEFAULT 0 NOT NULL ENABLE
  , usim_processed          NUMBER(1, 0)  DEFAULT 0 NOT NULL ENABLE
  , usim_energy_source      NUMBER
  , usim_amplitude_source   NUMBER
  , usim_wavelength_source  NUMBER
  , usim_frequency_source   NUMBER
  , usim_energy_target      NUMBER
  , usim_amplitude_target   NUMBER
  , usim_wavelength_target  NUMBER
  , usim_frequency_target   NUMBER
  )
;
COMMENT ON TABLE usim_output IS 'Keeps the outputs of every point with target. Will use the alias outp.';
COMMENT ON COLUMN usim_output.usim_id_outp IS 'Generic big ID to identify the output.';
COMMENT ON COLUMN usim_output.usim_id_source IS 'The big ID to identify the source point (poi).';
COMMENT ON COLUMN usim_output.usim_id_target IS 'The big ID to identify the target point (poi). It is possible that source and target point are equal.';
COMMENT ON COLUMN usim_output.usim_plancktime IS 'The planck time tick the output is associated with (big ID).';
COMMENT ON COLUMN usim_output.usim_direction IS 'The direction for processing, value = 0 is interpreted as direction childs, -1 is interpreted direction parent.';
COMMENT ON COLUMN usim_output.usim_processed IS 'A flag to indicate that the output has been processed and is not needed any longer. 0 = not processed, 1 = processed.';
COMMENT ON COLUMN usim_output.usim_energy_source IS 'The output energy of the source point before processing.';
COMMENT ON COLUMN usim_output.usim_amplitude_source IS 'The output amplitude of source point before processing.';
COMMENT ON COLUMN usim_output.usim_wavelength_source IS 'The output wavelength of source point before processing.';
COMMENT ON COLUMN usim_output.usim_frequency_source IS 'The output frequency of the source point before processing.';
COMMENT ON COLUMN usim_output.usim_energy_target IS 'The energy of the target point before processing.';
COMMENT ON COLUMN usim_output.usim_amplitude_target IS 'The amplitude of target point before processing.';
COMMENT ON COLUMN usim_output.usim_wavelength_target IS 'The wavelength of target point before processing.';
COMMENT ON COLUMN usim_output.usim_frequency_target IS 'The frequency of the target point before processing.';

-- pk
ALTER TABLE usim_output
  ADD CONSTRAINT usim_outp_pk
  PRIMARY KEY (usim_id_outp)
  ENABLE
;
-- check processed
ALTER TABLE usim_output
  ADD CONSTRAINT usim_outp_processed_chk
  CHECK (usim_processed IN (0, 1))
  ENABLE
;
-- check direction
ALTER TABLE usim_output
  ADD CONSTRAINT usim_outp_direction_chk
  CHECK (usim_direction IN (0, -1))
  ENABLE
;

-- seq
CREATE SEQUENCE usim_outp_id_seq
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
CREATE OR REPLACE TRIGGER usim_outp_id_trg
  BEFORE INSERT ON usim_output
    FOR EACH ROW
    BEGIN
      <<COLUMN_SEQUENCES>>
      BEGIN
        IF INSERTING AND :NEW.usim_id_outp IS NULL
        THEN
          SELECT usim_static.get_big_pk(usim_outp_id_seq.NEXTVAL) INTO :NEW.usim_id_outp FROM SYS.dual;
        END IF;
      END COLUMN_SEQUENCES;
    END;
/
ALTER TRIGGER usim_outp_id_trg ENABLE;
