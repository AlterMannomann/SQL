-- USIM_POSITION_V (posv)
CREATE OR REPLACE FORCE VIEW usim_position_v AS
  SELECT usim_utility.get_max_position              AS usim_max_position_positive
       , usim_utility.get_max_position_1st          AS usim_next_1st_position_positive
       , usim_utility.get_max_position_2nd          AS usim_next_2nd_position_positive
       , usim_utility.get_max_position(-1)          AS usim_max_position_negative
       , usim_utility.get_max_position_1st(-1)      AS usim_next_1st_position_negative
       , usim_utility.get_max_position_2nd(-1)      AS usim_next_2nd_position_negative
  FROM dual
;
