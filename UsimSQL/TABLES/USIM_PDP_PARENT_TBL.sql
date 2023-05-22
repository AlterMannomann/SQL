-- USIM_PDP_PARENT (pdr)
CREATE TABLE usim_pdp_parent
  ( usim_id_pdp     CHAR(55)  NOT NULL ENABLE
  , usim_id_parent  CHAR(55)  NOT NULL ENABLE
  )
;
COMMENT ON TABLE usim_pdp_parent IS 'Relates point/dimension/position to a parent. Only one parent allowed. Will use the alias pdr.';
COMMENT ON COLUMN usim_pdp_parent.usim_id_pdp IS 'Big ID in USIM_POI_DIM_POSITION to identify a point with position in a dimension.';
COMMENT ON COLUMN usim_pdp_parent.usim_id_parent IS 'Big parent ID in USIM_POI_DIM_POSITION to identify a point with position in a dimension.';

-- pk - relation parent is 1:1, only one entry for every pdp point possible
ALTER TABLE usim_pdp_parent
  ADD CONSTRAINT usim_pdr_pk
  PRIMARY KEY (usim_id_pdp)
  ENABLE
;
