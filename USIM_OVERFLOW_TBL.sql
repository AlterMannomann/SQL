-- USIM_OVERFLOW (ovr)
CREATE TABLE usim_overflow
  ( usim_id_pdp     NUMBER(38, 0)               NOT NULL ENABLE
  , usim_energy     NUMBER
  , usim_amplitude  NUMBER
  , usim_wavelength NUMBER
  )
;
COMMENT ON TABLE usim_overflow IS 'Keeps overflows of points. Will use the alias ovr.';
COMMENT ON COLUMN usim_overflow.usim_id_pdp IS 'ID in USIM_POI_DIM_POSITION to identify a point with position in a dimension.';
COMMENT ON COLUMN usim_overflow.usim_energy IS 'The energy potential which would have caused an overflow, if any.';
COMMENT ON COLUMN usim_overflow.usim_amplitude IS 'The amplitude potential which would have caused an overflow, if any.';
COMMENT ON COLUMN usim_overflow.usim_wavelength IS 'The wavelength potential which would have caused an overflow, if any.';

-- pk - only one overflow per point with position in a dimension
ALTER TABLE usim_overflow
  ADD CONSTRAINT usim_ovr_pk
  PRIMARY KEY (usim_id_pdp)
  ENABLE
;
