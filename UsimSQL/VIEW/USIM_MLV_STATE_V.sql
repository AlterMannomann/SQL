-- USIM_MLV_STATE_V (mlsv)
CREATE OR REPLACE VIEW usim_mlv_state_v AS
    WITH det AS
         (SELECT usim_id_mlv
               , dim_n1_sign
               , SUM(usim_energy)         AS base_energy
               , SUM(NVL(usim_energy, 0)) AS energy
            FROM usim_spc_v
           GROUP BY usim_id_mlv
                  , dim_n1_sign
         )
       , tot AS
         (SELECT usim_id_mlv
               , SUM(NVL(usim_energy, 0)) AS energy
            FROM usim_spc_v
           GROUP BY usim_id_mlv
         )
       , ovr AS
         (SELECT mlv.usim_id_mlv
               , usim_static.get_multiverse_status(mlv.usim_universe_status) AS current_status
               , mlv.usim_is_base_universe
               , tot.energy AS energy_total
               , det_pos.energy AS energy_positive
               , det_neg.energy AS energy_negative
               , det_base.base_energy AS energy_base
               , mlv.usim_universe_status
               , usim_spr.has_data AS has_process_data
               , usim_spr.has_unprocessed AS has_unprocessed
            FROM usim_multiverse mlv
            LEFT OUTER JOIN det det_neg
              ON mlv.usim_id_mlv = det_neg.usim_id_mlv
             AND det_neg.dim_n1_sign = -1
            LEFT OUTER JOIN det det_pos
              ON mlv.usim_id_mlv = det_pos.usim_id_mlv
             AND det_pos.dim_n1_sign = 1
            LEFT OUTER JOIN det det_base
              ON mlv.usim_id_mlv = det_base.usim_id_mlv
             AND det_base.dim_n1_sign IS NULL
            LEFT OUTER JOIN tot
              ON mlv.usim_id_mlv = tot.usim_id_mlv
         )
  SELECT usim_id_mlv
       , usim_base.get_planck_aeon_seq_current  AS planck_aeon
       , usim_base.get_planck_time_current      AS planck_time
       , current_status                         AS status_txt
       , CASE usim_universe_status
           WHEN usim_static.get_multiverse_active
           THEN CASE
                  WHEN has_process_data    = 1
                   AND NVL(energy_base, 0) = 0
                  THEN 1
                  ELSE 0
                END
           WHEN usim_static.get_multiverse_crashed
           THEN CASE
                  WHEN has_process_data = 1
                   AND has_unprocessed  = 0
                  THEN 1
                  WHEN has_process_data = 1
                   AND has_unprocessed  = 1
                   AND energy_base     != 0
                  THEN 1
                  ELSE 0
                END
           WHEN usim_static.get_multiverse_dead
           THEN CASE
                  WHEN has_process_data = 1
                   AND energy_base      = 0
                   AND energy_total     = 0
                   AND energy_positive  = 0
                   AND energy_negative  = 0
                  THEN 1
                  ELSE 0
                END
           WHEN usim_static.get_multiverse_inactive
           THEN CASE
                  WHEN has_process_data = 0
                  THEN 1
                  ELSE 0
                END
           ELSE -1
         END                                    AS status_valid
       , CASE
           WHEN has_process_data    = 1
            AND NVL(energy_base, 0) = 0
           THEN usim_static.get_multiverse_active
           WHEN has_process_data = 1
            AND has_unprocessed  = 0
           THEN usim_static.get_multiverse_crashed
           WHEN has_process_data = 1
            AND has_unprocessed  = 1
            AND energy_base     != 0
           THEN usim_static.get_multiverse_crashed
           WHEN energy_base      = 0
            AND energy_total     = 0
            AND energy_positive  = 0
            AND energy_negative  = 0
           THEN usim_static.get_multiverse_dead
           WHEN has_process_data = 0
           THEN usim_static.get_multiverse_inactive
           ELSE NULL
         END                                    AS status_calculated
       , usim_universe_status                   AS status_current
       , usim_is_base_universe
       , energy_total
       , energy_positive
       , energy_negative
       , energy_base
       , has_process_data
       , has_unprocessed
    FROM ovr
;

COMMENT ON COLUMN usim_mlv_state_v.status_valid IS 'Determines if the current database status is valid. 1 = valid 0 = invalid, -1 = no valid calculation rule found for a related universe';
COMMENT ON COLUMN usim_mlv_state_v.status_calculated IS 'Calculates the database status by current energy and process data for a related universe, NULL means invalid no rules found to determine state';
COMMENT ON COLUMN usim_mlv_state_v.energy_total IS 'The total summed up energy of the related universe';
COMMENT ON COLUMN usim_mlv_state_v.energy_positive IS 'The energy sum for all dimension axis with n1 sign = +1';
COMMENT ON COLUMN usim_mlv_state_v.energy_negative IS 'The energy sum for all dimension axis with n1 sign = -1';
COMMENT ON COLUMN usim_mlv_state_v.energy_base IS 'The energy sum for the base universe node with n1 sign = NULL';
COMMENT ON COLUMN usim_mlv_state_v.has_process_data IS 'Determines if process data are available. Without process data or no unprocessed data, the universe is inactive';
COMMENT ON COLUMN usim_mlv_state_v.has_unprocessed IS 'Determines if there are unprocessed data. An active universe should always have some unprocessed data';
