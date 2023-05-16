-- USIM_ENERGY_STATE (ensv)
CREATE OR REPLACE FORCE VIEW usim_energy_state_v AS
    WITH esum AS
         (SELECT SIGN(usim_coordinate) AS usim_sign
               , SUM(usim_energy) AS energy_total
            FROM usim_poi_dim_position_v
           GROUP BY SIGN(usim_coordinate)
         )
       , emas AS
         (SELECT 0 AS neutral
               , 1 AS positiv
               , -1 AS negativ
            FROM dual
         )
       , eplanck AS
         (SELECT last_number - 1 AS usim_planck_time   -- last number = NEXTVAL, -1 is CURRVAL
            FROM user_sequences
           WHERE sequence_name = 'USIM_PLANCK_TIME_SEQ'
         )
  SELECT neut.energy_total
       , CASE
           WHEN posi.energy_total + nega.energy_total = 0
           THEN 'equilibrated'
           ELSE 'out of sync'
         END AS usim_state
       , NVL(eplanck.usim_planck_time, 0) AS usim_planck_time
       , posi.energy_total + nega.energy_total AS energy_diff
       , posi.energy_total AS energy_positive
       , nega.energy_total AS energy_negative
    FROM emas
    LEFT OUTER JOIN esum neut
      ON emas.neutral = neut.usim_sign
    LEFT OUTER JOIN esum posi
      ON emas.positiv = posi.usim_sign
    LEFT OUTER JOIN esum nega
      ON emas.negativ = nega.usim_sign
    CROSS JOIN eplanck
;