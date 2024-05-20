-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
-- fk base-mirror relation between nodes in usim_space (for documentation, if disabled)
ALTER TABLE &USIM_SCHEMA..usim_spc_pos
  ADD CONSTRAINT usim_spo_pos_fk
  FOREIGN KEY (usim_id_pos) REFERENCES usim_position (usim_id_pos) ON DELETE CASCADE
  ENABLE
;
