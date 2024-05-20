-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
ALTER TABLE &USIM_SCHEMA..usim_rel_mlv_dim DROP CONSTRAINT usim_rmd_dim_fk;