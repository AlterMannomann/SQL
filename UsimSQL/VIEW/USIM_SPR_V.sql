CREATE OR REPLACE VIEW usim_spr_v AS
  SELECT spr.is_processed
       , xyzv_src.xyz_coord         AS src_xyz -- temporary, must have all dimensions
       , xyzv_src.usim_process_spin AS src_spin
       , xyzv_src.usim_n_dimension  AS src_dim
       , xyzv_src.dim_sign          AS src_dim_sign
       , xyzv_src.dim_n1_sign       AS src_dim_n1_sign
       , xyzv_tgt.xyz_coord         AS tgt_xyz
       , xyzv_tgt.usim_process_spin AS tgt_spin
       , xyzv_tgt.usim_n_dimension  AS tgt_dim
       , xyzv_tgt.dim_sign          AS tgt_dim_sign
       , xyzv_tgt.dim_n1_sign       AS tgt_dim_n1_sign
       , spr.usim_energy_source
       , spr.usim_energy_output
       , spr.usim_energy_target
       , spr.usim_id_spc_source
       , spr.usim_id_spc_target
       , xyzv_src.usim_id_mlv       AS src_id_mlv
       , xyzv_tgt.usim_id_mlv       AS tgt_id_mlv
       , spr.usim_planck_aeon
       , spr.usim_planck_time
       , spr.usim_real_time
    FROM usim_spc_process spr
    LEFT OUTER JOIN usim_spo_xyz_v xyzv_src
      ON spr.usim_id_spc_source = xyzv_src.usim_id_spc
    LEFT OUTER JOIN usim_spo_xyz_v xyzv_tgt
      ON spr.usim_id_spc_target = xyzv_tgt.usim_id_spc
;