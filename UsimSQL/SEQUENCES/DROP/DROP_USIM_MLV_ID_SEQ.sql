COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
-- USIM_MULTIVERSE (mlv) sequence
DROP SEQUENCE &USIM_SCHEMA..usim_mlv_id_seq;