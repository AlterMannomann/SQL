DECLARE
  l_tests_success       INTEGER := 0;
  l_tests_failed        INTEGER := 0;
  l_fail_message        VARCHAR2(4000);
  l_run_id              VARCHAR2(10);
  l_test_section        VARCHAR2(100);
  l_test_object         VARCHAR2(128) := 'USIM_RVM';
  l_sql_number_result   NUMBER;
  l_sql_char_result     VARCHAR2(32000);
  l_sql_date_result     DATE;
  l_test_id             NUMBER;
  l_usim_id_mlv         usim_multiverse.usim_id_mlv%TYPE;
  l_usim_id_mlv_child   usim_multiverse.usim_id_mlv%TYPE;
  l_usim_id_mlv2        usim_multiverse.usim_id_mlv%TYPE;
  l_usim_id_pos         usim_position.usim_id_pos%TYPE;
  l_usim_id_pos1        usim_position.usim_id_pos%TYPE;
  l_usim_id_pos2        usim_position.usim_id_pos%TYPE;
  l_usim_id_pos3        usim_position.usim_id_pos%TYPE;
  l_usim_id_pos4        usim_position.usim_id_pos%TYPE;
  l_usim_id_vol         usim_volume.usim_id_vol%TYPE;
  l_usim_id_vol2        usim_volume.usim_id_vol%TYPE;
  l_usim_id_vol_parent  usim_volume.usim_id_vol%TYPE;
  l_usim_id_dim         usim_dimension.usim_id_dim%TYPE;
  l_usim_id_rmd         usim_rel_mlv_dim.usim_id_rmd%TYPE;
