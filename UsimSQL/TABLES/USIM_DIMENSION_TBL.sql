CREATE TABLE usim_dimension
  ( usim_id_dim       CHAR(55)      NOT NULL ENABLE
  , usim_n_dimension  NUMBER(38, 0) NOT NULL ENABLE
  )
;
COMMENT ON TABLE usim_dimension IS 'Contains the dimensions available for the multiverse. Will use the alias dim.';
COMMENT ON COLUMN usim_dimension.usim_id_dim IS 'The unique id for the associated dimension. Update ignored.';
COMMENT ON COLUMN usim_dimension.usim_n_dimension IS 'The n-sphere supported dimension for space simulation. Must be >= 0 and <= usim_basedata.usim_max_dimension. Must be set on insert. Update ignored.';

-- pk
ALTER TABLE usim_dimension
  ADD CONSTRAINT usim_dim_pk
  PRIMARY KEY (usim_id_dim)
  ENABLE
;

-- uk
ALTER TABLE usim_dimension
  ADD CONSTRAINT usim_dim_uk
  UNIQUE (usim_n_dimension)
  ENABLE
;

-- chk
ALTER TABLE usim_dimension
  ADD CONSTRAINT usim_dim_dimension_chk
  CHECK (usim_n_dimension >= 0)
  ENABLE
;

-- insert trigger
CREATE OR REPLACE TRIGGER usim_dim_ins_trg
  BEFORE INSERT ON usim_dimension
    FOR EACH ROW
    BEGIN
      -- verify insert value
      IF :NEW.usim_n_dimension > usim_base.get_max_dimension
      THEN
        RAISE_APPLICATION_ERROR( num => -20000
                               , msg => 'Insert requirement not fulfilled. Dimension must be > 0 and <= usim_base.get_max_dimension.'
                               )
        ;
      END IF;
      -- ignore input on pk
      :NEW.usim_id_dim := usim_static.get_big_pk(usim_dim_id_seq.NEXTVAL);
    END;
/
ALTER TRIGGER usim_dim_ins_trg ENABLE;

-- update trigger to prevent updates
CREATE OR REPLACE TRIGGER usim_dim_upd_trg
  BEFORE UPDATE ON usim_dimension
    FOR EACH ROW
    BEGIN
      -- NEW is OLD, no updates
      :NEW.usim_id_dim      := :OLD.usim_id_dim;
      :NEW.usim_n_dimension := :OLD.usim_n_dimension;
    END;
/
ALTER TRIGGER usim_dim_upd_trg ENABLE;
