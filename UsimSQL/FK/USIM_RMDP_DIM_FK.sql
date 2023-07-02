-- fk relation mlv/dim/pos to dimension (for documentation, if disabled)
ALTER TABLE usim_rel_mlv_dim_pos
  ADD CONSTRAINT usim_rmdp_dim_fk
  FOREIGN KEY (usim_id_dim) REFERENCES usim_dimension (usim_id_dim) ON DELETE CASCADE
  ENABLE
;