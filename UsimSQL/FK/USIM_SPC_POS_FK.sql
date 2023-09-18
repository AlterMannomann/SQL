-- fk relation space for position (for documentation, if disabled)
ALTER TABLE usim_space
  ADD CONSTRAINT usim_spc_pos_fk
  FOREIGN KEY (usim_id_pos) REFERENCES usim_position (usim_id_pos) ON DELETE CASCADE
  ENABLE
;