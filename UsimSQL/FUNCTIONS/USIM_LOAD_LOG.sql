CREATE OR REPLACE FUNCTION usim_load_log( p_filename  IN VARCHAR2
                                        , p_platform  IN VARCHAR2 DEFAULT 'Win32'
                                        , p_directory IN VARCHAR2 DEFAULT 'USIM_LOG_DIR'
                                        )
  RETURN CLOB
IS
  /** Function for USIM to read logs from disc.
  * Expect SQL logs with max. linesize 9999 set. Needs to consider that DBA files are probably created on
  * windows and APEX runs as well mostly under windows. May only work with Windows Client and OVA server.
  * If log file is unix type and client is windows the new line is corrected to CRLF.
  * @param p_filename The name of the log file that resides in the given directory, e.g. USIM_SETUP.log.
  * @param p_platform The client platform used. Default is Win32. Useful if enviroments server/client differ to display logs correctly.
  * @param p_directory The name of a valid directory for logs. Default is USIM_LOG_DIR.
  * @return A CLOB containing either the file content or the error message why file could not be loaded.
  */
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
    l_system := 'UNIX';
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
END;
/