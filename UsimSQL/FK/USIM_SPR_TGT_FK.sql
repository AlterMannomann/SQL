-- fk relation to nodes in usim_space (for documentation, if disabled)
ALTER TABLE usim_spc_process
  ADD CONSTRAINT usim_spr_tgt_fk
  FOREIGN KEY (usim_id_spc_target) REFERENCES usim_space (usim_id_spc) ON DELETE CASCADE
  ENABLE
;