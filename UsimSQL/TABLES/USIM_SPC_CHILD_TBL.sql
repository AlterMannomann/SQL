COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
-- USIM_SPC_CHILD (chi)
CREATE TABLE &USIM_SCHEMA..usim_spc_child
  ( usim_id_spc        CHAR(55) NOT NULL ENABLE
  , usim_id_spc_child  CHAR(55) NOT NULL ENABLE
  )
;
COMMENT ON TABLE &USIM_SCHEMA..usim_spc_child IS 'Describes the parent-child relation between active nodes. Will use the alias chi.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_spc_child.usim_id_spc IS 'The parent id from usim_space.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_spc_child.usim_id_spc_child IS 'The child id from usim_space.';

-- uk
ALTER TABLE &USIM_SCHEMA..usim_spc_child
  ADD CONSTRAINT usim_chi_uk
  UNIQUE (usim_id_spc, usim_id_spc_child)
  ENABLE
;

-- insert trigger
CREATE OR REPLACE TRIGGER &USIM_SCHEMA..usim_chi_ins_trg
  BEFORE INSERT ON &USIM_SCHEMA..usim_spc_child
    FOR EACH ROW
    BEGIN
      IF :NEW.usim_id_spc = :NEW.usim_id_spc_child
      THEN
        RAISE_APPLICATION_ERROR( num => -20000
                               , msg => 'Insert requirement not fulfilled. Parent and child cannot be equal.'
                               )
        ;
      END IF;
    END;
/
ALTER TRIGGER &USIM_SCHEMA..usim_chi_ins_trg ENABLE;

-- update trigger
CREATE OR REPLACE TRIGGER &USIM_SCHEMA..usim_chi_upd_trg
  BEFORE UPDATE ON &USIM_SCHEMA..usim_spc_child
    FOR EACH ROW
    BEGIN
      RAISE_APPLICATION_ERROR( num => -20001
                             , msg => 'Update requirement not fulfilled. No update allowed.'
                             )
      ;
    END;
/
ALTER TRIGGER &USIM_SCHEMA..usim_chi_upd_trg ENABLE;
