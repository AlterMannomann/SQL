ACCEPT PASSW CHAR PROMPT 'Password for user USIM_TEST: '
CREATE USER usim_test IDENTIFIED BY &PASSW;

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
GRANT EXECUTE ON UTL_FILE to usim_test;
GRANT EXECUTE ON DBMS_LOB to usim_test;
