CREATE USER usim IDENTIFIED BY &PASS_USIM;
ALTER USER usim
DEFAULT TABLESPACE usim_live
ACCOUNT UNLOCK;
-- QUOTAS
ALTER USER usim QUOTA UNLIMITED ON usim_live;
-- ROLES
-- basic roles
GRANT GATHER_SYSTEM_STATISTICS, CONNECT, RESOURCE TO usim;
-- privileges
GRANT CREATE VIEW TO usim;
GRANT ALL ON DIRECTORY usim_dir TO usim;
GRANT ALL ON DIRECTORY usim_hist_dir TO usim;
GRANT EXECUTE ON UTL_FILE to usim;
GRANT EXECUTE ON DBMS_LOB to usim;
GRANT MANAGE SCHEDULER TO usim;
GRANT CREATE EXTERNAL JOB TO usim;
GRANT EXECUTE ANY PROGRAM TO usim;
GRANT ALL ON DIRECTORY usim_dir TO usim;
GRANT ALL ON DIRECTORY usim_hist_dir TO usim;
GRANT ALL ON DIRECTORY usim_script_dir TO usim;
GRANT ALL ON os_access TO usim;
GRANT ALL ON db_access TO usim;
GRANT ALL ON run_sql TO usim;
GRANT ALL ON run_server_sql TO usim;
GRANT ALL ON usim_run_recreate TO usim;
GRANT ALL ON usim_run_script TO usim;
GRANT ALL ON usim_install_state TO usim;
--COLUMN CUR_DBA NEW_VAL CUR_DBA
--SELECT USER AS CUR_DBA FROM dual;
--CREATE SYNONYM usim.usim_run_recreate FOR "&CUR_DBA".usim_run_recreate;
--CREATE SYNONYM usim.usim_is_installed FOR "&CUR_DBA".usim_is_installed;
--CREATE SYNONYM usim.usim_is_installed_txt FOR "&CUR_DBA".usim_is_installed_txt;
--CREATE SYNONYM usim.usim_is_test FOR "&CUR_DBA".usim_is_test;
--CREATE SYNONYM usim.usim_is_test_txt FOR "&CUR_DBA".usim_is_test_txt;
--CREATE SYNONYM usim.usim_install_state FOR "&CUR_DBA".usim_install_state;