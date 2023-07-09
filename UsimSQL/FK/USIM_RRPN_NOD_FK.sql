-- fk relation mlv/dim/pos to dimension (for documentation, if disabled)
ALTER TABLE usim_rel_rmd_pos_nod
  ADD CONSTRAINT usim_rrpn_nod_fk
  FOREIGN KEY (usim_id_nod) REFERENCES usim_node (usim_id_nod) ON DELETE CASCADE
  ENABLE
;