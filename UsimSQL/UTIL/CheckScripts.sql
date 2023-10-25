-- Collection of check scripts
-- check child parent symmetry
SELECT SUM(child_cnt) AS childs
     , SUM(parent_cnt) AS parents
     , dim_n1_sign
  FROM (SELECT usim_chi.child_count(usim_id_spc) AS child_cnt
             , usim_chi.parent_count(usim_id_spc) AS parent_cnt
             , dim_n1_sign
          FROM usim_spc_v
       )
 GROUP BY dim_n1_sign
;
-- dimension symmetry
SELECT usim_n1_sign
     , MAX(usim_n_dimension) AS max_dim
     , COUNT(*) AS cnt_dim
  FROM usim_rmd_v
 GROUP BY usim_n1_sign
;
-- symmetry processing, modulus 2 should be 0
SELECT usim_planck_aeon
     , usim_planck_time
     , COUNT(*) AS process_cnt
     , MOD(COUNT(*), 2) AS mod_2
  FROM usim_spc_process
 GROUP BY usim_planck_aeon
        , usim_planck_time
; 
-- classify check
SELECT CASE usim_dbif.classify_escape(usim_id_spc)
         WHEN 0 THEN 'FULL'
         WHEN 1 THEN 'FREE DIM POS'
         WHEN 2 THEN 'FREE DIM'
         WHEN 3 THEN 'FREE POS'
         WHEN 4 THEN 'FREE X-POS'
         ELSE 'ERR'
       END AS classify_escape
     , CASE usim_dbif.classify_parent(usim_id_spc)
         WHEN -2 THEN 'ERR'
         WHEN -1 THEN 'DM ERR'
         WHEN 0 THEN 'FULL'
         WHEN 1 THEN 'FREE DIM POS'
         WHEN 2 THEN 'FREE DIM'
         WHEN 3 THEN 'FREE POS'
         WHEN 4 THEN 'FREE X-POS'
         ELSE 'ERR'
       END AS classify_parent
     , CASE usim_dbif.dimension_rating(usim_id_spc)
         WHEN -1 THEN 'ERR'
         WHEN 0 THEN 'BASE0'
         WHEN 1 THEN 'AXIS0'
         WHEN 2 THEN 'AXIS'
         WHEN 3 THEN 'BETWEEN'
       END AS dim_rating
     , CASE usim_dbif.overflow_rating(usim_id_spc)
         WHEN 0 THEN 'TOTAL'
         WHEN 1 THEN 'NO'
         WHEN 2 THEN 'POS'
         WHEN 3 THEN 'DIM'
       END AS overflow
     , usim_dbif.is_overflow_dim_spc(usim_id_spc) AS is_overflow_dim
     , usim_dbif.is_overflow_pos_spc(usim_id_spc) AS is_overflow_pos
     , usim_spo.is_axis_zero_pos(usim_id_spc) is_zero_axis
     , usim_spc.is_universe_base(usim_id_spc) is_universe_base
     , usim_dbif.max_childs(usim_id_spc) AS max_childs
     , usim_dbif.child_count(usim_id_spc) AS childs
     , usim_spc.get_cur_max_dim_n1(usim_id_spc) AS max_dim_for_id
     , usim_chi.has_child_next_dim(usim_id_spc) AS child_next_dim
     , usim_n_dimension
     , dim_sign
     , dim_n1_sign
     , usim_spo.get_xyz(usim_id_spc) AS xyz
     , usim_id_spc
     , usim_spo.get_axis_max_pos_parent(usim_id_spc) AS max_pos_parent
  FROM usim_spc_v
 ORDER BY dim_n1_sign DESC NULLS FIRST
        , usim_n_dimension
        , ABS(usim_coordinate)
        , usim_dbif.dimension_rating(usim_id_spc)
;       
-- inspect processing
SELECT spr.usim_planck_time
     , spr.is_processed
     , xyz_src.xyz_coord AS from_xyz
     , xyz_src.usim_process_spin AS from_spin
     , xyz_src.usim_n_dimension AS from_dim
     , xyz_src.dim_n1_sign AS from_n1_sign
     , xyz_src.dim_sign AS from_n_sign
     , xyz_tgt.xyz_coord AS to_xyz
     , xyz_tgt.usim_process_spin AS to_spin
     , xyz_tgt.usim_n_dimension AS to_dim
     , xyz_tgt.dim_n1_sign AS to_n1_sign
     , xyz_tgt.dim_sign AS to_n_sign
     , spr.usim_energy_source
     , spr.usim_energy_target
     , spr.usim_energy_output
     , spr.usim_id_spc_source
     , spr.usim_id_spc_target
     , spr.usim_planck_aeon
     , spr.usim_real_time
  FROM usim_spc_process spr
  LEFT OUTER JOIN usim_spo_xyz_v xyz_src
    ON spr.usim_id_spc_source = xyz_src.usim_id_spc
  LEFT OUTER JOIN usim_spo_xyz_v xyz_tgt
    ON spr.usim_id_spc_target = xyz_tgt.usim_id_spc
-- WHERE spr.usim_planck_time = 2
 ORDER BY spr.usim_planck_aeon
        , spr.usim_planck_time
        , xyz_src.usim_n_dimension
        , xyz_tgt.usim_n_dimension
        , xyz_src.dim_n1_sign
;
-- create overview tabs
SELECT usim_timestamp, SUBSTR(usim_err_object, 1, 50) AS usim_err_object, usim_err_info FROM usim_error_log ORDER BY usim_timestamp, usim_tick;
SELECT * FROM usim_spc_v;
SELECT * FROM usim_spc_chi_v;
SELECT * FROM usim_spo_v;
SELECT * FROM usim_rmd_v;
SELECT * FROM usim_position;
SELECT * FROM usim_spo_xyz_v;
SELECT * FROM usim_spr_v;
SELECT * FROM usim_mlv_state_v;