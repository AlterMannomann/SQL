-- USIM_RRPN_V (rrpnv)
-- minimal joining
CREATE OR REPLACE FORCE VIEW usim_rrpn_v AS
  SELECT rmd.usim_id_mlv
       , rrpn.usim_id_rrpn
       , rrpn.usim_id_rmd
       , rrpn.usim_id_pos
       , rrpn.usim_id_nod
       , dim.usim_n_dimension
       , pos.usim_coordinate
       , nod.usim_energy
       , mlv.usim_universe_status
       , mlv.usim_is_base_universe
       , mlv.usim_energy_start_value
       , mlv.usim_base_sign
       , mlv.usim_mirror_sign
    FROM usim_rel_rmd_pos_nod rrpn
   INNER JOIN usim_rel_mlv_dim rmd
      ON rrpn.usim_id_rmd = rmd.usim_id_rmd
   INNER JOIN usim_dimension dim
      ON rmd.usim_id_dim = dim.usim_id_dim
   INNER JOIN usim_multiverse mlv
      ON rmd.usim_id_mlv = mlv.usim_id_mlv
   INNER JOIN usim_position pos
      ON rrpn.usim_id_pos = pos.usim_id_pos
   INNER JOIN usim_node nod
      ON rrpn.usim_id_nod = nod.usim_id_nod
;