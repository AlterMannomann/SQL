-- fk relation mlv/dim/pos to position (for documentation, if disabled)
ALTER TABLE usim_rel_rmd_pos_nod
  ADD CONSTRAINT usim_rrpn_pos_fk
  FOREIGN KEY (usim_id_pos) REFERENCES usim_position (usim_id_pos) ON DELETE CASCADE
  ENABLE
;