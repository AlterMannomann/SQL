-- USIM_POSITION (pos)
CREATE TABLE usim_position
  ( usim_id_pos     NUMBER(38, 0)               NOT NULL ENABLE
  , usim_coordinate NUMBER(38, 0)               NOT NULL ENABLE
  )
;
COMMENT ON TABLE usim_position IS 'Keeps unique positions which may be used more than one time. Will use the alias pos.';
COMMENT ON COLUMN usim_position.usim_id_pos IS 'Generic ID to identify a position.';
COMMENT ON COLUMN usim_position.usim_coordinate IS 'The unique space position coordinate.';

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

-- seq
CREATE SEQUENCE usim_pos_id_seq
  MINVALUE 1
  INCREMENT BY 1
  START WITH 1
  CACHE 20
  NOORDER
  NOCYCLE
  NOKEEP
  NOSCALE
  GLOBAL
;

-- id trigger
CREATE OR REPLACE TRIGGER usim_pos_id_trg
  BEFORE INSERT ON usim_position
    FOR EACH ROW
    BEGIN
      <<COLUMN_SEQUENCES>>
      BEGIN
        IF INSERTING AND :NEW.usim_id_pos IS NULL
        THEN
          SELECT usim_pos_id_seq.NEXTVAL INTO :NEW.usim_id_pos FROM SYS.dual;
        END IF;
      END COLUMN_SEQUENCES;
    END;
/
ALTER TRIGGER usim_pos_id_trg ENABLE;
