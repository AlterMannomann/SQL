-- only dimensions 0 - 4
INSERT INTO usim_dimension
  (usim_dimension)
  SELECT 0 FROM dual UNION ALL
  SELECT 1 FROM dual UNION ALL
  SELECT 2 FROM dual UNION ALL
  SELECT 3 FROM dual UNION ALL
  SELECT 4 FROM dual
;
COMMIT;