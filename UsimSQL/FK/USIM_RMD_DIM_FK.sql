-- fk relation universe/dimension for dimensions (for documentation, if disabled)
ALTER TABLE usim_rel_mlv_dim
  ADD CONSTRAINT usim_rmd_dim_fk
  FOREIGN KEY (usim_id_dim) REFERENCES usim_dimension (usim_id_dim) ON DELETE CASCADE
  ENABLE
;
