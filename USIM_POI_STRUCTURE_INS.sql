INSERT INTO usim_poi_structure
  (usim_point_name)
  SELECT usim_static.get_seed_name()
    FROM dual
;
COMMIT;