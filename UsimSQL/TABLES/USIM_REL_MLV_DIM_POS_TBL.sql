-- USIM_REL_MLV_DIM_POS (rmdp)
CREATE TABLE usim_rel_mlv_dim_pos
  ( usim_id_rmdp    CHAR(55)  NOT NULL ENABLE
  , usim_id_dim     CHAR(55)  NOT NULL ENABLE
  , usim_id_pos     CHAR(55)  NOT NULL ENABLE
  )
;
COMMENT ON TABLE usim_rel_mlv_dim_pos IS 'Relates a position in a dimension of a specific universe (implicite by dimension). Will use alias rmdp.';
COMMENT ON COLUMN usim_rel_mlv_dim_pos.usim_id_rmdp IS 'The primary key for the relation of universe, dimension and position.';
COMMENT ON COLUMN usim_rel_mlv_dim_pos.usim_id_dim IS 'The id of the dimension to relate with universe and position. Must be set on insert.';
COMMENT ON COLUMN usim_rel_mlv_dim_pos.usim_id_pos IS 'The id of the position to relate with universe and dimension. Must be set on insert.';


-- pk
ALTER TABLE usim_rel_mlv_dim_pos
  ADD CONSTRAINT usim_rmdp_pk
  PRIMARY KEY (usim_id_rmdp)
  ENABLE
;

-- uk highlander situation
ALTER TABLE usim_rel_mlv_dim_pos
  ADD CONSTRAINT usim_rmdp_uk
  UNIQUE (usim_id_dim, usim_id_pos)
  ENABLE
;

-- insert trigger
CREATE OR REPLACE TRIGGER usim_rmdp_ins_trg
  BEFORE INSERT ON usim_rel_mlv_dim_pos
    FOR EACH ROW
    BEGIN
      -- ignore input on pk
      :NEW.usim_id_rmdp := usim_static.get_big_pk(usim_rmdp_id_seq.NEXTVAL);
    END;
/
ALTER TRIGGER usim_rmdp_ins_trg ENABLE;

-- update trigger to prevent updates
CREATE OR REPLACE TRIGGER usim_rmdp_upd_trg
  BEFORE UPDATE ON usim_rel_mlv_dim_pos
    FOR EACH ROW
    BEGIN
      -- NEW is OLD, no updates
      :NEW.usim_id_rmdp   := :OLD.usim_id_rmdp;
      :NEW.usim_id_dim    := :OLD.usim_id_dim;
      :NEW.usim_id_pos    := :OLD.usim_id_pos;
    END;
/
ALTER TRIGGER usim_rmdp_upd_trg ENABLE;

