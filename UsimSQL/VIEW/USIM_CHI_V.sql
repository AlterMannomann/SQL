COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
-- USIM_CHI_V (chiv)
CREATE OR REPLACE FORCE VIEW &USIM_SCHEMA..usim_chi_v AS
  SELECT r_parent.usim_n_dimension AS parent_dimension
       , r_parent.dim_sign AS parent_dim_sign
       , r_parent.dim_n1_sign AS parent_dim_n1_sign
       , r_child.usim_n_dimension AS child_dimension
       , r_child.dim_sign AS child_dim_sign
       , r_child.dim_n1_sign AS child_dim_n1_sign
       , r_parent.usim_coordinate AS parent_coordinate
       , r_child.usim_coordinate AS child_coordinate
       , chi.usim_id_spc
       , chi.usim_id_spc_child
       , r_parent.usim_id_rmd AS parent_id_rmd
       , r_child.usim_id_rmd AS child_id_rmd
       , r_parent.usim_id_mlv AS parent_id_mlv
       , r_child.usim_id_mlv AS child_id_mlv
    FROM usim_spc_child chi
    LEFT OUTER JOIN usim_spc_v r_parent
      ON chi.usim_id_spc = r_parent.usim_id_spc
    LEFT OUTER JOIN usim_spc_v r_child
      ON chi.usim_id_spc_child = r_child.usim_id_spc
;