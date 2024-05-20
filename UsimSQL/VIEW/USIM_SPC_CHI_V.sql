COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
-- USIM_SPC_CHI_V (scv)
-- guarantees all space id in view with or without childs
CREATE OR REPLACE VIEW &USIM_SCHEMA..usim_spc_chi_v AS
  SELECT spcv.usim_n_dimension AS parent_dimension
       , spcv.dim_sign         AS parent_dim_sign
       , chiv.child_dimension
       , chiv.child_dim_sign
       , spcv.usim_coordinate  AS parent_coordinate
       , chiv.child_coordinate
       , spcv.usim_id_spc
       , chiv.usim_id_spc_child
       , spcv.usim_id_rmd
       , spcv.usim_id_pos
       , spcv.usim_id_mlv
       , spcv.usim_id_nod
       , spcv.usim_id_dim
       , chiv.child_id_rmd
    FROM usim_spc_v spcv
    LEFT OUTER JOIN usim_chi_v chiv
      ON spcv.usim_id_spc = chiv.usim_id_spc
;