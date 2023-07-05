-- USIM_RMD_V (rmdv)
-- minimal joining to get universe basics and dimension for the relation table usim_rel_mlv_dim
CREATE OR REPLACE FORCE VIEW usim_rmd_v AS
SELECT rmd.usim_id_rmd
     , rmd.usim_id_mlv
     , rmd.usim_id_dim
     , dim.usim_n_dimension
     , mlv.usim_universe_status
     , mlv.usim_is_base_universe
     , mlv.usim_energy_start_value
     , mlv.usim_base_sign
     , mlv.usim_mirror_sign
  FROM usim_rel_mlv_dim rmd
 INNER JOIN usim_dimension dim
    ON rmd.usim_id_dim = dim.usim_id_dim
 INNER JOIN usim_multiverse mlv
    ON rmd.usim_id_mlv = mlv.usim_id_mlv
;