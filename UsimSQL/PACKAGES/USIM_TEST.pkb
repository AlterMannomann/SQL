CREATE OR REPLACE PACKAGE BODY usim_test IS
  -- see header for description
  FUNCTION init_test(p_usim_test_object IN usim_test_summary.usim_test_object%TYPE)
    RETURN NUMBER
  IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    l_result NUMBER;
  BEGIN
    INSERT INTO usim_test_summary (usim_test_object) VALUES (p_usim_test_object) RETURNING usim_id_tsu INTO l_result;
    COMMIT;
    RETURN l_result;
  END init_test
  ;

  PROCEDURE log_error( p_usim_id_tsu    IN usim_test_errors.usim_id_tsu%TYPE
                     , p_usim_error_msg IN usim_test_errors.usim_error_msg%TYPE
                     )
  IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    INSERT INTO usim_test_errors
      ( usim_id_tsu
      , usim_error_msg
      )
      VALUES
      ( p_usim_id_tsu
      , p_usim_error_msg
      )
    ;
    COMMIT;
  END log_error
  ;

  PROCEDURE write_test_results( p_usim_id_tsu   IN usim_test_summary.usim_id_tsu%TYPE
                              , p_usim_success  IN NUMBER
                              , p_usim_failed   IN NUMBER
                              )
  IS
  BEGIN
    UPDATE usim_test_summary
       SET usim_tests_success = p_usim_success
         , usim_tests_failed  = p_usim_failed
     WHERE usim_id_tsu = p_usim_id_tsu
    ;
    COMMIT;
  END write_test_results
  ;

END;
/