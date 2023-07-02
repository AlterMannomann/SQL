DECLARE
  l_tests_success     INTEGER := 0;
  l_tests_failed      INTEGER := 0;
  l_fail_message      VARCHAR2(4000);
  l_run_id            VARCHAR2(10);
  l_test_section      VARCHAR2(100);
  l_test_object       VARCHAR2(128) := 'USIM_REL_MLV_DIM_POS Table';
  l_sql_number_result NUMBER;
  l_sql_char_result   VARCHAR2(32000);
  l_sql_date_result   DATE;
  l_test_id           NUMBER;
  l_usim_id_mlv       usim_multiverse.usim_id_mlv%TYPE;
  l_usim_id_dim       usim_dimension.usim_id_dim%TYPE;
  l_usim_id_pos       usim_position.usim_id_pos%TYPE;
  l_usim_id_rmdp      usim_rel_mlv_dim_pos.usim_id_rmdp%TYPE;
BEGIN
  l_test_id := usim_test.init_test(l_test_object);
  l_test_section := 'Table constraints';
  l_run_id := '001';
  -- setup
  DELETE usim_basedata;
  DELETE usim_multiverse;
  DELETE usim_dimension;
  DELETE usim_position;
  COMMIT;
  usim_base.init_basedata;
  l_usim_id_mlv := usim_mlv.insert_universe;
  l_usim_id_dim := usim_dim.insert_next_dimension(l_usim_id_mlv);
  l_usim_id_pos := usim_pos.insert_next_position(1); -- 0
  BEGIN
    INSERT INTO usim_rel_mlv_dim_pos (usim_id_dim, usim_id_pos) VALUES (l_usim_id_dim, l_usim_id_pos) RETURNING usim_id_rmdp INTO l_usim_id_rmdp;
    INSERT INTO usim_rel_mlv_dim_pos (usim_id_dim, usim_id_pos) VALUES (l_usim_id_dim, l_usim_id_pos) RETURNING usim_id_rmdp INTO l_usim_id_rmdp;
    -- input should be prevented by constraint
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_usim_id_rmdp || '] duplicates insert should not be possible';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF INSTR(SQLERRM, 'USIM_RMDP_UK') > 0
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
  l_run_id := '002';
  BEGIN
    INSERT INTO usim_rel_mlv_dim_pos (usim_id_rmdp, usim_id_dim, usim_id_pos) VALUES ('IGNORE_IT',l_usim_id_dim, l_usim_id_pos) RETURNING usim_id_rmdp INTO l_usim_id_rmdp;
    IF TRIM(l_usim_id_rmdp) != 'IGNORE_IT'
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_usim_id_rmdp || '] insert id IGNORE_IT should not be used.';
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
  l_run_id := '003';
  BEGIN
    INSERT INTO usim_rel_mlv_dim_pos (usim_id_dim, usim_id_pos) VALUES (l_usim_id_dim, l_usim_id_pos) RETURNING usim_id_rmdp INTO l_usim_id_rmdp;
    UPDATE usim_rel_mlv_dim_pos
       SET usim_id_dim  = 'BLA'
         , usim_id_pos  = 'BLA'
         , usim_id_rmdp = 'BLA'
     WHERE usim_id_rmdp =  l_usim_id_rmdp
    RETURNING usim_id_rmdp INTO l_sql_char_result
    ;
    IF TRIM(l_sql_char_result) != 'BLA'
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_char_result || '] update of usim_id_rmdp should not work.';
      usim_test.log_error(l_test_id, l_fail_message);
      l_tests_failed := l_tests_failed + 1;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': unexpected error ' || SQLCODE || ': ' || SQLERRM;
      usim_test.log_error(l_test_id, l_fail_message);
      l_tests_failed := l_tests_failed + 1;
  END;
  l_run_id := '004';
  BEGIN
    SELECT usim_id_dim
      INTO l_sql_char_result
      FROM usim_rel_mlv_dim_pos
     WHERE usim_id_rmdp =  l_usim_id_rmdp
    ;
    IF TRIM(l_sql_char_result) != 'BLA'
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_char_result || '] update of usim_id_dim should not work.';
      usim_test.log_error(l_test_id, l_fail_message);
      l_tests_failed := l_tests_failed + 1;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': unexpected error ' || SQLCODE || ': ' || SQLERRM;
      usim_test.log_error(l_test_id, l_fail_message);
      l_tests_failed := l_tests_failed + 1;
  END;
  l_run_id := '005';
  BEGIN
    SELECT usim_id_pos
      INTO l_sql_char_result
      FROM usim_rel_mlv_dim_pos
     WHERE usim_id_rmdp =  l_usim_id_rmdp
    ;
    IF TRIM(l_sql_char_result) != 'BLA'
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_char_result || '] update of usim_id_pos should not work.';
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

  -- cleanup
  DELETE usim_basedata;
  DELETE usim_multiverse;
  DELETE usim_dimension;
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