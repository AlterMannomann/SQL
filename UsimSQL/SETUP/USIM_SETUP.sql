@@../UTIL/SET_DEFAULT_SPOOL.sql
-- no spool file if started from server
SPOOL LOG/USIM_SETUP.log
-- get system information roughly formatted
@@../UTIL/SYSTEM_INFO.sql
-- Check user
SELECT 'Check USIM user/schema' AS info FROM dual;
-- USIM_LIVE
SELECT CASE
         WHEN USER = 'USIM'
           OR SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') = 'USIM'
         THEN '../UTIL/CHECK_SUCCESSFUL.sql "Acting on schema USIM."'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Wrong user or schema, USIM required."'
       END AS SCRIPTFILE
  FROM dual
;
@@&SCRIPTFILE
-- delete model
@@USIM_DROP.sql
@@../UTIL/VERIFY_DROP.sql
-- build model
@@USIM_MODEL.sql
-- check state of database
@@../UTIL/VERIFY_SYSTEM.sql
SPOOL OFF