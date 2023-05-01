SELECT * 
  FROM usim_point_insert_v
; 
SELECT *
  FROM usim_poi_dim_position_v
 ORDER BY usim_id_psc, usim_dimension, usim_id_poi 
;

SELECT * 
  FROM usim_tree_check_v
; 
SELECT * 
  FROM usim_tree_nodes_v 
;
SELECT * 
  FROM usim_dimension
; 
SELECT usim_id_dpo, COUNT(*) FROM usim_poi_dim_position GROUP BY usim_id_dpo HAVING COUNT(*) > 1; 
