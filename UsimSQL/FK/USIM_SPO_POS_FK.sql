-- fk base-mirror relation between nodes in usim_space (for documentation, if disabled)
ALTER TABLE usim_spc_pos
  ADD CONSTRAINT usim_spo_pos_fk
  FOREIGN KEY (usim_id_pos) REFERENCES usim_position (usim_id_pos) ON DELETE CASCADE
  ENABLE
;
