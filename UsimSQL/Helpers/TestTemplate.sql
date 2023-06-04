SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  l_tests_success     INTEGER := 0;
  l_tests_failed      INTEGER := 0;
  l_fail_message      VARCHAR2(32000);
  l_test_section      VARCHAR2(100);
  l_test_object       VARCHAR2(128) := 'OBJECT';
  l_sql_number_result NUMBER;
  l_sql_char_result   VARCHAR2(32000);
  l_sql_date_result   DATE;
BEGIN
  l_test_section := 'SECTION';
  IF FALSE
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': error message';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  -- Summary
  DBMS_OUTPUT.PUT_LINE(l_test_object || ' Tests: SUCCESS (' || l_tests_success || ') ERROR (' || l_tests_failed || ')');
  IF l_tests_failed > 0
  THEN
    DBMS_OUTPUT.PUT_LINE(l_test_object || ' Test: FAILED');
  ELSE
    DBMS_OUTPUT.PUT_LINE(l_test_object || ' Test: PASSED');
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Test section failed unexpected: [' || l_test_section || '] tests done: ' || TO_CHAR(NVL(l_tests_success, 0) + NVL(l_tests_failed, 0)));
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/