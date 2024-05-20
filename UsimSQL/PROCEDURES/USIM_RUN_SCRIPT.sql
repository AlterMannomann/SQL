-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
PROCEDURE &USIM_SCHEMA..usim_run_script( p_script   IN VARCHAR2 DEFAULT NULL
                                       , p_path     IN VARCHAR2 DEFAULT NULL
                                       , p_timeout  IN NUMBER   DEFAULT 300
                                       )
/**
* Starts the scheduler job to run a given script or recreate of the schema. If script is not
* given the setup scripts are run that recreate the schema. No checks are done on the given
* script so it may fail on execution. Do not use scripts that spool output. Output is captured
* by the job. Only ONE RUN_SERVER_JOB% can exist per user. If script path is not given the
* default path ./SETUP is used.
* @param p_script Either NULL or a valid file name including extension that exists on the database server.
* @param p_path Either NULL or a valid path that exists on the database server.
* @param p_timeout The timeout in seconds to wait that a job finishes. Default is 5 minutes. Invalid timeout leads to using the default.
*/
IS
  l_job_name  VARCHAR2(128);
  l_job_runs  INTEGER;
  l_job_end   DATE;
  l_timeout   NUMBER;
  l_jobs      INTEGER;
BEGIN
  SELECT COUNT(*)
    INTO l_jobs
    FROM all_scheduler_jobs
   WHERE job_name LIKE 'RUN_SERVER_SQL%'
  ;
  IF l_jobs = 1
  THEN
    SELECT owner || '.' || job_name
      INTO l_job_name
      FROM all_scheduler_jobs
     WHERE job_name LIKE 'RUN_SERVER_SQL%'
    ;
  ELSE
    -- log error
    l_job_name := NULL;
    usim_erl.log_error('usim_run_script', 'Wrong setup! No or too many RUN_SERVER_SQL% job exist Job count: ' || l_jobs);
  END IF;
  IF l_job_name IS NOT NULL
  THEN
    IF p_script IS NOT NULL
    THEN
      -- set parameter
      DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE( job_name       => l_job_name
                                           , argument_name  => 'SCRIPT_NAME'
                                           , argument_value => p_script
                                           )
      ;
    END IF;
    IF p_path IS NOT NULL
    THEN
      -- set parameter
      DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE( job_name       => l_job_name
                                           , argument_name  => 'SCRIPT_PATH'
                                           , argument_value => p_path
                                           )
      ;
    END IF;
    IF p_timeout > 0
    THEN
      l_timeout =: p_timeout;
    ELSE
      l_timeout := 300;
    END IF;
    l_job_end := SYSDATE + l_timeout/86400;
    -- run job once
    DBMS_SCHEDULER.RUN_JOB(job_name => l_job_name);
    -- wait until job finished
    WHILE TRUE
    LOOP
      SELECT COUNT(*)
        INTO l_job_runs
        FROM all_scheduler_running_jobs
       WHERE job_name = l_job_name
      ;
      EXIT WHEN l_job_runs = 0;
      IF l_job_end > SYSDATE
      THEN
        usim_erl.log_error('usim_run_script', 'Job ' || l_job_name || ' run is over used timeout ' || l_timeout || '. Check scheduler.');
        EXIT;
      END IF;
    END LOOP;
  END IF;
END;
/
