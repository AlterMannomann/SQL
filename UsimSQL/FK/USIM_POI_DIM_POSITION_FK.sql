-- USIM_POI_DIM_POSITION
-- fk dimension point
ALTER TABLE usim_poi_dim_position
  ADD CONSTRAINT usim_pdp_dpo_fk
  FOREIGN KEY (usim_id_dpo) REFERENCES usim_dim_point (usim_id_dpo) ON DELETE CASCADE
  ENABLE
;
-- fk dimension point
ALTER TABLE usim_poi_dim_position
  ADD CONSTRAINT usim_pdp_pos_fk
  FOREIGN KEY (usim_id_pos) REFERENCES usim_position (usim_id_pos) ON DELETE CASCADE
  ENABLE
;
-- fk point structure
ALTER TABLE usim_poi_dim_position
  ADD CONSTRAINT usim_pdp_psc_fk
  FOREIGN KEY (usim_id_psc) REFERENCES usim_poi_structure (usim_id_psc) ON DELETE CASCADE
  ENABLE
;