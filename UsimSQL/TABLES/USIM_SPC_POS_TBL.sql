COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
-- USIM_SPC_POS (spo)
CREATE TABLE &USIM_SCHEMA..usim_spc_pos
  ( usim_id_spc  CHAR(55) NOT NULL ENABLE
  , usim_id_rmd  CHAR(55) NOT NULL ENABLE
  , usim_id_pos  CHAR(55) NOT NULL ENABLE
  )
;
COMMENT ON TABLE &USIM_SCHEMA..usim_spc_pos IS 'Describes the axis coordinate index for a given space node over all dimensions. Will use the alias spo.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_spc_pos.usim_id_spc IS 'The space node id from usim_space.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_spc_pos.usim_id_rmd IS 'The dimension axis id relative to the universe defining the source position on this axis.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_spc_pos.usim_id_pos IS 'The source position on the related dimension axis.';

-- uk
ALTER TABLE &USIM_SCHEMA..usim_spc_pos
  ADD CONSTRAINT usim_spo_uk
  UNIQUE (usim_id_spc, usim_id_rmd, usim_id_pos)
  ENABLE
;

-- update trigger
CREATE OR REPLACE TRIGGER &USIM_SCHEMA..usim_spo_upd_trg
  BEFORE UPDATE ON &USIM_SCHEMA..usim_spc_pos
    FOR EACH ROW
    BEGIN
      RAISE_APPLICATION_ERROR( num => -20001
                             , msg => 'Update requirement not fulfilled. No update allowed.'
                             )
      ;
    END;
/
ALTER TRIGGER &USIM_SCHEMA..usim_spo_upd_trg ENABLE;
