-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
CREATE OR REPLACE PACKAGE &USIM_SCHEMA..usim_apex
IS
  /**This package is used as an interface to the APEX application
  * providing specialized functions and procedures for use in APEX.
  * BECAUSE F...ING APEX IS TRYING EVEN TO CONVERT STRINGS TO NUMBERS WITHOUT BEING TOLD SO.
  */

  --== package variable definition ==--
  -- default schema fixed, change if needed
  PROD_SCHEMA CONSTANT CHAR(4) := 'USIM';
  -- test schema fixed, change if needed
  TEST_SCHEMA CONSTANT CHAR(9) := 'USIM_TEST';

  /**
  * Provides a possibility to init base data with APEX as AJAX is not able to manage
  * big numbers. Therefore using strings for parameters and check internally for numbers.
  * Will report errors and exceptions to USIM_ERROR_LOG on errors of parameters. Provides also the
  * ability to initialize dimensions and numbers together with base data creation. Will not raise
  * any exception.
  * @param p_max_dimension The maximum dimensions possible for this multiverse.
  * @param p_max_abs_number The absolute maximum number available for this multiverse.
  * @param p_special_overflow Defines the overflow behaviour, default '0' means standard overflow behaviour. If set to '1', all new nodes are created with the universe seed at coordinate 0 as the parent.
  * @param p_init_dimensions If set to '1' will initialize the dimensions as defined by base data. Any other value disables this feature.
  * @param p_init_positions If set to '1' will initialize the possible space positions as defined by base data max number. Any other value disables this feature.
  */
  PROCEDURE run_init_basedata( p_max_dimension    VARCHAR2 DEFAULT '42'
                             , p_max_abs_number   VARCHAR2 DEFAULT '99999999999999999999999999999999999999'
                             , p_special_overflow VARCHAR2 DEFAULT '0'
                             , p_init_dimensions  VARCHAR2 DEFAULT '1'
                             , p_init_positions     VARCHAR2 DEFAULT '1'
                             )
  ;

  /**
  * Returns the state of base data as text. The parameters can be used
  * by translations to set language dependend return strings. Error messages
  * will nevertheless be in the language of the system.
  * @param p_yes_option The return value for base data exists. Defaults to Yes.
  * @param p_no_option The return value for base data do not exists. Defaults to No.
  * @param p_error_option The prefix value for errors in the called functions. Defaults to ERROR.
  * @return The text message related to the state of base data or error information.
  */
  FUNCTION disp_has_basedata( p_yes_option    IN VARCHAR2 DEFAULT 'Yes'
                            , p_no_option     IN VARCHAR2 DEFAULT 'No'
                            , p_error_option  IN VARCHAR2 DEFAULT 'ERROR'
                            )
    RETURN VARCHAR2
  ;

  /**
  * Returns the text information about existing base universe. The parameters can be used
  * by translations to set language dependend return strings. Error messages
  * will nevertheless be in the language of the system.
  * @param p_yes_option The return value for base data exists. Defaults to Yes.
  * @param p_no_option The return value for base data do not exists. Defaults to No.
  * @param p_error_option The prefix value for errors in the called functions. Defaults to ERROR.
  * @return The text message related to the state of a base universe or error information.
  */
  FUNCTION disp_has_base_universe( p_yes_option    IN VARCHAR2 DEFAULT 'Yes'
                                 , p_no_option     IN VARCHAR2 DEFAULT 'No'
                                 , p_error_option  IN VARCHAR2 DEFAULT 'ERROR'
                                 )
    RETURN VARCHAR2
  ;

  /**
  * Returns the text information about maximum dimensions. The parameters can be used
  * by translations to set language dependend return strings. Error messages
  * will nevertheless be in the language of the system.
  * @param p_none_option The display text if no dimensions exist. Defaults to N/A.
  * @param p_error_option The prefix value for errors in the called functions. Defaults to ERROR.
  * @return The text message displaying maximum dimensions or error information.
  */
  FUNCTION disp_max_dimension( p_none_option  IN VARCHAR2 DEFAULT 'N/A'
                             , p_error_option IN VARCHAR2 DEFAULT 'ERROR'
                             )
    RETURN VARCHAR2
  ;

  /**
  * Returns the text information about maximum numbers. The parameters can be used
  * by translations to set language dependend return strings. Error messages
  * will nevertheless be in the language of the system.
  * @param p_none_option The display text if no numbers exist. Defaults to N/A.
  * @param p_error_option The prefix value for errors in the called functions. Defaults to ERROR.
  * @return The text message displaying maximum numbers or error information.
  */
  FUNCTION disp_max_numbers( p_none_option  IN VARCHAR2 DEFAULT 'N/A'
                           , p_error_option IN VARCHAR2 DEFAULT 'ERROR'
                           )
    RETURN VARCHAR2
  ;

  /**
  * Returns the text information about maximum absolute number. The parameters can be used
  * by translations to set language dependend return strings. Error messages
  * will nevertheless be in the language of the system.
  * @param p_none_option The display text if no absolute maximum number exist. Defaults to N/A.
  * @param p_error_option The prefix value for errors in the called functions. Defaults to ERROR.
  * @return The text message displaying the maximum absolute number or error information.
  */
  FUNCTION disp_max_abs_number( p_none_option  IN VARCHAR2 DEFAULT 'N/A'
                              , p_error_option IN VARCHAR2 DEFAULT 'ERROR'
                              )
    RETURN VARCHAR2
  ;

  /**
  * Returns the text information about last processed date. The parameters can be used
  * by translations to set language dependend return strings. Error messages
  * will nevertheless be in the language of the system.
  * @param p_none_option The display text if no processed records exist. Defaults to N/A.
  * @param p_format_option The date format to use. Defaults to DD.MM.YYYY HH24:MI:SS.
  * @param p_error_option The prefix value for errors in the called functions. Defaults to ERROR.
  * @return The text message displaying last processed date or error information.
  */
  FUNCTION disp_last_processed( p_none_option   IN VARCHAR2 DEFAULT 'N/A'
                              , p_format_option IN VARCHAR2 DEFAULT 'DD.MM.YYYY HH24:MI:SS'
                              , p_error_option  IN VARCHAR2 DEFAULT 'ERROR'
                              )
    RETURN VARCHAR2
  ;

  /**
  * Returns the text information about time past since last processed date. The parameters can be used
  * by translations to set language dependend return strings. Error messages
  * will nevertheless be in the language of the system. Format is always Oracle system standard for
  * timestamps subtracted.
  * @param p_none_option The display text if no processed records exist. Defaults to N/A.
  * @param p_error_option The prefix value for errors in the called functions. Defaults to ERROR.
  * @return The text message displaying last processed date or error information.
  */
  FUNCTION disp_since_last_processed( p_none_option   IN VARCHAR2 DEFAULT 'N/A'
                                    , p_error_option  IN VARCHAR2 DEFAULT 'ERROR'
                                    )
    RETURN VARCHAR2
  ;

  /**
  * Returns the text information about amount of processed data. The parameters can be used
  * by translations to set language dependend return strings. Error messages
  * will nevertheless be in the language of the system.
  * @param p_total_option The display text for total of processed. Defaults to "of total".
  * @param p_error_option The prefix value for errors in the called functions. Defaults to ERROR.
  * @return The text message displaying the amount of processed data inclusive total or error information.
  */
  FUNCTION disp_processed( p_total_option IN VARCHAR2 DEFAULT 'total'
                         , p_error_option IN VARCHAR2 DEFAULT 'ERROR'
                         )
    RETURN VARCHAR2
  ;

  /**
  * Returns the text information about amount of unprocessed data. The parameters can be used
  * by translations to set language dependend return strings. Error messages
  * will nevertheless be in the language of the system.
  * @param p_error_option The prefix value for errors in the called functions. Defaults to ERROR.
  * @return The text message displaying the amount of unprocessed data or error information.
  */
  FUNCTION disp_unprocessed(p_error_option IN VARCHAR2 DEFAULT 'ERROR')
    RETURN VARCHAR2
  ;

  /**
  * Returns the text information about amount of existing nodes across universes. The parameters can be used
  * by translations to set language dependend return strings. Error messages
  * will nevertheless be in the language of the system.
  * @param p_error_option The prefix value for errors in the called functions. Defaults to ERROR.
  * @return The text message displaying the amount of existing nodes or error information.
  */
  FUNCTION disp_total_nodes(p_error_option IN VARCHAR2 DEFAULT 'ERROR')
    RETURN VARCHAR2
  ;

  /**
  * Returns the text information about amount of existing universes. The parameters can be used
  * by translations to set language dependend return strings. Error messages
  * will nevertheless be in the language of the system.
  * @param p_error_option The prefix value for errors in the called functions. Defaults to ERROR.
  * @return The text message displaying the amount of existing universes or error information.
  */
  FUNCTION disp_total_universes(p_error_option IN VARCHAR2 DEFAULT 'ERROR')
    RETURN VARCHAR2
  ;

  /**
  * Returns the text information about amount of active dimensions. The parameters can be used
  * by translations to set language dependend return strings. Error messages
  * will nevertheless be in the language of the system.
  * @param p_none_option The display text if no active dimensions exist. Defaults to N/A.
  * @param p_error_option The prefix value for errors in the called functions. Defaults to ERROR.
  * @return The text message displaying the amount of active dimensions or error information.
  */
  FUNCTION disp_active_dimensions( p_none_option  IN VARCHAR2 DEFAULT 'N/A'
                                 , p_error_option IN VARCHAR2 DEFAULT 'ERROR'
                                 )
    RETURN VARCHAR2
  ;

  /**
  * Returns the text information about the minimum and maximum of energy known. The parameters can be used
  * by translations to set language dependend return strings. Error messages
  * will nevertheless be in the language of the system.
  * @param p_none_option The display text if no active dimensions exist. Defaults to N/A.
  * @param p_error_option The prefix value for errors in the called functions. Defaults to ERROR.
  * @return The text message displaying the minimum and maximum energy or error information.
  */
  FUNCTION disp_minmax_energy( p_none_option  IN VARCHAR2 DEFAULT 'N/A'
                             , p_error_option IN VARCHAR2 DEFAULT 'ERROR'
                             )
    RETURN VARCHAR2
  ;

  /**
  * Returns the text information about the minimum and maximum of coordinates known. The parameters can be used
  * by translations to set language dependend return strings. Error messages
  * will nevertheless be in the language of the system.
  * @param p_none_option The display text if no active dimensions exist. Defaults to N/A.
  * @param p_error_option The prefix value for errors in the called functions. Defaults to ERROR.
  * @return The text message displaying the minimum and maximum coordinates or error information.
  */
  FUNCTION disp_minmax_coords( p_none_option  IN VARCHAR2 DEFAULT 'N/A'
                             , p_error_option IN VARCHAR2 DEFAULT 'ERROR'
                             )
    RETURN VARCHAR2
  ;

  /**
  * Returns the text information about the overflow value for positive numbers. The parameters can be used
  * by translations to set language dependend return strings. Error messages
  * will nevertheless be in the language of the system.
  * @param p_none_option The display text if no base data exist. Defaults to N/A.
  * @param p_error_option The prefix value for errors in the called functions. Defaults to ERROR.
  * @return The text message displaying the positive overflow number with a leading + sign or error information.
  */
  FUNCTION disp_max_overflow( p_none_option  IN VARCHAR2 DEFAULT 'N/A'
                            , p_error_option IN VARCHAR2 DEFAULT 'ERROR'
                            )
    RETURN VARCHAR2
  ;

  /**
  * Returns the text information about the underflow value for positive numbers. The parameters can be used
  * by translations to set language dependend return strings. Error messages
  * will nevertheless be in the language of the system.
  * @param p_prefix The prefix value to avoid that APEX tries to convert anything. Default NULL. In case of conversion errors in APEX set it to clear string value, e.g. 'at ', ':'.
  * @param p_none_option The display text if no base data exist. Defaults to N/A.
  * @param p_error_option The prefix value for errors in the called functions. Defaults to ERROR.
  * @return The text message displaying the positive underflow number with a leading + sign or error information.
  */
  FUNCTION disp_max_underflow( p_prefix       IN VARCHAR2 DEFAULT NULL
                             , p_none_option  IN VARCHAR2 DEFAULT 'N/A'
                             , p_error_option IN VARCHAR2 DEFAULT 'ERROR'
                             )
    RETURN VARCHAR2
  ;

  /**
  * Returns the text information about the overflow value for negative numbers. The parameters can be used
  * by translations to set language dependend return strings. Error messages
  * will nevertheless be in the language of the system.
  * @param p_none_option The display text if no base data exist. Defaults to N/A.
  * @param p_error_option The prefix value for errors in the called functions. Defaults to ERROR.
  * @return The text message displaying the negative overflow number with a leading - sign or error information.
  */
  FUNCTION disp_min_overflow( p_none_option  IN VARCHAR2 DEFAULT 'N/A'
                            , p_error_option IN VARCHAR2 DEFAULT 'ERROR'
                            )
    RETURN VARCHAR2
  ;

  /**
  * Returns the text information about the underflow value for negative numbers. The parameters can be used
  * by translations to set language dependend return strings. Error messages
  * will nevertheless be in the language of the system.
  * @param p_none_option The display text if no base data exist. Defaults to N/A.
  * @param p_error_option The prefix value for errors in the called functions. Defaults to ERROR.
  * @return The text message displaying the negative underflow number with a leading - sign or error information.
  */
  FUNCTION disp_min_underflow( p_none_option  IN VARCHAR2 DEFAULT 'N/A'
                             , p_error_option IN VARCHAR2 DEFAULT 'ERROR'
                             )
    RETURN VARCHAR2
  ;

  /**
  * Checks if dimension data exist. Wrapper for usim_dim.has_data.
  * @return Returns 1 if dimension data exist otherwise 0.
  */
  FUNCTION has_dim_data
    RETURN NUMBER
  ;

END usim_apex;
/