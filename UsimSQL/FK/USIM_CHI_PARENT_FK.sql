-- fk parent-child relation between nodes in usim_space (for documentation, if disabled)
ALTER TABLE usim_spc_child
  ADD CONSTRAINT usim_chi_parent_fk
  FOREIGN KEY (usim_id_spc) REFERENCES usim_space (usim_id_spc) ON DELETE CASCADE
  ENABLE
;