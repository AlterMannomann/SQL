COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
-- USIM_RMD_CHILD (rchi)
CREATE TABLE &USIM_SCHEMA..usim_rmd_child
  ( usim_id_rmd        CHAR(55) NOT NULL ENABLE
  , usim_id_rmd_child  CHAR(55) NOT NULL ENABLE
  )
;
COMMENT ON TABLE &USIM_SCHEMA..usim_rmd_child IS 'Describes the parent-child relation between dimension axis. Will use the alias rchi.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_rmd_child.usim_id_rmd IS 'The parent id from usim_rel_mlv_dim.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_rmd_child.usim_id_rmd_child IS 'The child id from usim_rel_mlv_dim. Only two childs possible';

-- uk
ALTER TABLE &USIM_SCHEMA..usim_rmd_child
  ADD CONSTRAINT usim_rchi_uk
  UNIQUE (usim_id_rmd, usim_id_rmd_child)
  ENABLE
;

-- insert trigger
CREATE OR REPLACE TRIGGER &USIM_SCHEMA..usim_rchi_ins_trg
  BEFORE INSERT ON &USIM_SCHEMA..usim_rmd_child
    FOR EACH ROW
    BEGIN
      IF :NEW.usim_id_rmd = :NEW.usim_id_rmd_child
      THEN
        RAISE_APPLICATION_ERROR( num => -20000
                               , msg => 'Insert requirement not fulfilled. Parent and child cannot be equal.'
                               )
        ;
      END IF;
    END;
/
ALTER TRIGGER &USIM_SCHEMA..usim_rchi_ins_trg ENABLE;

-- update trigger
CREATE OR REPLACE TRIGGER &USIM_SCHEMA..usim_rchi_upd_trg
  BEFORE UPDATE ON &USIM_SCHEMA..usim_rmd_child
    FOR EACH ROW
    BEGIN
      RAISE_APPLICATION_ERROR( num => -20001
                             , msg => 'Update requirement not fulfilled. No update allowed.'
                             )
      ;
    END;
/
ALTER TRIGGER &USIM_SCHEMA..usim_rchi_upd_trg ENABLE;
