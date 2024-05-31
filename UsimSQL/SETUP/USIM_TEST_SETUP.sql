@@../UTIL/SET_DEFAULT_TEST_SPOOL.sql
--@@../UTIL/SET_EXTENDED_SPOOL.sql
SPOOL LOG/USIM_TEST_SETUP.log
-- get system information roughly formatted
@@../UTIL/SYSTEM_INFO.sql

-- Check user
SELECT 'Check USIM user/schema' AS info FROM dual;
-- USIM_LIVE
SELECT CASE
         WHEN USER = 'USIM_TEST'
           OR SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') = 'USIM_TEST'
         THEN '../UTIL/CHECK_SUCCESSFUL.sql "Acting on schema USIM_TEST."'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Wrong user or schema, USIM_TEST required."'
       END AS SCRIPTFILE
  FROM dual
;
@@&SCRIPTFILE
-- delete model
@@USIM_DROP.sql
@@../UTIL/VERIFY_DROP.sql
-- build model
@@USIM_MODEL.sql
-- build test model
@@USIM_TEST_MODEL.sql
-- check state of database
@@../UTIL/VERIFY_SYSTEM.sql
SPOOL OFF