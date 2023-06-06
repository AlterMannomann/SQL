-- USIM_DIM_COORD_LIMITS_V (dcl)
CREATE OR REPLACE FORCE VIEW usim_dim_coord_limits_v AS
  WITH max_lvl AS
        -- get the maximum level by dimension
       (SELECT usim_n_dimension
             , MAX(usim_coord_level) AS max_level
          FROM usim_poi_dim_position_v
         GROUP BY usim_n_dimension
       )
     , max_coords AS
       -- get the max/min coordinates by dimension and level
       (SELECT usim_n_dimension
             , usim_coord_level
             , MAX(usim_coordinate) AS max_coordinate
             , MIN(usim_coordinate) AS min_coordinate
          FROM usim_poi_dim_position_v
         GROUP BY usim_n_dimension
                , usim_coord_level
       )
SELECT max_coords.usim_n_dimension
     , max_coords.usim_coord_level
     , max_coords.max_coordinate
     , max_coords.min_coordinate
  FROM max_coords
 INNER JOIN max_lvl
    ON max_coords.usim_n_dimension = max_lvl.usim_n_dimension
   AND max_coords.usim_coord_level = max_lvl.max_level
;

COMMENT ON COLUMN usim_dim_coord_limits_v.usim_n_dimension IS 'The dimension for getting max and min coordinates';
COMMENT ON COLUMN usim_dim_coord_limits_v.usim_coord_level IS 'The maximum coordinate number level for the assiciated dimension';
COMMENT ON COLUMN usim_dim_coord_limits_v.max_coordinate IS 'The maximum coordinate for the assiciated dimension and level';
COMMENT ON COLUMN usim_dim_coord_limits_v.min_coordinate IS 'The minimum coordinate for the assiciated dimension and level';