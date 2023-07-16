DECLARE
  l_tests_success     INTEGER := 0;
  l_tests_failed      INTEGER := 0;
  l_fail_message      VARCHAR2(4000);
  l_run_id            VARCHAR2(10);
  l_test_section      VARCHAR2(100);
  l_test_object       VARCHAR2(128) := 'USIM_VOL';
  l_sql_number_result NUMBER;
  l_sql_char_result   VARCHAR2(32000);
  l_sql_date_result   DATE;
  l_test_id           NUMBER;
  l_usim_id_mlv       usim_multiverse.usim_id_mlv%TYPE;
  l_usim_id_pos       usim_position.usim_id_pos%TYPE;
  l_usim_id_pos1      usim_position.usim_id_pos%TYPE;
  l_usim_id_pos2      usim_position.usim_id_pos%TYPE;
  l_usim_id_pos3      usim_position.usim_id_pos%TYPE;
  l_usim_id_pos4      usim_position.usim_id_pos%TYPE;
  l_usim_id_vol       usim_volume.usim_id_vol%TYPE;
BEGIN
  l_test_id := usim_test.init_test(l_test_object);
  l_test_section := 'Functions no data';
  l_run_id := '001';
  -- setup
  DELETE usim_basedata;
  DELETE usim_multiverse;
  DELETE usim_position;
  DELETE usim_volume;
  COMMIT;
  usim_base.init_basedata;
  l_usim_id_mlv  := usim_mlv.insert_universe;
  l_usim_id_pos  := usim_pos.insert_next_position(1, TRUE); -- 0, 0
  l_usim_id_pos1 := usim_pos.insert_next_position(1, TRUE); -- 0, 1
  l_usim_id_pos2 := usim_pos.insert_next_position(1, TRUE); -- 1, 1
  l_usim_id_pos3 := usim_pos.insert_next_position(-1, TRUE); -- 0, -1
  l_usim_id_pos4 := usim_pos.insert_next_position(-1, TRUE); -- -1, -1

  IF usim_vol.has_data = 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should not report data on empty table.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '002';
  IF usim_vol.has_data(l_usim_id_mlv, l_usim_id_pos1, l_usim_id_pos2, l_usim_id_pos3, l_usim_id_pos4) = 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should not report data on not inserted ids and empty table.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '003';
  IF usim_vol.has_data('BLA') = 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should not report data on non existing id and empty table.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '004';
  l_sql_char_result := usim_vol.get_id_vol(l_usim_id_mlv, l_usim_id_pos1, l_usim_id_pos2, l_usim_id_pos3, l_usim_id_pos4);
  IF l_sql_char_result IS NOT NULL
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_id_vol should not get id [' || l_sql_char_result || '] on not inserted ids and empty table.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '005';
  l_sql_number_result := usim_vol.get_next_base_from('BLA');
  IF l_sql_number_result IS NOT NULL
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_next_base_from should not get coordinate [' || l_sql_number_result || '] on faked id and empty table.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '006';
  l_sql_number_result := usim_vol.get_next_mirror_from('BLA');
  IF l_sql_number_result IS NOT NULL
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_next_mirror_from should not get coordinate [' || l_sql_number_result || '] on faked id and empty table.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Functions insert do commit FALSE';
  l_run_id := '007';
  l_usim_id_vol := usim_vol.insert_vol(l_usim_id_mlv, l_usim_id_pos1, l_usim_id_pos2, l_usim_id_pos3, l_usim_id_pos4, FALSE);
  IF usim_vol.has_data = 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should report data after insert.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '008';
  IF usim_vol.has_data(l_usim_id_vol) = 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should report data for id after insert.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '009';
  IF usim_vol.has_data(l_usim_id_mlv, l_usim_id_pos1, l_usim_id_pos2, l_usim_id_pos3, l_usim_id_pos4) = 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should report data on inserted ids.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '010';
  l_sql_char_result := usim_vol.get_id_vol(l_usim_id_mlv, l_usim_id_pos1, l_usim_id_pos2, l_usim_id_pos3, l_usim_id_pos4);
  IF TRIM(l_sql_char_result) != l_usim_id_vol
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_id_vol should get id [' || l_usim_id_vol || '] not [' || l_sql_char_result || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '011';
  l_sql_number_result := usim_vol.get_next_base_from(l_usim_id_vol);
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_next_base_from should get 1 not [' || l_sql_number_result || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '012';
  l_sql_number_result := usim_vol.get_next_mirror_from(l_usim_id_vol);
  IF l_sql_number_result != -1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_next_mirror_from should get -1 not [' || l_sql_number_result || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '013';
  ROLLBACK;
  IF usim_vol.has_data(l_usim_id_vol) = 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should not report data for id after insert rollback.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Functions insert do commit TRUE';
  l_run_id := '014';
  l_usim_id_vol := usim_vol.insert_vol(l_usim_id_mlv, l_usim_id_pos1, l_usim_id_pos2, l_usim_id_pos3, l_usim_id_pos4);
  IF usim_vol.has_data(l_usim_id_vol) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should report data for id after insert.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '015';
  ROLLBACK;
  IF usim_vol.has_data(l_usim_id_vol) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should report data for id after insert commit rollback.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Overflow function';
  l_run_id := '016';
  -- setup overflow
  DELETE usim_basedata;
  DELETE usim_multiverse;
  DELETE usim_position;
  DELETE usim_volume;
  COMMIT;
  usim_base.init_basedata(p_usim_abs_max_number => 2);
  l_usim_id_mlv  := usim_mlv.insert_universe;
  l_usim_id_pos  := usim_pos.insert_next_position(1, TRUE); -- 0, 0
  l_usim_id_pos1 := usim_pos.insert_next_position(1, TRUE); -- 0, 1
  l_usim_id_pos2 := usim_pos.insert_next_position(1, TRUE); -- 1, 1
  l_usim_id_pos3 := usim_pos.insert_next_position(-1, TRUE); -- 0, -1
  l_usim_id_pos4 := usim_pos.insert_next_position(-1, TRUE); -- -1, -1
  l_usim_id_vol := usim_vol.insert_vol(l_usim_id_mlv, l_usim_id_pos1, l_usim_id_pos2, l_usim_id_pos3, l_usim_id_pos4);
  IF usim_vol.overflow_reached(l_usim_id_mlv) = 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': should not reach overflow on coordinate not max.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '017';
  l_usim_id_pos1 := usim_pos.insert_next_position(1, TRUE); -- 2, 1
  l_usim_id_pos3 := usim_pos.insert_next_position(-1, TRUE); -- -2, -1
  l_usim_id_vol := usim_vol.insert_vol(l_usim_id_mlv, l_usim_id_pos2, l_usim_id_pos1, l_usim_id_pos4, l_usim_id_pos3);
  IF usim_vol.overflow_reached(l_usim_id_mlv) = 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': should reach overflow on coordinate max.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Get universe id function';
  l_run_id := '018';
  IF usim_vol.get_id_mlv('NOT EXISTS') IS NOT NULL
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_id_mlv should be NULL for not existing id.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '019';
  IF usim_vol.get_id_mlv(l_usim_id_vol) IS NULL
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_id_mlv should not be NULL for existing id.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  -- cleanup
  DELETE usim_basedata;
  DELETE usim_multiverse;
  DELETE usim_position;
  DELETE usim_volume;
  COMMIT;
  -- write test results
  usim_test.write_test_results(l_test_id, l_tests_success, l_tests_failed);
EXCEPTION
  WHEN OTHERS THEN
    usim_test.log_error(l_test_id, SUBSTR('Test section failed unexpected: [' || l_test_section || '] tests done: ' || TO_CHAR(NVL(l_tests_success, 0) + NVL(l_tests_failed, 0)) || ' last runs id ' || l_run_id || ' ora: ' || SQLERRM, 1, 4000));
    usim_test.write_test_results(l_test_id, l_tests_success, l_tests_failed);
END;
/