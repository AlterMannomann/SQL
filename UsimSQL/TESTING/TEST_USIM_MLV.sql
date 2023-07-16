DECLARE
  l_tests_success     INTEGER := 0;
  l_tests_failed      INTEGER := 0;
  l_fail_message      VARCHAR2(32000);
  l_run_id            VARCHAR2(10);
  l_test_section      VARCHAR2(100);
  l_test_object       VARCHAR2(128) := 'USIM_MLV';
  l_sql_number_result NUMBER;
  l_sql_char_result   VARCHAR2(32000);
  l_sql_date_result   DATE;
  l_usim_id_mlv       usim_multiverse.usim_id_mlv%TYPE;
  l_test_id           NUMBER;
BEGIN
  l_test_id := usim_test.init_test(l_test_object);
  l_test_section := 'No universe available';
  l_run_id := '001';
  -- setup
  DELETE usim_basedata;
  DELETE usim_multiverse;
  COMMIT;
  usim_base.init_basedata;
  IF usim_mlv.has_data = 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': no universe should exist after delete.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_test_section := 'First universe available';
  l_run_id := '002';
  l_usim_id_mlv := usim_mlv.insert_universe;
  IF usim_mlv.has_data = 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': insert failed, no universe usim_mlv.has_data NOT 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_test_section := 'Check insert values';
  l_run_id := '003';
  SELECT usim_energy_start_value INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': default usim_energy_start_value NOT 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '004';
  SELECT usim_planck_time_unit INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': default usim_planck_time_unit NOT 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '005';
  SELECT usim_planck_length_unit INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': default usim_planck_length_unit NOT 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '006';
  SELECT usim_planck_speed_unit INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': default p_usim_planck_speed_unit NOT 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '007';
  SELECT usim_planck_stable INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': default usim_planck_stable NOT 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '008';
  SELECT usim_base_sign INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': default usim_base_sign NOT 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '009';
  SELECT usim_is_base_universe INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': first insert usim_is_base_universe NOT 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '010';
  SELECT usim_mirror_sign INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != -1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': default usim_mirror_sign NOT -1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '011';
  SELECT usim_universe_status INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != usim_static.usim_multiverse_status_inactive
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': default usim_universe_status[' || l_sql_number_result || '] NOT usim_static.usim_multiverse_status_inactive[' || usim_static.usim_multiverse_status_inactive || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_test_section := 'Second universe available defaults by using 0';
  l_run_id := '012';
  l_usim_id_mlv := usim_mlv.insert_universe(0, 0, 0, 0, 1, 0);
  SELECT usim_energy_start_value INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': default usim_energy_start_value NOT 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '013';
  SELECT usim_planck_time_unit INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': default usim_planck_time_unit NOT 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '014';
  SELECT usim_planck_length_unit INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': default usim_planck_length_unit NOT 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '015';
  SELECT usim_planck_speed_unit INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': default p_usim_planck_speed_unit NOT 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '016';
  SELECT usim_planck_stable INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': default usim_planck_stable NOT 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '017';
  SELECT usim_base_sign INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': default usim_base_sign NOT 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '018';
  SELECT usim_is_base_universe INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': second insert usim_is_base_universe NOT 0.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '019';
  SELECT usim_mirror_sign INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != -1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': default usim_mirror_sign NOT -1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '020';
  SELECT usim_universe_status INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != usim_static.usim_multiverse_status_inactive
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': default usim_universe_status[' || l_sql_number_result || '] NOT usim_static.usim_multiverse_status_inactive[' || usim_static.usim_multiverse_status_inactive || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_test_section := 'Universe exists and p_do_commit';
  l_run_id := '021';
  IF usim_mlv.has_data(l_usim_id_mlv) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_mlv.universe_exists[' || l_usim_id_mlv || '] NOT 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '022';
  l_usim_id_mlv := usim_mlv.insert_universe(0, 0, 0, 0, 1, 0, FALSE);
  IF usim_mlv.has_data(l_usim_id_mlv) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_mlv.universe_exists[' || l_usim_id_mlv || '] NOT 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '023';
  ROLLBACK;
  IF usim_mlv.has_data(l_usim_id_mlv) != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_mlv.universe_exists[' || l_usim_id_mlv || '] NOT 0.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_test_section := 'Third universe available by using negative values';
  l_run_id := '024';
  l_usim_id_mlv := usim_mlv.insert_universe(-1, -1, -1, -1, -1, -10);
  SELECT usim_energy_start_value INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': insert usim_energy_start_value NOT 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '025';
  SELECT usim_planck_time_unit INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': insert usim_planck_time_unit NOT 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '026';
  SELECT usim_planck_length_unit INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': insert usim_planck_length_unit NOT 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '027';
  SELECT usim_planck_speed_unit INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': insert usim_planck_speed_unit NOT 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '028';
  SELECT usim_planck_stable INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': insert usim_planck_stable NOT 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '029';
  SELECT usim_base_sign INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != -1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': insert usim_base_sign NOT -1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '030';
  SELECT usim_mirror_sign INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': insert usim_mirror_sign NOT 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Fourth universe available by using not default values';
  l_run_id := '031';
  l_usim_id_mlv := usim_mlv.insert_universe(100, 2, 3, 4, 1, 1);
  SELECT usim_energy_start_value INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 100
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': insert usim_energy_start_value NOT 100.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '032';
  SELECT usim_planck_time_unit INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 2
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': insert usim_planck_time_unit NOT 2.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '033';
  SELECT usim_planck_length_unit INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 3
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': insert usim_planck_length_unit NOT 3.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '034';
  SELECT usim_planck_speed_unit INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 4
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': insert usim_planck_speed_unit NOT 4.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Fifth universe update energy and check state';
  l_run_id := '035';
  l_usim_id_mlv := usim_mlv.insert_universe(p_do_commit => FALSE);
  ROLLBACK;
  l_sql_number_result := usim_mlv.update_energy(l_usim_id_mlv, 0, 10);
  IF l_sql_number_result != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': update [' || l_sql_number_result || '] energy on not existing universe [' || l_usim_id_mlv || '] NOT 0.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '036';
  l_usim_id_mlv := usim_mlv.insert_universe;
  l_sql_number_result := usim_mlv.update_energy(l_usim_id_mlv, 10, -10);
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': update [' || l_sql_number_result || '] energy fails on existing universe [' || l_usim_id_mlv || '] NOT 0.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  -- check values and state
  l_run_id := '037';
  SELECT usim_energy_positive INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 10
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_energy_positive [' || l_sql_number_result || '] after update NOT 10.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '038';
  SELECT usim_energy_negative INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != -10
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_energy_negative [' || l_sql_number_result || '] after update NOT -10.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '039';
  SELECT usim_universe_status INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != usim_static.usim_multiverse_status_active
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_universe_status [' || l_sql_number_result || '] after update NOT active [' || usim_static.usim_multiverse_status_active || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '040';
  l_sql_number_result := usim_mlv.update_energy(l_usim_id_mlv, NULL, NULL);
  SELECT usim_universe_status INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != usim_static.usim_multiverse_status_dead
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_universe_status [' || l_sql_number_result || '] after update NULL NOT dead [' || usim_static.usim_multiverse_status_dead || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '041';
  l_sql_number_result := usim_mlv.update_energy(l_usim_id_mlv, 0, 0);
  SELECT usim_universe_status INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != usim_static.usim_multiverse_status_dead
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_universe_status [' || l_sql_number_result || '] after update 0 NOT dead [' || usim_static.usim_multiverse_status_dead || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '042';
  l_sql_number_result := usim_mlv.update_energy(l_usim_id_mlv, 10, NULL);
  SELECT usim_universe_status INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != usim_static.usim_multiverse_status_crashed
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_universe_status [' || l_sql_number_result || '] after update only positive energy NOT crashed [' || usim_static.usim_multiverse_status_crashed || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '043';
  l_sql_number_result := usim_mlv.update_energy(l_usim_id_mlv, NULL, -10);
  SELECT usim_universe_status INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != usim_static.usim_multiverse_status_crashed
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_universe_status [' || l_sql_number_result || '] after update only negative energy NOT crashed [' || usim_static.usim_multiverse_status_crashed || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '044';
  l_sql_number_result := usim_mlv.update_energy(l_usim_id_mlv, -10, -10);
  SELECT usim_universe_status INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != usim_static.usim_multiverse_status_crashed
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_universe_status [' || l_sql_number_result || '] after update of not equilibrated energy NOT crashed [' || usim_static.usim_multiverse_status_crashed || '].';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Fifth universe update check do commit';
  l_run_id := '045';
  l_sql_number_result := usim_mlv.update_energy(l_usim_id_mlv, 10, -10);
  l_sql_number_result := usim_mlv.update_energy(l_usim_id_mlv, 20, -20, FALSE);
  ROLLBACK;
  SELECT usim_energy_positive INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 10
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_energy_positive [' || l_sql_number_result || '] after update rollback NOT 10.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '046';
  SELECT usim_energy_negative INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != -10
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': usim_energy_negative [' || l_sql_number_result || '] after update rollback NOT -10.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Planck units update and planck stable 1';
  l_run_id := '047';
  l_usim_id_mlv := usim_mlv.insert_universe(p_usim_planck_stable => 1);
  SELECT usim_mlv.get_planck_stable(l_usim_id_mlv) INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_planck_stable [' || l_sql_number_result || '] NOT 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '048';
  SELECT usim_mlv.get_planck_stable('NO_VALID_ID') INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != -1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_planck_stable with invalid id [' || l_sql_number_result || '] NOT -1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '049';
  l_sql_number_result := usim_mlv.update_planck_unit_time_speed(l_usim_id_mlv, 1, 1);
  IF l_sql_number_result != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': update [' || l_sql_number_result || '] of planck units with planck stable 1 should not work.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '050';
  l_sql_number_result := usim_mlv.update_planck_unit_time_length(l_usim_id_mlv, 1, 1);
  IF l_sql_number_result != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': update [' || l_sql_number_result || '] of planck units with planck stable 1 should not work.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '051';
  l_sql_number_result := usim_mlv.update_planck_unit_speed_length(l_usim_id_mlv, 1, 1);
  IF l_sql_number_result != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': update [' || l_sql_number_result || '] of planck units with planck stable 1 should not work.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Planck units update and planck stable 0';
  l_run_id := '052';
  l_usim_id_mlv := usim_mlv.insert_universe(p_usim_planck_stable => 0);
  SELECT usim_mlv.get_planck_stable(l_usim_id_mlv) INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': get_planck_stable [' || l_sql_number_result || '] NOT 0.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '053';
  l_sql_number_result := usim_mlv.update_planck_unit_time_speed(l_usim_id_mlv, 2, 2);
  IF l_sql_number_result != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': update [' || l_sql_number_result || '] of planck units with planck stable 0 should work.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '054';
  SELECT usim_planck_time_unit INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 2
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': update usim_planck_time_unit [' || l_sql_number_result || '] NOT 2.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '055';
  SELECT usim_planck_speed_unit INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 2
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': update usim_planck_speed_unit [' || l_sql_number_result || '] NOT 2.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '056';
  SELECT usim_planck_length_unit INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 4
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': update usim_planck_length_unit [' || l_sql_number_result || '] NOT 2.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '057';
  l_sql_number_result := usim_mlv.update_planck_unit_time_length(l_usim_id_mlv, 3, 9);
  SELECT usim_planck_time_unit INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 3
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': update usim_planck_time_unit [' || l_sql_number_result || '] NOT 3.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '058';
  SELECT usim_planck_length_unit INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 9
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': update usim_planck_length_unit [' || l_sql_number_result || '] NOT 9.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '059';
  SELECT usim_planck_speed_unit INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 3
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': update usim_planck_speed_unit [' || l_sql_number_result || '] NOT 3.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '060';
  l_sql_number_result := usim_mlv.update_planck_unit_speed_length(l_usim_id_mlv, 2, 4);
  SELECT usim_planck_speed_unit INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 2
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': update usim_planck_speed_unit [' || l_sql_number_result || '] NOT 2.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '061';
  SELECT usim_planck_length_unit INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 4
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': update usim_planck_length_unit [' || l_sql_number_result || '] NOT 4.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '062';
  SELECT usim_planck_time_unit INTO l_sql_number_result FROM usim_multiverse WHERE usim_id_mlv = l_usim_id_mlv;
  IF l_sql_number_result != 2
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': update usim_planck_time_unit [' || l_sql_number_result || '] NOT 2.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Get universe sign';
  l_run_id := '063';
  IF usim_mlv.get_base_sign(l_usim_id_mlv) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': default base sign not 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '064';
  IF usim_mlv.get_mirror_sign(l_usim_id_mlv) != -1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': default mirror sign not -1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '065';
  IF usim_mlv.get_base_sign('NOT EXISTS') != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': base sign for not existing universe not 0.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '066';
  IF usim_mlv.get_mirror_sign('NOT EXISTS') != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': mirror sign for not existing universe not 0.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Check base universe';
  l_run_id := '067';
  DELETE usim_basedata;
  DELETE usim_multiverse;
  COMMIT;
  IF usim_mlv.is_base('NOT EXISTS') IS NOT NULL
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': is_base for empty table should be NULL.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '068';
  l_usim_id_mlv := usim_mlv.insert_universe;
  IF usim_mlv.is_base(l_usim_id_mlv) != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': is_base for first universe should be 1.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  l_run_id := '069';
  l_usim_id_mlv := usim_mlv.insert_universe;
  IF usim_mlv.is_base(l_usim_id_mlv) != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': is_base for second universe should be 0.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  -- cleanup
  DELETE usim_basedata;
  DELETE usim_multiverse;
  COMMIT;
  -- write test results
  usim_test.write_test_results(l_test_id, l_tests_success, l_tests_failed);
EXCEPTION
  WHEN OTHERS THEN
    usim_test.log_error(l_test_id, SUBSTR('Test section failed unexpected: [' || l_test_section || '] tests done: ' || TO_CHAR(NVL(l_tests_success, 0) + NVL(l_tests_failed, 0)) || ' last runs id ' || l_run_id || ' ora: ' || SQLERRM, 1, 4000));
    usim_test.write_test_results(l_test_id, l_tests_success, l_tests_failed);
END;
/