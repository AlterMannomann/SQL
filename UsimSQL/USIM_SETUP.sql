SET ECHO OFF
SET VERIFY OFF
ALTER SESSION SET NLS_LENGTH_SEMANTICS = 'CHAR';

CLEAR COLUMNS
COLUMN SCRIPTFILE NEW_VAL SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN 'USIM_DROP.sql'
         ELSE 'TESTING/NOTHING_TO_DO.sql'
       END AS SCRIPTFILE
  FROM user_objects
;
-- only run drop, if objects exist
@@&SCRIPTFILE
-- create model
@@USIM_MODEL.sql
-- basic inserts
