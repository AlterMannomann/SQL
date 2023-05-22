-- USIM_POSITION_V (posv)
CREATE OR REPLACE FORCE VIEW usim_position_v AS
  SELECT MAX(usim_coordinate)     AS usim_max_position_positive
       , MAX(usim_coordinate) + 1 AS usim_next_1st_position_positive
       , MAX(usim_coordinate) + 2 AS usim_next_2nd_position_positive
       , MIN(usim_coordinate)     AS usim_max_position_negative
       , MIN(usim_coordinate) - 1 AS usim_next_1st_position_negative
       , MIN(usim_coordinate) - 2 AS usim_next_2nd_position_negative
    FROM usim_position
;