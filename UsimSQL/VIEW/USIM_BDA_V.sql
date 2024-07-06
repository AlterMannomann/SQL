-- define session for test schema first (temporary for tests)
SET search_path TO usim_test, public;

-- View: usim_bda_v on usim_basedata
-- always drop to avoid errors on added columns
DROP VIEW usim_bda_v;

CREATE OR REPLACE VIEW usim_bda_v
 AS
 SELECT
        CASE
            WHEN bds.bda_id IS NOT NULL
            THEN 'Active'::text
            ELSE 'Inactive'::text
        END AS status,
        bda.bda_simulation_name AS simulation_name,
        bda.bda_max_dimension AS max_dimension,
        bda.bda_max_abs_number AS max_number_absolute,
        bda.bda_id,
        CASE
            WHEN bds.bda_id IS NOT NULL
            THEN 1
            ELSE 0
        END AS status_id,
        bda.bda_created,
        bda.bda_updated,
        bda.bda_created_by,
        bda.bda_updated_by
   FROM usim_test.usim_basedata bda
   LEFT JOIN usim_test.usim_bda_state bds
     ON bda.bda_id = bds.bda_id
  ORDER BY bda.bda_id;
