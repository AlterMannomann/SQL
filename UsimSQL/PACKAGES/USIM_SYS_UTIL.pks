CREATE OR REPLACE PACKAGE usim_sys_util
IS
  /* Interface package for DBA activities needed for USIM and APEX. */

  --== package variable definition ==--
  -- default schema fixed, change if needed
  PROD_SCHEMA CONSTANT CHAR(4) := 'USIM';
  -- test schema fixed, change if needed
  TEST_SCHEMA CONSTANT CHAR(9) := 'USIM_TEST';

  /**
  * Starts the scheduler job to run a given script or recreate of the schema. If script is not
  * given the setup scripts are run that recreate the schema. No checks are done on the given
  * script so it may fail on execution. Reserved by SYS. Timeout has to be controlled by provided
  * procedures granted to USIM users.
  * @param p_job_name Mandatory. The job to run, e.g. RUN_SERVER_SQL or RUN_SERVER_SQL_TEST.
  * @param p_script Either NULL or a valid file name including extension that exists on the database server.
  * @param p_path Either NULL or a valid path that exists on the database server.
  */
  PROCEDURE run_script( p_job_name IN VARCHAR2
                      , p_script   IN VARCHAR2 DEFAULT NULL
                      , p_path     IN VARCHAR2 DEFAULT NULL
                      )
  ;

  /**
  * Wrapper for USIM_RUN_SCRIPT to run setup for USIM main user. Setup will drop also all existing objects of USIM.
  * The finished state is detected by the scheduler log entry. Status can be FAILED or SUCCEEDED. There is an overall
  * timeout of 8 hours, scripts called should not take longer.
  * @param p_caller The schema to use, APEX should submit '#OWNER#' as parameter.
  * @param p_timeout The timeout for waiting to finish job in minutes, if NULL (default) wait until finished.
  */
  PROCEDURE run_recreate( p_caller   IN VARCHAR2
                        , p_timeout  IN NUMBER DEFAULT NULL
                        )
  ;

  /**
  * Wrapper for USIM_RUN_SCRIPT to run test scripts for USIM_TEST main user.
  * @param p_script The name of the test script file. Default is USIM_TESTS.sql.
  */
  PROCEDURE run_test(p_script_name IN VARCHAR2 DEFAULT 'USIM_TESTS.sql');

  /**
  * Determines a file type in sense of CRLF, LF, CR by analyzing the file until first
  * occurrence of LF or CR possibly followed by LF (not true for Mac). Only Windows must
  * be handled, if client and server differs. Mac and Unix environments are equal in handling
  * line end terminators. Windows clients with unix servers reading files created by server
  * will not display correctly linefeeds. So CR has to be added only in this situation.
  * @param p_filename The name of the file to inspect.
  * @param p_directory The Oracle directory that points to the folder the file is saved.
  * @return The file type as text, LF, CRLF, CR or error information.
  */
  FUNCTION usim_filetype( p_filename  IN VARCHAR2
                        , p_directory IN VARCHAR2 DEFAULT 'USIM_LOG_DIR'
                        )
    RETURN VARCHAR2
  ;

  /**
  * Transforms a user agent web site string to a platform string. Not in sense of browser old platform strings.
  * In the sense of USIM usage, the platform string is only relevant if Windows is used as client system. Identifying
  * only WIN may not be sufficient for user agent strings. Will search for WINDOWS without any version number.
  * @param p_user_agent The string provided by the client as USER AGENT.
  * @return The platform indentification, either WINDOWS or OTHERS. Smartphone OS is not handled or tested.
  */
  FUNCTION agent_to_platform(p_user_agent IN VARCHAR2)
    RETURN VARCHAR2
  ;

  /**
  * Read logs from disk. Expect SQL logs with max. linesize 9999 set. Needs to consider that DBA files are probably created on
  * windows and APEX runs as well mostly under windows. May only work with Windows Client and OVA server.
  * If log file is unix type and client is windows the new line is corrected to CRLF.
  * @param p_filename The name of the log file that resides in the given directory, e.g. USIM_SETUP.log.
  * @param p_platform The client platform used. Default is Win32. Useful if enviroments server/client differ to display logs correctly.
  * May also be USER AGENT string. Searched for the upper case string WIN to match.
  * @param p_directory The name of a valid directory for logs. Default is USIM_LOG_DIR.
  * @return A CLOB containing either the file content or the error message why file could not be loaded.
  */
  FUNCTION load_log( p_filename  IN VARCHAR2
                   , p_platform  IN VARCHAR2 DEFAULT 'Win32'
                   , p_directory IN VARCHAR2 DEFAULT 'USIM_LOG_DIR'
                   )
    RETURN CLOB
  ;

END usim_sys_util;
/