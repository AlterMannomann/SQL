-- USIM_RELATIONS_D1_V (rd1v)
-- all pdp points connected with each other only once apart from self connections
-- use this view to process all existing points
CREATE OR REPLACE FORCE VIEW usim_relations_d1_v AS
  SELECT DISTINCT
         usim_id_pdp1
       , usim_id_pdp2
    FROM (SELECT CASE
                   WHEN pdp1.usim_id_pdp < pdp2.usim_id_pdp
                   THEN pdp1.usim_id_pdp
                   ELSE pdp2.usim_id_pdp
                 END AS usim_id_pdp1
               , CASE
                   WHEN pdp1.usim_id_pdp > pdp2.usim_id_pdp
                   THEN pdp1.usim_id_pdp
                   ELSE pdp2.usim_id_pdp
                 END AS usim_id_pdp2
            FROM usim_poi_dim_position pdp1
           CROSS JOIN usim_poi_dim_position pdp2
           WHERE pdp1.usim_id_pdp != pdp2.usim_id_pdp
         )
   ORDER BY usim_id_pdp1
          , usim_id_pdp2
;
COMMENT ON COLUMN usim_relations_d1_v.usim_id_pdp1 IS 'The first point. A starting or end point of an imaginary line in dimension 1. Direction of processing is not defined.';
COMMENT ON COLUMN usim_relations_d1_v.usim_id_pdp2 IS 'The second point. A starting or end point of an imaginary line in dimension 1. Direction of processing is not defined.';
-- USIM_RELATIONS_D1X_V (rd1xv)
-- all pdp points connected with each other apart from self connections
-- use this view to process a specific point by adding a WHERE usim_id_pdp_in = point clause
CREATE OR REPLACE FORCE VIEW usim_relations_d1x_v AS
  SELECT pdp1.usim_id_pdp AS usim_id_pdp_in
       , pdp2.usim_id_pdp AS usim_id_pdp_out
    FROM usim_poi_dim_position pdp1
   CROSS JOIN usim_poi_dim_position pdp2
   WHERE pdp1.usim_id_pdp != pdp2.usim_id_pdp
   ORDER BY pdp1.usim_id_pdp
          , pdp2.usim_id_pdp
;
COMMENT ON COLUMN usim_relations_d1x_v.usim_id_pdp_in IS 'The starting point of an imaginary line in dimension 1. Limit this point by a WHERE condition.';
COMMENT ON COLUMN usim_relations_d1x_v.usim_id_pdp_out IS 'The end point of an imaginary line in dimension 1 that receives any input from the starting point.';