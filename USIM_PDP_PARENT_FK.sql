-- USIM_PDP_PARENT (pdr)
-- fk pdp point
ALTER TABLE usim_pdp_parent
  ADD CONSTRAINT usim_pdr_pdp_fk
  FOREIGN KEY (usim_id_pdp) REFERENCES usim_poi_dim_position (usim_id_pdp)
  ENABLE
;
-- fk pdp parent
ALTER TABLE usim_pdp_parent
  ADD CONSTRAINT usim_pdr_parent_fk
  FOREIGN KEY (usim_id_parent) REFERENCES usim_poi_dim_position (usim_id_pdp)
  ENABLE
;
