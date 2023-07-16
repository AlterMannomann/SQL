DECLARE
  l_tests_success     INTEGER := 0;
  l_tests_failed      INTEGER := 0;
  l_fail_message      VARCHAR2(4000);
  l_run_id            VARCHAR2(10);
  l_test_section      VARCHAR2(100);
  l_test_object       VARCHAR2(128) := 'USIM_STATIC';
  l_sql_number_result NUMBER;
  l_sql_char_result   VARCHAR2(32000);
  l_sql_date_result   DATE;
  l_test_id           NUMBER;
BEGIN
  l_test_id := usim_test.init_test(l_test_object);
  l_test_section := 'PACKAGE Variables';
  l_run_id := '001';
  IF usim_static.usim_max_childs_per_dimension != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_max_childs_per_dimension NOT 1';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '002';
  IF usim_static.usim_max_seeds != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_max_seeds NOT 1';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '003';
  IF usim_static.usim_planck_time_seq_name != 'USIM_PLANCK_TIME_SEQ'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_planck_time_seq_name NOT USIM_PLANCK_TIME_SEQ';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '004';
  IF usim_static.usim_planck_aeon_seq_name != 'USIM_PLANCK_AEON_SEQ'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_planck_aeon_seq_name NOT USIM_PLANCK_AEON_SEQ';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '005';
  IF usim_static.usim_not_available != 'N/A'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_not_available NOT "N/A"';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '006';
  IF usim_static.usim_status_success != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_status_success NOT 1';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '007';
  IF usim_static.usim_status_error != -1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_status_error NOT -1';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '008';
  IF usim_static.usim_status_warning != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_status_warning NOT 0';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '009';
  IF usim_static.PI != ACOS(-1)
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': PI NOT ACOS(-1)';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '010';
  IF usim_static.PI_DOUBLE != ACOS(-1) * 2
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': PI_DOUBLE NOT ACOS(-1) * 2';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '011';
  IF usim_static.PI_QUARTER != ACOS(-1) / 4
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': PI_QUARTER NOT ACOS(-1) / 4';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '012';
  IF usim_static.usim_multiverse_status_active != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_multiverse_status_active NOT 1';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '013';
  IF usim_static.usim_multiverse_status_inactive != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_multiverse_status_inactive NOT 0';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '014';
  IF usim_static.usim_multiverse_status_dead != -1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_multiverse_status_dead NOT -1';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '015';
  IF usim_static.usim_multiverse_status_crashed != -2
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_multiverse_status_crashed NOT -2';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'NON SQL Functions';
  l_run_id := '016';
  IF usim_static.get_bool_str(TRUE) != 'TRUE'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_bool_str(TRUE) NOT "TRUE"';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '017';
  IF usim_static.get_bool_str(1 = 1) != 'TRUE'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_bool_str(1 = 1) NOT "TRUE"';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '018';
  IF usim_static.get_bool_str(FALSE) != 'FALSE'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_bool_str(FALSE) NOT "FALSE"';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '019';
  IF usim_static.get_bool_str(1 = 2) != 'FALSE'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_bool_str(1 = 2) NOT "FALSE"';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'SQL Functions';
  l_run_id := '020';
  SELECT usim_static.get_max_childs_per_dimension INTO l_sql_number_result FROM dual;
  IF l_sql_number_result != usim_static.usim_max_childs_per_dimension
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': SELECT get_max_childs_per_dimension NOT usim_max_childs_per_dimension';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '021';
  SELECT usim_static.get_max_seeds INTO l_sql_number_result FROM dual;
  IF l_sql_number_result != usim_static.usim_max_seeds
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': SELECT get_max_seeds FROM dual NOT usim_max_seeds';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '022';
  SELECT usim_static.get_pi INTO l_sql_number_result FROM dual;
  IF l_sql_number_result != usim_static.PI
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': SELECT get_pi FROM dual NOT PI';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '023';
  SELECT usim_static.get_pi_double INTO l_sql_number_result FROM dual;
  IF l_sql_number_result != usim_static.PI_DOUBLE
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': SELECT get_pi_double FROM dual NOT PI_DOUBLE';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '024';
  SELECT usim_static.get_pi_quarter INTO l_sql_number_result FROM dual;
  IF l_sql_number_result != usim_static.PI_QUARTER
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': SELECT get_pi_quarter FROM dual NOT PI_QUARTER';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '025';
  SELECT usim_static.get_planck_time_seq_name INTO l_sql_char_result FROM dual;
  IF l_sql_char_result != usim_static.usim_planck_time_seq_name
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': SELECT get_planck_time_seq_name FROM dual NOT usim_planck_time_seq_name';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '026';
  SELECT usim_static.get_planck_aeon_seq_name INTO l_sql_char_result FROM dual;
  IF l_sql_char_result != usim_static.usim_planck_aeon_seq_name
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': SELECT get_planck_aeon_seq_name NOT usim_planck_aeon_seq_name';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '027';
  SELECT usim_static.get_not_available INTO l_sql_char_result FROM dual;
  IF l_sql_char_result != usim_static.usim_not_available
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': SELECT get_not_available NOT usim_not_available';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '028';
  SELECT usim_static.get_debug_success INTO l_sql_number_result FROM dual;
  IF l_sql_number_result != usim_static.usim_status_success
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': SELECT get_debug_success FROM dual NOT usim_status_success';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '029';
  SELECT usim_static.get_debug_error INTO l_sql_number_result FROM dual;
  IF l_sql_number_result != usim_static.usim_status_error
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': SELECT get_debug_error FROM dual NOT usim_status_error';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '030';
  SELECT usim_static.get_debug_warning INTO l_sql_number_result FROM dual;
  IF l_sql_number_result != usim_static.usim_status_warning
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': SELECT get_debug_warning FROM dual NOT usim_status_warning';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '031';
  SELECT usim_static.get_multiverse_active INTO l_sql_number_result FROM dual;
  IF l_sql_number_result != usim_static.usim_multiverse_status_active
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': SELECT get_multiverse_active FROM dual NOT usim_multiverse_status_active';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '032';
  SELECT usim_static.get_multiverse_inactive INTO l_sql_number_result FROM dual;
  IF l_sql_number_result != usim_static.usim_multiverse_status_inactive
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': SELECT get_multiverse_inactive FROM dual NOT usim_multiverse_status_inactive';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '033';
  SELECT usim_static.get_multiverse_dead INTO l_sql_number_result FROM dual;
  IF l_sql_number_result != usim_static.usim_multiverse_status_dead
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': SELECT get_multiverse_dead FROM dual NOT usim_multiverse_status_dead';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '034';
  SELECT usim_static.get_multiverse_crashed INTO l_sql_number_result FROM dual;
  IF l_sql_number_result != usim_static.usim_multiverse_status_crashed
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': SELECT get_multiverse_crashed FROM dual NOT usim_multiverse_status_crashed';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Status Functions';
  l_run_id := '035';
  IF usim_static.get_multiverse_status(usim_static.usim_multiverse_status_active) != 'ACTIVE'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_multiverse_status(usim_static.usim_multiverse_status_active) NOT "ACTIVE"';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '036';
  IF usim_static.get_multiverse_status(usim_static.usim_multiverse_status_inactive) != 'INACTIVE'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_multiverse_status(usim_static.usim_multiverse_status_inactive) NOT "INACTIVE"';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '037';
  IF usim_static.get_multiverse_status(usim_static.usim_multiverse_status_dead) != 'DEAD'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_multiverse_status(usim_static.usim_multiverse_status_dead) NOT "DEAD"';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '038';
  IF usim_static.get_multiverse_status(usim_static.usim_multiverse_status_crashed) != 'CRASHED'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_multiverse_status(usim_static.usim_multiverse_status_crashed) NOT "CRASHED"';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '039';
  IF usim_static.get_multiverse_status(-10) != 'UNKNOWN'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_multiverse_status(-10) NOT "UNKNOWN"';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '040';
  IF usim_static.get_debug_status(usim_static.usim_status_success) != 'SUCCESS'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_debug_status(usim_static.usim_status_success) NOT "SUCCESS"';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '041';
  IF usim_static.get_debug_status(usim_static.usim_status_error) != 'ERROR'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_debug_status(usim_static.usim_status_error) NOT "ERROR"';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '042';
  IF usim_static.get_debug_status(usim_static.usim_status_warning) != 'WARNING'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_debug_status(usim_static.usim_status_error) NOT "WARNING"';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '043';
  IF usim_static.get_debug_status(10) != 'UNKNOWN'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_debug_status(10) NOT "UNKNOWN"';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '044';
  IF usim_static.get_debug_status(-10) != 'UNKNOWN'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_debug_status(-10) NOT "UNKNOWN"';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Big PK Functions';
  l_run_id := '045';
  IF LENGTH(usim_static.get_big_pk(1)) != 55
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': LENGTH(usim_static.get_big_pk(1)) NOT 55';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '046';
  SELECT LENGTH(usim_static.get_big_pk(1)) INTO l_sql_number_result FROM dual;
  IF l_sql_number_result != 55
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': SELECT LENGTH(usim_static.get_big_pk(1)) FROM dual NOT 55';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '047';
  IF TO_NUMBER(SUBSTR(usim_static.get_big_pk(1), -38)) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': TO_NUMBER(SUBSTR(usim_static.get_big_pk(1), -38)) NOT 1';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '048';
  IF TRUNC(usim_static.get_big_pk_date(usim_static.get_big_pk(1))) != TRUNC(SYSDATE)
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': TRUNC(usim_static.get_big_pk_date(usim_static.get_big_pk(1))) NOT TRUNC(SYSDATE)';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '049';
  IF usim_static.get_big_pk_number(usim_static.get_big_pk(1)) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ':  usim_static.get_big_pk_number(usim_static.get_big_pk(1)) NOT 1';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'get_next_number function';
  l_run_id := '050';
  IF usim_static.get_next_number(NULL, NULL) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_next_number(NULL, NULL) NOT 1';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '051';
  IF usim_static.get_next_number(0, NULL) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_next_number(0, NULL) NOT 1';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '052';
  IF usim_static.get_next_number(0, 0) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_next_number(0, 0) NOT 1';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '053';
  IF usim_static.get_next_number(NULL, -1) != -1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_next_number(NULL, -1) NOT -1';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '054';
  IF usim_static.get_next_number(0, -1) != -1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_next_number(0, -1) NOT -1';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '055';
  IF usim_static.get_next_number(0, 1) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_next_number(0, 1) NOT 1';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '056';
  IF usim_static.get_next_number(0, 22) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_next_number(0, 22) NOT 1';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '057';
  IF usim_static.get_next_number(0, -22) != -1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_next_number(0, -22) NOT -1';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '058';
  IF usim_static.get_next_number(3, 1) != 4
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_next_number(3, 1) NOT 4';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '059';
  IF usim_static.get_next_number(3, -1) != 4
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_next_number(3, -1) NOT 4';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '060';
  IF usim_static.get_next_number(-3, -1) != -4
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_next_number(-3, -1) NOT -4';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '061';
  IF usim_static.get_next_number(-3, 1) != -4
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_next_number(-3, 1) NOT -4';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  -- write test results
  usim_test.write_test_results(l_test_id, l_tests_success, l_tests_failed);
EXCEPTION
  WHEN OTHERS THEN
    usim_test.log_error(l_test_id, SUBSTR('Test section failed unexpected: [' || l_test_section || '] tests done: ' || TO_CHAR(NVL(l_tests_success, 0) + NVL(l_tests_failed, 0)) || ' last runs id ' || l_run_id || ' ora: ' || SQLERRM, 1, 4000));
    usim_test.write_test_results(l_test_id, l_tests_success, l_tests_failed);
END;
/