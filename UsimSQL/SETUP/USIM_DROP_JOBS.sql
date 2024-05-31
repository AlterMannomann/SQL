-- drop sys jobs for usim
DECLARE
  l_result INTEGER;
BEGIN
  SELECT COUNT(*)
    INTO l_result
    FROM dba_objects
   WHERE object_name = 'USIM_RUN_SERVER_SQL'
     AND object_type = 'JOB'
     AND owner = USER
  ;
  IF l_result = 1
  THEN
    DBMS_SCHEDULER.DROP_JOB('USIM_RUN_SERVER_SQL', TRUE);
  END IF;
  SELECT COUNT(*)
    INTO l_result
    FROM dba_objects
   WHERE object_name = 'USIM_RUN_SQL'
     AND object_type = 'PROGRAM'
     AND owner = USER
  ;
  IF l_result = 1
  THEN
    DBMS_SCHEDULER.DROP_PROGRAM('USIM_RUN_SQL', TRUE);
  END IF;
  SELECT COUNT(*)
    INTO l_result
    FROM dba_objects
   WHERE object_name = 'USIM_RUN_SERVER_SQL_TEST'
     AND object_type = 'JOB'
     AND owner = USER
  ;
  IF l_result = 1
  THEN
    DBMS_SCHEDULER.DROP_JOB('USIM_RUN_SERVER_SQL_TEST', TRUE);
  END IF;
  SELECT COUNT(*)
    INTO l_result
    FROM dba_objects
   WHERE object_name = 'USIM_RUN_SQL_TEST'
     AND object_type = 'PROGRAM'
     AND owner = USER
  ;
  IF l_result = 1
  THEN
    DBMS_SCHEDULER.DROP_PROGRAM('USIM_RUN_SQL_TEST', TRUE);
  END IF;
  -- job class also
  SELECT COUNT(*)
    INTO l_result
    FROM dba_scheduler_job_classes
   WHERE job_class_name = 'USIM_JOBS'
  ;
  IF l_result = 1
  THEN
    DBMS_SCHEDULER.DROP_JOB_CLASS(job_class_name => 'USIM_JOBS');
  END IF;
END;
/
