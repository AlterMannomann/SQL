-- USIM_ENERGY_STATE (ensv)
CREATE OR REPLACE FORCE VIEW usim_energy_state_v AS
  SELECT SUM(usim_energy) AS energy_total
       , CASE SIGN(usim_coordinate)
           WHEN 0 THEN 'neutral (seed)'
           WHEN 1 THEN 'positive (tree)'
           WHEN -1 THEN 'negative (tree)'
           ELSE 'unexpected'
         END AS energy_type
    FROM usim_poi_dim_position_v
   GROUP BY SIGN(usim_coordinate)
;