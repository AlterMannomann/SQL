-- USIM_BASEDATA (bda)
CREATE TABLE usim_basedata
  ( usim_id_bda                 NUMBER(1)       DEFAULT 1                                       NOT NULL ENABLE
  , usim_max_dimension          NUMBER(38, 0)   DEFAULT 11                                      NOT NULL ENABLE
  , usim_abs_max_number         NUMBER(38, 0)   DEFAULT 99999999999999999999999999999999999999  NOT NULL ENABLE
  , usim_overflow_node_seed     NUMBER(1, 0)    DEFAULT 1                                       NOT NULL ENABLE
  , usim_planck_time_seq_last   CHAR(55)        DEFAULT 'N/A'                                   NOT NULL ENABLE
  , usim_planck_time_seq_curr   CHAR(55)        DEFAULT 'N/A'                                   NOT NULL ENABLE
  , usim_child_seq_last         CHAR(55)        DEFAULT 'N/A'                                   NOT NULL ENABLE
  , usim_child_seq_curr         CHAR(55)        DEFAULT 'N/A'                                   NOT NULL ENABLE
  , usim_child_mirror_seq_last  CHAR(55)        DEFAULT 'N/A'                                   NOT NULL ENABLE
  , usim_child_mirror_seq_curr  CHAR(55)        DEFAULT 'N/A'                                   NOT NULL ENABLE
  , usim_seed_name              VARCHAR2(128)   DEFAULT 'UniverseSeed'                          NOT NULL ENABLE
  , usim_seed_mirror_name       VARCHAR2(128)   DEFAULT 'MirrorSeed'                            NOT NULL ENABLE
  , usim_child_prefix           VARCHAR2(128)   DEFAULT 'Child'                                 NOT NULL ENABLE
  , usim_child_mirror_prefix    VARCHAR2(128)   DEFAULT 'MirrorChild'                           NOT NULL ENABLE
  , usim_created                DATE            DEFAULT SYSDATE                                 NOT NULL ENABLE
  , usim_updated                DATE            DEFAULT SYSDATE                                 NOT NULL ENABLE
  , usim_created_by             VARCHAR2(128)   DEFAULT 'N/A'                                   NOT NULL ENABLE
  , usim_updated_by             VARCHAR2(128)   DEFAULT 'N/A'                                   NOT NULL ENABLE
  )
;
COMMENT ON TABLE usim_basedata IS 'Holds the basic data used by the universe simulation. Will use the alias bda.';
COMMENT ON COLUMN usim_basedata.usim_id_bda IS 'The unique id of the base data. Can only have the value 1 ensured by primary key and check constraint.';
COMMENT ON COLUMN usim_basedata.usim_max_dimension IS 'The maximum dimension supported for any universe in this multiverse. Must be set on insert.';
COMMENT ON COLUMN usim_basedata.usim_abs_max_number IS 'The absolute maximum number possible on the used system. Must be set on insert.';
COMMENT ON COLUMN usim_basedata.usim_overflow_node_seed IS 'Set to 1 if all new trees should start with parent in dimension n = 0. Set to 0, if new trees should start at the node that would have caused an overflow. Must be set on insert.';
COMMENT ON COLUMN usim_basedata.usim_planck_time_seq_last IS 'The last planck time big id or N/A if not known yet. Package usim_static holds the name of the used sequence.';
COMMENT ON COLUMN usim_basedata.usim_planck_time_seq_curr IS 'The current planck time big id or N/A if not known yet. Package usim_static holds the name of the used sequence.';
COMMENT ON COLUMN usim_basedata.usim_child_seq_last IS 'The last child subtree structure name big id or N/A if not known yet. Used to build unique child subtree structure names together with usim_child_prefix.';
COMMENT ON COLUMN usim_basedata.usim_child_seq_curr IS 'The current child subtree structure name big id or N/A if not known yet. Used to build unique child subtree names structure together with usim_child_prefix.';
COMMENT ON COLUMN usim_basedata.usim_child_mirror_seq_last IS 'The last mirror child subtree structure name big id or N/A if not known yet. Used to build unique mirror child subtree structure names together with usim_child_mirror_prefix.';
COMMENT ON COLUMN usim_basedata.usim_child_mirror_seq_curr IS 'The current mirror child subtree structure name big id or N/A if not known yet. Used to build unique mirror child subtree structure names together with usim_child_mirror_prefix.';
COMMENT ON COLUMN usim_basedata.usim_seed_name IS 'The static name of the basic universe seed structure.';
COMMENT ON COLUMN usim_basedata.usim_seed_mirror_name IS 'The static name of the basic universe mirror seed structure.';
COMMENT ON COLUMN usim_basedata.usim_child_prefix IS 'The prefix to use for creating unique child subtree structure names.';
COMMENT ON COLUMN usim_basedata.usim_child_mirror_prefix IS 'The prefix to use for creating unique mirror child subtree structure names.';
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

-- check seed names - can't be equal
ALTER TABLE usim_basedata
  ADD CONSTRAINT usim_seed_bda_chk
  CHECK (TRIM(usim_seed_name) != TRIM(usim_seed_mirror_name))
  ENABLE
;

-- check child prefix names - can't be equal
ALTER TABLE usim_basedata
  ADD CONSTRAINT usim_child_bda_chk
  CHECK (TRIM(usim_child_prefix) != TRIM(usim_child_mirror_prefix))
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
      -- we ignore any input values and initialize to the default
      :NEW.usim_planck_time_seq_last  := usim_static.usim_not_available;
      :NEW.usim_planck_time_seq_curr  := usim_static.usim_not_available;
      :NEW.usim_child_seq_last        := usim_static.usim_not_available;
      :NEW.usim_child_seq_curr        := usim_static.usim_not_available;
      :NEW.usim_child_mirror_seq_last := usim_static.usim_not_available;
      :NEW.usim_child_mirror_seq_curr := usim_static.usim_not_available;
      -- set os user for create and update, ignore given values if any
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
      IF :NEW.usim_child_seq_last IS NOT NULL
      THEN
        :NEW.usim_child_seq_last := :OLD.usim_child_seq_last;
      END IF;
      IF :NEW.usim_child_mirror_seq_last IS NOT NULL
      THEN
        :NEW.usim_child_mirror_seq_last := :OLD.usim_child_mirror_seq_last;
      END IF;
      -- update current and last sequences if current is given
      IF :NEW.usim_planck_time_seq_curr IS NOT NULL
      THEN
        IF :NEW.usim_planck_time_seq_curr != :OLD.usim_planck_time_seq_curr
        THEN
          :NEW.usim_planck_time_seq_last := :OLD.usim_planck_time_seq_curr;
        END IF;
      END IF;
      IF :NEW.usim_child_seq_curr IS NOT NULL
      THEN
        IF :NEW.usim_child_seq_curr != :OLD.usim_child_seq_curr
        THEN
          :NEW.usim_child_seq_last := :OLD.usim_child_seq_curr;
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
      -- no update of created only update
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