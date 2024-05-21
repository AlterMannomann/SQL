CREATE OR REPLACE PROCEDURE usim_run_script( p_job_name IN VARCHAR2
                                           , p_script   IN VARCHAR2 DEFAULT NULL
                                           , p_path     IN VARCHAR2 DEFAULT NULL
                                           )
/**
* Starts the scheduler job to run a given script or recreate of the schema. If script is not
* given the setup scripts are run that recreate the schema. No checks are done on the given
* script so it may fail on execution. Reserved by SYS. Timeout has to be controlled by provided
* procedures granted to USIM users.
* @param p_job_name Mandatory. The job to run, e.g. RUN_SERVER_SQL or RUN_SERVER_SQL_TEST.
* @param p_script Either NULL or a valid file name including extension that exists on the database server.
* @param p_path Either NULL or a valid path that exists on the database server.
*/
IS
BEGIN
    IF p_script IS NOT NULL
    THEN
      -- set parameter
      DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE( job_name       => p_job_name
                                           , argument_name  => 'SCRIPT_NAME'
                                           , argument_value => p_script
                                           )
      ;
    END IF;
    IF p_path IS NOT NULL
    THEN
      -- set parameter
      DBMS_SCHEDULER.SET_JOB_ARGUMENT_VALUE( job_name       => p_job_name
                                           , argument_name  => 'SCRIPT_PATH'
                                           , argument_value => p_path
                                           )
      ;
    END IF;
    -- run job once
    DBMS_SCHEDULER.RUN_JOB(job_name => p_job_name);
END;
/
