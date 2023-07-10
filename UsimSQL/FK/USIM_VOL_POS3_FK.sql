-- fk volume to position mirror from (for documentation, if disabled)
ALTER TABLE usim_volume
  ADD CONSTRAINT usim_vol_pos3_fk
  FOREIGN KEY (usim_id_pos_mirror_from) REFERENCES usim_position (usim_id_pos) ON DELETE CASCADE
  ENABLE
;