BEGIN
  l_test_id := usim_test.init_test(l_test_object);
  l_test_section := 'Functions no data';
  l_run_id := '001';
  -- setup
  DELETE usim_basedata;
  DELETE usim_multiverse;
  DELETE usim_position;
  DELETE usim_volume;
  DELETE usim_rel_vol_mlv;
  DELETE usim_dimension;
  DELETE usim_rel_mlv_dim;
  COMMIT;
  usim_base.init_basedata;
  l_usim_id_mlv       := usim_mlv.insert_universe;
  l_usim_id_mlv_child := usim_mlv.insert_universe;
  l_usim_id_mlv2      := usim_mlv.insert_universe;
  l_usim_id_pos       := usim_pos.insert_next_position(1, TRUE); -- 0, 0
  l_usim_id_pos1      := usim_pos.insert_next_position(1, TRUE); -- 0, 1
  l_usim_id_pos2      := usim_pos.insert_next_position(1, TRUE); -- 1, 1
  l_usim_id_pos3      := usim_pos.insert_next_position(-1, TRUE); -- 0, -1
  l_usim_id_pos4      := usim_pos.insert_next_position(-1, TRUE); -- -1, -1
  l_usim_id_vol       := usim_vol.insert_vol(l_usim_id_mlv, l_usim_id_pos1, l_usim_id_pos2, l_usim_id_pos3, l_usim_id_pos4);
  l_usim_id_pos1      := usim_pos.insert_next_position(1, TRUE); -- 2, 1
  l_usim_id_pos3      := usim_pos.insert_next_position(-1, TRUE); -- -2, -1
  l_usim_id_vol2      := usim_vol.insert_vol(l_usim_id_mlv, l_usim_id_pos2, l_usim_id_pos1, l_usim_id_pos4, l_usim_id_pos3);
  l_usim_id_dim       := usim_dim.insert_next_dimension; -- 0
  l_usim_id_rmd       := usim_rmd.insert_rmd(l_usim_id_mlv, l_usim_id_dim);
  l_usim_id_dim       := usim_dim.insert_next_dimension; -- 1
  l_usim_id_rmd       := usim_rmd.insert_rmd(l_usim_id_mlv, l_usim_id_dim);

  IF usim_rvm.has_data = 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should not report data on empty table.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '002';
  IF usim_rvm.has_data('BLA') = 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should not report data for not existing volume id on empty table.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '003';
  IF usim_rvm.has_data_mlv(l_usim_id_mlv_child) = 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should not report data for universe id on empty table.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '004';
  IF usim_rvm.has_data_mlv('BLA') = 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should not report data for not existing universe id on empty table.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Functions insert no overflow';
  l_run_id := '005';
  l_usim_id_vol_parent := usim_rvm.insert_relation(l_usim_id_vol, l_usim_id_mlv);
  IF l_usim_id_vol_parent IS NOT NULL
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': insert should do nothing if a base universe is given and overflow is not reached.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '006';
  l_usim_id_vol_parent := usim_rvm.insert_relation(l_usim_id_vol, l_usim_id_mlv_child);
  IF l_usim_id_vol_parent IS NOT NULL
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': insert should do nothing if overflow is not reached.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Functions insert overflow';
  l_run_id := '007';
  -- setup overflow
  DELETE usim_basedata;
  DELETE usim_multiverse;
  DELETE usim_position;
  DELETE usim_volume;
  DELETE usim_rel_vol_mlv;
  DELETE usim_dimension;
  DELETE usim_rel_mlv_dim;
  COMMIT;
  usim_base.init_basedata(p_max_dimension => 1, p_usim_abs_max_number => 2);
  l_usim_id_mlv        := usim_mlv.insert_universe;
  l_usim_id_mlv_child  := usim_mlv.insert_universe;
  l_usim_id_mlv2       := usim_mlv.insert_universe;
  l_usim_id_pos        := usim_pos.insert_next_position(1, TRUE); -- 0, 0
  l_usim_id_pos1       := usim_pos.insert_next_position(1, TRUE); -- 0, 1
  l_usim_id_pos2       := usim_pos.insert_next_position(1, TRUE); -- 1, 1
  l_usim_id_pos3       := usim_pos.insert_next_position(-1, TRUE); -- 0, -1
  l_usim_id_pos4       := usim_pos.insert_next_position(-1, TRUE); -- -1, -1
  l_usim_id_vol        := usim_vol.insert_vol(l_usim_id_mlv, l_usim_id_pos1, l_usim_id_pos2, l_usim_id_pos3, l_usim_id_pos4);
  l_usim_id_pos1       := usim_pos.insert_next_position(1, TRUE); -- 2, 1
  l_usim_id_pos3       := usim_pos.insert_next_position(-1, TRUE); -- -2, -1
  l_usim_id_vol2       := usim_vol.insert_vol(l_usim_id_mlv, l_usim_id_pos2, l_usim_id_pos1, l_usim_id_pos4, l_usim_id_pos3);
  l_usim_id_dim        := usim_dim.insert_next_dimension; -- 0
  l_usim_id_rmd        := usim_rmd.insert_rmd(l_usim_id_mlv, l_usim_id_dim);
  l_usim_id_dim        := usim_dim.insert_next_dimension; -- 1
  l_usim_id_rmd        := usim_rmd.insert_rmd(l_usim_id_mlv, l_usim_id_dim);
  l_usim_id_vol_parent := usim_rvm.insert_relation(l_usim_id_vol, l_usim_id_mlv_child);
  IF l_usim_id_vol_parent IS NULL
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': insert should work if overflow is reached.';
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
  DELETE usim_rel_vol_mlv;
  DELETE usim_dimension;
  DELETE usim_rel_mlv_dim;
  COMMIT;
  -- write test results
  usim_test.write_test_results(l_test_id, l_tests_success, l_tests_failed);
EXCEPTION
  WHEN OTHERS THEN
    usim_test.log_error(l_test_id, SUBSTR('Test section failed unexpected: [' || l_test_section || '] tests done: ' || TO_CHAR(NVL(l_tests_success, 0) + NVL(l_tests_failed, 0)) || ' last runs id ' || l_run_id || ' ora: ' || SQLERRM, 1, 4000));
    usim_test.write_test_results(l_test_id, l_tests_success, l_tests_failed);
END;
/