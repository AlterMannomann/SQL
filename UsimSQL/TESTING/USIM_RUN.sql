-- must reside in every directory where scripts are called that call other scripts from the directory they are
SET ECHO ON
SET VERIFY ON
SET FLUSH OFF
SELECT '&1' AS username
     , '&2' AS scriptname
  FROM dual
;
SHOW con_name
ALTER SESSION SET CONTAINER = FREEPDB1;
ALTER SESSION SET CURRENT_SCHEMA = &1;
@@&2
EXIT;