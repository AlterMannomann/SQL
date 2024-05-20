COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
-- USIM_SPO_ZERO3D_V (spz3d)
CREATE OR REPLACE VIEW &USIM_SCHEMA..usim_spo_zero3d_v AS
    WITH base AS
         (SELECT /*+ MATERIALIZE */
                 usim_spo.get_xyz(chi.usim_id_spc)          AS src_xyz
               , usim_spo.get_xyz(chi.usim_id_spc_child)    AS tgt_xyz
               , usim_spo.get_magnitude(chi.usim_id_spc, 3) AS src_mag
               , src.usim_n_dimension                       AS src_dim
               , tgt.usim_n_dimension                       AS tgt_dim
               , src.dim_sign                               AS src_dim_sign
               , tgt.dim_sign                               AS tgt_dim_sign
               , src.dim_n1_sign                            AS src_n1_sign
               , tgt.dim_n1_sign                            AS tgt_n1_sign
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
  SELECT src_xyz
       , tgt_xyz
       , src_mag
       , src_dim
       , tgt_dim
       , src_dim_sign
       , tgt_dim_sign
       , src_n1_sign
       , tgt_n1_sign
       , src_id_mlv     AS usim_id_mlv
    FROM base
   GROUP BY src_id_mlv
          , src_xyz
          , tgt_xyz
          , src_mag
          , src_dim
          , tgt_dim
          , src_dim_sign
          , tgt_dim_sign
          , src_n1_sign
          , tgt_n1_sign
   ORDER BY src_id_mlv
          , src_mag
          , src_dim
          , tgt_dim
          , src_dim_sign DESC
          , tgt_dim_sign DESC
          , src_n1_sign DESC
          , tgt_n1_sign DESC
          , src_xyz
          , tgt_xyz
;