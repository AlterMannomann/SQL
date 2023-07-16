DECLARE
  l_tests_success     INTEGER := 0;
  l_tests_failed      INTEGER := 0;
  l_fail_message      VARCHAR2(4000);
  l_run_id            VARCHAR2(10);
  l_test_section      VARCHAR2(100);
  l_test_object       VARCHAR2(128) := 'USIM_VOLUME table';
  l_sql_number_result NUMBER;
  l_sql_char_result   VARCHAR2(32000);
  l_sql_date_result   DATE;
  l_test_id           NUMBER;
  l_usim_id_mlv       usim_multiverse.usim_id_mlv%TYPE;
  l_usim_id_pos1      usim_position.usim_id_pos%TYPE;
  l_usim_id_pos2      usim_position.usim_id_pos%TYPE;
  l_usim_id_pos3      usim_position.usim_id_pos%TYPE;
  l_usim_id_pos4      usim_position.usim_id_pos%TYPE;
  l_usim_id_vol       usim_volume.usim_id_vol%TYPE;
BEGIN
  l_test_id := usim_test.init_test(l_test_object);
  l_test_section := 'Table constraints';
  l_run_id := '001';
  -- setup
  DELETE usim_basedata;
  DELETE usim_multiverse;
  DELETE usim_position;
  DELETE usim_volume;
  COMMIT;
  usim_base.init_basedata;
  l_usim_id_mlv := usim_mlv.insert_universe;
  l_usim_id_pos1 := usim_pos.insert_next_position(1, TRUE); -- 0, 0
  l_usim_id_pos1 := usim_pos.insert_next_position(1, TRUE); -- 0, 1
  l_usim_id_pos2 := usim_pos.insert_next_position(1, TRUE); -- 1, 1
  l_usim_id_pos3 := usim_pos.insert_next_position(-1, TRUE); -- 0, -1
  l_usim_id_pos4 := usim_pos.insert_next_position(-1, TRUE); -- -1, -1

  BEGIN
    INSERT INTO usim_volume
      ( usim_id_mlv
      , usim_id_pos_base_from
      , usim_id_pos_base_to
      , usim_id_pos_mirror_from
      , usim_id_pos_mirror_to
      )
      VALUES
      ( l_usim_id_mlv
      , l_usim_id_pos1
      , l_usim_id_pos2
      , l_usim_id_pos3
      , l_usim_id_pos4
      )
      RETURNING usim_id_vol INTO l_usim_id_vol
    ;
    INSERT INTO usim_volume
      ( usim_id_mlv
      , usim_id_pos_base_from
      , usim_id_pos_base_to
      , usim_id_pos_mirror_from
      , usim_id_pos_mirror_to
      )
      VALUES
      ( l_usim_id_mlv
      , l_usim_id_pos1
      , l_usim_id_pos2
      , l_usim_id_pos3
      , l_usim_id_pos4
      )
      RETURNING usim_id_vol INTO l_usim_id_vol
    ;
    -- input should be prevented by constraint
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': duplicate insert of same ids should not be possible.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF INSTR(SQLERRM, 'USIM_VOL_UK') > 0
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
    INSERT INTO usim_volume
      ( usim_id_mlv
      , usim_id_pos_base_from
      , usim_id_pos_base_to
      , usim_id_pos_mirror_from
      , usim_id_pos_mirror_to
      )
      VALUES
      ( l_usim_id_mlv
      , 'NOT EXISTS'
      , l_usim_id_pos2
      , l_usim_id_pos3
      , l_usim_id_pos4
      )
      RETURNING usim_id_vol INTO l_usim_id_vol
    ;
    -- input should be prevented by constraint
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': insert of not existing pos id on base_from should not be possible.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF INSTR(SQLERRM, 'USIM_VOL_POS1_FK') > 0
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
    INSERT INTO usim_volume
      ( usim_id_mlv
      , usim_id_pos_base_from
      , usim_id_pos_base_to
      , usim_id_pos_mirror_from
      , usim_id_pos_mirror_to
      )
      VALUES
      ( l_usim_id_mlv
      , l_usim_id_pos1
      , 'NOT EXISTS'
      , l_usim_id_pos3
      , l_usim_id_pos4
      )
      RETURNING usim_id_vol INTO l_usim_id_vol
    ;
    -- input should be prevented by constraint
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': insert of not existing pos id on base_to should not be possible.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF INSTR(SQLERRM, 'USIM_VOL_POS2_FK') > 0
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
    INSERT INTO usim_volume
      ( usim_id_mlv
      , usim_id_pos_base_from
      , usim_id_pos_base_to
      , usim_id_pos_mirror_from
      , usim_id_pos_mirror_to
      )
      VALUES
      ( l_usim_id_mlv
      , l_usim_id_pos1
      , l_usim_id_pos2
      , 'NOT EXISTS'
      , l_usim_id_pos4
      )
      RETURNING usim_id_vol INTO l_usim_id_vol
    ;
    -- input should be prevented by constraint
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': insert of not existing pos id on mirror_from should not be possible.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF INSTR(SQLERRM, 'USIM_VOL_POS3_FK') > 0
      THEN
        l_tests_success := l_tests_success + 1;
      ELSE
        l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': unexpected error ' || SQLCODE || ': ' || SQLERRM;
        usim_test.log_error(l_test_id, l_fail_message);
        l_tests_failed := l_tests_failed + 1;
      END IF;
  END;
  ROLLBACK;
  l_run_id := '005';
  BEGIN
    INSERT INTO usim_volume
      ( usim_id_mlv
      , usim_id_pos_base_from
      , usim_id_pos_base_to
      , usim_id_pos_mirror_from
      , usim_id_pos_mirror_to
      )
      VALUES
      ( l_usim_id_mlv
      , l_usim_id_pos1
      , l_usim_id_pos2
      , l_usim_id_pos3
      , 'NOT EXISTS'
      )
      RETURNING usim_id_vol INTO l_usim_id_vol
    ;
    -- input should be prevented by constraint
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': insert of not existing pos id on mirror_to should not be possible.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF INSTR(SQLERRM, 'USIM_VOL_POS4_FK') > 0
      THEN
        l_tests_success := l_tests_success + 1;
      ELSE
        l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': unexpected error ' || SQLCODE || ': ' || SQLERRM;
        usim_test.log_error(l_test_id, l_fail_message);
        l_tests_failed := l_tests_failed + 1;
      END IF;
  END;
  ROLLBACK;

  l_test_section := 'Table insert trigger';
  -- throws insert trigger instead of fk
  l_run_id := '006';
  BEGIN
    INSERT INTO usim_volume
      ( usim_id_mlv
      , usim_id_pos_base_from
      , usim_id_pos_base_to
      , usim_id_pos_mirror_from
      , usim_id_pos_mirror_to
      )
      VALUES
      ( 'NOT EXISTS'
      , l_usim_id_pos1
      , l_usim_id_pos2
      , l_usim_id_pos3
      , l_usim_id_pos4
      )
      RETURNING usim_id_vol INTO l_usim_id_vol
    ;
    -- input should be prevented by constraint
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': insert of not existing mlv id should not be possible and position signs must match universe.';
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
  l_run_id := '007';
  l_sql_char_result := usim_mlv.insert_universe(p_usim_base_sign => -1, p_do_commit => FALSE);
  BEGIN
    INSERT INTO usim_volume
      ( usim_id_mlv
      , usim_id_pos_base_from
      , usim_id_pos_base_to
      , usim_id_pos_mirror_from
      , usim_id_pos_mirror_to
      )
      VALUES
      ( l_sql_char_result
      , l_usim_id_pos1
      , l_usim_id_pos2
      , l_usim_id_pos3
      , l_usim_id_pos4
      )
      RETURNING usim_id_vol INTO l_usim_id_vol
    ;
    -- input should be prevented by constraint
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': position signs must match universe.';
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
  l_run_id := '008';
  BEGIN
    INSERT INTO usim_volume
      ( usim_id_mlv
      , usim_id_pos_base_from
      , usim_id_pos_base_to
      , usim_id_pos_mirror_from
      , usim_id_pos_mirror_to
      )
      VALUES
      ( l_usim_id_mlv
      , l_usim_id_pos1
      , l_usim_id_pos3
      , l_usim_id_pos3
      , l_usim_id_pos4
      )
      RETURNING usim_id_vol INTO l_usim_id_vol
    ;
    -- input should be prevented by constraint
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': position sign base from-to must match.';
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
  l_run_id := '009';
  BEGIN
    INSERT INTO usim_volume
      ( usim_id_mlv
      , usim_id_pos_base_from
      , usim_id_pos_base_to
      , usim_id_pos_mirror_from
      , usim_id_pos_mirror_to
      )
      VALUES
      ( l_usim_id_mlv
      , l_usim_id_pos1
      , l_usim_id_pos2
      , l_usim_id_pos2
      , l_usim_id_pos4
      )
      RETURNING usim_id_vol INTO l_usim_id_vol
    ;
    -- input should be prevented by constraint
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': position sign mirror from-to must match.';
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
  l_run_id := '010';
  BEGIN
    INSERT INTO usim_volume
      ( usim_id_mlv
      , usim_id_pos_base_from
      , usim_id_pos_base_to
      , usim_id_pos_mirror_from
      , usim_id_pos_mirror_to
      )
      VALUES
      ( l_usim_id_mlv
      , l_usim_id_pos2
      , l_usim_id_pos1
      , l_usim_id_pos2
      , l_usim_id_pos4
      )
      RETURNING usim_id_vol INTO l_usim_id_vol
    ;
    -- input should be prevented by constraint
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': position base to should be greater than from.';
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
  l_run_id := '011';
  BEGIN
    INSERT INTO usim_volume
      ( usim_id_mlv
      , usim_id_pos_base_from
      , usim_id_pos_base_to
      , usim_id_pos_mirror_from
      , usim_id_pos_mirror_to
      )
      VALUES
      ( l_usim_id_mlv
      , l_usim_id_pos1
      , l_usim_id_pos2
      , l_usim_id_pos4
      , l_usim_id_pos3
      )
      RETURNING usim_id_vol INTO l_usim_id_vol
    ;
    -- input should be prevented by constraint
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': position mirror to should be greater than from.';
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
  l_run_id := '012';
  BEGIN
    INSERT INTO usim_volume
      ( usim_id_mlv
      , usim_id_pos_base_from
      , usim_id_pos_base_to
      , usim_id_pos_mirror_from
      , usim_id_pos_mirror_to
      )
      VALUES
      ( l_usim_id_mlv
      , l_usim_id_pos1
      , l_usim_id_pos2
      , l_usim_id_pos3
      , l_usim_id_pos3
      )
      RETURNING usim_id_vol INTO l_usim_id_vol
    ;
    -- input should be prevented by constraint
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': position mirror to-from should not be equal.';
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
  l_run_id := '013';
  BEGIN
    INSERT INTO usim_volume
      ( usim_id_mlv
      , usim_id_pos_base_from
      , usim_id_pos_base_to
      , usim_id_pos_mirror_from
      , usim_id_pos_mirror_to
      )
      VALUES
      ( l_usim_id_mlv
      , l_usim_id_pos1
      , l_usim_id_pos1
      , l_usim_id_pos3
      , l_usim_id_pos4
      )
      RETURNING usim_id_vol INTO l_usim_id_vol
    ;
    -- input should be prevented by constraint
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': position base to-from should not be equal.';
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
  l_run_id := '014';
  BEGIN
    INSERT INTO usim_volume
      ( usim_id_vol
      , usim_id_mlv
      , usim_id_pos_base_from
      , usim_id_pos_base_to
      , usim_id_pos_mirror_from
      , usim_id_pos_mirror_to
      )
      VALUES
      ( 'BLA'
      , l_usim_id_mlv
      , l_usim_id_pos1
      , l_usim_id_pos2
      , l_usim_id_pos3
      , l_usim_id_pos4
      )
      RETURNING usim_id_vol INTO l_usim_id_vol
    ;
    -- check input value
    IF TRIM(l_usim_id_vol) != 'BLA'
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_usim_id_vol || '] setting id should not be possible.';
      usim_test.log_error(l_test_id, l_fail_message);
      l_tests_failed := l_tests_failed + 1;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': unexpected error ' || SQLCODE || ': ' || SQLERRM;
      usim_test.log_error(l_test_id, l_fail_message);
      l_tests_failed := l_tests_failed + 1;
  END;
  ROLLBACK;

  l_test_section := 'Table update trigger';
  l_run_id := '015';
  BEGIN
    INSERT INTO usim_volume
      ( usim_id_mlv
      , usim_id_pos_base_from
      , usim_id_pos_base_to
      , usim_id_pos_mirror_from
      , usim_id_pos_mirror_to
      )
      VALUES
      ( l_usim_id_mlv
      , l_usim_id_pos1
      , l_usim_id_pos2
      , l_usim_id_pos3
      , l_usim_id_pos4
      )
      RETURNING usim_id_vol INTO l_usim_id_vol
    ;
    UPDATE usim_volume SET usim_id_vol = 'BLA' WHERE usim_id_vol = l_usim_id_vol RETURNING usim_id_vol INTO l_sql_char_result;
     l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_char_result || '] update should not be possible.';
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
  COMMIT;
  -- write test results
  usim_test.write_test_results(l_test_id, l_tests_success, l_tests_failed);
EXCEPTION
  WHEN OTHERS THEN
    usim_test.log_error(l_test_id, SUBSTR('Test section failed unexpected: [' || l_test_section || '] tests done: ' || TO_CHAR(NVL(l_tests_success, 0) + NVL(l_tests_failed, 0)) || ' last runs id ' || l_run_id || ' ora: ' || SQLERRM, 1, 4000));
    usim_test.write_test_results(l_test_id, l_tests_success, l_tests_failed);
END;
/