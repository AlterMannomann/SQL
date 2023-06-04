-- USIM_LEVELS (lvl)
CREATE TABLE usim_levels
  ( usim_id_lvl          NUMBER(1)     NOT NULL ENABLE
  , usim_level_positive  NUMBER(38, 0) NOT NULL ENABLE
  , usim_level_negative  NUMBER(38, 0) NOT NULL ENABLE
  )
;
COMMENT ON TABLE usim_levels IS 'Keeps the current number levels. Has only one record, application controlled. Will use the alias lvl.';
COMMENT ON COLUMN usim_levels.usim_id_lvl IS 'The limited id for inserts. Only one record with id = 1 is possible through check constraint and primary unique key.';
COMMENT ON COLUMN usim_levels.usim_level_positive IS 'The current level for positive space point coordinates.';
COMMENT ON COLUMN usim_levels.usim_level_negative IS 'The current level for negative space point coordinates.';

-- pk
ALTER TABLE usim_levels
  ADD CONSTRAINT usim_lvl_pk
  PRIMARY KEY (usim_id_lvl)
  ENABLE
;

-- check id, means we limit records inserted to one record with id = 1 as we have a primary key unique constraint
ALTER TABLE usim_levels
  ADD CONSTRAINT usim_id_lvl_chk
  CHECK (usim_id_lvl = 1)
  ENABLE
;