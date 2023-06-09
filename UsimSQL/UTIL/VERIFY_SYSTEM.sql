-- check state of database
SELECT CASE
        WHEN COUNT(*) > 0
        THEN 'ERROR Database has invalid objects'
        ELSE 'SUCCESS All database objects are valid'
      END AS info
  FROM user_objects
 WHERE status != 'VALID'
;
-- details if any
SELECT object_type
     , COUNT(*) AS invalid_objects
  FROM user_objects
 WHERE status != 'VALID'
 GROUP BY object_type
;
SELECT trigger_name AS not_enabled_trigger
     , table_name
  FROM user_triggers
 WHERE status != 'ENABLED'
;
