-- fk volume to position mirror to (for documentation, if disabled)
ALTER TABLE usim_volume
  ADD CONSTRAINT usim_vol_pos4_fk
  FOREIGN KEY (usim_id_pos_mirror_to) REFERENCES usim_position (usim_id_pos) ON DELETE CASCADE
  ENABLE
;
