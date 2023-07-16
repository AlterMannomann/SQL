DECLARE
  l_tests_success     INTEGER := 0;
  l_tests_failed      INTEGER := 0;
  l_fail_message      VARCHAR2(4000);
  l_run_id            VARCHAR2(10);
  l_test_section      VARCHAR2(100);
  l_test_object       VARCHAR2(128) := 'USIM_REL_VOL_MLV table';
  l_sql_number_result NUMBER;
  l_sql_char_result   VARCHAR2(32000);
  l_sql_date_result   DATE;
  l_test_id           NUMBER;
  l_usim_id_mlv       usim_multiverse.usim_id_mlv%TYPE;
  l_usim_id_mlv_child usim_multiverse.usim_id_mlv%TYPE;
  l_usim_id_mlv2      usim_multiverse.usim_id_mlv%TYPE;
  l_usim_id_pos       usim_position.usim_id_pos%TYPE;
  l_usim_id_pos1      usim_position.usim_id_pos%TYPE;
  l_usim_id_pos2      usim_position.usim_id_pos%TYPE;
  l_usim_id_pos3      usim_position.usim_id_pos%TYPE;
  l_usim_id_pos4      usim_position.usim_id_pos%TYPE;
  l_usim_id_vol       usim_volume.usim_id_vol%TYPE;
  l_usim_id_vol2      usim_volume.usim_id_vol%TYPE;
BEGIN
  l_test_id := usim_test.init_test(l_test_object);
  l_test_section := 'Table constraints';
  l_run_id := '001';
  -- setup
  DELETE usim_basedata;
  DELETE usim_multiverse;
  DELETE usim_position;
  DELETE usim_volume;
  DELETE usim_rel_vol_mlv;
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

  BEGIN
    INSERT INTO usim_rel_vol_mlv (usim_id_vol, usim_id_mlv) VALUES (l_usim_id_vol, l_usim_id_mlv_child);
    INSERT INTO usim_rel_vol_mlv (usim_id_vol, usim_id_mlv) VALUES (l_usim_id_vol, l_usim_id_mlv2);
    -- input should be prevented by constraint
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_number_result || '] pk should prevent insert.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF INSTR(SQLERRM, 'USIM_RVM_PK') > 0
      THEN
        l_tests_success := l_tests_success + 1;
      ELSE
        l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': unexpected error ' || SQLCODE || ': ' || SQLERRM;
        usim_test.log_error(l_test_id, l_fail_message);
        l_tests_failed := l_tests_failed + 1;
      END IF;
  END;
  ROLLBACK;
  l_run_id := '002';
  BEGIN
    INSERT INTO usim_rel_vol_mlv (usim_id_vol, usim_id_mlv) VALUES (l_usim_id_vol, l_usim_id_mlv_child);
    INSERT INTO usim_rel_vol_mlv (usim_id_vol, usim_id_mlv) VALUES (l_usim_id_vol2, l_usim_id_mlv_child);
    -- input should be prevented by constraint
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_number_result || '] uk should prevent insert.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF INSTR(SQLERRM, 'USIM_RVM_UK') > 0
      THEN
        l_tests_success := l_tests_success + 1;
      ELSE
        l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': unexpected error ' || SQLCODE || ': ' || SQLERRM;
        usim_test.log_error(l_test_id, l_fail_message);
        l_tests_failed := l_tests_failed + 1;
      END IF;
  END;
  ROLLBACK;
  l_run_id := '003';
  BEGIN
    INSERT INTO usim_rel_vol_mlv (usim_id_vol, usim_id_mlv) VALUES ('BLA', l_usim_id_mlv_child);
    -- input should be prevented by constraint
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_number_result || '] fk should prevent insert.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF INSTR(SQLERRM, 'USIM_RVM_VOL_FK') > 0
      THEN
        l_tests_success := l_tests_success + 1;
      ELSE
        l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': unexpected error ' || SQLCODE || ': ' || SQLERRM;
        usim_test.log_error(l_test_id, l_fail_message);
        l_tests_failed := l_tests_failed + 1;
      END IF;
  END;
  ROLLBACK;
  l_run_id := '004';
  BEGIN
    INSERT INTO usim_rel_vol_mlv (usim_id_vol, usim_id_mlv) VALUES (l_usim_id_vol, 'BLA');
    -- input should be prevented by constraint
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_number_result || '] fk should prevent insert.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF INSTR(SQLERRM, 'USIM_RVM_MLV_FK') > 0
      THEN
        l_tests_success := l_tests_success + 1;
      ELSE
        l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': unexpected error ' || SQLCODE || ': ' || SQLERRM;
        usim_test.log_error(l_test_id, l_fail_message);
        l_tests_failed := l_tests_failed + 1;
      END IF;
  END;
  ROLLBACK;

  l_test_section := 'Insert trigger';
  l_run_id := '005';
  BEGIN
    INSERT INTO usim_rel_vol_mlv (usim_id_vol, usim_id_mlv) VALUES (l_usim_id_vol, l_usim_id_mlv);
    -- input should be prevented by trigger
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_number_result || '] trigger should prevent insert.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -20000
      THEN
        l_tests_success := l_tests_success + 1;
      ELSE
        l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': unexpected error ' || SQLCODE || ': ' || SQLERRM;
        usim_test.log_error(l_test_id, l_fail_message);
        l_tests_failed := l_tests_failed + 1;
      END IF;
  END;
  ROLLBACK;

  l_test_section := 'Update trigger';
  l_run_id := '006';
  BEGIN
    INSERT INTO usim_rel_vol_mlv (usim_id_vol, usim_id_mlv) VALUES (l_usim_id_vol, l_usim_id_mlv_child);
    UPDATE usim_rel_vol_mlv SET usim_id_vol = l_usim_id_vol2, usim_id_mlv = l_usim_id_mlv2;
    -- input should be prevented by trigger
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_number_result || '] trigger should prevent update.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -20001
      THEN
        l_tests_success := l_tests_success + 1;
      ELSE
        l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': unexpected error ' || SQLCODE || ': ' || SQLERRM;
        usim_test.log_error(l_test_id, l_fail_message);
        l_tests_failed := l_tests_failed + 1;
      END IF;
  END;
  ROLLBACK;

  -- cleanup
  DELETE usim_basedata;
  DELETE usim_multiverse;
  DELETE usim_position;
  DELETE usim_volume;
  DELETE usim_rel_vol_mlv;
  COMMIT;
  -- write test results
  usim_test.write_test_results(l_test_id, l_tests_success, l_tests_failed);
EXCEPTION
  WHEN OTHERS THEN
    usim_test.log_error(l_test_id, SUBSTR('Test section failed unexpected: [' || l_test_section || '] tests done: ' || TO_CHAR(NVL(l_tests_success, 0) + NVL(l_tests_failed, 0)) || ' last runs id ' || l_run_id || ' ora: ' || SQLERRM, 1, 4000));
    usim_test.write_test_results(l_test_id, l_tests_success, l_tests_failed);
END;
/