-- USIM_POSITION (pos)
CREATE TABLE usim_position
  ( usim_id_pos     CHAR(55)  NOT NULL ENABLE
  , usim_coordinate NUMBER    NOT NULL ENABLE
  )
;
COMMENT ON TABLE usim_position IS 'A table holding the possible coordinates for reuse by different universes. Will use the alias pos.';
COMMENT ON COLUMN usim_position.usim_id_pos IS 'The unique id of the coordinate. Automatically set, ignored on update';
COMMENT ON COLUMN usim_position.usim_coordinate IS 'The coordinate value between -max and +max of available number space. Must be set on insert, ignored on update.';

-- pk
ALTER TABLE usim_position
  ADD CONSTRAINT usim_pos_pk
  PRIMARY KEY (usim_id_pos)
  ENABLE
;

-- uk
ALTER TABLE usim_position
  ADD CONSTRAINT usim_pos_uk
  UNIQUE (usim_coordinate)
  ENABLE
;

-- insert trigger
CREATE OR REPLACE TRIGGER usim_pos_ins_trg
  BEFORE INSERT ON usim_position
    FOR EACH ROW
    BEGIN
      -- verify insert value
      IF ABS(:NEW.usim_coordinate) > usim_base.get_abs_max_number
      THEN
        RAISE_APPLICATION_ERROR( num => -20000
                               , msg => 'Insert requirement not fulfilled. Absolute coordinate must be >= 0 and <= usim_base.get_abs_max_number.'
                               )
        ;
      END IF;
      -- ignore input on pk
      :NEW.usim_id_pos := usim_static.get_big_pk(usim_pos_id_seq.NEXTVAL);
    END;
/
ALTER TRIGGER usim_pos_ins_trg ENABLE;

-- update trigger to prevent updates
CREATE OR REPLACE TRIGGER usim_pos_upd_trg
  BEFORE UPDATE ON usim_position
    FOR EACH ROW
    BEGIN
      -- NEW is OLD, no updates
      :NEW.usim_id_pos      := :OLD.usim_id_pos;
      :NEW.usim_coordinate  := :OLD.usim_coordinate;
    END;
/
ALTER TRIGGER usim_pos_upd_trg ENABLE;
