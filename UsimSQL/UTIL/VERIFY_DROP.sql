SELECT COUNT(*) AS objects_after_cleanup
  FROM user_objects
;
-- overview remaining objects after cleanup
SELECT object_type
     , COUNT(*) AS object_cnt
  FROM user_objects
 GROUP BY object_type
;
