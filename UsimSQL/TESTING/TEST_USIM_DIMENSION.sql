DECLARE
  l_tests_success     INTEGER := 0;
  l_tests_failed      INTEGER := 0;
  l_fail_message      VARCHAR2(4000);
  l_run_id            VARCHAR2(10);
  l_test_section      VARCHAR2(100);
  l_test_object       VARCHAR2(128) := 'USIM_DIMENSION table';
  l_sql_number_result NUMBER;
  l_sql_char_result   VARCHAR2(32000);
  l_sql_date_result   DATE;
  l_test_id           NUMBER;
  l_usim_id_dim       usim_dimension.usim_id_dim%TYPE;
BEGIN
  l_test_id := usim_test.init_test(l_test_object);
  l_test_section := 'Table constraints';
  l_run_id := '001';
  -- setup
  DELETE usim_basedata;
  DELETE usim_dimension;
  COMMIT;
  usim_base.init_basedata;
  BEGIN
    INSERT INTO usim_dimension (usim_n_dimension) VALUES (-1) RETURNING usim_id_dim INTO l_usim_id_dim;
    -- input should be prevented by constraint
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_usim_id_dim || '] negative dimension insert should not be possible.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF INSTR(SQLERRM, 'USIM_DIM_DIMENSION_CHK') > 0
      THEN
        l_tests_success := l_tests_success + 1;
      ELSE
        l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': unexpected error ' || SQLCODE || ': ' || SQLERRM;
        usim_test.log_error(l_test_id, l_fail_message);
        l_tests_failed := l_tests_failed + 1;
      END IF;
  END;
  ROLLBACK;
  l_run_id := '002';
  BEGIN
    INSERT INTO usim_dimension (usim_n_dimension) VALUES (0) RETURNING usim_id_dim INTO l_usim_id_dim;
    INSERT INTO usim_dimension (usim_n_dimension) VALUES (0) RETURNING usim_id_dim INTO l_usim_id_dim;
    -- input should be prevented by constraint
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_number_result || '] duplicate dimension insert should not be possible.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF INSTR(SQLERRM, 'USIM_DIM_UK') > 0
      THEN
        l_tests_success := l_tests_success + 1;
      ELSE
        l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': unexpected error ' || SQLCODE || ': ' || SQLERRM;
        usim_test.log_error(l_test_id, l_fail_message);
        l_tests_failed := l_tests_failed + 1;
      END IF;
  END;
  ROLLBACK;

  l_test_section := 'Table insert trigger';
  l_run_id := '003';
  BEGIN
    INSERT INTO usim_dimension (usim_n_dimension) VALUES (500) RETURNING usim_id_dim INTO l_usim_id_dim;
    -- input should be prevented by trigger
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': dimension over max insert should not be possible.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -20000
      THEN
        l_tests_success := l_tests_success + 1;
      ELSE
        l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': unexpected error ' || SQLCODE || ': ' || SQLERRM;
        usim_test.log_error(l_test_id, l_fail_message);
        l_tests_failed := l_tests_failed + 1;
      END IF;
  END;
  ROLLBACK;
  l_test_section := 'Table update trigger';
  l_run_id := '004';
  BEGIN
    INSERT INTO usim_dimension (usim_n_dimension) VALUES (0) RETURNING usim_id_dim INTO l_usim_id_dim;
    UPDATE usim_dimension SET usim_n_dimension = 1 WHERE usim_id_dim = l_usim_id_dim;
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_usim_id_dim || '] should not be updateable.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -20001
      THEN
        l_tests_success := l_tests_success + 1;
      ELSE
        l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': unexpected error ' || SQLCODE || ': ' || SQLERRM;
        usim_test.log_error(l_test_id, l_fail_message);
        l_tests_failed := l_tests_failed + 1;
      END IF;
  END;
  ROLLBACK;
  l_run_id := '005';
  BEGIN
    INSERT INTO usim_dimension (usim_id_dim, usim_n_dimension) VALUES ('BLA', 0) RETURNING usim_id_dim INTO l_usim_id_dim;
    IF l_usim_id_dim != 'BLA'
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_char_result || '] insert usim_id_dim BLA should not be possible.';
      usim_test.log_error(l_test_id, l_fail_message);
      l_tests_failed := l_tests_failed + 1;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': unexpected error ' || SQLCODE || ': ' || SQLERRM;
      usim_test.log_error(l_test_id, l_fail_message);
      l_tests_failed := l_tests_failed + 1;
  END;
  ROLLBACK;

  -- cleanup
  DELETE usim_basedata;
  DELETE usim_multiverse;
  DELETE usim_dimension;
  COMMIT;
  -- write test results
  usim_test.write_test_results(l_test_id, l_tests_success, l_tests_failed);
EXCEPTION
  WHEN OTHERS THEN
    usim_test.log_error(l_test_id, SUBSTR('Test section failed unexpected: [' || l_test_section || '] tests done: ' || TO_CHAR(NVL(l_tests_success, 0) + NVL(l_tests_failed, 0)) || ' last runs id ' || l_run_id || ' ora: ' || SQLERRM, 1, 4000));
    usim_test.write_test_results(l_test_id, l_tests_success, l_tests_failed);
END;
/