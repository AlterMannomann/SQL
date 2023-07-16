DECLARE
  l_tests_success     INTEGER := 0;
  l_tests_failed      INTEGER := 0;
  l_fail_message      VARCHAR2(4000);
  l_run_id            VARCHAR2(10);
  l_test_section      VARCHAR2(100);
  l_test_object       VARCHAR2(128) := 'USIM_RRPN';
  l_sql_number_result NUMBER;
  l_sql_char_result   VARCHAR2(32000);
  l_sql_date_result   DATE;
  l_test_id           NUMBER;
  l_usim_id_mlv       usim_multiverse.usim_id_mlv%TYPE;
  l_usim_id_dim       usim_dimension.usim_id_dim%TYPE;
  l_usim_id_pos       usim_position.usim_id_pos%TYPE;
  l_usim_id_nod       usim_node.usim_id_nod%TYPE;
  l_usim_id_rmd       usim_rel_mlv_dim.usim_id_rmd%TYPE;
  l_usim_id_rrpn      usim_rel_rmd_pos_nod.usim_id_rrpn%TYPE;
BEGIN
  l_test_id := usim_test.init_test(l_test_object);
  l_test_section := 'Functions no data';
  l_run_id := '001';
  -- setup
  DELETE usim_basedata;
  DELETE usim_multiverse;
  DELETE usim_dimension;
  DELETE usim_position;
  DELETE usim_node;
  DELETE usim_rel_mlv_dim;
  DELETE usim_rel_rmd_pos_nod;
  COMMIT;
  usim_base.init_basedata;
  l_usim_id_mlv := usim_mlv.insert_universe;
  l_usim_id_dim := usim_dim.insert_next_dimension;
  l_usim_id_pos := usim_pos.insert_next_position(1, TRUE);
  l_usim_id_nod := usim_nod.insert_node;
  l_usim_id_rmd := usim_rmd.insert_rmd(l_usim_id_mlv, l_usim_id_dim);
  IF usim_rrpn.has_data = 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should not report data on empty table.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '002';
  IF usim_rrpn.has_data('BLA') = 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should not report data for not existing id BLA on empty table.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '003';
  IF usim_rrpn.has_data(l_usim_id_rmd, l_usim_id_pos, l_usim_id_nod) = 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should not report data for not existing relation on empty table.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '004';
  l_sql_char_result := usim_rrpn.get_id_rrpn(l_usim_id_rmd, l_usim_id_pos, l_usim_id_nod);
  IF l_sql_char_result IS NOT NULL
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_id_rrpn should not get id [' || l_sql_char_result || '] for not existing relation on empty table.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Functions insert data do commit FALSE';
  l_run_id := '005';
  l_usim_id_rrpn := usim_rrpn.insert_rrpn(l_usim_id_rmd, l_usim_id_pos, l_usim_id_nod, FALSE);
  IF l_usim_id_rrpn IS NULL
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': insert_rrpn failed for existing relation ids.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '006';
  IF usim_rrpn.has_data(l_usim_id_rrpn) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should report data for existing id [' || l_usim_id_rrpn || '] after insert.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '007';
  l_sql_char_result := usim_rrpn.get_id_rrpn(l_usim_id_rmd, l_usim_id_pos, l_usim_id_nod);
  IF TRIM(l_sql_char_result) != l_usim_id_rrpn
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_id_rrpn should retrieve correct id [' || l_sql_char_result || '] for existing relation ids after insert.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '008';
  ROLLBACK;
  IF usim_rrpn.has_data(l_usim_id_rrpn) = 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should not report data for id [' || l_usim_id_rrpn || '] after insert rollback.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Functions insert data do commit TRUE';
  l_run_id := '009';
  l_usim_id_rrpn := usim_rrpn.insert_rrpn(l_usim_id_rmd, l_usim_id_pos, l_usim_id_nod);
  IF usim_rrpn.has_data(l_usim_id_rrpn) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should report data for existing id [' || l_usim_id_rrpn || '] after insert.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '010';
  ROLLBACK;
  IF usim_rrpn.has_data(l_usim_id_rrpn) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': has_data should still report data for existing id [' || l_usim_id_rrpn || '] after insert committed and rollback.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  -- cleanup
  DELETE usim_basedata;
  DELETE usim_multiverse;
  DELETE usim_dimension;
  DELETE usim_position;
  DELETE usim_node;
  DELETE usim_rel_mlv_dim;
  DELETE usim_rel_rmd_pos_nod;
  COMMIT;
  -- write test results
  usim_test.write_test_results(l_test_id, l_tests_success, l_tests_failed);
EXCEPTION
  WHEN OTHERS THEN
    usim_test.log_error(l_test_id, SUBSTR('Test section failed unexpected: [' || l_test_section || '] tests done: ' || TO_CHAR(NVL(l_tests_success, 0) + NVL(l_tests_failed, 0)) || ' last runs id ' || l_run_id || ' ora: ' || SQLERRM, 1, 4000));
    usim_test.write_test_results(l_test_id, l_tests_success, l_tests_failed);
END;
/