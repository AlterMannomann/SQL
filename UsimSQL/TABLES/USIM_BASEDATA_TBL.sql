-- USIM_BASEDATA (bda)
CREATE TABLE usim_basedata
  ( usim_id_bda                 NUMBER(1)       DEFAULT 1                                       NOT NULL ENABLE
  , usim_max_dimension          NUMBER(38, 0)   DEFAULT 42                                      NOT NULL ENABLE
  , usim_abs_max_number         NUMBER(38, 0)   DEFAULT 99999999999999999999999999999999999999  NOT NULL ENABLE
  , usim_overflow_node_seed     NUMBER(1, 0)    DEFAULT 0                                       NOT NULL ENABLE
  , usim_planck_time_seq_last   NUMBER          DEFAULT -1                                      NOT NULL ENABLE
  , usim_planck_time_seq_curr   NUMBER          DEFAULT -1                                      NOT NULL ENABLE
  , usim_planck_aeon_seq_last   CHAR(55)        DEFAULT 'N/A'                                   NOT NULL ENABLE
  , usim_planck_aeon_seq_curr   CHAR(55)        DEFAULT 'N/A'                                   NOT NULL ENABLE
  , usim_created                DATE            DEFAULT SYSDATE                                 NOT NULL ENABLE
  , usim_updated                DATE            DEFAULT SYSDATE                                 NOT NULL ENABLE
  , usim_created_by             VARCHAR2(128)   DEFAULT 'N/A'                                   NOT NULL ENABLE
  , usim_updated_by             VARCHAR2(128)   DEFAULT 'N/A'                                   NOT NULL ENABLE
  )
;
COMMENT ON TABLE usim_basedata IS 'Holds the basic data used by the multiverse simulation that belong to all universes. Will use the alias bda.';
COMMENT ON COLUMN usim_basedata.usim_id_bda IS 'The unique id of the base data. Can only have the value 1 ensured by primary key and check constraint.';
COMMENT ON COLUMN usim_basedata.usim_max_dimension IS 'The maximum dimension supported for any universe in this multiverse. Must be set on insert.';
COMMENT ON COLUMN usim_basedata.usim_abs_max_number IS 'The absolute maximum number possible on the used system. Must be set on insert.';
COMMENT ON COLUMN usim_basedata.usim_overflow_node_seed IS 'Set to 1 if all new structures should start with parent in dimension n = 0. Set to 0, if new structures should use standard overflow handling. Must be set on insert.';
COMMENT ON COLUMN usim_basedata.usim_planck_time_seq_last IS 'The last planck time tick or -1 if not known yet. Package usim_static holds the name of the used sequence.';
COMMENT ON COLUMN usim_basedata.usim_planck_time_seq_curr IS 'The current planck time tick or -1 if not known yet. Package usim_static holds the name of the used sequence.';
COMMENT ON COLUMN usim_basedata.usim_planck_aeon_seq_last IS 'The last planck aeon big id or N/A if not known yet. Package usim_static holds the name of the used sequence.';
COMMENT ON COLUMN usim_basedata.usim_planck_aeon_seq_curr IS 'The current planck aeon big id or N/A if not known yet. Package usim_static holds the name of the used sequence.';
COMMENT ON COLUMN usim_basedata.usim_created IS 'Date of record creation.';
COMMENT ON COLUMN usim_basedata.usim_updated IS 'Date of record update.';
COMMENT ON COLUMN usim_basedata.usim_created_by IS 'OS user responsible for record creation.';
COMMENT ON COLUMN usim_basedata.usim_updated IS 'OS user, schema owner or user (depending on situation of update) responsible for record update.';

-- pk (only to ensure not more than one entry)
ALTER TABLE usim_basedata
  ADD CONSTRAINT usim_bda_pk
  PRIMARY KEY (usim_id_bda)
  ENABLE
;

-- check id, means we limit records inserted to one record with id = 1 as we have a primary key unique constraint
ALTER TABLE usim_basedata
  ADD CONSTRAINT usim_id_bda_chk
  CHECK (usim_id_bda = 1)
  ENABLE
;

-- check overflow setting
ALTER TABLE usim_basedata
  ADD CONSTRAINT usim_ovr_bda_chk
  CHECK (usim_overflow_node_seed IN (0, 1))
  ENABLE
;

