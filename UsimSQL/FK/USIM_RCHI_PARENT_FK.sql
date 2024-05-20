-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
-- fk parent-child relation between dimension axis in usim_rel_mlv_dim (for documentation, if disabled)
ALTER TABLE &USIM_SCHEMA..usim_rmd_child
  ADD CONSTRAINT usim_rchi_parent_fk
  FOREIGN KEY (usim_id_rmd) REFERENCES usim_rel_mlv_dim (usim_id_rmd) ON DELETE CASCADE
  ENABLE
;