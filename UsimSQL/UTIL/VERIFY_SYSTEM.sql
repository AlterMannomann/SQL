COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
-- check state of database
SET FEEDBACK OFF
SELECT CASE
        WHEN COUNT(*) > 0
        THEN 'ERROR Database has invalid objects'
        ELSE 'SUCCESS All database objects are valid'
      END AS info
  FROM all_objects
 WHERE status != 'VALID'
   AND owner   = '&USIM_SCHEMA'
;
-- group details if any
SELECT object_type
     , COUNT(*) AS invalid_objects
  FROM all_objects
 WHERE status != 'VALID'
   AND owner   = '&USIM_SCHEMA'
 GROUP BY object_type
;
-- details if any
SELECT object_name
     , object_type
     , status
  FROM all_objects
 WHERE status != 'VALID'
   AND owner   = '&USIM_SCHEMA'
 ORDER BY object_type
        , object_name
;
SELECT trigger_name AS not_enabled_trigger
     , table_name
  FROM all_triggers
 WHERE status != 'ENABLED'
   AND owner   = '&USIM_SCHEMA'
;
SET FEEDBACK ON