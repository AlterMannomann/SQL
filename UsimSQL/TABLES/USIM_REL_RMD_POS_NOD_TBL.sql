-- USIM_REL_RMD_POS_NOD (rrpn)
CREATE TABLE usim_rel_rmd_pos_nod
  ( usim_id_rrpn    CHAR(55)  NOT NULL ENABLE
  , usim_id_rmd     CHAR(55)  NOT NULL ENABLE
  , usim_id_pos     CHAR(55)  NOT NULL ENABLE
  , usim_id_nod     CHAR(55)  NOT NULL ENABLE
  )
;
COMMENT ON TABLE usim_rel_rmd_pos_nod IS 'A table describing the relation between universe, dimension, position and node. Will use the alias rrnp.';
COMMENT ON COLUMN usim_rel_rmd_pos_nod.usim_id_rrpn IS 'The id for the relation between universe, dimension, position and node. Automatically set, ignored on update.';
COMMENT ON COLUMN usim_rel_rmd_pos_nod.usim_id_rmd IS 'The id for the universe / dimension relation. Must exist and be set on insert, ignored on update.';
COMMENT ON COLUMN usim_rel_rmd_pos_nod.usim_id_pos IS 'The id for the position relation. Must exist and be set on insert, ignored on update.';
COMMENT ON COLUMN usim_rel_rmd_pos_nod.usim_id_nod IS 'The id for the node relation. Must exist and be set on insert, ignored on update.';

-- pk
ALTER TABLE usim_rel_rmd_pos_nod
  ADD CONSTRAINT usim_rrpn_pk
  PRIMARY KEY (usim_id_rrpn)
  ENABLE
;

-- uk universe/dim/position is unique
ALTER TABLE usim_rel_rmd_pos_nod
  ADD CONSTRAINT usim_rrpn_uk
  UNIQUE (usim_id_rmd, usim_id_pos)
  ENABLE
;

-- uk node is unique
ALTER TABLE usim_rel_rmd_pos_nod
  ADD CONSTRAINT usim_rrpn_nod_uk
  UNIQUE (usim_id_nod)
  ENABLE
;

-- insert trigger
CREATE OR REPLACE TRIGGER usim_rrpn_ins_trg
  BEFORE INSERT ON usim_rel_rmd_pos_nod
    FOR EACH ROW
    BEGIN
      -- ignore input on pk
      :NEW.usim_id_rrpn := usim_static.get_big_pk(usim_rrpn_id_seq.NEXTVAL);
    END;
/
ALTER TRIGGER usim_rrpn_ins_trg ENABLE;

-- update trigger
CREATE OR REPLACE TRIGGER usim_rrpn_upd_trg
  BEFORE UPDATE ON usim_rel_rmd_pos_nod
    FOR EACH ROW
    BEGIN
      -- ignore input on update OLD is NEW
      :NEW.usim_id_rrpn := :OLD.usim_id_rrpn;
      :NEW.usim_id_rmd  := :OLD.usim_id_rmd;
      :NEW.usim_id_pos  := :OLD.usim_id_pos;
      :NEW.usim_id_nod  := :OLD.usim_id_nod;
    END;
/
ALTER TRIGGER usim_rrpn_upd_trg ENABLE;
