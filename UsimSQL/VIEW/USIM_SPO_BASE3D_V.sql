-- USIM_SPO_BASE3D_V (spb3d)
CREATE OR REPLACE VIEW usim_spo_base3d_v AS
    WITH base AS
         (SELECT /*+ MATERIALIZE */
                 usim_spo.get_xyz(chi.usim_id_spc)          AS src_xyz
               , usim_spo.get_xyz(chi.usim_id_spc_child)    AS tgt_xyz
               , usim_spo.get_magnitude(chi.usim_id_spc, 3) AS src_mag
               , src.usim_n_dimension                       AS src_dim
               , tgt.usim_n_dimension                       AS tgt_dim
               , src.dim_sign                               AS src_dim_sign
               , tgt.dim_sign                               AS tgt_dim_sign
               , src.usim_id_mlv                            AS src_id_mlv
            FROM usim_spc_child chi
            LEFT OUTER JOIN usim_spc_v src
              ON chi.usim_id_spc = src.usim_id_spc
            LEFT OUTER JOIN usim_spc_v tgt
              ON chi.usim_id_spc_child = tgt.usim_id_spc
           WHERE src.usim_n_dimension <= 3
             AND tgt.usim_n_dimension <= 3
             AND src.usim_id_mlv       = tgt.usim_id_mlv -- no inter universe connects
         )
       , grp_prep AS
         (SELECT src_xyz
               , tgt_xyz
               , src_mag
               , CASE
                   WHEN src_xyz = '0,0,0'
                    AND src_xyz = tgt_xyz
                   THEN 0
                   ELSE src_dim
                 END                        AS src_dim
               , CASE
                   WHEN src_xyz = '0,0,0'
                    AND src_xyz = tgt_xyz
                   THEN 1
                   ELSE tgt_dim
                 END                        AS tgt_dim
               , CASE
                   WHEN src_xyz = '0,0,0'
                    AND src_xyz = tgt_xyz
                   THEN 0
                   ELSE src_dim_sign
                 END                        AS src_dim_sign
               , CASE
                   WHEN src_xyz = '0,0,0'
                    AND src_xyz = tgt_xyz
                   THEN 0
                   ELSE tgt_dim_sign
                 END                        AS tgt_dim_sign
               , src_id_mlv
            FROM base
         )
  SELECT src_xyz
       , tgt_xyz
       , src_mag
       , src_dim
       , tgt_dim
       , src_dim_sign
       , tgt_dim_sign
       , src_id_mlv     AS usim_id_mlv
    FROM grp_prep
   GROUP BY src_id_mlv
          , src_xyz
          , tgt_xyz
          , src_mag
          , src_dim
          , tgt_dim
          , src_dim_sign
          , tgt_dim_sign
   ORDER BY src_id_mlv
          , src_mag
          , src_dim
          , tgt_dim
          , src_dim_sign DESC
          , tgt_dim_sign DESC
          , src_xyz
          , tgt_xyz
;