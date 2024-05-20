COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
-- USIM_POSITION (pos)
CREATE TABLE &USIM_SCHEMA..usim_position
  ( usim_id_pos     CHAR(55)      NOT NULL ENABLE
  , usim_coordinate NUMBER        NOT NULL ENABLE
  )
;
COMMENT ON TABLE &USIM_SCHEMA..usim_position IS 'A table holding the possible coordinates for reuse by different universes. Will use the alias pos.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_position.usim_id_pos IS 'The unique id of the coordinate. Automatically set, update not allowed.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_position.usim_coordinate IS 'The coordinate value between -max and +max of available number space. Must be set on insert, update not allowed.';

-- pk
ALTER TABLE &USIM_SCHEMA..usim_position
  ADD CONSTRAINT usim_pos_pk
  PRIMARY KEY (usim_id_pos)
  ENABLE
;

-- uk
ALTER TABLE &USIM_SCHEMA..usim_position
  ADD CONSTRAINT usim_pos_uk
  UNIQUE (usim_coordinate)
  ENABLE
;

-- insert trigger
CREATE OR REPLACE TRIGGER &USIM_SCHEMA..usim_pos_ins_trg
  BEFORE INSERT ON &USIM_SCHEMA..usim_position
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
ALTER TRIGGER &USIM_SCHEMA..usim_pos_ins_trg ENABLE;

-- update trigger to prevent updates
CREATE OR REPLACE TRIGGER &USIM_SCHEMA..usim_pos_upd_trg
  BEFORE UPDATE ON &USIM_SCHEMA..usim_position
    FOR EACH ROW
    BEGIN
      RAISE_APPLICATION_ERROR( num => -20001
                             , msg => 'Update requirement not fulfilled. No update allowed.'
                             )
      ;
    END;
/
ALTER TRIGGER &USIM_SCHEMA..usim_pos_upd_trg ENABLE;
