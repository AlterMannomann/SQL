-- fk relation to nodes in usim_space (for documentation, if disabled)
ALTER TABLE usim_spc_pos
  ADD CONSTRAINT usim_spo_spc_fk
  FOREIGN KEY (usim_id_spc) REFERENCES usim_space (usim_id_spc) ON DELETE CASCADE
  ENABLE
;