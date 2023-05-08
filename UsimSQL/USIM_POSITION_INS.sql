INSERT INTO usim_position
  (usim_coordinate)
  SELECT 0 FROM dual UNION ALL
  SELECT 1 FROM dual UNION ALL
  SELECT -1 FROM dual
;
COMMIT;