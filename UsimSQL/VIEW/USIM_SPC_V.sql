COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
-- USIM_SPC_V (spcv)
-- minimal joining
CREATE OR REPLACE FORCE VIEW &USIM_SCHEMA..usim_spc_v AS
  SELECT rmd.usim_id_mlv
       , spc.usim_id_spc
       , spc.usim_id_rmd
       , spc.usim_id_pos
       , spc.usim_id_nod
       , spc.usim_process_spin
       , dim.usim_id_dim
       , dim.usim_n_dimension
       , rmd.usim_sign AS dim_sign
       , rmd.usim_n1_sign AS dim_n1_sign
       , pos.usim_coordinate
       , nod.usim_energy
       , mlv.usim_universe_status
       , mlv.usim_is_base_universe
       , CASE
           WHEN usim_spc.is_universe_base(spc.usim_id_spc) = 1
           THEN mlv.usim_energy_start_value
           ELSE NULL
         END                                      AS usim_energy_start_value
       , mlv.usim_ultimate_border
       , mlv.usim_planck_stable
       , mlv.usim_planck_length_unit
    FROM usim_space spc
   INNER JOIN usim_rel_mlv_dim rmd
      ON spc.usim_id_rmd = rmd.usim_id_rmd
   INNER JOIN usim_dimension dim
      ON rmd.usim_id_dim = dim.usim_id_dim
   INNER JOIN usim_multiverse mlv
      ON rmd.usim_id_mlv = mlv.usim_id_mlv
   INNER JOIN usim_position pos
      ON spc.usim_id_pos = pos.usim_id_pos
   INNER JOIN usim_node nod
      ON spc.usim_id_nod = nod.usim_id_nod
;