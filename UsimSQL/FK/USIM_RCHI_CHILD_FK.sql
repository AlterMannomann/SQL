-- fk parent-child relation between dimensions in usim_rel_mlv_dim (for documentation, if disabled)
ALTER TABLE usim_rmd_child
  ADD CONSTRAINT usim_rchi_child_fk
  FOREIGN KEY (usim_id_rmd_child) REFERENCES usim_rel_mlv_dim (usim_id_rmd) ON DELETE CASCADE
  ENABLE
;
