-- define here the amount of dimensions to handle
INSERT INTO usim_dimension
  (usim_n_dimension)
  SELECT LEVEL - 1  AS usim_n_dimension
    FROM dual
 -- max dimension n + 1 to get n dimensions
 CONNECT BY LEVEL <= (SELECT usim_static.get_max_dimensions + 1 FROM dual)
;
COMMIT;