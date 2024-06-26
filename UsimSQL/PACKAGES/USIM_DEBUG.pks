-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
CREATE OR REPLACE PACKAGE &USIM_SCHEMA..usim_debug
IS
  /** A package for debugging purposes.
  *
  * Package is session dependend. Debug mode is
  * disabled by default and if set only valid in the
  * the current session.
  */

  /**
  * Check debug state in PL/SQL Code.
  * @return TRUE if debug is enabled for this session, otherwise FALSE.
  */
  FUNCTION is_debug_on
    RETURN BOOLEAN
  ;

  /**
  * Check debug state in SQL.
  * @return "TRUE" if debug is enabled for this session, otherwise "FALSE".
  */
  FUNCTION is_debug
    RETURN VARCHAR2
  ;

  /**
  * Activate debug state and intialize an internal debug id which can be used
  * for the whole session.
  */
  PROCEDURE set_debug_on;

  /**
  * Deactivate debug state.
  */
  PROCEDURE set_debug_off;

  /**
  * Starts a debug session, if debug state is on for this session and user wants to control
  * the debug ids.
  * @return A new debug id or NULL if debug state is not set.
  */
  FUNCTION start_debug
    RETURN usim_debug_log.usim_id_dlg%TYPE
  ;

  /**
  * Returns a text representation of supported status values.
  * @param p_usim_status The status value to get the text representation for.
  * @return The text for the given status value or UNKNOWN.
  */
  FUNCTION debug_status_txt(p_usim_status IN usim_debug_log.usim_status%TYPE)
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Delete all entries of the current debug log.
  */
  PROCEDURE purge_log;

  /**
  * Creates a debug log entry in USIM_DEBUG_LOG if debug state
  * is set. Requires a valid id from START_DEBUG.
  * @param p_usim_id_dlg The debug ID to use.
  * @param p_usim_status The debug status for this debug entry.
  * @param p_usim_log_object The function or procedure name, e.g. USIM_DEBUG.DEBUG_LOG.
  * @param p_usim_log_content The debug message to use limited to VARCHAR2 size.
  */
  PROCEDURE debug_log( p_usim_id_dlg        IN usim_debug_log.usim_id_dlg%TYPE
                     , p_usim_status        IN usim_debug_log.usim_status%TYPE
                     , p_usim_log_object    IN usim_debug_log.usim_log_object%TYPE
                     , p_usim_log_content   IN VARCHAR2
                     )
  ;

  /**
  * Creates a debug log entry in USIM_DEBUG_LOG if debug state
  * is set. Requires a valid id from START_DEBUG.
  * @param p_usim_id_dlg The debug ID to use.
  * @param p_usim_status The debug status for this debug entry.
  * @param p_usim_log_object The function or procedure name, e.g. USIM_DEBUG.DEBUG_LOG.
  * @param p_usim_log_content The debug message to use limited to CLOB size.
  */
  PROCEDURE debug_log( p_usim_id_dlg        IN usim_debug_log.usim_id_dlg%TYPE
                     , p_usim_status        IN usim_debug_log.usim_status%TYPE
                     , p_usim_log_object    IN usim_debug_log.usim_log_object%TYPE
                     , p_usim_log_content   IN usim_debug_log.usim_log_content%TYPE
                     )
  ;

  /**
  * Creates a debug log entry in USIM_DEBUG_LOG if debug state
  * is set. Uses internal session debug id.
  * @param p_usim_log_object The function or procedure name, e.g. USIM_DEBUG.DEBUG_LOG.
  * @param p_usim_log_content The debug message to use limited to CLOB size.
  * @param p_usim_status The debug status for this debug entry. Default 2 INFO.
  */
  PROCEDURE debug_log( p_usim_log_object    IN usim_debug_log.usim_log_object%TYPE
                     , p_usim_log_content   IN usim_debug_log.usim_log_content%TYPE
                     , p_usim_status        IN usim_debug_log.usim_status%TYPE      DEFAULT 2
                     )
  ;

END usim_debug;
/