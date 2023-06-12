-- USIM_RUN_LOG (rlg)
CREATE TABLE usim_run_log
  ( usim_plancktime         CHAR(55)
  , usim_energy_total       NUMBER
  , usim_energy_diff        NUMBER
  , usim_energy_positive    NUMBER
  , usim_energy_negative    NUMBER
  )
;
COMMENT ON TABLE usim_run_log IS 'Provides a log of runs executed in this simulated universe. Will use the alias rlg.';
COMMENT ON COLUMN usim_run_log.usim_plancktime IS 'The current planck time used by the run. Also used as primary key.';
COMMENT ON COLUMN usim_run_log.usim_energy_total IS 'The total energy of the universe after the run. Should be different from zero, otherwise the universe is dead.';
COMMENT ON COLUMN usim_run_log.usim_energy_diff IS 'The energy difference between positive and negative space after one run. Should be zero, otherwise the universe is crashed.';
COMMENT ON COLUMN usim_run_log.usim_energy_positive IS 'The positive energy of the universe after the run.';
COMMENT ON COLUMN usim_run_log.usim_energy_negative IS 'The negative energy of the universe after the run.';

-- pk as planck time should change with every run, this is our primary key.
ALTER TABLE usim_run_log
  ADD CONSTRAINT usim_rlg_pk
  PRIMARY KEY (usim_plancktime)
  ENABLE
;
