-- USIM_TREE_NODES_V (tnv)
CREATE OR REPLACE FORCE VIEW usim_tree_nodes_v AS
  SELECT usim_point_name
       , usim_dimension
       , COUNT(*)           AS nodes_per_dimension
       , usim_dimension + 1 AS relative_tree_height
    FROM usim_poi_dim_position_v
   GROUP BY usim_point_name
          , usim_dimension
;
COMMENT ON COLUMN usim_tree_nodes_v.usim_point_name IS 'The name of the associated point structure.';
COMMENT ON COLUMN usim_tree_nodes_v.usim_dimension IS 'The dimension the nodes/points reside.';
COMMENT ON COLUMN usim_tree_nodes_v.nodes_per_dimension IS 'The count of nodes/points per dimension';
COMMENT ON COLUMN usim_tree_nodes_v.relative_tree_height IS 'The relative tree height of a binary tree for this dimension.';