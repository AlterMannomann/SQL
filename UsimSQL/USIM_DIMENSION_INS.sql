-- define here the amount of dimensions to handle
INSERT INTO usim_dimension
  (usim_dimension)
  SELECT LEVEL - 1  AS usim_dimension
    FROM dual
 CONNECT BY LEVEL <= 4 -- max dimension is N - 1 currently 3
;
COMMIT;