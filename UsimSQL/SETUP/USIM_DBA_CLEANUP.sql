-- you will need a user with sufficient rights to run this script
@@../UTIL/SET_DEFAULT_SPOOL.sql
-- clean up all USIM components
-- start spool
SPOOL LOG/USIM_DBA_CLEANUP.log
-- get system information roughly formatted
@@../UTIL/SYSTEM_INFO.sql

-- DROP USERS
SELECT 'DROP USIM Users' AS info FROM dual;
-- USIM_TEST
SELECT CASE
         WHEN COUNT(*) > 0
         THEN 'USIM_DROP_TESTUSER.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "User USIM_TEST does not exist."'
       END AS SCRIPTFILE
  FROM dba_users
 WHERE username = 'USIM_TEST'
;
@@&SCRIPTFILE
-- USIM
SELECT CASE
         WHEN COUNT(*) > 0
         THEN 'USIM_DROP_USER.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "User USIM does not exist."'
       END AS SCRIPTFILE
  FROM dba_users
 WHERE username = 'USIM'
;
@@&SCRIPTFILE

-- DROP TABLESPACES
SELECT 'DROP USIM Tablespaces' AS info FROM dual;
-- USIM_TEST
SELECT CASE
         WHEN COUNT(*) > 0
         THEN 'USIM_DROP_TEST_TBL_SPC.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Tablespace USIM_TEST does not exist."'
       END AS SCRIPTFILE
  FROM dba_tablespaces
 WHERE tablespace_name = 'USIM_TEST'
;
@@&SCRIPTFILE
-- USIM_LIVE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN 'USIM_DROP_TBL_SPC.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Tablespace USIM_LIVE does not exist."'
       END AS SCRIPTFILE
  FROM dba_tablespaces
 WHERE tablespace_name = 'USIM_LIVE'
;
@@&SCRIPTFILE

-- DROP DIRECTORIES
SELECT CASE
         WHEN COUNT(*) > 0
         THEN 'USIM_DROP_DIRECTORIES.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Directories USIM_DIR and USIM_HIST_DIR do not exists."'
       END AS SCRIPTFILE
  FROM dba_directories
 WHERE directory_name IN ('USIM_DIR', 'USIM_HIST_DIR')
;
@@&SCRIPTFILE

SPOOL OFF