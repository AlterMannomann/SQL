-- USIM_VOL_JOIN_V (voljv)
-- will list the from/to columns as rows to have proper join criteria
CREATE OR REPLACE FORCE VIEW usim_vol_join_v AS
  SELECT vol.usim_id_vol
       , vol.usim_id_mlv
       , pos.usim_id_pos
       , pos.usim_coordinate
       , pos.usim_sign
       , CASE
           WHEN vol.usim_id_pos_base_from = pos.usim_id_pos
           THEN 1
           WHEN vol.usim_id_pos_base_to = pos.usim_id_pos
           THEN 1
           WHEN vol.usim_id_pos_mirror_from = pos.usim_id_pos
           THEN 0
           WHEN vol.usim_id_pos_mirror_to = pos.usim_id_pos
           THEN 0
         END AS is_base
       , CASE
           WHEN vol.usim_id_pos_base_from = pos.usim_id_pos
           THEN 1
           WHEN vol.usim_id_pos_base_to = pos.usim_id_pos
           THEN 0
           WHEN vol.usim_id_pos_mirror_from = pos.usim_id_pos
           THEN 1
           WHEN vol.usim_id_pos_mirror_to = pos.usim_id_pos
           THEN 0
         END AS is_from
       , mlv.usim_universe_status
       , mlv.usim_is_base_universe
       , mlv.usim_energy_start_value
    FROM usim_volume vol
   INNER JOIN usim_position pos
      ON vol.usim_id_pos_base_from    = pos.usim_id_pos
      OR vol.usim_id_pos_base_to      = pos.usim_id_pos
      OR vol.usim_id_pos_mirror_from  = pos.usim_id_pos
      OR vol.usim_id_pos_mirror_to    = pos.usim_id_pos
   INNER JOIN usim_multiverse mlv
      ON vol.usim_id_mlv = mlv.usim_id_mlv
;