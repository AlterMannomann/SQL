CREATE OR REPLACE PACKAGE BODY usim_debug IS
  debug_status  BOOLEAN;
  FUNCTION is_debug_on
    RETURN BOOLEAN
  IS
  BEGIN
    RETURN debug_status;
  END is_debug_on
  ;

  FUNCTION is_debug
    RETURN VARCHAR2
  IS
  BEGIN
    RETURN CASE WHEN debug_status THEN 'TRUE' ELSE 'FALSE' END;
  END is_debug
  ;

  PROCEDURE set_debug_on
  IS
  BEGIN
    debug_status := TRUE;
  END set_debug_on
  ;

  PROCEDURE set_debug_off
  IS
  BEGIN
    debug_status := FALSE;
  END set_debug_off
  ;

  FUNCTION start_debug
    RETURN usim_debug_log.usim_id_dlg%TYPE
  IS
  BEGIN
    IF debug_status
    THEN
      RETURN usim_dlg_id_seq.NEXTVAL;
    ELSE
      RETURN NULL;
    END IF;
  END start_debug
  ;

  PROCEDURE debug_log( p_usim_id_dlg        IN usim_debug_log.usim_id_dlg%TYPE
                     , p_usim_status        IN usim_debug_log.usim_status%TYPE
                     , p_usim_log_object    IN usim_debug_log.usim_log_object%TYPE
                     , p_usim_log_content   IN VARCHAR2
                     )
  IS
    l_usim_log_content  CLOB;
  BEGIN
    IF debug_status AND p_usim_id_dlg IS NOT NULL
    THEN
      l_usim_log_content := p_usim_log_content;
      debug_log(p_usim_id_dlg, p_usim_status, p_usim_log_object, l_usim_log_content);
    END IF;
  END debug_log
  ;

  PROCEDURE debug_log( p_usim_id_dlg        IN usim_debug_log.usim_id_dlg%TYPE
                     , p_usim_status        IN usim_debug_log.usim_status%TYPE
                     , p_usim_log_object    IN usim_debug_log.usim_log_object%TYPE
                     , p_usim_log_content   IN usim_debug_log.usim_log_content%TYPE
                     )
  IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    IF debug_status AND p_usim_id_dlg IS NOT NULL
    THEN
      INSERT INTO usim_debug_log
        ( usim_id_dlg
        , usim_timestamp
        , usim_status
        , usim_log_object
        , usim_log_content
        )
        VALUES
        ( p_usim_id_dlg
        , SYSTIMESTAMP
        , p_usim_status
        , p_usim_log_object
        , p_usim_log_content
        )
      ;
      COMMIT;
    END IF;
  END debug_log
  ;

BEGIN
  -- init debug state for the current session
  debug_status := FALSE;
END usim_debug;
/