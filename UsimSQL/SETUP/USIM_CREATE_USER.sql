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
GRANT ALL ON DIRECTORY usim_log_dir TO usim;
GRANT ALL ON DIRECTORY usim_script_dir TO usim;
GRANT EXECUTE ON UTL_FILE to usim;
GRANT EXECUTE ON DBMS_LOB to usim;
GRANT MANAGE SCHEDULER TO usim;
GRANT CREATE EXTERNAL JOB TO usim;
GRANT EXECUTE ANY PROGRAM TO usim;
GRANT ALL ON usim_os_access TO usim;
GRANT ALL ON usim_db_access TO usim;
GRANT ALL ON usim_install_state TO usim;
GRANT ALL ON usim_sys_util TO usim;
