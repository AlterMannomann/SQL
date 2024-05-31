CREATE OR REPLACE FUNCTION usim_filetype( p_filename  IN VARCHAR2
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
END;
/