-- max dimensions >= 0
ALTER TABLE usim_basedata
  ADD CONSTRAINT usim_dim_bda_chk
  CHECK (usim_max_dimension >= 0)
  ENABLE
;

-- absolute max >= 0
ALTER TABLE usim_basedata
  ADD CONSTRAINT usim_maxn_bda_chk
  CHECK (usim_abs_max_number >= 0)
  ENABLE
;

-- insert trigger
CREATE OR REPLACE TRIGGER usim_bda_ins_trg
  -- check insert values and ensure default values where needed
  BEFORE INSERT ON usim_basedata
    FOR EACH ROW
    BEGIN
      IF :NEW.usim_id_bda IS NULL
      THEN
        -- ensure correct id
        :NEW.usim_id_bda := 1;
      END IF;
      -- we ignore input values which should not be set on insert and initialize them to the default
      :NEW.usim_planck_time_seq_last  := -1;
      :NEW.usim_planck_time_seq_curr  := -1;
      :NEW.usim_planck_aeon_seq_last  := usim_static.usim_not_available;
      :NEW.usim_planck_aeon_seq_curr  := usim_static.usim_not_available;
      -- set os user for create, ignore given values if any
      :NEW.usim_created               := SYSDATE;
      :NEW.usim_updated               := SYSDATE;
      :NEW.usim_created_by            := SYS_CONTEXT('USERENV', 'OS_USER');
      :NEW.usim_updated_by            := SYS_CONTEXT('USERENV', 'OS_USER');
    END;
/
ALTER TRIGGER usim_bda_ins_trg ENABLE;

-- update trigger
CREATE OR REPLACE TRIGGER usim_bda_upd_trg
  -- check update values and ensure consistency
  BEFORE UPDATE ON usim_basedata
    FOR EACH ROW
    BEGIN
      -- check big sequences
      -- only allow updates on current sequences
      IF :NEW.usim_planck_time_seq_last IS NOT NULL
      THEN
        :NEW.usim_planck_time_seq_last := :OLD.usim_planck_time_seq_last;
      END IF;
      IF :NEW.usim_planck_aeon_seq_last IS NOT NULL
      THEN
        :NEW.usim_planck_aeon_seq_last := :OLD.usim_planck_aeon_seq_last;
      END IF;
      -- update current and last sequences if current is given
      IF :NEW.usim_planck_time_seq_curr IS NOT NULL
      THEN
        IF :NEW.usim_planck_time_seq_curr != :OLD.usim_planck_time_seq_curr
        THEN
          :NEW.usim_planck_time_seq_last := :OLD.usim_planck_time_seq_curr;
        END IF;
      END IF;
      IF :NEW.usim_planck_aeon_seq_curr IS NOT NULL
      THEN
        IF :NEW.usim_planck_aeon_seq_curr != :OLD.usim_planck_aeon_seq_curr
        THEN
          :NEW.usim_planck_aeon_seq_last := :OLD.usim_planck_aeon_seq_curr;
        END IF;
      END IF;
      -- no updates on basic design values
      IF :NEW.usim_overflow_node_seed IS NOT NULL
      THEN
        :NEW.usim_overflow_node_seed := :OLD.usim_overflow_node_seed;
      END IF;
      IF :NEW.usim_max_dimension IS NOT NULL
      THEN
        :NEW.usim_max_dimension := :OLD.usim_max_dimension;
      END IF;
      IF :NEW.usim_abs_max_number IS NOT NULL
      THEN
        :NEW.usim_abs_max_number := :OLD.usim_abs_max_number;
      END IF;
      -- no update of created only on updated
      IF :NEW.usim_created IS NOT NULL
      THEN
        :NEW.usim_created := :OLD.usim_created;
      END IF;
      IF :NEW.usim_created_by IS NOT NULL
      THEN
        :NEW.usim_created_by := :OLD.usim_created_by;
      END IF;
      :NEW.usim_updated     := SYSDATE;
      -- allow user override, if system updates the table, otherwise use OS user
      -- limit allowed users to either OS user or current schema owner
      IF :NEW.usim_updated_by NOT IN (SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA'), SYS_CONTEXT('USERENV', 'OS_USER'))
      THEN
        :NEW.usim_updated_by  := SYS_CONTEXT('USERENV', 'OS_USER');
      END IF;
    END;
/
ALTER TRIGGER usim_bda_upd_trg ENABLE;
