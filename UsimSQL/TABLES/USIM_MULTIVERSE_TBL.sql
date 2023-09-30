-- USIM_MULTIVERSE (mlv)
CREATE TABLE usim_multiverse
  ( usim_id_mlv             CHAR(55)                  NOT NULL ENABLE
  , usim_universe_status    NUMBER(1, 0)  DEFAULT 0   NOT NULL ENABLE
  , usim_is_base_universe   NUMBER(1, 0)  DEFAULT 0   NOT NULL ENABLE
  , usim_energy_start_value NUMBER
  , usim_planck_aeon        CHAR(55)
  , usim_planck_time        NUMBER
  , usim_planck_time_unit   NUMBER        DEFAULT 1   NOT NULL ENABLE
  , usim_planck_length_unit NUMBER        DEFAULT 1   NOT NULL ENABLE
  , usim_planck_speed_unit  NUMBER        DEFAULT 1   NOT NULL ENABLE
  , usim_planck_stable      NUMBER(1, 0)  DEFAULT 1   NOT NULL ENABLE
  , usim_ultimate_border    NUMBER(1, 0)  DEFAULT 1   NOT NULL ENABLE
  )
;
COMMENT ON TABLE usim_multiverse IS 'A table to manage existing universes. Will use the alias mlv.';
COMMENT ON COLUMN usim_multiverse.usim_id_mlv IS 'The unique id for a universe in the multiverse. Automatically set on insert, update ignored.';
COMMENT ON COLUMN usim_multiverse.usim_universe_status IS 'The current state of the associated universe at usim_planck_time. Either INACTIVE, ACTIVE, DEAD, CRASHED or UNKNOWN. Calculated, set to INACTIVE on insert, update ignored.';
COMMENT ON COLUMN usim_multiverse.usim_is_base_universe IS 'Defines if the universe the base universe for the multiverse. 1 means base universe, 0 depending universe. Only one base allowed by application. Must be set on insert, update ignored';
COMMENT ON COLUMN usim_multiverse.usim_energy_start_value IS 'The energy start value for the associated universe. Must be set on insert, update ignored.';
COMMENT ON COLUMN usim_multiverse.usim_planck_aeon IS 'The planck aeon big id at insert or update of energy and universe state. Automatically set, insert and update ignored.';
COMMENT ON COLUMN usim_multiverse.usim_planck_time IS 'The planck time tick at insert or update of energy and universe state. Automatically set, insert and update ignored.';
COMMENT ON COLUMN usim_multiverse.usim_planck_time_unit IS 'The relative time unit of planck time for this universe. Inside always 1, but from outside it may have different values. Value 0 ignored. Update only allowed if usim_planck_stable = 0.';
COMMENT ON COLUMN usim_multiverse.usim_planck_length_unit IS 'The relative length unit of planck length for this universe. Inside always 1, but from outside it may have different values. Value 0 ignored. Update only allowed if usim_planck_stable = 0.';
COMMENT ON COLUMN usim_multiverse.usim_planck_speed_unit IS 'The relative speed (c) unit of planck speed for this universe. Inside always 1, but from outside it may have different values. Value 0 ignored. Update only allowed if usim_planck_stable = 0.';
COMMENT ON COLUMN usim_multiverse.usim_planck_stable IS 'The indicator if planck values may change over time (0) or are constant (1). Must be set on insert, ignored on update.';
COMMENT ON COLUMN usim_multiverse.usim_ultimate_border IS 'The indicator if energy flow is returned on any dimension border (0) or at the ultimate border, where no child connections are available (1). Must be set on insert, ignored on update.';

-- pk
ALTER TABLE usim_multiverse
  ADD CONSTRAINT usim_mlv_pk
  PRIMARY KEY (usim_id_mlv)
  ENABLE
;

-- chk planck stable
ALTER TABLE usim_multiverse
  ADD CONSTRAINT usim_mlv_planck_chk
  CHECK (usim_planck_stable IN (0, 1))
  ENABLE
;

-- chk base universe values
ALTER TABLE usim_multiverse
  ADD CONSTRAINT usim_mlv_base_chk
  CHECK (usim_is_base_universe IN (0, 1))
  ENABLE
;

-- check sign setting
ALTER TABLE usim_multiverse
  ADD CONSTRAINT usim_border_mlv_chk
  CHECK (usim_ultimate_border IN (0, 1))
  ENABLE
