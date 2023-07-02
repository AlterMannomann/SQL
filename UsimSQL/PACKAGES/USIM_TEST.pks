CREATE OR REPLACE PACKAGE usim_test IS
  /** Package for test support.
  * No checks are done, parameters must be valid.
  */

  /**
  * Initialize a new test.
  * @param p_usim_test_object The name of the test object.
  * @return The id of the initialized test.
  */
  FUNCTION init_test(p_usim_test_object IN usim_test_summary.usim_test_object%TYPE)
    RETURN NUMBER
  ;

  /**
  * Logs an error message that occured in a test for a given test object.
  * @param p_usim_id_tsu The id of the test object in usim_test_summary.
  * @param p_usim_error_msg The error message to log in usim_test_errors.
  */
  PROCEDURE log_error( p_usim_id_tsu    IN usim_test_errors.usim_id_tsu%TYPE
                     , p_usim_error_msg IN usim_test_errors.usim_error_msg%TYPE
                     )
  ;

  /**
  * Persists the test results after testing.
  * @param p_usim_id_tsu The id of the test object in usim_test_summary.
  * @param p_usim_success The amount of successful tests.
  * @param p_usim_failed The amount of failed tests.
  */
  PROCEDURE write_test_results( p_usim_id_tsu   IN usim_test_summary.usim_id_tsu%TYPE
                              , p_usim_success  IN NUMBER
                              , p_usim_failed   IN NUMBER
                              )
  ;
END;
/