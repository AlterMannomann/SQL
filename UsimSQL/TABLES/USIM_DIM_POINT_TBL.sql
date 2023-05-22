-- USIM_DIM_POINT (dpo)
CREATE TABLE usim_dim_point
  ( usim_id_dpo     CHAR(55)               NOT NULL ENABLE
  , usim_id_poi     CHAR(55)               NOT NULL ENABLE
  , usim_id_dim     NUMBER(38, 0)          NOT NULL ENABLE
  )
;
COMMENT ON TABLE usim_dim_point IS 'Relates all points to a unique dimension. Will use the alias dpo.';
COMMENT ON COLUMN usim_dim_point.usim_id_dpo IS 'Generic big ID to identify a point with dimension.';
COMMENT ON COLUMN usim_dim_point.usim_id_poi IS 'Big ID to identify the point for a dimension.';
COMMENT ON COLUMN usim_dim_point.usim_id_dim IS 'ID to identify the dimension for a point.';

-- pk
ALTER TABLE usim_dim_point
  ADD CONSTRAINT usim_dpo_pk
  PRIMARY KEY (usim_id_dpo)
  ENABLE
;

-- uk - a point can only have one dimension, only one entry allowed
ALTER TABLE usim_dim_point
  ADD CONSTRAINT usim_dpo_uk
  UNIQUE (usim_id_poi)
  ENABLE
;

-- seq
CREATE SEQUENCE usim_dpo_id_seq
  MINVALUE 1
  MAXVALUE 99999999999999999999999999999999999999
  INCREMENT BY 1
  START WITH 1
  CACHE 20
  NOORDER
  CYCLE
  NOKEEP
  NOSCALE
  GLOBAL
;

-- id trigger
CREATE OR REPLACE TRIGGER usim_dpo_id_trg
  BEFORE INSERT ON usim_dim_point
    FOR EACH ROW
    BEGIN
      <<COLUMN_SEQUENCES>>
      BEGIN
        IF INSERTING AND :NEW.usim_id_dpo IS NULL
        THEN
          SELECT usim_static.get_big_pk(usim_dpo_id_seq.NEXTVAL) INTO :NEW.usim_id_dpo FROM SYS.dual;
        END IF;
      END COLUMN_SEQUENCES;
    END;
/
ALTER TRIGGER usim_dpo_id_trg ENABLE;
