DECLARE
  l_tests_success     INTEGER := 0;
  l_tests_failed      INTEGER := 0;
  l_fail_message      VARCHAR2(4000);
  l_run_id            VARCHAR2(10);
  l_test_section      VARCHAR2(100);
  l_test_object       VARCHAR2(128) := 'USIM_POS';
  l_sql_number_result NUMBER;
  l_sql_char_result   VARCHAR2(32000);
  l_sql_date_result   DATE;
  l_test_id           NUMBER;
  l_usim_id_pos       usim_position.usim_id_pos%TYPE;
  l_usim_coordinate   usim_position.usim_coordinate%TYPE;
  l_sign              NUMBER;
BEGIN
  l_test_id := usim_test.init_test(l_test_object);
  l_test_section := 'Check functions no data';
  l_run_id := '001';
  -- setup
  DELETE usim_basedata;
  DELETE usim_position;
  COMMIT;
  usim_base.init_basedata;
  IF usim_pos.has_data != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_pos.has_data should not find data.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '002';
  IF usim_pos.coordinate_exists(0, 0) != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_pos.coordinate_exists(0, 0) should not find data.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '003';
  IF usim_pos.get_max_coordinate(1) IS NOT NULL
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_pos.get_max_coordinate(1) should not find data.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '004';
  IF usim_pos.get_max_coordinate(-1) IS NOT NULL
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_pos.get_max_coordinate(-1) should not find data.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '005';
  IF usim_pos.has_data('NO_VALID_ID') != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_pos.has_data(NO_VALID_ID) should not find data.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '006';
  l_usim_coordinate := usim_pos.get_coordinate('NO_VALID_ID');
  IF l_usim_coordinate IS NOT NULL
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_pos.get_coordinate(NO_VALID_ID) should not find data[' || l_usim_coordinate || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '007';
  l_usim_id_pos := usim_pos.get_id_pos(0, 0);
  IF l_usim_id_pos IS NOT NULL
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_pos.get_id_pos(0) should not find data[' || l_usim_id_pos || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Basic inserts and do commit check';
  l_run_id := '008';
  l_usim_id_pos := usim_pos.insert_next_position(1, FALSE); -- 0, 0
  IF usim_pos.has_data != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_pos.insert_next_position should insert data.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '009';
  l_usim_coordinate := usim_pos.get_coordinate(l_usim_id_pos);
  IF l_usim_coordinate != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': first insert[' || l_usim_coordinate || '] should create coordinate 0.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '010';
  ROLLBACK;
  IF usim_pos.has_data != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': after rollback of first insert usim_position should not have data.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '011';
  l_usim_coordinate := usim_pos.get_coordinate(l_usim_id_pos);
  IF l_usim_coordinate IS NOT NULL
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': rollback after first insert[' || l_usim_coordinate || '] should not find coordinate.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '012';
  l_usim_id_pos     := usim_pos.insert_next_position(-1, TRUE);
  l_usim_coordinate := usim_pos.get_coordinate(l_usim_id_pos);
  l_sign            := usim_pos.get_coord_sign(l_usim_id_pos);
  IF    l_usim_coordinate != 0
     OR l_sign            != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': first insert[' || l_usim_coordinate || '] should find coordinate 0 with sign 0.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Overflow state';
  l_run_id := '013';
  DELETE usim_position;
  COMMIT;
  l_sql_number_result := usim_pos.overflow_reached;
  IF l_sql_number_result != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': overflow state [' || l_sql_number_result || '] wrong for empty usim_position.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '014';
  l_usim_id_pos := usim_pos.insert_next_position(1, TRUE); -- 0, 0
  l_usim_id_pos := usim_pos.insert_next_position(1, TRUE); -- 0, 1
  l_usim_id_pos := usim_pos.insert_next_position(-1, TRUE); -- 0, -1
  l_sql_number_result := usim_pos.overflow_reached;
  IF l_sql_number_result != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': overflow state [' || l_sql_number_result || '] wrong for minimal inserts in usim_position.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '015';
  -- mimic half overflow
  INSERT INTO usim_position (usim_coordinate, usim_sign) VALUES (usim_base.get_abs_max_number, 1);
  l_sql_number_result := usim_pos.overflow_reached(1);
  IF l_sql_number_result = 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': overflow state [' || l_sql_number_result || '] wrong for having max coordinate as positive number in usim_position.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  ROLLBACK;
  l_run_id := '016';
  INSERT INTO usim_position (usim_coordinate, usim_sign) VALUES (usim_base.get_abs_max_number * -1, -1);
  l_sql_number_result := usim_pos.overflow_reached(-1);
  IF l_sql_number_result = 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': overflow state [' || l_sql_number_result || '] wrong for having max coordinate as negative number in usim_position.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  ROLLBACK;
  l_run_id := '017';
  INSERT INTO usim_position (usim_coordinate, usim_sign) VALUES (usim_base.get_abs_max_number, 1);
  INSERT INTO usim_position (usim_coordinate, usim_sign) VALUES (usim_base.get_abs_max_number * -1, -1);
  l_sql_number_result := usim_pos.overflow_reached;
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': overflow state [' || l_sql_number_result || '] wrong for having max coordinates in usim_position.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  ROLLBACK;

  l_test_section := 'Check functions with data';
  l_run_id := '018';
  DELETE usim_position;
  COMMIT;
  l_usim_id_pos     := usim_pos.insert_next_position(1, TRUE); -- 0, 0
  l_usim_id_pos     := usim_pos.insert_next_position(1, TRUE); -- 0, 1
  l_usim_id_pos     := usim_pos.insert_next_position(-1, TRUE); -- 0, -1
  l_usim_coordinate := usim_pos.get_coordinate(l_usim_id_pos);
  l_sign            := usim_pos.get_coord_sign(l_usim_id_pos);
  IF    l_usim_coordinate != 0
     OR l_sign            != -1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': first negative coordinate [' || l_usim_coordinate || '] should be 0.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '019';
  IF usim_pos.has_data(l_usim_id_pos) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': coordinate id [' || l_usim_id_pos || '] should exist.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '020';
  l_sql_char_result := usim_pos.get_id_pos(-2, 1);
  IF l_sql_char_result IS NOT NULL
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': coordinate -2 should not exist.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '021';
  l_sql_char_result := usim_pos.get_id_pos(0, -1);
  IF l_sql_char_result != l_usim_id_pos
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': coordinate -0 [' || l_sql_char_result || '] should have id [' || l_usim_id_pos || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '022';
  IF usim_pos.coordinate_exists(0, 0) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': coordinate 0, sign 0, should exist.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '023';
  IF usim_pos.coordinate_exists(0, 1) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': coordinate 0, sign 1, should exist.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Get sign';
  l_run_id := '024';
  IF usim_pos.get_sign(0, 0) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_sign(0, 0) should be 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '025';
  IF usim_pos.get_sign(NULL, 0) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_sign(NULL, 0) should be 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '026';
  IF usim_pos.get_sign(NULL, NULL) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_sign(NULL, NULL) should be 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '027';
  IF usim_pos.get_sign(0, 1) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_sign(0, 1) should be 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '028';
  IF usim_pos.get_sign(0, -1) != -1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_sign(0, -1) should be -1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '029';
  IF usim_pos.get_sign(1, -1) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_sign(1, -1) should be 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '030';
  IF usim_pos.get_sign(-1, 1) != -1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_sign(-1, 1) should be -1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Insert given coordinate';
  l_run_id := '031';
  l_usim_coordinate := usim_pos.get_max_coordinate(1) + 1;
  l_usim_id_pos     := usim_pos.insert_next_position(l_usim_coordinate, 1);
  IF l_usim_id_pos IS NULL
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': inserting next coordinate (max +1) should work.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '032';
  l_sql_char_result := usim_pos.insert_next_position(l_usim_coordinate, 1);
  IF l_usim_id_pos != TRIM(l_sql_char_result)
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': inserting existing coordinate should return the correct coodinate.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '033';
  l_usim_id_pos     := usim_pos.insert_next_position(99, 1);
  IF l_usim_id_pos IS NOT NULL
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': inserting coordinate bigger than max +1 should not work.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  -- cleanup
  DELETE usim_basedata;
  DELETE usim_position;
  COMMIT;
  -- write test results
  usim_test.write_test_results(l_test_id, l_tests_success, l_tests_failed);
EXCEPTION
  WHEN OTHERS THEN
    usim_test.log_error(l_test_id, SUBSTR('Test section failed unexpected: [' || l_test_section || '] tests done: ' || TO_CHAR(NVL(l_tests_success, 0) + NVL(l_tests_failed, 0)) || ' last runs id ' || l_run_id || ' ora: ' || SQLERRM, 1, 4000));
    usim_test.write_test_results(l_test_id, l_tests_success, l_tests_failed);
END;
/