;

-- insert trigger
CREATE OR REPLACE TRIGGER usim_mlv_ins_trg
  BEFORE INSERT ON usim_multiverse
    FOR EACH ROW
    BEGIN
      IF usim_base.has_basedata = 0
      THEN
        RAISE_APPLICATION_ERROR( num => -20000
                               , msg => 'Insert requirement not fulfilled. Base data must exist before inserting a universe.'
                               )
        ;
      END IF;
      -- always set this values on insert, do not care about input
      :NEW.usim_id_mlv := usim_static.get_big_pk(usim_mlv_id_seq.NEXTVAL);
      -- inherit current values from base data
      :NEW.usim_planck_time := usim_base.get_planck_time_current;
      :NEW.usim_planck_aeon := usim_base.get_planck_aeon_seq_current;
      -- set default status INACTIVE on insert
      :NEW.usim_universe_status := usim_static.usim_multiverse_status_inactive;
      -- if not given, set to 1 as default
      IF :NEW.usim_energy_start_value IS NULL
      THEN
        :NEW.usim_energy_start_value := 1;
      END IF;
      IF :NEW.usim_planck_stable IS NULL
      THEN
        :NEW.usim_planck_stable := 1;
      END IF;
      IF :NEW.usim_ultimate_border IS NULL
      THEN
        :NEW.usim_ultimate_border := 1;
      END IF;
    END;
/
ALTER TRIGGER usim_mlv_ins_trg ENABLE;

-- update trigger
CREATE OR REPLACE TRIGGER usim_mlv_upd_trg
  BEFORE UPDATE ON usim_multiverse
    FOR EACH ROW
    BEGIN
      -- handle values that should not be updated
      IF :NEW.usim_id_mlv != :OLD.usim_id_mlv
      THEN
        :NEW.usim_id_mlv := :OLD.usim_id_mlv;
      END IF;
      -- not allowed, must be set on insert
      IF :NEW.usim_energy_start_value != :OLD.usim_energy_start_value
      THEN
        :NEW.usim_energy_start_value := :OLD.usim_energy_start_value;
      END IF;
      -- not allowed, must be set on insert
      IF :NEW.usim_is_base_universe != :OLD.usim_is_base_universe
      THEN
        :NEW.usim_is_base_universe := :OLD.usim_is_base_universe;
      END IF;
      IF :NEW.usim_ultimate_border != :OLD.usim_ultimate_border
      THEN
        :NEW.usim_ultimate_border := :OLD.usim_ultimate_border;
      END IF;
      IF :NEW.usim_planck_stable != :OLD.usim_planck_stable
      THEN
        :NEW.usim_planck_stable := :OLD.usim_planck_stable;
      END IF;
      -- ignore input for planck time
      :NEW.usim_planck_time := usim_base.get_planck_time_current;
      :NEW.usim_planck_aeon := usim_base.get_planck_aeon_seq_current;
      -- avoid set status if invalid
      IF :NEW.usim_universe_status != :OLD.usim_universe_status
      THEN
        IF :NEW.usim_universe_status NOT IN (usim_static.usim_multiverse_status_dead
                                            , usim_static.usim_multiverse_status_crashed
                                            , usim_static.usim_multiverse_status_active
                                            , usim_static.usim_multiverse_status_inactive
                                            )
        THEN
          :NEW.usim_universe_status := :OLD.usim_universe_status;
        END IF;
      END IF;
      -- set planck values only, if they differ from 0 and usim_planck_stable = 0
      IF    :NEW.usim_planck_time_unit = 0
         OR :OLD.usim_planck_stable = 1
      THEN
        :NEW.usim_planck_time_unit := :OLD.usim_planck_time_unit;
      END IF;
      IF    :NEW.usim_planck_speed_unit = 0
         OR :OLD.usim_planck_stable = 1
      THEN
        :NEW.usim_planck_speed_unit := :OLD.usim_planck_speed_unit;
      END IF;
      IF    :NEW.usim_planck_length_unit = 0
         OR :OLD.usim_planck_stable = 1
      THEN
        :NEW.usim_planck_length_unit := :OLD.usim_planck_length_unit;
      END IF;
    END;
/
ALTER TRIGGER usim_mlv_upd_trg ENABLE;
