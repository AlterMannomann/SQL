-- USIM_REL_VOL_RRNP (rvr)
CREATE TABLE usim_rel_vol_rrnp
  ( usim_id_vol_from  CHAR(55)  NOT NULL ENABLE
  , usim_id_vol_to    CHAR(55)  NOT NULL ENABLE
  , usim_id_rrnp_from CHAR(55)  NOT NULL ENABLE
  , usim_id_rrnp_to   CHAR(55)  NOT NULL ENABLE
  , usim_id_rmd_from  CHAR(55)  NOT NULL ENABLE
  , usim_id_rmd_to    CHAR(55)  NOT NULL ENABLE
  , planck_tick       NUMBER    NOT NULL ENABLE
  )
;
COMMENT ON TABLE usim_rel_vol_rrnp IS 'Decribes the processing relation and order of universe, volumes, dimensions, positions and nodes in relation to needed planck ticks. Will use the alias rvr.';
COMMENT ON COLUMN usim_rel_vol_rrnp.usim_id_vol_from IS 'The starting volume id for processing a node. Volumes share borders. Border nodes are only processed once but impact both volumes.';
COMMENT ON COLUMN usim_rel_vol_rrnp.usim_id_vol_to IS 'The target volume id for processing a node. Volumes share borders. Border nodes are only processed once but impact both volumes.';
COMMENT ON COLUMN usim_rel_vol_rrnp.usim_id_rrpn_from IS 'The reference id to a specific starting node for processing. Border nodes are only processed once but impact both volumes.';
COMMENT ON COLUMN usim_rel_vol_rrnp.usim_id_rrpn_to IS 'The reference id for a specific target node for processing. Border nodes are only processed once but impact both volumes.';
COMMENT ON COLUMN usim_rel_vol_rrnp.usim_id_rmd_from IS 'The dimension relation id to a specific starting node for processing. Nodes are referenced in more than one dimension, e.g. a node in dimension 1 has coordinate 0, in dimension 2 0,0 and in dimension 3 0,0,0 but it stays always the same node.';
COMMENT ON COLUMN usim_rel_vol_rrnp.usim_id_rmd_to IS 'The dimension relation id to a specific target node for processing. Nodes are referenced in more than one dimension, e.g. a node in dimension 1 has coordinate 0, in dimension 2 0,0 and in dimension 3 0,0,0 but it stays always the same node.';

