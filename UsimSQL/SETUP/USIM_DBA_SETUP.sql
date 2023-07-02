-- you will need a user with sufficient rights to run this script
@@../UTIL/SET_DEFAULT_SPOOL.sql
-- start spool
SPOOL LOG/USIM_DBA_SETUP.log
-- get system information roughly formatted
@@../UTIL/SYSTEM_INFO.sql

-- CREATE TABLESPACES
SELECT 'CREATE USIM tablespaces' AS info FROM dual;
-- USIM_LIVE
SELECT CASE
         WHEN COUNT(*) = 0
         THEN 'USIM_CREATE_TBL_SPC.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Tablespace USIM_LIVE already exists."'
       END AS SCRIPTFILE
  FROM dba_tablespaces
 WHERE tablespace_name = 'USIM_LIVE'
;
@@&SCRIPTFILE
-- USIM_TEST
SELECT CASE
         WHEN COUNT(*) = 0
         THEN 'USIM_CREATE_TEST_TBL_SPC.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Tablespace USIM_TEST already exists."'
       END AS SCRIPTFILE
  FROM dba_tablespaces
 WHERE tablespace_name = 'USIM_TEST'
;
@@&SCRIPTFILE

-- CREATE USERS
SELECT 'CREATE USIM users' AS info FROM dual;
-- USIM
SELECT CASE
         WHEN COUNT(*) = 0
         THEN 'USIM_CREATE_USER.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "User USIM already exists."'
       END AS SCRIPTFILE
  FROM dba_users
 WHERE username = 'USIM'
;
@@&SCRIPTFILE
-- USIM_TEST
SELECT CASE
         WHEN COUNT(*) = 0
         THEN 'USIM_CREATE_TESTUSER.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "User USIM_TEST already exists."'
       END AS SCRIPTFILE
  FROM dba_users
 WHERE username = 'USIM_TEST'
;
@@&SCRIPTFILE

SPOOL OFF