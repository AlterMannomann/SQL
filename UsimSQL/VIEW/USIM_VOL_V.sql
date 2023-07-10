-- USIM_VOL_V (volv)
CREATE OR REPLACE FORCE VIEW usim_vol_v AS
  SELECT vol.usim_id_vol
       , vol.usim_id_mlv
       , vol.usim_id_pos_base_from
       , vol.usim_id_pos_base_to
       , vol.usim_id_pos_mirror_from
       , vol.usim_id_pos_mirror_to
       , pos1.usim_coordinate           AS usim_coordinate_base_from
       , pos1.usim_sign                 AS usim_sign_base_from
       , pos2.usim_coordinate           AS usim_coordinate_base_to
       , pos2.usim_sign                 AS usim_sign_base_to
       , pos3.usim_coordinate           AS usim_coordinate_mirror_from
       , pos3.usim_sign                 AS usim_sign_mirror_from
       , pos4.usim_coordinate           AS usim_coordinate_mirror_to
       , pos4.usim_sign                 AS usim_sign_mirror_to
       , mlv.usim_universe_status
       , mlv.usim_is_base_universe
       , mlv.usim_energy_start_value
       , mlv.usim_base_sign
       , mlv.usim_mirror_sign
    FROM usim_volume vol
   INNER JOIN usim_position pos1
      ON vol.usim_id_pos_base_from    = pos1.usim_id_pos
   INNER JOIN usim_position pos2
      ON vol.usim_id_pos_base_to      = pos2.usim_id_pos
   INNER JOIN usim_position pos3
      ON vol.usim_id_pos_mirror_from  = pos3.usim_id_pos
   INNER JOIN usim_position pos4
      ON vol.usim_id_pos_mirror_to    = pos4.usim_id_pos
   INNER JOIN usim_multiverse mlv
      ON vol.usim_id_mlv = mlv.usim_id_mlv
;