CREATE OR REPLACE PROCEDURE usim_run_testdata
/**
* Wrapper for USIM_RUN_SCRIPT to run test script for USIM_TEST main user.
*/
IS
  l_path VARCHAR2(4000);
BEGIN
  SELECT directory_path || delimiter || 'TESTING' AS test_path
    INTO l_path
    FROM (SELECT directory_path
               , CASE
                   WHEN INSTR(directory_path, ':')
                   THEN '\'
                   ELSE '/'
                 END AS delimiter
            FROM dba_directories
           WHERE directory_name = 'USIM_SCRIPT_DIR'
         )
  ;
  usim_run_script( p_job_name  => 'USIM_RUN_SERVER_SQL_TEST'
                 , p_script    => 'BASIC_TEST_DATA_SETUP.sql'
                 , p_path      => l_path
                 )
  ;
END;
/
