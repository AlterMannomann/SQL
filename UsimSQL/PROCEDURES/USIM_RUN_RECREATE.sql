CREATE OR REPLACE PROCEDURE usim_run_recreate( p_caller   IN VARCHAR2
                                             , p_timeout  IN NUMBER DEFAULT NULL
                                             )
/**
* Wrapper for USIM_RUN_SCRIPT to run setup for USIM main user. Setup will drop also all existing objects of USIM.
* The finished state is detected by the scheduler log entry. Status can be FAILED or SUCCEEDED. There is an overall
* timeout of 8 hours, scripts called should not take longer.
* @param p_caller The schema to use, APEX should submit '#OWNER#' as parameter.
* @param p_timeout The timeout for waiting to finish job in minutes, if NULL (default) wait until finished.
*/
IS
  l_job_name        VARCHAR2(128);
  l_package         VARCHAR2(128);
  l_startdate       TIMESTAMP;
  l_enddate         TIMESTAMP;
  l_is_done         INTEGER;
  l_is_schema_done  INTEGER;
  CURSOR cur_done( cp_startdate IN TIMESTAMP
                 , cp_job_name  IN VARCHAR2
                 )
  IS
    SELECT COUNT(*) AS is_done
      FROM dba_scheduler_job_log
     WHERE job_name  = cp_job_name
       AND operation = 'RUN'
       AND status   IN ('SUCCEEDED', 'FAILED')
       AND log_date  > cp_startdate
  ;
  -- end of install by last object installed, should be USIM_APEX or USIM_TEST package
  CURSOR cur_schema_done( cp_owner    IN VARCHAR2
                        , cp_package  IN VARCHAR2
                        )
  IS
    SELECT COUNT(*)
      FROM dba_objects
     WHERE owner        = cp_owner
       AND object_name  = cp_package
       AND object_type  = 'PACKAGE BODY'
  ;
BEGIN
  -- check caller
  IF p_caller NOT IN ('USIM', 'USIM_TEST')
  THEN
    -- do not anything if caller is not USIM or USIM_TEST
    RETURN;
  ELSE
    IF p_caller = 'USIM'
    THEN
      l_job_name := 'RUN_SERVER_SQL';
      l_package  := 'USIM_APEX';
    ELSE
      l_job_name := 'RUN_SERVER_SQL_TEST';
      l_package  := 'USIM_TEST';
    END IF;
  END IF;
  l_startdate := SYSTIMESTAMP;
  usim_run_script(p_job_name  => l_job_name);
  -- only positive numbers
  IF NVL(p_timeout, 0) > 0
  THEN
    l_enddate := l_startdate + (INTERVAL '1' MINUTE * p_timeout);
  ELSE
    -- overall timeout
    l_enddate := l_startdate + INTERVAL '8' HOUR;
  END IF;
  -- loop until done or timeout
  LOOP
    l_is_done := 0;
    l_is_schema_done := 0;
    OPEN cur_done(l_startdate, l_job_name);
    FETCH cur_done INTO l_is_done;
    CLOSE cur_done;
    OPEN cur_schema_done(p_caller, l_package);
    FETCH cur_schema_done INTO l_is_schema_done;
    CLOSE cur_schema_done;
    EXIT WHEN (l_is_done > 0 AND l_is_schema_done > 0) OR SYSTIMESTAMP > l_enddate;
    DBMS_SESSION.SLEEP(5);
  END LOOP;
END;
/
