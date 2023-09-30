-- check state of database
SET FEEDBACK OFF
SELECT CASE
        WHEN COUNT(*) > 0
        THEN 'ERROR Database has invalid objects'
        ELSE 'SUCCESS All database objects are valid'
      END AS info
  FROM user_objects
 WHERE status != 'VALID'
;
-- group details if any
SELECT object_type
     , COUNT(*) AS invalid_objects
  FROM user_objects
 WHERE status != 'VALID'
 GROUP BY object_type
;
-- details if any
SELECT object_name
     , object_type
     , status
  FROM user_objects
 WHERE status != 'VALID'
 ORDER BY object_type
        , object_name
;
SELECT trigger_name AS not_enabled_trigger
     , table_name
  FROM user_triggers
 WHERE status != 'ENABLED'
;
SET FEEDBACK ON