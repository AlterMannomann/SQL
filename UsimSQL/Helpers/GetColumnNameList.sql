ACCEPT TABLENAME CHAR PROMPT 'Name der Tabelle:'
ACCEPT PREFIX CHAR DEFAULT 'N/A' PROMPT 'Optional prefix: '
-- get a formatted list of columns
SELECT ', ' || CASE WHEN '&PREFIX' != 'N/A' THEN '&PREFIX..' END || LOWER(column_name) AS col
  FROM user_tab_columns
 WHERE table_name = UPPER('&TABLENAME')
 ORDER BY column_id
;