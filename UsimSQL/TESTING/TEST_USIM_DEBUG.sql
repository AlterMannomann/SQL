SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  l_tests_success     INTEGER := 0;
  l_tests_failed      INTEGER := 0;
  l_fail_message      VARCHAR2(32000);
  l_test_section      VARCHAR2(100);
  l_test_object       VARCHAR2(128) := 'USIM_DEBUG';
  l_sql_number_result NUMBER;
  l_sql_char_result   VARCHAR2(32000);
  l_debug_id          usim_debug_log.usim_id_dlg%TYPE;
  l_debug_object      usim_debug_log.usim_log_object%TYPE := 'TEST_USIM_DEBUG';
  l_debug_content     usim_debug_log.usim_log_content%TYPE;
BEGIN
  l_test_section := 'Debug Status';
  usim_debug.set_debug_on;
  IF NOT usim_debug.is_debug_on
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': Debug on and usim_debug.is_debug_on NOT TRUE';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  SELECT usim_debug.is_debug INTO l_sql_char_result FROM dual;
  IF l_sql_char_result != 'TRUE'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': Debug on and SELECT usim_debug.is_debug NOT "TRUE"';
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  usim_debug.set_debug_off;
  IF usim_debug.is_debug_on
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': Debug off and usim_debug.is_debug_on NOT FALSE';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  SELECT usim_debug.is_debug INTO l_sql_char_result FROM dual;
  IF l_sql_char_result != 'FALSE'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': Debug off and SELECT usim_debug.is_debug NOT "FALSE"';
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Debug Action';
  IF NVL(usim_debug.start_debug, -1) != -1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': Debug off and usim_debug.start_debug IS NOT NULL';
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  usim_debug.set_debug_on;
  l_debug_id      := usim_debug.start_debug;
  IF NVL(l_debug_id, -1) != usim_dlg_id_seq.CURRVAL
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': Debug on and usim_debug.start_debug IS NOT usim_dlg_id_seq.CURRVAL';
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_debug_content := 'Test: l_debug_id[' || l_debug_id || ']';
  usim_debug.debug_log(l_debug_id, usim_static.usim_status_success, l_debug_object, l_debug_content);
  SELECT COUNT(*) INTO l_sql_number_result FROM usim_debug_log WHERE usim_log_object = l_debug_object;
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': No debug message written.';
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  SELECT TRIM(usim_log_content) INTO l_sql_char_result FROM usim_debug_log WHERE usim_log_object = l_debug_object;
  IF l_sql_char_result != l_debug_content
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': No debug content does not match expected content.';
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  -- basic state
  usim_debug.set_debug_off;

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