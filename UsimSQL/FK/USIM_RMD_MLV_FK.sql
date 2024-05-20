-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
-- fk relation universe/dimension for universe (for documentation, if disabled)
ALTER TABLE &USIM_SCHEMA..usim_rel_mlv_dim
  ADD CONSTRAINT usim_rmd_mlv_fk
  FOREIGN KEY (usim_id_mlv) REFERENCES usim_multiverse (usim_id_mlv) ON DELETE CASCADE
  ENABLE
;
