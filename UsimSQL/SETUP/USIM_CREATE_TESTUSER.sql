CREATE USER usim_test IDENTIFIED BY &PASS_USIM_TEST;

ALTER USER usim_test
DEFAULT TABLESPACE usim_test
ACCOUNT UNLOCK;

-- QUOTAS
ALTER USER usim_test QUOTA UNLIMITED ON usim_test;

-- ROLES
-- basic roles
GRANT GATHER_SYSTEM_STATISTICS, CONNECT, RESOURCE TO usim_test;

-- privileges
GRANT CREATE VIEW TO usim_test;
GRANT ALL ON DIRECTORY usim_dir TO usim_test;
GRANT ALL ON DIRECTORY usim_hist_dir TO usim_test;
GRANT ALL ON DIRECTORY usim_script_dir TO usim_test;
GRANT ALL ON DIRECTORY usim_log_dir TO usim_test;
GRANT ALL ON DIRECTORY usim_test_dir TO usim_test;
GRANT EXECUTE ON UTL_FILE to usim_test;
GRANT EXECUTE ON DBMS_LOB to usim_test;
GRANT MANAGE SCHEDULER TO usim_test;
GRANT CREATE EXTERNAL JOB TO usim_test;
GRANT EXECUTE ANY PROGRAM TO usim_test;
GRANT ALL ON usim_os_access TO usim_test;
GRANT ALL ON usim_db_access_test TO usim_test;
GRANT ALL ON usim_install_state TO usim_test;
GRANT ALL ON usim_sys_util TO usim_test;
