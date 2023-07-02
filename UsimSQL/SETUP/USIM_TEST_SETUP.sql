@@../UTIL/SET_DEFAULT_SPOOL.sql
--@@../UTIL/SET_EXTENDED_SPOOL.sql
-- start spool
SPOOL LOG/USIM_TESTING.log
-- get system information roughly formatted
@@../UTIL/SYSTEM_INFO.sql

-- Check user
SELECT 'Check USIM user/schema' AS info FROM dual;
-- USIM_LIVE
SELECT CASE
         WHEN USER = 'USIM_TEST'
           OR SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') = 'USIM_TEST'
         THEN '../UTIL/CHECK_SUCCESSFUL.sql "Acting on schema USIM_TEST."'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Wrong user or schema, USIM_TEST required."'
       END AS SCRIPTFILE
  FROM dual
;
@@&SCRIPTFILE

-- delete model
@@USIM_DROP.sql
@@../UTIL/VERIFY_DROP.sql

-- build model
@@USIM_MODEL.sql
-- build test model
@@USIM_TEST_MODEL.sql
-- check state of database
@@../UTIL/VERIFY_SYSTEM.sql
-- run tests
@@../TESTING/USIM_TESTS.sql

-- Test summary
SELECT CASE
         WHEN usim_tests_failed = 0
         THEN 'SUCCESS'
         ELSE 'FAILED'
       END AS status
     , usim_tests_success
     , usim_tests_failed
     , usim_test_object
  FROM usim_test_summary
;
-- Test errors if any
SELECT ter.usim_timestamp
     , tsu.usim_test_object
     , ter.usim_error_msg
  FROM usim_test_errors ter
  LEFT OUTER JOIN usim_test_summary tsu
    ON ter.usim_id_tsu = tsu.usim_id_tsu
 ORDER BY ter.usim_timestamp
;
SPOOL OFF