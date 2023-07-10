-- fk volume to position base from (for documentation, if disabled)
ALTER TABLE usim_volume
  ADD CONSTRAINT usim_vol_pos1_fk
  FOREIGN KEY (usim_id_pos_base_from) REFERENCES usim_position (usim_id_pos) ON DELETE CASCADE
  ENABLE
;
