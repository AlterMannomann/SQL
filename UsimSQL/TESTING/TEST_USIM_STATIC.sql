SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  l_tests_success     INTEGER := 0;
  l_tests_failed      INTEGER := 0;
  l_fail_message      VARCHAR2(32000);
  l_test_section      VARCHAR2(100);
  l_test_object       VARCHAR2(128) := 'USIM_STATIC';
  l_sql_number_result NUMBER;
  l_sql_char_result   VARCHAR2(32000);
  l_sql_date_result   DATE;
BEGIN
  l_test_section := 'PACKAGE Variables';
  IF usim_static.usim_max_childs != 2
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': usim_max_childs NOT 2';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.usim_max_seeds != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': usim_max_seeds NOT 1';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.usim_seed_name != 'UniverseSeed'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': usim_seed_name NOT UniverseSeed';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.usim_mirror_name != 'MirrorSeed'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': usim_mirror_name NOT MirrorSeed';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.usim_child_add != 'Child'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': usim_child_add NOT Child';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.usim_max_dimensions != 3
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': usim_max_dimensions NOT 3';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.usim_planck_timer != 'USIM_PLANCK_TIME_SEQ'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': usim_planck_timer NOT USIM_PLANCK_TIME_SEQ';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.usim_not_available != 'N/A'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': usim_not_available NOT N/A';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.usim_max_number != 99999999999999999999999999999999999999
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': usim_max_number NOT 99999999999999999999999999999999999999';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.usim_status_success != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': usim_status_success NOT 1';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.usim_status_error != -1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': usim_status_error NOT -1';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.usim_status_warning != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': usim_status_warning NOT 0';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.PI != ACOS(-1)
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': PI NOT ACOS(-1)';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.PI_DOUBLE != ACOS(-1) * 2
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': PI_DOUBLE NOT ACOS(-1) * 2';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.PI_QUARTER != ACOS(-1) / 4
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': PI_QUARTER NOT ACOS(-1) / 4';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_test_section := 'NON SQL Functions';
  IF usim_static.get_bool_str(TRUE) != 'TRUE'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_bool_str(TRUE) NOT "TRUE"';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.get_bool_str(1 = 1) != 'TRUE'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_bool_str(1 = 1) NOT "TRUE"';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.get_bool_str(FALSE) != 'FALSE'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_bool_str(FALSE) NOT "FALSE"';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.get_bool_str(1 = 2) != 'FALSE'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_bool_str(1 = 2) NOT "FALSE"';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.is_overflow_reached(usim_static.usim_max_number - 1)
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': is_overflow_reached(usim_static.usim_max_number - 1) NOT FALSE';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'SQL Functions';
  IF usim_static.get_max_childs != usim_static.usim_max_childs
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_max_childs NOT usim_max_childs';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  SELECT usim_static.get_max_childs INTO l_sql_number_result FROM dual;
  IF l_sql_number_result != usim_static.usim_max_childs
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': SELECT get_max_childs FROM dual NOT usim_max_childs';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.get_max_seeds != usim_static.usim_max_seeds
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_max_seeds NOT usim_max_seeds';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  SELECT usim_static.get_max_seeds INTO l_sql_number_result FROM dual;
  IF l_sql_number_result != usim_static.usim_max_seeds
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': SELECT get_max_seeds FROM dual NOT usim_max_seeds';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.get_seed_name != usim_static.usim_seed_name
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_seed_name NOT usim_seed_name';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  SELECT usim_static.get_seed_name INTO l_sql_char_result FROM dual;
  IF l_sql_char_result != usim_static.usim_seed_name
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': SELECT get_seed_name FROM dual NOT usim_seed_name';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.get_mirror_name != usim_static.usim_mirror_name
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_mirror_name NOT usim_mirror_name';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  SELECT usim_static.get_mirror_name INTO l_sql_char_result FROM dual;
  IF l_sql_char_result != usim_static.usim_mirror_name
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': SELECT get_mirror_name FROM dual NOT usim_mirror_name';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.get_child_add != usim_static.usim_child_add
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_child_add NOT usim_child_add';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  SELECT usim_static.get_child_add INTO l_sql_char_result FROM dual;
  IF l_sql_char_result != usim_static.usim_child_add
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': SELECT get_child_add FROM dual NOT usim_child_add';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.get_pi != usim_static.PI
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_pi NOT PI';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  SELECT usim_static.get_pi INTO l_sql_number_result FROM dual;
  IF l_sql_number_result != usim_static.PI
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': SELECT get_pi FROM dual NOT PI';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.get_pi_double != usim_static.PI_DOUBLE
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_pi_double NOT PI_DOUBLE';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  SELECT usim_static.get_pi_double INTO l_sql_number_result FROM dual;
  IF l_sql_number_result != usim_static.PI_DOUBLE
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': SELECT get_pi_double FROM dual NOT PI_DOUBLE';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.get_pi_quarter != usim_static.PI_QUARTER
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_pi_quarter NOT PI_QUARTER';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  SELECT usim_static.get_pi_quarter INTO l_sql_number_result FROM dual;
  IF l_sql_number_result != usim_static.PI_QUARTER
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': SELECT get_pi_quarter FROM dual NOT PI_QUARTER';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.get_max_dimensions != usim_static.usim_max_dimensions
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_max_dimensions NOT usim_max_dimensions';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  SELECT usim_static.get_max_dimensions INTO l_sql_number_result FROM dual;
  IF l_sql_number_result != usim_static.usim_max_dimensions
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': SELECT get_max_dimensions FROM dual NOT usim_max_dimensions';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.get_planck_timer != usim_static.usim_planck_timer
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_planck_timer NOT usim_planck_timer';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  SELECT usim_static.get_planck_timer INTO l_sql_char_result FROM dual;
  IF l_sql_char_result != usim_static.usim_planck_timer
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': SELECT get_planck_timer FROM dual NOT usim_planck_timer';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.get_not_available != usim_static.usim_not_available
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_not_available NOT usim_not_available';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  SELECT usim_static.get_not_available INTO l_sql_char_result FROM dual;
  IF l_sql_char_result != usim_static.usim_not_available
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': SELECT get_not_available FROM dual NOT usim_not_available';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.get_debug_success != usim_static.usim_status_success
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_debug_success NOT usim_status_success';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  SELECT usim_static.get_debug_success INTO l_sql_number_result FROM dual;
  IF l_sql_number_result != usim_static.usim_status_success
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': SELECT get_debug_success FROM dual NOT usim_status_success';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.get_debug_error != usim_static.usim_status_error
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_debug_error NOT usim_status_error';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  SELECT usim_static.get_debug_error INTO l_sql_number_result FROM dual;
  IF l_sql_number_result != usim_static.usim_status_error
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': SELECT get_debug_error FROM dual NOT usim_status_error';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.get_debug_warning != usim_static.usim_status_warning
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_debug_warning NOT usim_status_warning';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  SELECT usim_static.get_debug_warning INTO l_sql_number_result FROM dual;
  IF l_sql_number_result != usim_static.usim_status_warning
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': SELECT get_debug_warning FROM dual NOT usim_status_warning';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.get_debug_status(usim_static.usim_status_success) != 'SUCCESS'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_debug_status(usim_static.usim_status_success) NOT "SUCCESS"';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  SELECT usim_static.get_debug_status(usim_static.get_debug_success) INTO l_sql_char_result FROM dual;
  IF l_sql_char_result != 'SUCCESS'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': SELECT usim_static.get_debug_status(usim_static.get_debug_success) FROM dual NOT "SUCCESS"';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.get_debug_status(usim_static.usim_status_error) != 'ERROR'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_debug_status(usim_static.usim_status_error) NOT "ERROR"';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  SELECT usim_static.get_debug_status(usim_static.get_debug_error) INTO l_sql_char_result FROM dual;
  IF l_sql_char_result != 'ERROR'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': SELECT usim_static.get_debug_status(usim_static.get_debug_error) FROM dual NOT "ERROR"';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.get_debug_status(usim_static.usim_status_warning) != 'WARNING'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_debug_status(usim_static.usim_status_error) NOT "WARNING"';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  SELECT usim_static.get_debug_status(usim_static.get_debug_warning) INTO l_sql_char_result FROM dual;
  IF l_sql_char_result != 'WARNING'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': SELECT usim_static.get_debug_status(usim_static.get_debug_warning) FROM dual NOT "WARNING"';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.get_debug_status(10) != 'UNKNOWN'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_debug_status(10) NOT "UNKNOWN"';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  SELECT usim_static.get_debug_status(10) INTO l_sql_char_result FROM dual;
  IF l_sql_char_result != 'UNKNOWN'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': SELECT usim_static.get_debug_status(10) FROM dual NOT "UNKNOWN"';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_static.get_debug_status(-10) != 'UNKNOWN'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_debug_status(-10) NOT "UNKNOWN"';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  SELECT usim_static.get_debug_status(-10) INTO l_sql_char_result FROM dual;
  IF l_sql_char_result != 'UNKNOWN'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': SELECT usim_static.get_debug_status(-10) FROM dual NOT "UNKNOWN"';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  IF LENGTH(usim_static.get_big_pk(1)) != 55
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': LENGTH(usim_static.get_big_pk(1)) NOT 55';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  SELECT LENGTH(usim_static.get_big_pk(1)) INTO l_sql_number_result FROM dual;
  IF l_sql_number_result != 55
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': SELECT LENGTH(usim_static.get_big_pk(1)) FROM dual NOT 55';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF TO_NUMBER(SUBSTR(usim_static.get_big_pk(1), -38)) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': TO_NUMBER(SUBSTR(usim_static.get_big_pk(1), -38)) NOT 1';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  SELECT TO_NUMBER(SUBSTR(usim_static.get_big_pk(1), -38)) INTO l_sql_number_result FROM dual;
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': SELECT TO_NUMBER(SUBSTR(usim_static.get_big_pk(1), -38)) FROM dual NOT 1';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF TRUNC(usim_static.get_big_pk_date(usim_static.get_big_pk(1))) != TRUNC(SYSDATE)
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': TRUNC(usim_static.get_big_pk_date(usim_static.get_big_pk(1))) NOT TRUNC(SYSDATE)';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  SELECT TRUNC(usim_static.get_big_pk_date(usim_static.get_big_pk(1))) INTO l_sql_date_result FROM dual;
  IF l_sql_date_result != TRUNC(SYSDATE)
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': SELECT TRUNC(usim_static.get_big_pk_date(usim_static.get_big_pk(1))) FROM dual NOT TRUNC(SYSDATE)';
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