COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
-- USIM_SPO_ZERO3D_V (spz3d)
DROP VIEW &USIM_SCHEMA..usim_spo_zero3d_v;
