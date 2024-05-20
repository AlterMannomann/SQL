COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
-- USIM_NODE (nod)
CREATE TABLE &USIM_SCHEMA..usim_node
  ( usim_id_nod     CHAR(55)  NOT NULL ENABLE
  , usim_energy     NUMBER
  )
;
COMMENT ON TABLE &USIM_SCHEMA..usim_node IS 'Contains all nodes of all universes that form volumes holding a potential energy. Will use the alias nod.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_node.usim_id_nod IS 'The unique id for this node. Automatically set, update ignored.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_node.usim_id_nod IS 'The potential energy of the node. Set to NULL on insert. Only updates allowed.';

-- pk
ALTER TABLE &USIM_SCHEMA..usim_node
  ADD CONSTRAINT usim_nod_pk
  PRIMARY KEY (usim_id_nod)
  ENABLE
;

-- insert trigger
CREATE OR REPLACE TRIGGER &USIM_SCHEMA..usim_node_ins_trg
  BEFORE INSERT ON &USIM_SCHEMA..usim_node
    FOR EACH ROW
    BEGIN
      -- ignore input on pk and energy
      :NEW.usim_id_nod := usim_static.get_big_pk(usim_nod_id_seq.NEXTVAL);
      :NEW.usim_energy := NULL;
    END;
/
ALTER TRIGGER &USIM_SCHEMA..usim_node_ins_trg ENABLE;

-- update trigger
CREATE OR REPLACE TRIGGER &USIM_SCHEMA..usim_node_upd_trg
  BEFORE UPDATE ON &USIM_SCHEMA..usim_node
    FOR EACH ROW
    BEGIN
      -- ignore update on pk
      :NEW.usim_id_nod := :OLD.usim_id_nod;
    END;
/
ALTER TRIGGER &USIM_SCHEMA..usim_node_upd_trg ENABLE;
