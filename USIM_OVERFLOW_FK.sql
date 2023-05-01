-- USIM_OVERFLOW (ovr)
-- fk pdp point
ALTER TABLE usim_overflow
  ADD CONSTRAINT usim_ovr_pdp_fk
  FOREIGN KEY (usim_id_pdp) REFERENCES usim_poi_dim_position (usim_id_pdp) ON DELETE CASCADE
  ENABLE
;
