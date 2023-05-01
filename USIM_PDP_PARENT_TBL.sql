-- USIM_PDP_PARENT (pdr)
CREATE TABLE usim_pdp_parent
  ( usim_id_pdp     NUMBER(38, 0)               NOT NULL ENABLE
  , usim_id_parent  NUMBER(38, 0)               NOT NULL ENABLE
  )
;
COMMENT ON TABLE usim_pdp_parent IS 'Relates point/dimension/position to a parent. Only one parent allowed. Will use the alias pdr.';
COMMENT ON COLUMN usim_pdp_parent.usim_id_pdp IS 'ID in USIM_POI_DIM_POSITION to identify a point with position in a dimension.';
COMMENT ON COLUMN usim_pdp_parent.usim_id_parent IS 'Parent ID in USIM_POI_DIM_POSITION to identify a point with position in a dimension.';

-- pk - relation parent is 1:1, only one entry for every pdp point
ALTER TABLE usim_pdp_parent
  ADD CONSTRAINT usim_pdr_pk
  PRIMARY KEY (usim_id_pdp)
  ENABLE
;
