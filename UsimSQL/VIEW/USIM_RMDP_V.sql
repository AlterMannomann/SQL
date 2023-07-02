-- USIM_RMDP_V (rmdpv)
-- minimal joining to get universe id, dimension and coordinate for the relation table usim_rel_mlv_dim_pos
CREATE OR REPLACE FORCE VIEW usim_rmdp_v AS
SELECT rmdp.usim_id_rmdp
     , dim.usim_id_mlv
     , rmdp.usim_id_dim
     , rmdp.usim_id_pos
     , dim.usim_n_dimension
     , pos.usim_coordinate
  FROM usim_rel_mlv_dim_pos rmdp
 INNER JOIN usim_dimension dim
    ON rmdp.usim_id_dim = dim.usim_id_dim
 INNER JOIN usim_position pos
    ON rmdp.usim_id_pos = pos.usim_id_pos
;