COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
-- USIM_RMD_V (rmdv)
DROP VIEW &USIM_SCHEMA..usim_rmd_v;