-- use PDB SYS user to run this script
/* Run the following script on your install client to get NLS settings
-- from server and set it for any SYS installs
SELECT 'Client To Server NLS' AS direction
     , 'ALTER SESSION SET ' || parameter || ' = ''' || value || ''';' AS statement
  FROM nls_database_parameters
 WHERE parameter IN ('NLS_LANGUAGE', 'NLS_TERRITORY', 'NLS_CURRENCY', 'NLS_ISO_CURRENCY', 'NLS_NUMERIC_CHARACTERS', 'NLS_CALENDAR', 'NLS_DATE_FORMAT', 'NLS_DATE_LANGUAGE', 'NLS_SORT', 'NLS_TIME_FORMAT', 'NLS_TIMESTAMP_FORMAT', 'NLS_TIME_TZ_FORMAT', 'NLS_TIMESTAMP_TZ_FORMAT', 'NLS_DUAL_CURRENCY', 'NLS_COMP', 'NLS_LENGTH_SEMANTICS', 'NLS_NCHAR_CONV_EXCP', 'NLS_CHARACTERSET')
 UNION ALL
SELECT 'Client Back To Client NLS' AS direction
     , 'ALTER SESSION SET ' || parameter || ' = ''' || value || ''';' AS statement
  FROM v$nls_parameters
 WHERE parameter IN ('NLS_LANGUAGE', 'NLS_TERRITORY', 'NLS_CURRENCY', 'NLS_ISO_CURRENCY', 'NLS_NUMERIC_CHARACTERS', 'NLS_CALENDAR', 'NLS_DATE_FORMAT', 'NLS_DATE_LANGUAGE', 'NLS_SORT', 'NLS_TIME_FORMAT', 'NLS_TIMESTAMP_FORMAT', 'NLS_TIME_TZ_FORMAT', 'NLS_TIMESTAMP_TZ_FORMAT', 'NLS_DUAL_CURRENCY', 'NLS_COMP', 'NLS_LENGTH_SEMANTICS', 'NLS_NCHAR_CONV_EXCP', 'NLS_CHARACTERSET')
;
*/
-- set to server setting hardcoded (settings derived from OVA 23ai Free)
ALTER SESSION SET NLS_CHARACTERSET = 'AL32UTF8';
ALTER SESSION SET NLS_NCHAR_CONV_EXCP = 'FALSE';
ALTER SESSION SET NLS_LENGTH_SEMANTICS = 'BYTE';
ALTER SESSION SET NLS_COMP = 'BINARY';
ALTER SESSION SET NLS_DUAL_CURRENCY = '$';
ALTER SESSION SET NLS_TIMESTAMP_TZ_FORMAT = 'DD-MON-RR HH.MI.SSXFF AM TZR';
ALTER SESSION SET NLS_TIME_TZ_FORMAT = 'HH.MI.SSXFF AM TZR';
ALTER SESSION SET NLS_TIMESTAMP_FORMAT = 'DD-MON-RR HH.MI.SSXFF AM';
ALTER SESSION SET NLS_TIME_FORMAT = 'HH.MI.SSXFF AM';
ALTER SESSION SET NLS_SORT = 'BINARY';
ALTER SESSION SET NLS_DATE_LANGUAGE = 'AMERICAN';
ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-RR';
ALTER SESSION SET NLS_CALENDAR = 'GREGORIAN';
ALTER SESSION SET NLS_NUMERIC_CHARACTERS = '.,';
ALTER SESSION SET NLS_ISO_CURRENCY = 'AMERICA';
ALTER SESSION SET NLS_CURRENCY = '$';
ALTER SESSION SET NLS_TERRITORY = 'AMERICA';
ALTER SESSION SET NLS_LANGUAGE = 'AMERICAN';
--@@../UTIL/SET_DEFAULT_SPOOL.sql
@@../UTIL/SET_EXTENDED_SPOOL.sql
-- start spool
SPOOL LOG/USIM_DBA_SETUP.log
-- get system information roughly formatted
@@../UTIL/SYSTEM_INFO.sql
-- get parameter to use - can be skipped with ok for objects that exist already
ACCEPT USIM_SCRIPTS CHAR DEFAULT '/opt/oracle/USIM' PROMPT 'Main directory for script files (a valid server directory like C:\Users\xxx\Documents\SQL\UsimSQL or /opt/oracle/USIM - the default):'
ACCEPT USER_OS CHAR DEFAULT 'oracle' PROMPT 'OS username for DB server (default ORACLE): '
ACCEPT PASS_OS CHAR DEFAULT 'oracle' PROMPT 'OS password for DB server (default oracle): '
ACCEPT PASS_USIM CHAR DEFAULT 'usim' PROMPT 'Password for user USIM (default usim): '
ACCEPT PASS_USIM_TEST CHAR DEFAULT 'usim' PROMPT 'Password for user USIM_TEST (default usim): '
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
COLUMN CONFIG_INFO NEW_VAL CONFIG_INFO
SELECT 'Current configuration' || CHR(13) || CHR(10) ||
       'Main directory: &USIM_SCRIPTS' || CHR(13) || CHR(10) ||
       'Space log directory: &USIM_DIRECTORY' || CHR(13) || CHR(10) ||
       'History log directory: &USIM_HISTORY' || CHR(13) || CHR(10) ||
       'Shell script directory: &USIM_SHELL' || CHR(13) || CHR(10) ||
       'Server user: &USER_OS' || CHR(13) || CHR(10) ||
       'Server user password: &PASS_OS' || CHR(13) || CHR(10) ||
       'USIM password: &PASS_USIM' || CHR(13) || CHR(10) ||
       'USIM_TEST password: &PASS_USIM_TEST' || CHR(13) ||  CHR(10) || CHR(13) || CHR(10) ||
       'Remark: If you care about security this is the wrong application for you. Press Yes to install or No to cancel.' AS CONFIG_INFO
  FROM dual
;
PAUSE &CONFIG_INFO
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
-- CREATE PROCEDURES
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../PROCEDURES/USIM_RUN_SCRIPT.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "USIM_RUN_SCRIPT procedure already exists."'
       END AS SCRIPTFILE
  FROM dba_objects
 WHERE object_name LIKE 'USIM_RUN_SCRIPT'
   AND object_type = 'PROCEDURE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../PROCEDURES/USIM_RUN_RECREATE.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "USIM_RUN_RECREATE procedure already exists."'
       END AS SCRIPTFILE
  FROM dba_objects
 WHERE object_name LIKE 'USIM_RUN_RECREATE'
   AND object_type = 'PROCEDURE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../PROCEDURES/USIM_RUN_RECREATE_TEST.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "USIM_RUN_RECREATE_TEST procedure already exists."'
       END AS SCRIPTFILE
  FROM dba_objects
 WHERE object_name LIKE 'USIM_RUN_RECREATE_TEST'
   AND object_type = 'PROCEDURE'
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