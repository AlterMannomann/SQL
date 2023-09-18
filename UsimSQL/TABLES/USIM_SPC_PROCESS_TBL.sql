-- USIM_SPC_PROCESS (SPR)
CREATE TABLE usim_spc_process
  ( usim_planck_aeon   CHAR(55)                     NOT NULL ENABLE
  , usim_planck_time   NUMBER                       NOT NULL ENABLE
  , usim_id_spc_source CHAR(55)                     NOT NULL ENABLE
  , usim_id_spc_target CHAR(55)                     NOT NULL ENABLE
  , usim_real_time     DATE         DEFAULT SYSDATE NOT NULL ENABLE
  , is_processed       NUMBER(1, 0) DEFAULT 0       NOT NULL ENABLE
  , usim_energy_source NUMBER
  , usim_energy_target NUMBER
  , usim_energy_output NUMBER
  )
  PARTITION BY RANGE (usim_real_time)
    INTERVAL (NUMTODSINTERVAL(1, 'DAY'))
    (PARTITION p_first VALUES LESS THAN (TO_DATE('01.01.2023', 'DD.MM.YYYY')))
;
COMMENT ON TABLE usim_spc_process IS 'Holds the log of all space activity. Will use the alias spr.';
COMMENT ON COLUMN usim_spc_process.usim_planck_aeon IS 'The current planck aeon of the energy output. Only insert allowed.';
COMMENT ON COLUMN usim_spc_process.usim_planck_time IS 'The current planck time relative to the planck aeon of the energy output. Only insert allowed.';
COMMENT ON COLUMN usim_spc_process.usim_id_spc_source IS 'The space node id of the energy source, which will output energy to the target. Only insert allowed.';
COMMENT ON COLUMN usim_spc_process.usim_id_spc_target IS 'The space node id of the target, which will receive the energy output from the source. Only insert allowed.';
COMMENT ON COLUMN usim_spc_process.usim_real_time IS 'The real date time of the simulation. Automatically set.';
COMMENT ON COLUMN usim_spc_process.is_processed IS 'The indicator for processed outputs. On creation 0, after output applied 1. Only updates allowed. Any update sets this to 1 (processed).';
COMMENT ON COLUMN usim_spc_process.usim_energy_source IS 'The energy of the source, which was the base of the calculated output before processing. Only insert allowed.';
COMMENT ON COLUMN usim_spc_process.usim_energy_target IS 'The energy of the target before processing. Only insert allowed.';
COMMENT ON COLUMN usim_spc_process.usim_energy_output IS 'The output energy of the source that has to be applied to the target. Only insert allowed.';
-- indexes
CREATE INDEX usim_spr_src_idx
    ON usim_spc_process
       ( usim_planck_aeon
       , usim_planck_time
       , usim_id_spc_source
       )
;

CREATE INDEX usim_spr_tgt_idx
    ON usim_spc_process
       ( usim_planck_aeon
       , usim_planck_time
       , usim_id_spc_target
       )
;
-- constraints
ALTER TABLE usim_spc_process
  ADD CONSTRAINT usim_processed_chk
  CHECK (is_processed IN (0, 1))
  ENABLE
;

-- insert trigger
CREATE OR REPLACE TRIGGER usim_spr_ins_trg
  -- set insert values that can not be changed on insert
  BEFORE INSERT ON usim_spc_process
    FOR EACH ROW
    BEGIN
      :NEW.is_processed   := 0;
      :NEW.usim_real_time := SYSDATE;
    END;
 /
 -- update trigger
CREATE OR REPLACE TRIGGER usim_spr_upd_trg
  -- set insert values that can not be changed on insert
  BEFORE UPDATE ON usim_spc_process
    FOR EACH ROW
    BEGIN
      IF :NEW.usim_planck_aeon != :OLD.usim_planck_aeon
      THEN
        :NEW.usim_planck_aeon := :OLD.usim_planck_aeon;
      END IF;
      IF :NEW.usim_planck_time != :OLD.usim_planck_time
      THEN
        :NEW.usim_planck_time := :OLD.usim_planck_time;
      END IF;
      IF :NEW.usim_id_spc_source != :OLD.usim_id_spc_source
      THEN
        :NEW.usim_id_spc_source := :OLD.usim_id_spc_source;
      END IF;
      IF :NEW.usim_id_spc_target != :OLD.usim_id_spc_target
      THEN
        :NEW.usim_id_spc_target := :OLD.usim_id_spc_target;
      END IF;
      IF :NEW.usim_real_time != :OLD.usim_real_time
      THEN
        :NEW.usim_real_time := :OLD.usim_real_time;
      END IF;
      IF :NEW.usim_energy_source != :OLD.usim_energy_source
      THEN
        :NEW.usim_energy_source := :OLD.usim_energy_source;
      END IF;
      IF :NEW.usim_energy_target != :OLD.usim_energy_target
      THEN
        :NEW.usim_energy_target := :OLD.usim_energy_target;
      END IF;
      IF :NEW.usim_energy_output != :OLD.usim_energy_output
      THEN
        :NEW.usim_energy_output := :OLD.usim_energy_output;
      END IF;
    END;
 /