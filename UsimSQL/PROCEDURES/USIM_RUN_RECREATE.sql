CREATE OR REPLACE PROCEDURE usim_run_recreate(p_timeout IN NUMBER DEFAULT 300)
/**
* Wrapper for USIM_RUN_SCRIPT to run setup for USIM main user. Setup will drop also all existing objects of USIM.
* @param p_timeout Default is to wait not longer than 5 minutes for job to finish.
*/
IS
  l_job_runs  INTEGER;
  l_job_end   DATE;
  l_timeout   NUMBER;
BEGIN
  usim_run_script(p_job_name  => 'RUN_SERVER_SQL');
  IF p_timeout > 0
  THEN
    l_timeout := p_timeout;
  ELSE
    l_timeout := 300;
  END IF;
  l_job_end := SYSDATE + l_timeout/86400;
  WHILE TRUE
  LOOP
    SELECT COUNT(*)
      INTO l_job_runs
      FROM all_scheduler_running_jobs
      WHERE job_name = 'RUN_SERVER_SQL'
    ;
    EXIT WHEN l_job_runs = 0 OR SYSDATE > l_job_end;
    -- wait 10 seconds to next check
    DBMS_SESSION.SLEEP(seconds  => 10);
  END LOOP;
END;
/
