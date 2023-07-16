-- fk relation volume/universe for volume (for documentation, if disabled)
ALTER TABLE usim_rel_vol_mlv
  ADD CONSTRAINT usim_rvm_vol_fk
  FOREIGN KEY (usim_id_vol) REFERENCES usim_volume (usim_id_vol) ON DELETE CASCADE
  ENABLE
;
