
-- Insert test data
-- dimensions
INSERT INTO usim_dimension
  (usim_dimension) VALUES (0)
;
INSERT INTO usim_dimension
  (usim_dimension) VALUES (1)
;
INSERT INTO usim_dimension
  (usim_dimension) VALUES (2)
;
INSERT INTO usim_dimension
  (usim_dimension) VALUES (3)
;
COMMIT;
-- positions
INSERT INTO usim_position
  (usim_position) VALUES (0)
;
INSERT INTO usim_position
  (usim_position) VALUES (-1)
;
INSERT INTO usim_position
  (usim_position) VALUES (1)
;
COMMIT;
-- point
INSERT INTO usim_point
    (usim_energy, usim_amplitude, usim_wavelength) VALUES (0,0,0)
;
-- point with dimension
INSERT INTO usim_dim_point
   ( usim_id_poi
   , usim_id_dim
   )
   VALUES
   ( (SELECT MAX(usim_id_poi) FROM usim_point)
   , (SELECT usim_id_dim FROM usim_dimension WHERE usim_dimension = 0)
   )
;
-- dim position
INSERT INTO usim_poi_dim_position
  ( usim_id_dpo
  , usim_id_pos
  )
  VALUES
  ( (SELECT usim_id_dpo FROM usim_dim_point WHERE usim_id_poi = (SELECT MAX(usim_id_poi) FROM usim_point) AND usim_id_dim = (SELECT usim_id_dim FROM usim_dimension WHERE usim_dimension = 0))
  , (SELECT usim_id_pos FROM usim_position WHERE usim_position = 0)
  )
;
COMMIT;