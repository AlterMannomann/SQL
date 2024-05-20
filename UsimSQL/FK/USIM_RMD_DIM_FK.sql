-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
-- fk relation universe/dimension for dimensions (for documentation, if disabled)
ALTER TABLE &USIM_SCHEMA..usim_rel_mlv_dim
  ADD CONSTRAINT usim_rmd_dim_fk
  FOREIGN KEY (usim_id_dim) REFERENCES usim_dimension (usim_id_dim) ON DELETE CASCADE
  ENABLE
;
