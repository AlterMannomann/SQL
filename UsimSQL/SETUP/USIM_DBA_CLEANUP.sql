-- you will need a user with sufficient rights to run this script
@@../UTIL/SET_EXTENDED_SPOOL.sql
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
-- DROP PROCEDURES
SELECT CASE
         WHEN COUNT(*) = 1
         THEN '../PROCEDURES/DROP/DROP_USIM_RUN_SCRIPT.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "USIM_RUN_SCRIPT procedure does not exists."'
       END AS SCRIPTFILE
  FROM dba_objects
 WHERE object_name LIKE 'USIM_RUN_SCRIPT'
   AND object_type = 'PROCEDURE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) = 1
         THEN '../PROCEDURES/DROP/DROP_USIM_RUN_RECREATE.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "USIM_RUN_RECREATE procedure does not exists."'
       END AS SCRIPTFILE
  FROM dba_objects
 WHERE object_name LIKE 'USIM_RUN_RECREATE'
   AND object_type = 'PROCEDURE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) = 1
         THEN '../PROCEDURES/DROP/DROP_USIM_RUN_RECREATE_TEST.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "USIM_RUN_RECREATE_TEST procedure does not exists."'
       END AS SCRIPTFILE
  FROM dba_objects
 WHERE object_name LIKE 'USIM_RUN_RECREATE_TEST'
   AND object_type = 'PROCEDURE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) = 1
         THEN '../PROCEDURES/DROP/DROP_USIM_RUN_TEST.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "USIM_RUN_TEST procedure does not exists."'
       END AS SCRIPTFILE
  FROM dba_objects
 WHERE object_name LIKE 'USIM_RUN_TEST'
   AND object_type = 'PROCEDURE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) = 1
         THEN '../PROCEDURES/DROP/DROP_USIM_RUN_TESTDATA.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "USIM_RUN_TESTDATA procedure does not exists."'
       END AS SCRIPTFILE
  FROM dba_objects
 WHERE object_name LIKE 'USIM_RUN_TESTDATA'
   AND object_type = 'PROCEDURE'
;
@@&SCRIPTFILE
-- DROP JOBS AND PROGRAMS
SELECT CASE
         WHEN COUNT(*) > 0
         THEN 'USIM_DROP_JOBS.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Tablespace USIM_LIVE does not exist."'
       END AS SCRIPTFILE
  FROM dba_objects
 WHERE object_name IN ('RUN_SERVER_SQL', 'RUN_SERVER_SQL_TEST', 'RUN_SQL', 'RUN_SQL_TEST')
   AND owner = USER
;
@@&SCRIPTFILE
-- DROP CREDENTIALS
SELECT CASE
         WHEN COUNT(*) > 0
         THEN 'USIM_DROP_CREDENTIALS.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Credentials OS_ACCESS, DB_ACCESS and DB_ACCESS_TEST does not exists."'
       END AS SCRIPTFILE
  FROM dba_credentials
 WHERE owner = USER
   AND credential_name IN ('OS_ACCESS', 'DB_ACCESS', 'DB_ACCESS_TEST')
;
@@&SCRIPTFILE
-- DROP DIRECTORIES
SELECT CASE
         WHEN COUNT(*) = 3
         THEN 'USIM_DROP_DIRECTORIES.sql'
         WHEN COUNT(*) = 0
         THEN '../UTIL/NOTHING_TO_DO.sql "Directories USIM_DIR, USIM_HIST_DIR and USIM_SCRIPT_DIR do not exists."'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Cleanup failed remove directories manually before."'
       END AS SCRIPTFILE
  FROM dba_directories
 WHERE directory_name IN ('USIM_DIR', 'USIM_HIST_DIR', 'USIM_SCRIPT_DIR')
;
@@&SCRIPTFILE
SPOOL OFF