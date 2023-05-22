-- USIM_DIM_POINT
-- fk point
ALTER TABLE usim_dim_point
  ADD CONSTRAINT usim_dpo_poi_fk
  FOREIGN KEY (usim_id_poi) REFERENCES usim_point (usim_id_poi) ON DELETE CASCADE
  ENABLE
;
-- fk dimension
ALTER TABLE usim_dim_point
  ADD CONSTRAINT usim_dpo_dim_fk
  FOREIGN KEY (usim_id_dim) REFERENCES usim_dimension (usim_id_dim) ON DELETE CASCADE
  ENABLE
;