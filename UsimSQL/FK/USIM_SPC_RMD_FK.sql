-- fk relation space for relation universe/dimension (for documentation, if disabled)
ALTER TABLE usim_space
  ADD CONSTRAINT usim_spc_rmd_fk
  FOREIGN KEY (usim_id_rmd) REFERENCES usim_rel_mlv_dim (usim_id_rmd) ON DELETE CASCADE
  ENABLE
;