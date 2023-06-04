CREATE OR REPLACE PACKAGE usim_debug IS
  /* PACKAGE USIM_DEBUG
   * Package is session dependend. Debug mode is
   * disabled by default and if set only valid in the
   * the current session.
   */

  /* Function USIM_DEBUG.IS_DEBUG_ON
   * Check debug state in PL/SQL Code.
   *
   * RETURNS
   * TRUE if debug is enabled for this session, otherwise FALSE.
   */
  FUNCTION is_debug_on
    RETURN BOOLEAN
  ;

  /* Function USIM_DEBUG.IS_DEBUG
   * Check debug state in SQL.
   *
   * RETURNS
   * TRUE if debug is enabled for this session, otherwise FALSE.
   */
  FUNCTION is_debug
    RETURN VARCHAR2
  ;

  /* Procedure USIM_DEBUG.SET_DEBUG_ON
   * Activate debug state.
   */
  PROCEDURE set_debug_on;

  /* Procedure USIM_DEBUG.SET_DEBUG_ON
   * Deactivate debug state.
   */
  PROCEDURE set_debug_off;

  /* Function USIM_DEBUG.START_DEBUG
   * Starts a debug session, if debug state is
   * on for this session.
   *
   * RETURNS
   * A new debug id or NULL if debug state is
   * not set.
   */
  FUNCTION start_debug
    RETURN usim_debug_log.usim_id_dlg%TYPE
  ;

  /* Procedure USIM_DEBUG.DEBUG_LOG
   * Creates a debug log entry in USIM_DEBUG_LOG if debug state
   * is set. Requires a valid id from START_DEBUG.
   *
   * PARAMETER
   *
   */
  PROCEDURE debug_log( p_usim_id_dlg        IN usim_debug_log.usim_id_dlg%TYPE
                     , p_usim_status        IN usim_debug_log.usim_status%TYPE
                     , p_usim_log_object    IN usim_debug_log.usim_log_object%TYPE
                     , p_usim_log_content   IN VARCHAR2
                     )
  ;

  PROCEDURE debug_log( p_usim_id_dlg        IN usim_debug_log.usim_id_dlg%TYPE
                     , p_usim_status        IN usim_debug_log.usim_status%TYPE
                     , p_usim_log_object    IN usim_debug_log.usim_log_object%TYPE
                     , p_usim_log_content   IN usim_debug_log.usim_log_content%TYPE
                     )
  ;

END usim_debug;
/