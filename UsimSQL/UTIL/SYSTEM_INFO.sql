SELECT TO_CHAR(SYSDATE, 'DD.MM.YYYY HH24:MI:SS') AS exec_date
     , SUBSTR(SYS_CONTEXT('USERENV', 'DB_NAME'), 1, 30) AS db_name
     , SUBSTR(SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA'), 1, 30) AS db_schema
     , SUBSTR(SYS_CONTEXT('USERENV', 'OS_USER'), 1, 60) AS os_user
  FROM dual
;
