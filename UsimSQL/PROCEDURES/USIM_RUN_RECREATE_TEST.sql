CREATE OR REPLACE PROCEDURE usim_run_recreate_test
/**
* Wrapper for USIM_RUN_SCRIPT to run setup for USIM main user. Setup will drop also all existing objects of USIM.
*/
IS
BEGIN
  usim_run_script(p_job_name  => 'RUN_SERVER_SQL_TEST');
END;
/
