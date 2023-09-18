-- fk relation space for node (for documentation, if disabled)
ALTER TABLE usim_space
  ADD CONSTRAINT usim_spc_nod_fk
  FOREIGN KEY (usim_id_nod) REFERENCES usim_node (usim_id_nod) ON DELETE CASCADE
  ENABLE
;