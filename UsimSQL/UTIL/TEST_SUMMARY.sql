SELECT CASE
         WHEN usim_tests_failed = 0
         THEN 'SUCCESS'
         ELSE 'FAILED'
       END AS status
     , usim_tests_success
     , usim_tests_failed
     , usim_test_object
  FROM usim_test_summary
;
-- Test errors if any
SELECT ter.usim_timestamp
     , tsu.usim_test_object
     , ter.usim_error_msg
  FROM usim_test_errors ter
  LEFT OUTER JOIN usim_test_summary tsu
    ON ter.usim_id_tsu = tsu.usim_id_tsu
 ORDER BY ter.usim_timestamp
;
