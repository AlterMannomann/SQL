-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
ALTER TABLE &USIM_SCHEMA..usim_spc_process DROP CONSTRAINT usim_spr_tgt_fk;