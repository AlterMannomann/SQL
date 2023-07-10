-- USIM_VOLUME (vol)
CREATE TABLE usim_volume
  ( usim_id_vol             CHAR(55)  NOT NULL ENABLE
  , usim_id_mlv             CHAR(55)  NOT NULL ENABLE
  , usim_id_pos_base_from   CHAR(55)  NOT NULL ENABLE
  , usim_id_pos_base_to     CHAR(55)  NOT NULL ENABLE
  , usim_id_pos_mirror_from CHAR(55)  NOT NULL ENABLE
  , usim_id_pos_mirror_to   CHAR(55)  NOT NULL ENABLE
  )
;
COMMENT ON TABLE usim_volume IS 'This table contains the basic definiion of a volume in either dimension where distance between from-to nodes is equal to 1 within one dimension. From-to describes only the basic direction, not a parent-child relation. Will use the alias vol.';
COMMENT ON COLUMN usim_volume.usim_id_vol IS 'The unique id of the volume definition. Automatically set, update ignored.';
COMMENT ON COLUMN usim_volume.usim_id_mlv IS 'The id of the related universe. Must be set on insert, ignored on update.';
COMMENT ON COLUMN usim_volume.usim_id_pos_base_from IS 'The id of the first base coordinate (in absolute always the lower one). Must be set on insert, ignored on update.';
COMMENT ON COLUMN usim_volume.usim_id_pos_base_to IS 'The id of the second base coordinate (in absolute always the higher one with number space distance 1). Must be set on insert, ignored on update.';
COMMENT ON COLUMN usim_volume.usim_id_pos_mirror_from IS 'The id of the first mirror coordinate (in absolute always the lower one, opposite sign of base). Must be set on insert, ignored on update.';
COMMENT ON COLUMN usim_volume.usim_id_pos_mirror_to IS 'The id of the second mirror coordinate (in absolute always the higher one with number space distance 1). Must be set on insert, ignored on update.';

-- pk
ALTER TABLE usim_volume
  ADD CONSTRAINT usim_vol_pk
  PRIMARY KEY (usim_id_vol)
  ENABLE
;

-- uk all attributes are unique and fk
ALTER TABLE usim_volume
  ADD CONSTRAINT usim_vol_uk
  UNIQUE (usim_id_mlv, usim_id_pos_base_from, usim_id_pos_base_to, usim_id_pos_mirror_from, usim_id_pos_mirror_to)
  ENABLE
;

CREATE OR REPLACE TRIGGER usim_vol_ins_trg
  BEFORE INSERT ON usim_volume
    FOR EACH ROW
    BEGIN
      -- ignore input on pk
      :NEW.usim_id_vol := usim_static.get_big_pk(usim_vol_id_seq.NEXTVAL);
      -- check consistency of given values
      IF    usim_pos.get_coord_sign(:NEW.usim_id_pos_base_from)   != usim_pos.get_coord_sign(:NEW.usim_id_pos_base_to)
         OR usim_pos.get_coord_sign(:NEW.usim_id_pos_mirror_from) != usim_pos.get_coord_sign(:NEW.usim_id_pos_mirror_to)
      THEN
        RAISE_APPLICATION_ERROR( num => -20000
                               , msg => 'Insert requirement not fulfilled. Sign of base/mirror from and to must be equal.'
                               )
        ;
      END IF;
      IF    ABS(usim_pos.get_coordinate(:NEW.usim_id_pos_base_to)) - ABS(usim_pos.get_coordinate(:NEW.usim_id_pos_base_from))     != 1
         OR ABS(usim_pos.get_coordinate(:NEW.usim_id_pos_mirror_to)) - ABS(usim_pos.get_coordinate(:NEW.usim_id_pos_mirror_from)) != 1
      THEN
        RAISE_APPLICATION_ERROR( num => -20000
                               , msg => 'Insert requirement not fulfilled. Distance of from to coordinates must be 1.'
                               )
        ;
      END IF;
      IF    ABS(usim_pos.get_coordinate(:NEW.usim_id_pos_base_to))   != ABS(usim_pos.get_coordinate(:NEW.usim_id_pos_mirror_to))
         OR ABS(usim_pos.get_coordinate(:NEW.usim_id_pos_base_from)) != ABS(usim_pos.get_coordinate(:NEW.usim_id_pos_mirror_from))
      THEN
        RAISE_APPLICATION_ERROR( num => -20000
                               , msg => 'Insert requirement not fulfilled. Mirror coordinates must be equal apart from sign.'
                               )
        ;
      END IF;
      IF    usim_pos.get_coord_sign(:NEW.usim_id_pos_base_from)   != usim_mlv.get_base_sign(:NEW.usim_id_mlv)
         OR usim_pos.get_coord_sign(:NEW.usim_id_pos_mirror_from) != usim_mlv.get_mirror_sign(:NEW.usim_id_mlv)
      THEN
        RAISE_APPLICATION_ERROR( num => -20000
                               , msg => 'Insert requirement not fulfilled. Sign of base/mirror must match universe settings.'
                               )
        ;
      END IF;
    END;
/
ALTER TRIGGER usim_vol_ins_trg ENABLE;

-- update trigger
CREATE OR REPLACE TRIGGER usim_vol_upd_trg
  BEFORE UPDATE ON usim_volume
    FOR EACH ROW
    BEGIN
      -- ignore updates
      :NEW.usim_id_vol             := :OLD.usim_id_vol;
      :NEW.usim_id_mlv             := :OLD.usim_id_mlv;
      :NEW.usim_id_pos_base_from   := :OLD.usim_id_pos_base_from;
      :NEW.usim_id_pos_base_to     := :OLD.usim_id_pos_base_to;
      :NEW.usim_id_pos_mirror_from := :OLD.usim_id_pos_mirror_from;
      :NEW.usim_id_pos_mirror_to   := :OLD.usim_id_pos_mirror_to;
    END;
/
ALTER TRIGGER usim_vol_upd_trg ENABLE;
