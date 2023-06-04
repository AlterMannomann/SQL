SELECT * FROM usim_output_order_v WHERE usim_processed = 0;
SELECT * FROM usim_poi_dim_position_v;
SELECT * FROM usim_energy_state_v;
SELECT * FROM usim_poi_mirror_v;
-- overflow on 10 cycles
EXEC usim_ctrl.run_planck_cycles(10);

EXEC usim_ctrl.run_one_direction(0, 1, 1, 1, 1);
-- data
SELECT *
  FROM usim_point
 WHERE ABS(usim_energy) = binary_double_infinity
; 
SELECT * FROM usim_poi_history ORDER BY usim_id_phis;
SELECT * FROM usim_output_v WHERE usim_processed = 0 ORDER BY usim_id_outp;
SELECT * FROM usim_overflow_v ORDER BY usim_id_outp;
SELECT * FROM usim_position_v;

EXEC usim_ctrl.process_output(57);

      SELECT *
        FROM usim_overflow_v
       WHERE usim_processed = 0
       ORDER BY usim_id_outp
    ;