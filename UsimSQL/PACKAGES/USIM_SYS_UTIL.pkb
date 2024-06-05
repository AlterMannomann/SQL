CREATE OR REPLACE PACKAGE BODY usim_sys_util
IS
  -- see header for documentation

  PROCEDURE run_script( p_job_name IN VARCHAR2
                      , p_script   IN VARCHAR2 DEFAULT NULL
                      , p_path     IN VARCHAR2 DEFAULT NULL
                      )
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
  END run_script;

  PROCEDURE run_recreate( p_caller   IN VARCHAR2
                        , p_timeout  IN NUMBER DEFAULT NULL
                        )
  IS
    l_job_name        VARCHAR2(128);
    l_package         VARCHAR2(128);
    l_startdate       TIMESTAMP;
    l_enddate         TIMESTAMP;
    l_is_done         INTEGER;
    l_is_schema_done  INTEGER;
    l_status_old      NUMBER;
    l_status_new      NUMBER;
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
    IF p_caller NOT IN (usim_sys_util.PROD_SCHEMA, usim_sys_util.TEST_SCHEMA)
    THEN
      -- do not anything if caller is not USIM or USIM_TEST
      RETURN;
    ELSE
      IF p_caller = usim_sys_util.PROD_SCHEMA
      THEN
        l_job_name := 'USIM_RUN_SERVER_SQL';
        l_package  := 'USIM_APEX';
      ELSE
        l_job_name := 'USIM_RUN_SERVER_SQL_TEST';
        l_package  := 'USIM_TEST';
      END IF;
    END IF;
    l_startdate := SYSTIMESTAMP;
    SELECT status
      INTO l_status_old
      FROM usim_install_state
    ;
    run_script(p_job_name  => l_job_name);
    -- only positive numbers
    IF NVL(p_timeout, 0) > 0
    THEN
      l_enddate := l_startdate + (INTERVAL '1' MINUTE * p_timeout);
    ELSE
      -- overall timeout
      l_enddate := l_startdate + INTERVAL '8' HOUR;
    END IF;
    -- loop until state is changing to get beginning of external job execution
    -- no sleep as things should change fast, but timeout anyway
    LOOP
      SELECT status
        INTO l_status_new
        FROM usim_install_state
      ;
      EXIT WHEN l_status_old != l_status_new OR SYSTIMESTAMP > l_enddate;
    END LOOP;
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
  END run_recreate;

  PROCEDURE run_test(p_script_name IN VARCHAR2 DEFAULT 'USIM_TESTS.sql')
  IS
    l_path VARCHAR2(4000);
  BEGIN
    SELECT directory_path
      INTO l_path
      FROM dba_directories
     WHERE directory_name = 'USIM_TEST_DIR'
    ;
    run_script( p_job_name  => 'USIM_RUN_SERVER_SQL_TEST'
              , p_script    => NVL(p_script_name, 'USIM_TESTS.sql')
              , p_path      => l_path
              )
    ;
  END run_test;

  FUNCTION usim_filetype( p_filename  IN VARCHAR2
                        , p_directory IN VARCHAR2 DEFAULT 'USIM_LOG_DIR'
                        )
    RETURN VARCHAR2
  IS
    l_file        UTL_FILE.FILE_TYPE;
    -- minimum raw buffer is 512
    l_buffer      RAW(512);
    l_bufsize     CONSTANT PLS_INTEGER := 512;
    l_lf          RAW(1);
    l_cr          RAW(1);
    l_line        INTEGER;
    l_type        VARCHAR2(2000);
  BEGIN
    l_type := 'ERROR';
    l_line := -3;
    l_lf   := utl_raw.cast_to_raw(CHR(10));
    l_line := -2;
    l_cr   := utl_raw.cast_to_raw(CHR(13));
    l_line := -1;
    l_file := UTL_FILE.FOPEN(p_directory, p_filename, 'r', l_bufsize);
    l_line := 0;
    LOOP
      -- loop as long as needed to find first line end
      BEGIN
        l_line := l_line +1;
        UTL_FILE.GET_RAW(l_file, l_buffer, l_bufsize);
        -- loop char by char through buffer
        FOR l_idx IN 1..l_bufsize
        LOOP
          IF utl_raw.SUBSTR(l_buffer, l_idx, 1) = l_cr
          THEN
              -- first found CR, checkout if Windows or Mac
              IF utl_raw.SUBSTR(l_buffer, l_idx + 1, 1) = l_lf
              THEN
                l_type := 'CRLF';
              ELSE
                l_type := 'CR';
              END IF;
              EXIT;
          END IF;
          IF utl_raw.SUBSTR(l_buffer, l_idx, 1) = l_lf
          THEN
              -- first found LF, so UNIX style
              l_type := 'LF';
              EXIT;
          END IF;
        END LOOP;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          -- read until end if needed: no data found and no line end delimiter found
          l_type := 'ERROR no CR or LF found in ' || p_filename|| ' directory: ' || p_directory;
          EXIT;
      END;
      EXIT WHEN l_type != 'ERROR';
    END LOOP;
    UTL_FILE.FCLOSE(l_file);
    RETURN l_type;
  EXCEPTION
    WHEN OTHERS THEN
      RETURN 'Error USIM_FILETYPE filename: ' || p_filename || ' directory: ' || p_directory || ' line: ' || l_line || ' ' || SQLERRM;
  END usim_filetype;

  FUNCTION agent_to_platform(p_user_agent IN VARCHAR2)
    RETURN VARCHAR2
  IS
    l_return VARCHAR2(10);
  BEGIN
    IF INSTR(UPPER(p_user_agent), 'WINDOWS') > 0
    THEN
      l_return := 'WINDOWS';
    ELSE
      l_return := 'OTHERS';
    END IF;
    RETURN l_return;
  END agent_to_platform;

  FUNCTION load_log( p_filename  IN VARCHAR2
                   , p_platform  IN VARCHAR2 DEFAULT 'Win32'
                   , p_directory IN VARCHAR2 DEFAULT 'USIM_LOG_DIR'
                   )
    RETURN CLOB
  IS
    l_clob        CLOB;
    l_file        UTL_FILE.FILE_TYPE;
    l_buffer      VARCHAR2(10024);
    l_bufsize     CONSTANT PLS_INTEGER := 10024;
    l_crlf        VARCHAR2(2) := CHR(13) || CHR(10);
    l_lf          VARCHAR2(1) := CHR(10);
    l_buffer_crlf VARCHAR(32000);
    l_line        INTEGER;
    l_filetype    VARCHAR2(2000);
    l_system      VARCHAR2(128);
  BEGIN
    IF INSTR(UPPER(p_platform), 'WIN') > 0
    THEN
      l_system := 'WINDOWS';
    ELSE
      l_system := 'OTHERS';
    END IF;
    l_line := -3;
    l_filetype := usim_filetype(p_filename, p_directory);
    IF INSTR(UPPER(l_filetype), 'ERROR') > 0
    THEN
      RETURN 'ERROR USIM_LOAD_LOG checking file type: ' || l_filetype;
    END IF;
    l_line := -2;
    l_file := UTL_FILE.FOPEN(p_directory, p_filename, 'r', l_bufsize);
    l_line := -1;
    DBMS_LOB.CREATETEMPORARY(l_clob, TRUE, DBMS_LOB.CALL);
    l_line := 0;
    LOOP
      BEGIN
        l_line := l_line +1;
        UTL_FILE.GET_LINE(l_file, l_buffer);
        -- empty buffers through different lf/crlf settings cause errors if running APEX on windows.
        IF l_buffer IS NULL
        THEN
          IF l_filetype != 'CRLF' AND l_system = 'WINDOWS'
          THEN
            l_buffer_crlf := l_crlf;
          ELSE
            l_buffer_crlf := l_lf;
          END IF;
        ELSE
          IF l_filetype != 'CRLF' AND l_system = 'WINDOWS'
          THEN
            l_buffer_crlf := RTRIM(REPLACE(l_buffer, l_lf, l_crlf)) || l_crlf;
          ELSE
            l_buffer_crlf := RTRIM(l_buffer);
          END IF;
        END IF;
        DBMS_LOB.WRITEAPPEND(l_clob, LENGTH(l_buffer_crlf), l_buffer_crlf);
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          -- read until end: no data found
          EXIT;
      END;
    END LOOP;
    UTL_FILE.FCLOSE(l_file);
    -- add debug information on file
    l_buffer_crlf := 'File type: ' || l_filetype || ' client platform: ' || l_system || ' platform parameter: ' || p_platform;
    DBMS_LOB.WRITEAPPEND(l_clob, LENGTH(l_buffer_crlf), l_buffer_crlf);
    RETURN l_clob;
  EXCEPTION
    WHEN OTHERS THEN
      l_clob := 'Error USIM_LOAD_LOG filename: ' || p_filename || ' directory: ' || p_directory || ' line: ' || l_line || ' ' || SQLERRM;
      RETURN l_clob;
  END load_log;

END usim_sys_util;
/

