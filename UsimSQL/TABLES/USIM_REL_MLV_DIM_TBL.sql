-- USIM_REL_MLV_DIM (rmd)
CREATE TABLE usim_rel_mlv_dim
  ( usim_id_rmd CHAR(55)  NOT NULL ENABLE
  , usim_id_mlv CHAR(55)  NOT NULL ENABLE
  , usim_id_dim CHAR(55)  NOT NULL ENABLE
  )
;
COMMENT ON TABLE usim_rel_mlv_dim IS 'A table describing the relation between dimension and a specific universe. Will use the alias rmd.';
COMMENT ON COLUMN usim_rel_mlv_dim.usim_id_rmd IS 'The unique id of the relation between universe and dimension. Automatically set, ignored on update';
COMMENT ON COLUMN usim_rel_mlv_dim.usim_id_mlv IS 'The universe id to relate to a dimension. Must be set on insert, ignored on update.';
COMMENT ON COLUMN usim_rel_mlv_dim.usim_id_dim IS 'The dimension id to relate to a universe. Must be set on insert, ignored on update.';

-- pk
ALTER TABLE usim_rel_mlv_dim
  ADD CONSTRAINT usim_rmd_pk
  PRIMARY KEY (usim_id_rmd)
  ENABLE
;

-- uk universe/dim is unique
ALTER TABLE usim_rel_mlv_dim
  ADD CONSTRAINT usim_rmd_uk
  UNIQUE (usim_id_mlv, usim_id_dim)
  ENABLE
;

-- insert trigger
CREATE OR REPLACE TRIGGER usim_rmd_ins_trg
  BEFORE INSERT ON usim_rel_mlv_dim
    FOR EACH ROW
    BEGIN
      -- ignore input on pk
      :NEW.usim_id_rmd := usim_static.get_big_pk(usim_rmd_id_seq.NEXTVAL);
    END;
/
ALTER TRIGGER usim_rmd_ins_trg ENABLE;

-- update trigger to prevent updates
CREATE OR REPLACE TRIGGER usim_rmd_upd_trg
  BEFORE UPDATE ON usim_rel_mlv_dim
    FOR EACH ROW
    BEGIN
      -- NEW is OLD, no updates
      :NEW.usim_id_rmd  := :OLD.usim_id_rmd;
      :NEW.usim_id_mlv  := :OLD.usim_id_mlv;
      :NEW.usim_id_dim  := :OLD.usim_id_dim;
    END;
/
ALTER TRIGGER usim_rmd_upd_trg ENABLE;
