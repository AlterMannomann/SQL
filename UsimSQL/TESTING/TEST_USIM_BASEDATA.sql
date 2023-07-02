DECLARE
  l_tests_success     INTEGER := 0;
  l_tests_failed      INTEGER := 0;
  l_fail_message      VARCHAR2(4000);
  l_run_id            VARCHAR2(10);
  l_test_section      VARCHAR2(100);
  l_test_object       VARCHAR2(128) := 'USIM_BASE_DATA table';
  l_sql_number_result NUMBER;
  l_sql_char_result   VARCHAR2(32000);
  l_sql_date_result   DATE;
  l_test_id           NUMBER;
BEGIN
  l_test_id := usim_test.init_test(l_test_object);
  l_test_section := 'Table constraints';
  -- insert record
  l_run_id := '001';
  DELETE usim_basedata;
  COMMIT;
  BEGIN
    INSERT INTO usim_basedata (usim_id_bda) VALUES (2) RETURNING usim_id_bda INTO l_sql_number_result;
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_number_result || '] insert 2 for id should not work.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF INSTR(SQLERRM, 'USIM_ID_BDA_CHK') > 0
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
    INSERT INTO usim_basedata (usim_overflow_node_seed) VALUES (2) RETURNING usim_id_bda INTO l_sql_number_result;
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_number_result || '] insert 2 for usim_overflow_node_seed should not work.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF INSTR(SQLERRM, 'USIM_OVR_BDA_CHK') > 0
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
    INSERT INTO usim_basedata (usim_max_dimension) VALUES (-2) RETURNING usim_max_dimension INTO l_sql_number_result;
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_number_result || '] insert -2 for usim_max_dimension should not work.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF INSTR(SQLERRM, 'USIM_DIM_BDA_CHK') > 0
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
    INSERT INTO usim_basedata (usim_abs_max_number) VALUES (-2) RETURNING usim_abs_max_number INTO l_sql_number_result;
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_number_result || '] insert -2 for usim_abs_max_number should not work.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF INSTR(SQLERRM, 'USIM_MAXN_BDA_CHK') > 0
      THEN
        l_tests_success := l_tests_success + 1;
      ELSE
        l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': unexpected error ' || SQLCODE || ': ' || SQLERRM;
        usim_test.log_error(l_test_id, l_fail_message);
        l_tests_failed := l_tests_failed + 1;
      END IF;
  END;
  ROLLBACK;
  l_test_section := 'Column defaults, insert trigger';
  l_run_id := '005';
  BEGIN
    INSERT INTO usim_basedata (usim_id_bda) VALUES (NULL) RETURNING usim_id_bda INTO l_sql_number_result;
    IF l_sql_number_result = 1
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_number_result || '] insert NULL for usim_id_bda NOT 1.';
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
  l_run_id := '006';
  BEGIN
    INSERT INTO usim_basedata (usim_planck_time_seq_last) VALUES (1) RETURNING usim_planck_time_seq_last INTO l_sql_number_result;
    IF l_sql_number_result = -1
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_number_result || '] insert 1 for usim_planck_time_seq_last NOT -1.';
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
  l_run_id := '007';
  BEGIN
    INSERT INTO usim_basedata (usim_planck_time_seq_curr) VALUES (1) RETURNING usim_planck_time_seq_curr INTO l_sql_number_result;
    IF l_sql_number_result = -1
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_number_result || '] insert 1 for usim_planck_time_seq_curr NOT -1.';
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
  l_run_id := '008';
  BEGIN
    INSERT INTO usim_basedata (usim_planck_aeon_seq_last) VALUES ('BLA') RETURNING usim_planck_aeon_seq_last INTO l_sql_char_result;
    IF TRIM(l_sql_char_result) = usim_static.usim_not_available
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_char_result || '] insert BLA for usim_planck_aeon_seq_last NOT ' || usim_static.usim_not_available;
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
  l_run_id := '009';
  BEGIN
    INSERT INTO usim_basedata (usim_planck_aeon_seq_curr) VALUES ('BLA') RETURNING usim_planck_aeon_seq_curr INTO l_sql_char_result;
    IF TRIM(l_sql_char_result) = usim_static.usim_not_available
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_char_result || '] insert BLA for usim_planck_aeon_seq_curr NOT ' || usim_static.usim_not_available;
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
  l_run_id := '010';
  BEGIN
    INSERT INTO usim_basedata (usim_created) VALUES (TRUNC(SYSDATE-10)) RETURNING usim_created INTO l_sql_date_result;
    IF l_sql_date_result != TRUNC(SYSDATE-10)
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || TO_CHAR(l_sql_date_result, 'DD.MM.YYYY HH24:MI:SS') || '] usim_created should not be writable.';
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
  l_run_id := '011';
  BEGIN
    INSERT INTO usim_basedata (usim_updated) VALUES (TRUNC(SYSDATE-10)) RETURNING usim_updated INTO l_sql_date_result;
    IF l_sql_date_result != TRUNC(SYSDATE-10)
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || TO_CHAR(l_sql_date_result, 'DD.MM.YYYY HH24:MI:SS') || '] usim_updated should not be writable.';
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
  l_run_id := '012';
  BEGIN
    INSERT INTO usim_basedata (usim_created_by) VALUES ('BLA') RETURNING usim_created_by INTO l_sql_char_result;
    IF TRIM(l_sql_char_result) != 'BLA'
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_char_result || '] usim_created_by should not be writable.';
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
  l_run_id := '013';
  BEGIN
    INSERT INTO usim_basedata (usim_updated_by) VALUES ('BLA') RETURNING usim_created_by INTO l_sql_char_result;
    IF TRIM(l_sql_char_result) != 'BLA'
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_char_result || '] usim_updated_by should not be writable.';
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


  l_test_section := 'Update trigger no update allowed';
  -- insert default record
  l_run_id := '014';
  INSERT INTO usim_basedata (usim_updated_by) VALUES ('BLA');
  COMMIT;
  BEGIN
    UPDATE usim_basedata
       SET usim_planck_time_seq_last = 1
    RETURNING usim_planck_time_seq_last INTO l_sql_number_result;
    IF l_sql_number_result != 1
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_number_result || '] usim_planck_time_seq_last update not allowed.';
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
  l_run_id := '019';
  BEGIN
    UPDATE usim_basedata
       SET usim_planck_aeon_seq_last = 'BLA'
    RETURNING usim_planck_aeon_seq_last INTO l_sql_char_result;
    IF TRIM(l_sql_char_result) != 'BLA'
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_char_result || '] usim_planck_aeon_seq_last update not allowed.';
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
  l_run_id := '015';
  BEGIN
    UPDATE usim_basedata
       SET usim_overflow_node_seed = -1
    RETURNING usim_overflow_node_seed INTO l_sql_number_result;
    IF l_sql_number_result != -1
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_number_result || '] usim_overflow_node_seed update not allowed.';
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
  l_run_id := '016';
  BEGIN
    UPDATE usim_basedata
       SET usim_max_dimension = 999
    RETURNING usim_max_dimension INTO l_sql_number_result;
    IF l_sql_number_result != 999
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_number_result || '] usim_max_dimension update not allowed.';
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
  l_run_id := '017';
  BEGIN
    UPDATE usim_basedata
       SET usim_abs_max_number = 999
    RETURNING usim_abs_max_number INTO l_sql_number_result;
    IF l_sql_number_result != 999
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_number_result || '] usim_abs_max_number update not allowed.';
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
  l_run_id := '018';
  BEGIN
    UPDATE usim_basedata
       SET usim_created = TRUNC(SYSDATE+10)
    RETURNING usim_created INTO l_sql_date_result;
    IF l_sql_date_result != TRUNC(SYSDATE+10)
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || TO_CHAR(l_sql_date_result, 'DD.MM.YYYY HH24:MI:SS') || '] usim_created update not allowed.';
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
  l_run_id := '020';
  BEGIN
    UPDATE usim_basedata
       SET usim_updated = TRUNC(SYSDATE+10)
    RETURNING usim_updated INTO l_sql_date_result;
    IF l_sql_date_result != TRUNC(SYSDATE+10)
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || TO_CHAR(l_sql_date_result, 'DD.MM.YYYY HH24:MI:SS') || '] usim_updated update not allowed.';
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
  l_run_id := '021';
  BEGIN
    UPDATE usim_basedata
       SET usim_updated_by = 'BLA'
    RETURNING usim_updated_by INTO l_sql_char_result;
    IF TRIM(l_sql_char_result) != 'BLA'
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_char_result || '] usim_updated_by update only for schema or OS user allowed.';
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

  l_test_section := 'Update trigger update sequence currval';
  l_run_id := '022';
  BEGIN
    UPDATE usim_basedata
       SET usim_planck_time_seq_curr = 1
    RETURNING usim_planck_time_seq_curr INTO l_sql_number_result;
    IF l_sql_number_result = 1
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_number_result || '] usim_planck_time_seq_curr should be writable.';
      usim_test.log_error(l_test_id, l_fail_message);
      l_tests_failed := l_tests_failed + 1;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': unexpected error ' || SQLCODE || ': ' || SQLERRM;
      usim_test.log_error(l_test_id, l_fail_message);
      l_tests_failed := l_tests_failed + 1;
  END;
  l_run_id := '023';
  BEGIN
    UPDATE usim_basedata
       SET usim_planck_time_seq_curr = 2
    RETURNING usim_planck_time_seq_curr INTO l_sql_number_result;
    IF l_sql_number_result = 2
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_number_result || '] usim_planck_time_seq_curr should be writable.';
      usim_test.log_error(l_test_id, l_fail_message);
      l_tests_failed := l_tests_failed + 1;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': unexpected error ' || SQLCODE || ': ' || SQLERRM;
      usim_test.log_error(l_test_id, l_fail_message);
      l_tests_failed := l_tests_failed + 1;
  END;
  l_run_id := '024';
  BEGIN
    SELECT usim_planck_time_seq_last INTO l_sql_number_result FROM usim_basedata;
    IF l_sql_number_result = 1
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_number_result || '] usim_planck_time_seq_last not set to last curr.';
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
  l_run_id := '025';
  BEGIN
    UPDATE usim_basedata
       SET usim_planck_aeon_seq_curr = 'BLA'
    RETURNING usim_planck_aeon_seq_curr INTO l_sql_char_result;
    IF TRIM(l_sql_char_result) = 'BLA'
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_char_result || '] usim_planck_aeon_seq_curr should be writable.';
      usim_test.log_error(l_test_id, l_fail_message);
      l_tests_failed := l_tests_failed + 1;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': unexpected error ' || SQLCODE || ': ' || SQLERRM;
      usim_test.log_error(l_test_id, l_fail_message);
      l_tests_failed := l_tests_failed + 1;
  END;
  l_run_id := '026';
  BEGIN
    UPDATE usim_basedata
       SET usim_planck_aeon_seq_curr = 'BLUBB'
    RETURNING usim_planck_aeon_seq_curr INTO l_sql_char_result;
    IF TRIM(l_sql_char_result) = 'BLUBB'
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_char_result || '] usim_planck_aeon_seq_curr should be writable.';
      usim_test.log_error(l_test_id, l_fail_message);
      l_tests_failed := l_tests_failed + 1;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': unexpected error ' || SQLCODE || ': ' || SQLERRM;
      usim_test.log_error(l_test_id, l_fail_message);
      l_tests_failed := l_tests_failed + 1;
  END;
  l_run_id := '027';
  BEGIN
    SELECT usim_planck_aeon_seq_last INTO l_sql_char_result FROM usim_basedata;
    IF TRIM(l_sql_char_result) = 'BLA'
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_char_result || '] usim_planck_aeon_seq_last not set to last curr.';
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

  -- reset table
  DELETE usim_basedata;
  COMMIT;
  -- write test results
  usim_test.write_test_results(l_test_id, l_tests_success, l_tests_failed);
EXCEPTION
  WHEN OTHERS THEN
    usim_test.log_error(l_test_id, SUBSTR('Test section failed unexpected: [' || l_test_section || '] tests done: ' || TO_CHAR(NVL(l_tests_success, 0) + NVL(l_tests_failed, 0)) || ' last runs id ' || l_run_id || ' ora: ' || SQLERRM, 1, 4000));
    usim_test.write_test_results(l_test_id, l_tests_success, l_tests_failed);
END;
/