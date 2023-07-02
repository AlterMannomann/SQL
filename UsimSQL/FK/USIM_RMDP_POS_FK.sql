-- fk relation mlv/dim/pos to dimension (for documentation, if disabled)
ALTER TABLE usim_rel_mlv_dim_pos
  ADD CONSTRAINT usim_rmdp_pos_fk
  FOREIGN KEY (usim_id_pos) REFERENCES usim_position (usim_id_pos) ON DELETE CASCADE
  ENABLE
;