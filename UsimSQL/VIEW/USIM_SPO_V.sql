-- USIM_SPO_V (spov)
CREATE OR REPLACE FORCE VIEW usim_spo_v AS
  SELECT spo.usim_id_spc
       , spo.usim_id_rmd
       , spo.usim_id_pos
       , rmdv.usim_sign AS dim_sign
       , rmdv.usim_n1_sign AS dim_n1_sign
       , rmdv.usim_n_dimension
       , pos.usim_coordinate
       , rmdv.usim_id_mlv
    FROM usim_spc_pos spo
   INNER JOIN usim_rmd_v rmdv
      ON spo.usim_id_rmd = rmdv.usim_id_rmd
   INNER JOIN usim_position pos
      ON spo.usim_id_pos = pos.usim_id_pos
;