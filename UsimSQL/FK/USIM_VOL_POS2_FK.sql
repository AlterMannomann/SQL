-- fk volume to position base to (for documentation, if disabled)
ALTER TABLE usim_volume
  ADD CONSTRAINT usim_vol_pos2_fk
  FOREIGN KEY (usim_id_pos_base_to) REFERENCES usim_position (usim_id_pos) ON DELETE CASCADE
  ENABLE
;
