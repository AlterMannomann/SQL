DECLARE
  l_tests_success     INTEGER := 0;
  l_tests_failed      INTEGER := 0;
  l_fail_message      VARCHAR2(4000);
  l_run_id            VARCHAR2(10);
  l_test_section      VARCHAR2(100);
  l_test_object       VARCHAR2(128) := 'USIM_DIM';
  l_sql_number_result NUMBER;
  l_sql_char_result   VARCHAR2(32000);
  l_sql_date_result   DATE;
  l_test_id           NUMBER;
  l_usim_id_mlv       usim_multiverse.usim_id_mlv%TYPE;
  l_usim_id_dim       usim_dimension.usim_id_dim%TYPE;
BEGIN
  l_test_id := usim_test.init_test(l_test_object);
  l_test_section := 'Check functions no data';
  l_run_id := '001';
  -- setup
  DELETE usim_basedata;
  DELETE usim_multiverse;
  DELETE usim_dimension;
  COMMIT;
  usim_base.init_basedata(2); -- limit to 2 dimensions for tests
  l_usim_id_mlv := usim_mlv.insert_universe;
  IF usim_dim.has_data != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_dim.has_data should not have any data.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '002';
  IF usim_dim.has_data(l_usim_id_mlv) != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_dim.has_data(l_usim_id_mlv) should not have any data for the given universe.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '003';
  IF usim_dim.get_max_dimension(l_usim_id_mlv) != -1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_dim.get_max_dimension should not have any max data for the given universe.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '004';
  IF usim_dim.dimension_exists('NO_VALID_ID') != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_dim.dimension_exists should not have any data for the given id.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '005';
  IF usim_dim.get_dimension('NO_VALID_ID') != -1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_dim.get_dimension should not have any data for the given id.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Insert first dimension and checks';
  l_run_id := '006';
  l_usim_id_dim := usim_dim.insert_next_dimension(l_usim_id_mlv);
  l_sql_number_result := usim_dim.get_dimension(l_usim_id_dim);
  IF l_sql_number_result != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': first dimension [' || l_sql_number_result || '] should be 0.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '007';
  IF usim_dim.dimension_exists(l_usim_id_dim) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': dimension id [' || l_usim_id_dim || '] should exist.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '008';
  l_sql_number_result := usim_dim.get_max_dimension(l_usim_id_mlv);
  IF l_sql_number_result != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': first max dimension [' || l_sql_number_result || '] should be 0.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '009';
  IF usim_dim.has_data != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_dim.has_data should have data.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '010';
  IF usim_dim.has_data(l_usim_id_mlv) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_dim.has_data should have data for the given universe.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_test_section := 'Insert second dimension and checks';
  l_run_id := '011';
  l_usim_id_dim := usim_dim.insert_next_dimension(l_usim_id_mlv);
  l_sql_number_result := usim_dim.get_dimension(l_usim_id_dim);
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': second dimension [' || l_sql_number_result || '] should be 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Insert third dimension and checks';
  l_run_id := '012';
  l_usim_id_dim := usim_dim.insert_next_dimension(l_usim_id_mlv);
  l_sql_number_result := usim_dim.get_dimension(l_usim_id_dim);
  IF l_sql_number_result != 2
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': third dimension [' || l_sql_number_result || '] should be 2.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Insert dimension over max and checks';
  l_run_id := '013';
  l_usim_id_dim := usim_dim.insert_next_dimension(l_usim_id_mlv);
  IF l_usim_id_dim IS NOT NULL
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': new dimension id [' || l_usim_id_dim || '] should not exist for dimension over max.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '014';
  l_usim_id_dim := usim_dim.insert_next_dimension('NO_VALID_ID');
  IF l_usim_id_dim IS NOT NULL
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': new dimension id [' || l_usim_id_dim || '] should not exist for not existing universe.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_test_section := 'Insert dimension do commit check';
  l_run_id := '015';
  DELETE usim_dimension;
  COMMIT;
  l_usim_id_dim := usim_dim.insert_next_dimension(l_usim_id_mlv, FALSE);
  l_sql_number_result := usim_dim.get_dimension(l_usim_id_dim);
  IF l_sql_number_result != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': first dimension [' || l_sql_number_result || '] should be 0.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '016';
  ROLLBACK;
  l_sql_number_result := usim_dim.get_dimension(l_usim_id_dim);
  IF l_sql_number_result != -1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': dimension [' || l_sql_number_result || '] should not exist after rollback.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Overflow state';
  l_run_id := '017';
  l_sql_number_result := usim_dim.overflow_reached(l_usim_id_mlv);
  IF l_sql_number_result != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': overflow [' || l_sql_number_result || '] wrong for empty dimensions.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '018';
  l_usim_id_dim := usim_dim.insert_next_dimension(l_usim_id_mlv);
  l_sql_number_result := usim_dim.overflow_reached(l_usim_id_mlv);
  IF l_sql_number_result != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': overflow [' || l_sql_number_result || '] wrong for first dimension.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '019';
  -- mimic overflow by insert
  INSERT INTO usim_dimension (usim_id_mlv, usim_n_dimension) VALUES (l_usim_id_mlv, usim_base.get_max_dimension);
  COMMIT;
  l_sql_number_result := usim_dim.overflow_reached(l_usim_id_mlv);
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': overflow [' || l_sql_number_result || '] wrong for max dimension.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

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