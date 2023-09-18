-- fk parent-child relation between nodes in usim_space (for documentation, if disabled)
ALTER TABLE usim_spc_child
  ADD CONSTRAINT usim_chi_child_fk
  FOREIGN KEY (usim_id_spc_child) REFERENCES usim_space (usim_id_spc) ON DELETE CASCADE
  ENABLE
;
