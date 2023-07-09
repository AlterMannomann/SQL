DECLARE
  l_tests_success     INTEGER := 0;
  l_tests_failed      INTEGER := 0;
  l_fail_message      VARCHAR2(4000);
  l_run_id            VARCHAR2(10);
  l_test_section      VARCHAR2(100);
  l_test_object       VARCHAR2(128) := 'USIM_NOD';
  l_sql_number_result NUMBER;
  l_sql_char_result   VARCHAR2(32000);
  l_sql_date_result   DATE;
  l_test_id           NUMBER;
  l_usim_id_nod       usim_node.usim_id_nod%TYPE;
BEGIN
  l_test_id := usim_test.init_test(l_test_object);
  l_test_section := 'Functions no data';
  l_run_id := '001';
  -- setup
  DELETE usim_basedata;
  DELETE usim_node;
  COMMIT;
  usim_base.init_basedata;

  IF usim_nod.has_data = 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should not report data on empty table.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '002';
  IF usim_nod.has_data('BLA') = 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should not report data on empty table for not existing id BLA.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '003';
  IF usim_nod.get_energy('BLA') IS NOT NULL
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_energy should not report data on empty table for not existing id BLA.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '004';
  IF usim_nod.overflow_reached('BLA') = 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': overflow_reached should not report overflow on empty table for not existing id BLA.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '005';
  IF usim_nod.overflow_reached('BLA', 1000) = 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': overflow_reached with energy should not report overflow on empty table for not existing id BLA.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Functions insert do commit FALSE';
  l_run_id := '006';
  l_usim_id_nod := usim_nod.insert_node(FALSE);
  IF l_usim_id_nod IS NULL
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_id_nod should not be NULL after insert.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '007';
  l_sql_number_result := usim_nod.get_energy(l_usim_id_nod);
  IF l_sql_number_result IS NOT NULL
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_energy should be NULL after insert.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '008';
  IF usim_nod.has_data = 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should report data after insert.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '009';
  IF usim_nod.has_data(l_usim_id_nod) = 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data[' || l_usim_id_nod || '] should report data for id after insert.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '010';
  IF usim_nod.overflow_reached(l_usim_id_nod) = 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': overflow_reached[' || l_usim_id_nod || '] should not report overflow for energy after insert.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '011';
  IF usim_nod.overflow_reached(l_usim_id_nod, 10) = 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': overflow_reached[' || l_usim_id_nod || '] should not report overflow for energy 10 after insert.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '012';
  IF usim_nod.overflow_reached(l_usim_id_nod, usim_base.get_abs_max_number) = 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': overflow_reached[' || l_usim_id_nod || '] should not report overflow for energy max after insert.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '013';
  IF usim_nod.overflow_reached(l_usim_id_nod, usim_base.get_abs_max_number + 10) = 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': overflow_reached[' || l_usim_id_nod || '] should report overflow for energy max + 10 after insert.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  ROLLBACK;
  l_run_id := '014';
  IF usim_nod.has_data = 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should not report data after rollback.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '015';
  IF usim_nod.has_data(l_usim_id_nod) = 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data[' || l_usim_id_nod || '] should not report data for id after rollback.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Functions update do commit FALSE';
  l_run_id := '016';
  l_usim_id_nod := usim_nod.insert_node(FALSE);
  l_sql_number_result := usim_nod.update_energy(10, l_usim_id_nod, FALSE);
  IF l_sql_number_result != 10
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_energy [' || l_sql_number_result || '] should be 10 after update for [' || l_usim_id_nod || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '017';
  IF usim_nod.overflow_reached(l_usim_id_nod) = 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': overflow_reached[' || l_usim_id_nod || '] should not report overflow for energy after update with 10.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '018';
  IF usim_nod.overflow_reached(l_usim_id_nod, usim_base.get_abs_max_number) = 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': overflow_reached[' || l_usim_id_nod || '] should report overflow for energy after update with 10 and adding max.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '019';
  l_sql_number_result := usim_nod.update_energy(usim_base.get_abs_max_number + 10, l_usim_id_nod, FALSE);
  IF l_sql_number_result != 10
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_energy [' || l_sql_number_result || '] should be 10 after overflow update for [' || l_usim_id_nod || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '020';
  l_sql_number_result := usim_nod.update_energy(usim_base.get_abs_max_number, l_usim_id_nod, FALSE);
  IF l_sql_number_result != usim_base.get_abs_max_number
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_energy [' || l_sql_number_result || '] should be max after correct max update for [' || l_usim_id_nod || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  ROLLBACK;

  l_test_section := 'Functions add do commit FALSE';
  l_run_id := '021';
  l_usim_id_nod := usim_nod.insert_node(FALSE);
  l_sql_number_result := usim_nod.add_energy(10, l_usim_id_nod, FALSE);
  IF l_sql_number_result != 10
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_energy [' || l_sql_number_result || '] should be 10 after add for [' || l_usim_id_nod || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '022';
  l_sql_number_result := usim_nod.add_energy(usim_base.get_abs_max_number - 10, l_usim_id_nod, FALSE);
  IF l_sql_number_result != usim_base.get_abs_max_number
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_energy [' || l_sql_number_result || '] should be max after add max -10 for [' || l_usim_id_nod || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '023';
  l_sql_number_result := usim_nod.add_energy(1, l_usim_id_nod, FALSE);
  IF l_sql_number_result != usim_base.get_abs_max_number
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_energy [' || l_sql_number_result || '] should be still max after add 1 to max for [' || l_usim_id_nod || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  ROLLBACK;

  l_test_section := 'Functions add negative energy do commit FALSE';
  l_run_id := '024';
  l_usim_id_nod := usim_nod.insert_node(FALSE);
  l_sql_number_result := usim_nod.add_energy(-10, l_usim_id_nod, FALSE);
  IF l_sql_number_result != -10
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_energy [' || l_sql_number_result || '] should be -10 after add for [' || l_usim_id_nod || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '025';
  l_sql_number_result := usim_nod.add_energy((usim_base.get_abs_max_number - 10) * -1, l_usim_id_nod, FALSE);
  IF ABS(l_sql_number_result) != usim_base.get_abs_max_number
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_energy [' || l_sql_number_result || '] should be -max after add negative max-10 for [' || l_usim_id_nod || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '026';
  l_sql_number_result := usim_nod.add_energy(-1, l_usim_id_nod, FALSE);
  IF ABS(l_sql_number_result) != usim_base.get_abs_max_number
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_energy [' || l_sql_number_result || '] should be still -max after add -1 for [' || l_usim_id_nod || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  ROLLBACK;
  l_run_id := '027';
  IF usim_nod.has_data = 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should not report data after rollback.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '028';
  IF usim_nod.has_data(l_usim_id_nod) = 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data[' || l_usim_id_nod || '] should not report data for id after rollback.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Functions insert, update, add do commit TRUE';
  l_run_id := '029';
  l_usim_id_nod := usim_nod.insert_node;
  IF usim_nod.has_data = 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should have data after insert.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '030';
  IF usim_nod.has_data(l_usim_id_nod) = 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data[' || l_usim_id_nod || '] should have data for id after insert.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  ROLLBACK;
  l_run_id := '031';
  IF usim_nod.has_data = 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should have data after insert with commit and rollback.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '032';
  IF usim_nod.has_data(l_usim_id_nod) = 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data[' || l_usim_id_nod || '] should have data for id after insert with commit and rollback.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '033';
  l_sql_number_result := usim_nod.add_energy(10, l_usim_id_nod);
  IF l_sql_number_result != 10
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_energy [' || l_sql_number_result || '] should be 10 after add for [' || l_usim_id_nod || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  ROLLBACK;
  l_run_id := '034';
  IF l_sql_number_result != 10
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_energy [' || l_sql_number_result || '] should be still 10 after rollback of add with commit for [' || l_usim_id_nod || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '035';
  l_sql_number_result := usim_nod.update_energy(20, l_usim_id_nod);
  IF l_sql_number_result != 20
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_energy [' || l_sql_number_result || '] should be 20 after update for [' || l_usim_id_nod || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  ROLLBACK;
  l_run_id := '036';
  IF l_sql_number_result != 20
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_energy [' || l_sql_number_result || '] should still be 20 after update with commit for [' || l_usim_id_nod || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;


  -- cleanup
  DELETE usim_basedata;
  DELETE usim_node;
  COMMIT;
  -- write test results
  usim_test.write_test_results(l_test_id, l_tests_success, l_tests_failed);
EXCEPTION
  WHEN OTHERS THEN
    usim_test.log_error(l_test_id, SUBSTR('Test section failed unexpected: [' || l_test_section || '] tests done: ' || TO_CHAR(NVL(l_tests_success, 0) + NVL(l_tests_failed, 0)) || ' last runs id ' || l_run_id || ' ora: ' || SQLERRM, 1, 4000));
    usim_test.write_test_results(l_test_id, l_tests_success, l_tests_failed);
END;
/