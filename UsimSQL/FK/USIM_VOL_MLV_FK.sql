-- fk volume to universe (for documentation, if disabled)
ALTER TABLE usim_volume
  ADD CONSTRAINT usim_vol_mlv_fk
  FOREIGN KEY (usim_id_mlv) REFERENCES usim_multiverse (usim_id_mlv) ON DELETE CASCADE
  ENABLE
;
