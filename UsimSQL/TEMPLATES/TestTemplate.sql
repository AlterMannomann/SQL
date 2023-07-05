DECLARE
  l_tests_success     INTEGER := 0;
  l_tests_failed      INTEGER := 0;
  l_fail_message      VARCHAR2(4000);
  l_run_id            VARCHAR2(10);
  l_test_section      VARCHAR2(100);
  l_test_object       VARCHAR2(128) := 'OBJECT';
  l_sql_number_result NUMBER;
  l_sql_char_result   VARCHAR2(32000);
  l_sql_date_result   DATE;
  l_test_id           NUMBER;
BEGIN
  l_test_id := usim_test.init_test(l_test_object);
  l_test_section := 'SECTION';
  l_run_id := '001';
  -- setup
  DELETE <table>;
  COMMIT;

  -- functions
  IF FALSE
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': error message';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  -- tables
  l_run_id := '002';
  BEGIN
    INSERT INTO <table> (<column>) VALUES (<value>) RETURNING <column> INTO l_sql_number_result;
    -- input should be prevented by constraint
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_number_result || '] error message.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF INSTR(SQLERRM, 'CONSTRAINT') > 0
      THEN
        l_tests_success := l_tests_success + 1;
      ELSE
        l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': unexpected error ' || SQLCODE || ': ' || SQLERRM;
        usim_test.log_error(l_test_id, l_fail_message);
        l_tests_failed := l_tests_failed + 1;
      END IF;
  END;
  ROLLBACK;

  l_run_id := '003';
  BEGIN
    INSERT INTO <table> (<column>) VALUES (<value>) RETURNING <column> INTO l_sql_number_result;
    -- check input value
    IF TRIM(l_sql_char_result) = <compare>
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_char_result || '] error message[' || <var> || '].';
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
  DELETE <table>;
  COMMIT;
  -- write test results
  usim_test.write_test_results(l_test_id, l_tests_success, l_tests_failed);
EXCEPTION
  WHEN OTHERS THEN
    usim_test.log_error(l_test_id, SUBSTR('Test section failed unexpected: [' || l_test_section || '] tests done: ' || TO_CHAR(NVL(l_tests_success, 0) + NVL(l_tests_failed, 0)) || ' last runs id ' || l_run_id || ' ora: ' || SQLERRM, 1, 4000));
    usim_test.write_test_results(l_test_id, l_tests_success, l_tests_failed);
END;
/