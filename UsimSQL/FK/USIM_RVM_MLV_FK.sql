-- fk relation volume/universe for universe (for documentation, if disabled)
ALTER TABLE usim_rel_vol_mlv
  ADD CONSTRAINT usim_rvm_mlv_fk
  FOREIGN KEY (usim_id_mlv) REFERENCES usim_multiverse (usim_id_mlv) ON DELETE CASCADE
  ENABLE
;
