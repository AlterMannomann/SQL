COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
-- USIM_MLV_STATE_V (mlsv)
DROP VIEW &USIM_SCHEMA..usim_mlv_state_v;
