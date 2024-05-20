-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
ALTER TABLE &USIM_SCHEMA..usim_spc_pos DROP CONSTRAINT usim_spo_pos_fk;