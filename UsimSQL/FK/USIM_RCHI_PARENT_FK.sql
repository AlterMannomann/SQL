-- fk parent-child relation between dimension axis in usim_rel_mlv_dim (for documentation, if disabled)
ALTER TABLE usim_rmd_child
  ADD CONSTRAINT usim_rchi_parent_fk
  FOREIGN KEY (usim_id_rmd) REFERENCES usim_rel_mlv_dim (usim_id_rmd) ON DELETE CASCADE
  ENABLE
;