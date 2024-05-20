-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
-- fk relation to nodes in usim_space (for documentation, if disabled)
ALTER TABLE &USIM_SCHEMA..usim_spc_process
  ADD CONSTRAINT usim_spr_tgt_fk
  FOREIGN KEY (usim_id_spc_target) REFERENCES usim_space (usim_id_spc) ON DELETE CASCADE
  ENABLE
;