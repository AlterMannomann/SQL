COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
SELECT COUNT(*) AS objects_after_cleanup
  FROM all_objects
 WHERE owner = '&USIM_SCHEMA'
;
-- overview remaining objects after cleanup
SELECT object_type
     , COUNT(*) AS object_cnt
  FROM all_objects
 WHERE owner = '&USIM_SCHEMA'
 GROUP BY object_type
;
