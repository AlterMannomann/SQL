-- USIM_PDP_CHILDS (pdc)
-- fk pdp point
ALTER TABLE usim_pdp_childs
  ADD CONSTRAINT usim_pdc_pdp_fk
  FOREIGN KEY (usim_id_pdp) REFERENCES usim_poi_dim_position (usim_id_pdp)
  ENABLE
;
-- fk pdp child
ALTER TABLE usim_pdp_childs
  ADD CONSTRAINT usim_pdc_child_fk
  FOREIGN KEY (usim_id_child) REFERENCES usim_poi_dim_position (usim_id_pdp)
  ENABLE
;
