-- you will need a user with sufficient rights to run this script
@@../UTIL/SET_DEFAULT_SPOOL.sql
-- start spool
SPOOL LOG/USIM_DBA_SETUP.log
-- get system information roughly formatted
@@../UTIL/SYSTEM_INFO.sql
-- get parameter to use - can be skipped with ok for objects that exist already
ACCEPT USIM_SCRIPTS CHAR PROMPT 'Main directory for script files (a valid server directory like C:\Users\xxx\Documents\SQL\UsimSQL or /opt/oracle/USIM):'
ACCEPT USER_OS CHAR PROMPT 'OS username for DB server: '
ACCEPT PASS_OS CHAR PROMPT 'OS password for DB server: '
ACCEPT PASS_USIM CHAR PROMPT 'Password for user USIM: '
ACCEPT PASS_USIM_TEST CHAR PROMPT 'Password for user USIM_TEST: '
COLUMN USIM_TERMINATOR NEW_VAL USIM_TERMINATOR
SELECT CASE
         WHEN INSTR('&USIM_SCRIPTS', ':') > 0
         THEN '\'
         ELSE '/'
       END AS USIM_TERMINATOR
  FROM dual
;
COLUMN USIM_DIRECTORY NEW_VAL USIM_DIRECTORY
COLUMN USIM_HISTORY NEW_VAL USIM_HISTORY
COLUMN USIM_SETUP NEW_VAL USIM_SETUP
COLUMN USIM_SHELL NEW_VAL USIM_SHELL
SELECT '&USIM_SCRIPTS.&USIM_TERMINATOR.JS' AS USIM_DIRECTORY
     , '&USIM_SCRIPTS.&USIM_TERMINATOR.JS&USIM_TERMINATOR.SpaceLog' AS USIM_HISTORY
     , '&USIM_SCRIPTS.&USIM_TERMINATOR.SETUP' AS USIM_SETUP
     , '&USIM_SCRIPTS.&USIM_TERMINATOR.SH' AS USIM_SHELL
  FROM dual
;
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
-- CREATE CREDENTIALS
SELECT CASE
         WHEN COUNT(*) = 0
         THEN 'USIM_CREATE_CREDENTIALS.sql'
         WHEN COUNT(*) = 3
         THEN '../UTIL/NOTHING_TO_DO.sql "Credentials OS_ACCESS, DB_ACCESS and DB_ACCESS_TEST already exists."'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Cleanup failed remove credentials manually before."'
       END AS SCRIPTFILE
  FROM dba_credentials
 WHERE owner = USER
   AND credential_name IN ('OS_ACCESS', 'DB_ACCESS', 'DB_ACCESS_TEST')
;
@@&SCRIPTFILE
-- CREATE DIRECTORY, we expect a proper cleanup, may fail if cleanup failed
SELECT CASE
         WHEN COUNT(*) = 0
         THEN 'USIM_CREATE_DIRECTORIES.sql'
         WHEN COUNT(*) = 3
         THEN '../UTIL/NOTHING_TO_DO.sql "Directories USIM_DIR, USIM_HIST_DIR and USIM_SCRIPT_DIR already exists."'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Cleanup failed remove directories manually before."'
       END AS SCRIPTFILE
  FROM dba_directories
 WHERE directory_name IN ('USIM_DIR', 'USIM_HIST_DIR', 'USIM_SCRIPT_DIR')
;
@@&SCRIPTFILE
-- CREATE JOBS, we expect a proper cleanup, may fail if cleanup failed
SELECT CASE
         WHEN NVL(SUM(installed), 0) = 0
         THEN 'USIM_CREATE_JOBS.sql'
         WHEN SUM(installed) = 4
         THEN '../UTIL/NOTHING_TO_DO.sql "Job RUN_SERVER_SQL and program RUN_SQL already exists for live and test."'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Cleanup failed remove job and program manually before."'
       END AS SCRIPTFILE
  FROM (SELECT CASE
                 WHEN object_name IN ('RUN_SERVER_SQL', 'RUN_SERVER_SQL_TEST')
                  AND object_type = 'JOB'
                 THEN 1
                 WHEN object_name IN ('RUN_SQL', 'RUN_SQL_TEST')
                  AND object_type = 'PROGRAM'
                 THEN 1
                 ELSE 0
               END AS installed
          FROM dba_objects
         WHERE object_name IN ('RUN_SERVER_SQL', 'RUN_SERVER_SQL_TEST', 'RUN_SQL', 'RUN_SQL_TEST')
           AND owner = USER
       )
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