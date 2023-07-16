DECLARE
  l_tests_success     INTEGER := 0;
  l_tests_failed      INTEGER := 0;
  l_fail_message      VARCHAR2(4000);
  l_run_id            VARCHAR2(10);
  l_test_section      VARCHAR2(100);
  l_test_object       VARCHAR2(128) := 'USIM_REL_RMD_POS_NOD table';
  l_sql_number_result NUMBER;
  l_sql_char_result   VARCHAR2(32000);
  l_sql_date_result   DATE;
  l_test_id           NUMBER;
  l_usim_id_mlv       usim_multiverse.usim_id_mlv%TYPE;
  l_usim_id_dim       usim_dimension.usim_id_dim%TYPE;
  l_usim_id_rmd       usim_rel_mlv_dim.usim_id_rmd%TYPE;
  l_usim_id_pos       usim_position.usim_id_pos%TYPE;
  l_usim_id_nod       usim_node.usim_id_nod%TYPE;
  l_usim_id_rrpn      usim_rel_rmd_pos_nod.usim_id_rrpn%TYPE;
BEGIN
  l_test_id := usim_test.init_test(l_test_object);
  l_test_section := 'Table constraints';
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
  l_usim_id_rmd := usim_rmd.insert_rmd(l_usim_id_mlv, l_usim_id_dim);
  l_usim_id_pos := usim_pos.insert_next_position(1, TRUE);
  l_usim_id_nod := usim_nod.insert_node;
  BEGIN
    INSERT INTO usim_rel_rmd_pos_nod
      ( usim_id_rmd
      , usim_id_pos
      , usim_id_nod
      )
      VALUES
      ( 'NO VALID FK'
      , l_usim_id_pos
      , l_usim_id_nod
      )
    ;
    -- input should be prevented by constraint
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': insert of not existing rmd id should not possible.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF INSTR(SQLERRM, 'USIM_RRPN_RMD_FK') > 0
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
    INSERT INTO usim_rel_rmd_pos_nod
      ( usim_id_rmd
      , usim_id_pos
      , usim_id_nod
      )
      VALUES
      ( l_usim_id_rmd
      , 'NO VALID FK'
      , l_usim_id_nod
      )
    ;
    -- input should be prevented by constraint
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': insert of not existing position id should not possible.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF INSTR(SQLERRM, 'USIM_RRPN_POS_FK') > 0
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
    INSERT INTO usim_rel_rmd_pos_nod
      ( usim_id_rmd
      , usim_id_pos
      , usim_id_nod
      )
      VALUES
      ( l_usim_id_rmd
      , l_usim_id_pos
      , 'NO VALID FK'
      )
    ;
    -- input should be prevented by constraint
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': insert of not existing node id should not possible.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF INSTR(SQLERRM, 'USIM_RRPN_NOD_FK') > 0
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
    INSERT INTO usim_rel_rmd_pos_nod
      ( usim_id_rmd
      , usim_id_pos
      , usim_id_nod
      )
      VALUES
      ( l_usim_id_rmd
      , l_usim_id_pos
      , l_usim_id_nod
      )
    ;
    l_sql_char_result := usim_nod.insert_node(FALSE);
    INSERT INTO usim_rel_rmd_pos_nod
      ( usim_id_rmd
      , usim_id_pos
      , usim_id_nod
      )
      VALUES
      ( l_usim_id_rmd
      , l_usim_id_pos
      , l_sql_char_result
      )
    ;
    -- input should be prevented by constraint
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': duplicate insert of rmd/pos ids should not possible.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF INSTR(SQLERRM, 'USIM_RRPN_UK') > 0
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
  l_run_id := '005';
  BEGIN
    INSERT INTO usim_rel_rmd_pos_nod
      ( usim_id_rrpn
      , usim_id_rmd
      , usim_id_pos
      , usim_id_nod
      )
      VALUES
      ( 'BLA'
      , l_usim_id_rmd
      , l_usim_id_pos
      , l_usim_id_nod
      )
      RETURNING usim_id_rrpn INTO l_usim_id_rrpn;
    -- check input value
    IF TRIM(l_usim_id_rrpn) != 'BLA'
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_usim_id_rrpn || '] rrpn id should not be BLA on insert.';
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
  l_run_id := '006';
  BEGIN
    INSERT INTO usim_rel_rmd_pos_nod
      ( usim_id_rmd
      , usim_id_pos
      , usim_id_nod
      )
      VALUES
      ( l_usim_id_rmd
      , l_usim_id_pos
      , l_usim_id_nod
      )
      RETURNING usim_id_rrpn INTO l_usim_id_rrpn;
    UPDATE usim_rel_rmd_pos_nod
       SET usim_id_rrpn = 'BLA'
         , usim_id_rmd  = 'BLA'
         , usim_id_pos  = 'BLA'
         , usim_id_nod  = 'BLA'
     WHERE usim_id_rrpn = l_usim_id_rrpn
    RETURNING usim_id_rrpn INTO l_sql_char_result
    ;
    -- check input value
    IF TRIM(l_sql_char_result) != 'BLA'
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_char_result || '] rrpn id should not be BLA on update.';
      usim_test.log_error(l_test_id, l_fail_message);
      l_tests_failed := l_tests_failed + 1;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': unexpected error ' || SQLCODE || ': ' || SQLERRM;
      usim_test.log_error(l_test_id, l_fail_message);
      l_tests_failed := l_tests_failed + 1;
  END;
  l_run_id := '007';
  BEGIN
    SELECT usim_id_rmd INTO l_sql_char_result FROM usim_rel_rmd_pos_nod WHERE usim_id_rrpn = l_usim_id_rrpn;
    -- check input value
    IF TRIM(l_sql_char_result) != 'BLA'
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_char_result || '] rmd id should not be BLA on update.';
      usim_test.log_error(l_test_id, l_fail_message);
      l_tests_failed := l_tests_failed + 1;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': unexpected error ' || SQLCODE || ': ' || SQLERRM;
      usim_test.log_error(l_test_id, l_fail_message);
      l_tests_failed := l_tests_failed + 1;
  END;
  l_run_id := '008';
  BEGIN
    SELECT usim_id_pos INTO l_sql_char_result FROM usim_rel_rmd_pos_nod WHERE usim_id_rrpn = l_usim_id_rrpn;
    -- check input value
    IF TRIM(l_sql_char_result) != 'BLA'
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_char_result || '] position id should not be BLA on update.';
      usim_test.log_error(l_test_id, l_fail_message);
      l_tests_failed := l_tests_failed + 1;
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': unexpected error ' || SQLCODE || ': ' || SQLERRM;
      usim_test.log_error(l_test_id, l_fail_message);
      l_tests_failed := l_tests_failed + 1;
  END;
  l_run_id := '009';
  BEGIN
    SELECT usim_id_nod INTO l_sql_char_result FROM usim_rel_rmd_pos_nod WHERE usim_id_rrpn = l_usim_id_rrpn;
    -- check input value
    IF TRIM(l_sql_char_result) != 'BLA'
    THEN
      l_tests_success := l_tests_success + 1;
    ELSE
      l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': [' || l_sql_char_result || '] node id should not be BLA on update.';
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

  l_test_section := 'Table constraints';
  l_run_id := '010';
  BEGIN
    INSERT INTO usim_rel_rmd_pos_nod
      ( usim_id_rmd
      , usim_id_pos
      , usim_id_nod
      )
      VALUES
      ( l_usim_id_rmd
      , l_usim_id_pos
      , l_usim_id_nod
      )
    ;
    l_sql_char_result := usim_pos.insert_next_position(1, FALSE);
    INSERT INTO usim_rel_rmd_pos_nod
      ( usim_id_rmd
      , usim_id_pos
      , usim_id_nod
      )
      VALUES
      ( l_usim_id_rmd
      , l_sql_char_result
      , l_usim_id_nod
      )
    ;
    -- input should be prevented by constraint
    l_fail_message := l_test_object || ' - ' || l_test_section || ' - ' || l_run_id || ': duplicate insert of node ids should not possible.';
    usim_test.log_error(l_test_id, l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  EXCEPTION
    WHEN OTHERS THEN
      IF INSTR(SQLERRM, 'USIM_RRPN_NOD_UK') > 0
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