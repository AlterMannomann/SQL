-- USIM_SPO_XYZ_V (xyzv)
CREATE OR REPLACE VIEW usim_spo_xyz_v AS
  SELECT usim_id_spc
       , usim_spo.get_dim_coord(usim_id_spc, 1) AS x_coord
       , usim_spo.get_dim_coord(usim_id_spc, 2) AS y_coord
       , usim_spo.get_dim_coord(usim_id_spc, 3) AS z_coord
       , usim_spo.get_xyz(usim_id_spc) AS xyz_coord
       , usim_n_dimension
       , dim_sign
       , dim_n1_sign
       , usim_id_mlv
       , usim_energy
    FROM usim_spc_v
;