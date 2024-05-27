-- you will need a user with sufficient rights to run this script
@@../UTIL/SET_EXTENDED_SPOOL.sql
-- clean up all USIM components
-- start spool
SPOOL LOG/USIM_DBA_CLEANUP.log
-- get system information roughly formatted
@@../UTIL/SYSTEM_INFO.sql

-- DROP PUBLIC SYNONYMS
SELECT 'DROP USIM related public synonyms' AS info FROM dual;
SELECT CASE
         WHEN COUNT(*) = 5
         THEN 'DROP_USIM_PUBLIC_SYNONYMS.sql'
         WHEN COUNT(*) = 0
         THEN '../UTIL/NOTHING_TO_DO.sql "Public synonyms do not exists."'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Setup failed remove public synonyms manually."'
       END AS SCRIPTFILE
  FROM dba_objects
 WHERE owner        = 'PUBLIC'
   AND object_type  = 'SYNONYM'
   AND object_name IN ('USIM_INSTALL_STATE', 'USIM_RUN_SCRIPT', 'USIM_RUN_RECREATE', 'USIM_RUN_TEST', 'USIM_RUN_TESTDATA')
;
@@&SCRIPTFILE
-- DROP VIEWS
SELECT 'DROP USIM related views' AS info FROM dual;
SELECT CASE
         WHEN COUNT(*) = 1
         THEN '../VIEW/DROP/DROP_USIM_INSTALL_STATE.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "View USIM_INSTALL_STATE does not exists."'
       END AS SCRIPTFILE
  FROM dba_objects
 WHERE object_name = 'USIM_INSTALL_STATE'
   AND object_type = 'VIEW'
;
@@&SCRIPTFILE
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
SELECT 'DROP USIM related procedures' AS info FROM dual;
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
SELECT 'DROP USIM related jobs and programs' AS info FROM dual;
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
SELECT 'DROP USIM related credentials' AS info FROM dual;
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
SELECT 'DROP USIM related directories' AS info FROM dual;
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
SELECT owner, object_name, object_type, status FROM dba_objects WHERE status != 'VALID';
SPOOL OFF