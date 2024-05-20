-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
-- fk relation space for node (for documentation, if disabled)
ALTER TABLE &USIM_SCHEMA..usim_space
  ADD CONSTRAINT usim_spc_nod_fk
  FOREIGN KEY (usim_id_nod) REFERENCES usim_node (usim_id_nod) ON DELETE CASCADE
  ENABLE
;