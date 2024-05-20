-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
CREATE OR REPLACE PACKAGE &USIM_SCHEMA..usim_erl
IS
  /**A package for actions on table usim_error_log.*/

  /**
  * Writes given possible error informations to usim_error_log as an autonomous transaction.
  * Package functions returning NULL state in most cases an inproper use of functions, if not
  * handled in the calling code explicitly, except for testing. Purge log after testing.
  * Will cut strings to meet the size of the table columns.
  */
  PROCEDURE log_error( p_usim_err_object  IN VARCHAR2
                     , p_usim_err_info    IN VARCHAR2
                     )
  ;

  /**
  * Purges all current saved informations from the usim_error_log table.
  */
  PROCEDURE purge_log;

END usim_erl;
/