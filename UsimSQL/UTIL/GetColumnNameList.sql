ACCEPT TABLENAME CHAR PROMPT 'Name der Tabelle:'
ACCEPT PREFIX CHAR DEFAULT 'N/A' PROMPT 'Optional prefix: '
ACCEPT POSTFIX CHAR DEFAULT 'N/A' PROMPT 'Optional use prefix as postfix: '
-- get a formatted list of columns for views
SELECT ', ' || CASE WHEN '&PREFIX' != 'N/A' THEN '&PREFIX..' END || LOWER(column_name) || CASE WHEN '&POSTFIX' != 'N/A' THEN ' AS ' || LOWER(column_name) || '_&PREFIX' END AS col
  FROM user_tab_columns
 WHERE table_name = UPPER('&TABLENAME')
 ORDER BY column_id
;
-- get a parameter list with types
SELECT ', p_' || LOWER(column_name) || ' IN ' || LOWER(table_name) || '.' || LOWER(column_name) || '%TYPE' AS col 
  FROM user_tab_columns
 WHERE table_name = UPPER('&TABLENAME')
 ORDER BY column_id
;
-- get a simple parameter list
SELECT ', p_' || LOWER(column_name) AS col 
  FROM user_tab_columns
 WHERE table_name = UPPER('&TABLENAME')
 ORDER BY column_id
;