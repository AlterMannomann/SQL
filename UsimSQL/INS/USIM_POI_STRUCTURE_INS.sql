-- insert seed structure
INSERT INTO usim_poi_structure
  (usim_point_name)
  SELECT usim_static.get_seed_name()
    FROM dual
;
-- insert mirror structure
INSERT INTO usim_poi_structure
  (usim_point_name)
  SELECT usim_static.get_mirror_name()
    FROM dual
;
COMMIT;