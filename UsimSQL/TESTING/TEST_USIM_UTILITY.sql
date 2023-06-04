SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  l_tests_success     INTEGER := 0;
  l_tests_failed      INTEGER := 0;
  l_fail_message      VARCHAR2(32000);
  l_test_section      VARCHAR2(100);
  l_test_object       VARCHAR2(128) := 'USIM_UTILITY';
  l_new_plancktime    usim_planck_time.usim_current_planck_time%TYPE;
  l_cur_plancktime    usim_planck_time.usim_current_planck_time%TYPE;
  l_last_plancktime   usim_planck_time.usim_current_planck_time%TYPE;
  l_sql_number_result NUMBER;
  l_sql_char_result   VARCHAR2(32000);
  l_sql_date_result   DATE;
BEGIN
  l_test_section := 'Extract Coords';
  IF usim_utility.extract_coordinate('1(1)', 0) != '1'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': extract_coordinate 1(1) on position 0 NOT 1';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.extract_coordinate(' 1 (1) ', 0) != '1'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': extract_coordinate  1 (1)  on position 0 NOT 1';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.extract_coordinate('1(1),2(1)', 0) != '1'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': extract_coordinate 1(1),2(1) on position 0 NOT 1';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.extract_coordinate(' 1 (1) , 2 (1)', 0) != '1'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': extract_coordinate  1 (1) , 2 (1) on position 0 NOT 1';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.extract_coordinate('23231(1)', 0) != '23231'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': extract_coordinate 23231(1) on position 0 NOT 23231';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.extract_coordinate('23231(1),344455(1)', 0) != '23231'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': extract_coordinate 23231(1),344455(1) on position 0 NOT 23231';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.extract_coordinate('23231(1),344455(1)', 1) != '344455'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': extract_coordinate 23231(1),344455(1) on position 1 NOT 344455';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.extract_coordinate('23231(1),344455(1),23232(1)', 1) != '344455'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': extract_coordinate 23231(1),344455(1),23232(1) on position 1 NOT 344455';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.extract_coordinate(' 23231 (1001) , 344455 (2000) , 23232 (3000)', 1) != '344455'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': extract_coordinate  23231 (1001) , 344455 (2000) , 23232 (3000) on position 1 NOT 344455';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.extract_coordinate(' 23231 (1001) , 344455 (2000) , 23232 (3000)', 2) != '23232'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': extract_coordinate  23231 (1001) , 344455 (2000) , 23232 (3000) on position 2 NOT 23232';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.extract_coordinate(' 23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1)', 2) != '23232'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': extract_coordinate  23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1) on position 2 NOT 23232';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.extract_coordinate(' 23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1)', 3) != '65656'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': extract_coordinate  23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1) on position 3 NOT 65656';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.extract_coordinate(' 23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1)', -10) != '23231'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': extract_coordinate  23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1) on position -10 NOT 23231';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF NVL(usim_utility.extract_coordinate(' 23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1)', 4), 'NADA') != 'NADA'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': extract_coordinate  23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1) on position 4 NOT NULL';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.get_coordinate(' 23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1)', 2) != 23232
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_coordinate  23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1) on position 2 NOT 23232';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.get_coordinate(' 23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1)', 4) != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_coordinate  23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1) on position 4 NOT 0';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Extract Level';
  IF usim_utility.extract_number_level('1(1)', 0) != '1'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': extract_number_level 1(1) on position 0 NOT 1';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.extract_number_level('1(1),2(1)', 0) != '1'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': extract_number_level 1(1),2(1) on position 0 NOT 1';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.extract_number_level(' 23231 ( 1001 ) , 344455 (2000 ) , 23232 ( 3000)', 0) != '1001'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': extract_number_level  23231 ( 1001 ) , 344455 (2000 ) , 23232 ( 3000) on position 0 NOT 1001';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.extract_number_level(' 23231 ( 1001 ) , 344455 (2000 ) , 23232 ( 3000)', 1) != '2000'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': extract_number_level  23231 ( 1001 ) , 344455 (2000 ) , 23232 ( 3000) on position 1 NOT 2000';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.extract_number_level(' 23231 ( 1001 ) , 344455 (2000 ) , 23232 ( 3000)', 2) != '3000'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': extract_number_level  23231 ( 1001 ) , 344455 (2000 ) , 23232 ( 3000) on position 2 NOT 3000';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.extract_number_level(' 23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1)', 2) != '3000'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': extract_number_level  23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1) on position 2 NOT 3000';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF NVL(usim_utility.extract_number_level(' 23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1)', 4), 'NADA') != 'NADA'
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': extract_number_level  23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1) on position 4 NOT NULL';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.get_number_level(' 23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1)', 2) != 3000
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_number_level  23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1) on position 2 NOT 3000';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.get_number_level(' 23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1)', 4) != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_number_level  23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1) on position 4 NOT 0';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Get XYZ';
  IF usim_utility.get_x(' 23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1)') != 344455
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_x  23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1) NOT 344455';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.get_y(' 23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1)') != 23232
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_y  23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1) NOT 23232';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.get_z(' 23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1)') != 65656
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_z  23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1) NOT 65656';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.get_x('23231(1001)') != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_x 23231(1001) NOT 0';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.get_y('23231(1001)') != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_y 23231(1001) NOT 0';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.get_z('23231(1001)') != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_z 23231(1001) NOT 0';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.get_x_level(' 23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1)') != 2000
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_x_level  23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1) NOT 2000';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.get_y_level(' 23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1)') != 3000
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_y_level  23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1) NOT 3000';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.get_z_level(' 23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1)') != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_y_level  23231 (1001) , 344455 (2000) , 23232 (3000), 65656(1) NOT 1';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.get_x_level('23231(1001)') != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_x_level 23231(1001) NOT 0';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.get_y_level('23231(1001)') != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_y_level 23231(1001) NOT 0';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.get_z_level('23231(1001)') != 0
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': get_z_level 23231(1001) NOT 0';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Get Plancktime';
  l_cur_plancktime  := usim_utility.current_planck_time;
  IF TRIM(l_cur_plancktime) = 'N/A'
  THEN
    -- not initialized yet, get a next first
    l_new_plancktime  := usim_utility.next_planck_time;
    l_cur_plancktime  := usim_utility.current_planck_time;
  END IF;
  l_new_plancktime  := usim_utility.next_planck_time;
  l_last_plancktime := usim_utility.last_planck_time;
  IF l_last_plancktime != l_cur_plancktime
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': last planck time not updated correctly';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF TO_NUMBER(SUBSTR(l_new_plancktime, -38)) <= TO_NUMBER(SUBSTR(l_cur_plancktime, -38))
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': new planck time lower then last planck time';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Get Coords Diff';
  IF usim_utility.coords_diff('2(1)', '1(1)') != 1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': coords_diff 2(1), 1(1) is NOT 1';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.coords_diff('1(1)', '2(1)' ) != -1
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': coords_diff 1(1), 2(1) is NOT -1';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.coords_diff('2(2)', '999999999(1)') != 99999999999999999999999999999000000002
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': coords_diff 2(2), 999999999(1) is NOT 99999999999999999999999999999000000002';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.coords_diff('999999999(1)', '2(2)') != -99999999999999999999999999999000000002
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': coords_diff 2(2), 999999999(1) is NOT -99999999999999999999999999999000000002';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  l_test_section := 'Get Max Positions';
  IF NVL(usim_utility.get_max_position(1), -1) + 1 != usim_utility.get_max_position_1st(1)
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': max position + 1 is NOT max 1st position';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF NVL(usim_utility.get_max_position(-1), 1) - 1 != usim_utility.get_max_position_1st(-1)
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': max negative position - 1 is NOT max 1st position';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.get_max_position_1st(1) + 1 != usim_utility.get_max_position_2nd(1)
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': max 1st position + 1 is NOT max 2nd position';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;
  IF usim_utility.get_max_position_1st(-1) - 1 != usim_utility.get_max_position_2nd(-1)
  THEN
    l_fail_message := l_test_object || ' - ' || l_test_section || ': max negative 1st position - 1 is NOT max 2nd position';
    DBMS_OUTPUT.PUT_LINE(l_fail_message);
    l_tests_failed := l_tests_failed + 1;
  ELSE
    l_tests_success := l_tests_success + 1;
  END IF;

  -- Summary
  DBMS_OUTPUT.PUT_LINE(l_test_object || ' Tests: SUCCESS (' || l_tests_success || ') ERROR (' || l_tests_failed || ')');
  IF l_tests_failed > 0
  THEN
    DBMS_OUTPUT.PUT_LINE(l_test_object || ' Test: FAILED');
  ELSE
    DBMS_OUTPUT.PUT_LINE(l_test_object || ' Test: PASSED');
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Test section failed unexpected: [' || l_test_section || '] tests done: ' || TO_CHAR(NVL(l_tests_success, 0) + NVL(l_tests_failed, 0)));
    DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/