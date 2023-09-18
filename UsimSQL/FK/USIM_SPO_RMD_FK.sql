-- fk base-mirror relation between nodes in usim_space (for documentation, if disabled)
ALTER TABLE usim_spc_pos
  ADD CONSTRAINT usim_spo_rmd_fk
  FOREIGN KEY (usim_id_rmd) REFERENCES usim_rel_mlv_dim (usim_id_rmd) ON DELETE CASCADE
  ENABLE
;
