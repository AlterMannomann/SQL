CREATE OR REPLACE PACKAGE usim_debug IS
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
  * Activate debug state.
  */
  PROCEDURE set_debug_on;

  /**
  * Deactivate debug state.
  */
  PROCEDURE set_debug_off;

  /**
  * Starts a debug session, if debug state is
  * on for this session.
  * @return A new debug id or NULL if debug state is not set.
  */
  FUNCTION start_debug
    RETURN usim_debug_log.usim_id_dlg%TYPE
  ;

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

END usim_debug;
/