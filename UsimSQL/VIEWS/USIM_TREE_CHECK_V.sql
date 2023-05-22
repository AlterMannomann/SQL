
-- USIM_TREE_CHECK_V (tcv)
CREATE OR REPLACE FORCE VIEW usim_tree_check_v AS
  SELECT usim_point_name
       , usim_n_dimension
       , nodes_per_dimension
       , relative_tree_height
       , perfect_node_cnt
       , subtree_add + SUM(nodes_per_dimension) OVER (PARTITION BY usim_point_name ORDER BY usim_n_dimension ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cur_node_cnt
    FROM (SELECT usim_point_name
               , usim_n_dimension
               , nodes_per_dimension
               , relative_tree_height
               , POWER(2, relative_tree_height) - 1 AS perfect_node_cnt
               , CASE -- add parent node in base staructure, which is not counted
                   WHEN usim_point_name = (SELECT usim_static.get_seed_name() FROM dual)
                   THEN 0
                   ELSE 1
                 END                                AS subtree_add
            FROM usim_tree_nodes_v
         )
;
COMMENT ON COLUMN usim_tree_check_v.usim_point_name IS 'The name of the associated point structure.';
COMMENT ON COLUMN usim_tree_check_v.usim_n_dimension IS 'The dimension the nodes/points reside.';
COMMENT ON COLUMN usim_tree_check_v.nodes_per_dimension IS 'The count of nodes/points per dimension.';
COMMENT ON COLUMN usim_tree_check_v.relative_tree_height IS 'The relative tree height of a binary tree for this dimension.';
COMMENT ON COLUMN usim_tree_check_v.perfect_node_cnt IS 'The perfect node/point count necessary for the current tree level to be a perfect binary tree. 2^tree level -1.';
COMMENT ON COLUMN usim_tree_check_v.cur_node_cnt IS 'The current node/point for the current tree level.';