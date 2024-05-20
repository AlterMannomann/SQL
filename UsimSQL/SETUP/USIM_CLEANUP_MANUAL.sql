@@../UTIL/SET_DEFAULT_SPOOL.sql
-- start spool
SELECT CASE
         WHEN SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') = 'USIM_TEST'
         THEN 'LOG/USIM_TEST_CLEANUP.log'
         ELSE 'LOG/USIM_CLEANUP.log'
       END AS LOGFILE
  FROM dual
;
SPOOL &LOGFILE
-- get system information roughly formatted
@@../UTIL/SYSTEM_INFO.sql

-- DROP USIM objects
@@USIM_DROP.sql

@@../UTIL/VERIFY_DROP.sql

SPOOL OFF