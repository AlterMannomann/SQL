-- fk universe for dimensions (for documentation, if disabled)
ALTER TABLE usim_rel_mlv_dim
  ADD CONSTRAINT usim_rmd_mlv_fk
  FOREIGN KEY (usim_id_mlv) REFERENCES usim_multiverse (usim_id_mlv) ON DELETE CASCADE
  ENABLE
;
