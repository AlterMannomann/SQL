-- fk relation mlv/dim/pos to dimension (for documentation, if disabled)
ALTER TABLE usim_rel_rmd_pos_nod
  ADD CONSTRAINT usim_rrpn_rmd_fk
  FOREIGN KEY (usim_id_rmd) REFERENCES usim_rel_mlv_dim (usim_id_rmd) ON DELETE CASCADE
  ENABLE
;