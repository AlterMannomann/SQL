-- USIM_OVERFLOW (ovr)
CREATE TABLE usim_overflow
  ( usim_id_outp    CHAR(55)                NOT NULL ENABLE
  , usim_processed  NUMBER(1, 0)  DEFAULT 0 NOT NULL ENABLE
  )
;
COMMENT ON TABLE usim_overflow IS 'Keeps overflows of points. Will use the alias ovr.';
COMMENT ON COLUMN usim_overflow.usim_id_outp IS 'Big ID in USIM_OUTPUT to identify the responsible output task.';
COMMENT ON COLUMN usim_overflow.usim_processed IS 'Either 0 (not processed, default) or 1 (processed).';

-- pk - only one overflow per output task
ALTER TABLE usim_overflow
  ADD CONSTRAINT usim_ovr_pk
  PRIMARY KEY (usim_id_outp)
  ENABLE
;
-- check processed
ALTER TABLE usim_overflow
  ADD CONSTRAINT usim_ovr_processed_chk
  CHECK (usim_processed IN (0, 1))
  ENABLE
;
