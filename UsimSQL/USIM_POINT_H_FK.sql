-- USIM_POINT_H
-- fk point
ALTER TABLE usim_point_h
  ADD CONSTRAINT usim_hpoi_poi_fk
  FOREIGN KEY (usim_id_poi) REFERENCES usim_point (usim_id_poi) ON DELETE CASCADE
  ENABLE
;