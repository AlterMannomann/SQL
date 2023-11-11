-- default settings for spooling log files
SET ECHO OFF
SET VERIFY OFF
SET TRIMSPOOL ON
SET LINESIZE 9999
SET PAGESIZE 9999
-- limit CLOB display to 2000 char
SET LONG 2000
SET LONGCHUNKSIZE 2000
SET FEEDBACK ON
SET NULL 'NULL'
SET SERVEROUTPUT ON SIZE UNLIMITED
WHENEVER SQLERROR EXIT FAILURE ROLLBACK
WHENEVER OSERROR EXIT FAILURE ROLLBACK
CLEAR COLUMNS
-- used for setting script file names to execute
COLUMN SCRIPTFILE NEW_VAL SCRIPTFILE
-- used for setting log file names to spool
COLUMN LOGFILE NEW_VAL LOGFILE

