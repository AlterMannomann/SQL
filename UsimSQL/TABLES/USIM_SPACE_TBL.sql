-- USIM_SPACE (spc)
CREATE TABLE usim_space
  ( usim_id_spc       CHAR(55)    NOT NULL ENABLE
  , usim_id_rmd       CHAR(55)    NOT NULL ENABLE
  , usim_id_pos       CHAR(55)    NOT NULL ENABLE
  , usim_id_nod       CHAR(55)    NOT NULL ENABLE
  , usim_process_spin NUMBER(1,0) NOT NULL ENABLE
  )
;
COMMENT ON TABLE usim_space IS 'A table describing the space of the universes by universe, dimension, position, node and volume. Will use the alias spc.';
COMMENT ON COLUMN usim_space.usim_id_spc IS 'The id for a node in space. Automatically set, update not allowed.';
COMMENT ON COLUMN usim_space.usim_id_rmd IS 'The id for the universe / dimension relation. Must exist and be set on insert, update not allowed.';
COMMENT ON COLUMN usim_space.usim_id_pos IS 'The id for the position relation. Must exist and be set on insert, update not allowed.';
COMMENT ON COLUMN usim_space.usim_id_nod IS 'The id for the node relation. Must exist and be set on insert, update not allowed.';
COMMENT ON COLUMN usim_space.usim_process_spin IS 'The direction to emit energy to. 1 is direction childs, -1 direction parents. Nodes in dimension 0 will always have direction childs.';

-- pk
ALTER TABLE usim_space
  ADD CONSTRAINT usim_spc_pk
  PRIMARY KEY (usim_id_spc)
  ENABLE
;

-- uk universe/dim/position/node is unique
ALTER TABLE usim_space
  ADD CONSTRAINT usim_spc_uk
  UNIQUE (usim_id_rmd, usim_id_pos, usim_id_nod)
  ENABLE
;

-- uk node is unique
ALTER TABLE usim_space
  ADD CONSTRAINT usim_spc_nod_uk
  UNIQUE (usim_id_nod)
  ENABLE
;

-- check usim_process_spin
ALTER TABLE usim_space
  ADD CONSTRAINT usim_spc_spin_chk
  CHECK (usim_process_spin IN (-1, 1))
  ENABLE
;

-- insert trigger
CREATE OR REPLACE TRIGGER usim_spc_ins_trg
  BEFORE INSERT ON usim_space
    FOR EACH ROW
    BEGIN
      -- ignore input on pk
      :NEW.usim_id_spc := usim_static.get_big_pk(usim_spc_id_seq.NEXTVAL);
    END;
/
ALTER TRIGGER usim_spc_ins_trg ENABLE;

-- update trigger
CREATE OR REPLACE TRIGGER usim_spc_upd_trg
  BEFORE UPDATE ON usim_space
    FOR EACH ROW
    BEGIN
      IF :NEW.usim_process_spin = :OLD.usim_process_spin
      THEN
        RAISE_APPLICATION_ERROR( num => -20001
                               , msg => 'Update requirement not fulfilled. Only changing update of usim_process_spin allowed.'
                               )
        ;
      END IF;
    END;
/
ALTER TRIGGER usim_spc_upd_trg ENABLE;
