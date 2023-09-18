-- fk relation to nodes in usim_space (for documentation, if disabled)
ALTER TABLE usim_spc_process
  ADD CONSTRAINT usim_spr_src_fk
  FOREIGN KEY (usim_id_spc_source) REFERENCES usim_space (usim_id_spc) ON DELETE CASCADE
  ENABLE
;