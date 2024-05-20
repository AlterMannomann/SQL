COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
-- USIM_REL_MLV_DIM (rmd) sequence
CREATE SEQUENCE &USIM_SCHEMA..usim_rmd_id_seq
  MINVALUE 1
  MAXVALUE 99999999999999999999999999999999999999
  INCREMENT BY 1
  START WITH 1
  NOCACHE
  NOORDER
  CYCLE
  NOKEEP
  NOSCALE
  GLOBAL
;