SELECT * FROM usim_output_order_v WHERE usim_processed = 0;
SELECT * FROM usim_poi_dim_position_v;
SELECT * FROM usim_energy_state_v;
-- planck time für negativen durchlauf setzen
SELECT usim_planck_time_seq.NEXTVAL FROM dual;
-- dann
EXEC usim_ctrl.runPlanckCycle;

-- duplicates?
SELECT usim_id_source
     , usim_id_target
     , usim_plancktime
     , COUNT(*) AS anzahl
  FROM usim_output_order_v
 WHERE usim_plancktime >= 1
   AND usim_direction = -1
 GROUP BY usim_id_source
        , usim_id_target
        , usim_plancktime
HAVING COUNT(*) > 1
 ORDER BY usim_id_source
        , usim_id_target
;
-- data
SELECT *
  FROM usim_point
 WHERE ABS(usim_energy) = binary_double_infinity
; 
SELECT * FROM usim_poi_history ORDER BY usim_id_phis;
SELECT * FROM usim_output_v WHERE usim_processed = 0 ORDER BY usim_id_outp;

EXEC usim_ctrl.processoutput(57);
