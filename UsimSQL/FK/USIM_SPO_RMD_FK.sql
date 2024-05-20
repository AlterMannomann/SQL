-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
-- fk base-mirror relation between nodes in usim_space (for documentation, if disabled)
ALTER TABLE &USIM_SCHEMA..usim_spc_pos
  ADD CONSTRAINT usim_spo_rmd_fk
  FOREIGN KEY (usim_id_rmd) REFERENCES usim_rel_mlv_dim (usim_id_rmd) ON DELETE CASCADE
  ENABLE
;
