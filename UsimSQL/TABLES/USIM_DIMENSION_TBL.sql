-- USIM_DIMENSION (dim)
CREATE TABLE usim_dimension
  ( usim_id_dim       NUMBER(38, 0) NOT NULL ENABLE
  , usim_n_dimension  NUMBER(2, 0)  NOT NULL ENABLE
  )
;
COMMENT ON TABLE usim_dimension IS 'Keeps the possible dimensions. Will use the alias dim.';
COMMENT ON COLUMN usim_dimension.usim_id_dim IS 'Generic small ID to identify a dimension.';
COMMENT ON COLUMN usim_dimension.usim_n_dimension IS 'The n-sphere dimension 0-99 for space simulation.';

-- pk
ALTER TABLE usim_dimension
  ADD CONSTRAINT usim_dim_pk
  PRIMARY KEY (usim_id_dim)
  ENABLE
;

-- uk - dimension must be unique
ALTER TABLE usim_dimension
  ADD CONSTRAINT usim_dim_uk
  UNIQUE (usim_n_dimension)
  ENABLE
;

-- chk - dimension must be >= 0 and <= 99
ALTER TABLE usim_dimension
  ADD CONSTRAINT usim_dim_dimension_chk
  CHECK (usim_n_dimension BETWEEN 0 AND 99)
  ENABLE
;

-- seq
CREATE SEQUENCE usim_dim_id_seq
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
CREATE OR REPLACE TRIGGER usim_dim_id_trg
  BEFORE INSERT ON usim_dimension
    FOR EACH ROW
    BEGIN
      <<COLUMN_SEQUENCES>>
      BEGIN
        IF INSERTING AND :NEW.usim_id_dim IS NULL
        THEN
          SELECT usim_dim_id_seq.NEXTVAL INTO :NEW.usim_id_dim FROM SYS.dual;
        END IF;
      END COLUMN_SEQUENCES;
    END;
/
ALTER TRIGGER usim_dim_id_trg ENABLE;
