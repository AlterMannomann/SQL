-- USIM_TREE_NODES_V (tnv)
CREATE OR REPLACE FORCE VIEW usim_tree_nodes_v AS
  SELECT usim_point_name
       , usim_n_dimension
       , COUNT(*)             AS nodes_per_dimension
       , usim_n_dimension + 1 AS relative_tree_height
       , usim_id_psc
       , usim_id_dim
    FROM usim_poi_dim_position_v
   GROUP BY usim_point_name
          , usim_id_psc
          , usim_id_dim
          , usim_n_dimension
;
COMMENT ON COLUMN usim_tree_nodes_v.usim_point_name IS 'The name of the associated point structure.';
COMMENT ON COLUMN usim_tree_nodes_v.usim_n_dimension IS 'The dimension the nodes/points reside.';
COMMENT ON COLUMN usim_tree_nodes_v.nodes_per_dimension IS 'The count of nodes/points per dimension';
COMMENT ON COLUMN usim_tree_nodes_v.relative_tree_height IS 'The relative tree height of a binary tree for this dimension.';
COMMENT ON COLUMN usim_tree_nodes_v.usim_id_psc IS 'The ID of the associated point structure.';
COMMENT ON COLUMN usim_tree_nodes_v.usim_id_dim IS 'The ID of the associated dimension.';
