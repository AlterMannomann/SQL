COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
CREATE TABLE &USIM_SCHEMA..usim_dimension
  ( usim_id_dim       CHAR(55)     NOT NULL ENABLE
  , usim_n_dimension  NUMBER(2, 0) NOT NULL ENABLE
  )
;
COMMENT ON TABLE &USIM_SCHEMA..usim_dimension IS 'Contains the dimensions available for the multiverse. Will use the alias dim.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_dimension.usim_id_dim IS 'The unique id for the associated dimension. Update not allowed.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_dimension.usim_n_dimension IS 'The n-sphere supported dimension for space simulation. Must be >= 0 and <= usim_basedata.usim_max_dimension. Must be set on insert. Update not allowed.';

-- pk
ALTER TABLE &USIM_SCHEMA..usim_dimension
  ADD CONSTRAINT usim_dim_pk
  PRIMARY KEY (usim_id_dim)
  ENABLE
;

-- uk
ALTER TABLE &USIM_SCHEMA..usim_dimension
  ADD CONSTRAINT usim_dim_uk
  UNIQUE (usim_n_dimension)
  ENABLE
;

-- chk
ALTER TABLE &USIM_SCHEMA..usim_dimension
  ADD CONSTRAINT usim_dim_dimension_chk
  CHECK (usim_n_dimension >= 0)
  ENABLE
;

-- insert trigger
CREATE OR REPLACE TRIGGER &USIM_SCHEMA..usim_dim_ins_trg
  BEFORE INSERT ON &USIM_SCHEMA..usim_dimension
    FOR EACH ROW
    BEGIN
      -- verify insert value
      IF :NEW.usim_n_dimension > usim_base.get_max_dimension
      THEN
        RAISE_APPLICATION_ERROR( num => -20000
                               , msg => 'Insert requirement not fulfilled. Dimension must be >= 0 and <= usim_base.get_max_dimension.'
                               )
        ;
      END IF;
      -- ignore input on pk
      :NEW.usim_id_dim := usim_static.get_big_pk(usim_dim_id_seq.NEXTVAL);
    END;
/
ALTER TRIGGER &USIM_SCHEMA..usim_dim_ins_trg ENABLE;

-- update trigger to prevent updates
CREATE OR REPLACE TRIGGER &USIM_SCHEMA..usim_dim_upd_trg
  BEFORE UPDATE ON &USIM_SCHEMA..usim_dimension
    FOR EACH ROW
    BEGIN
      RAISE_APPLICATION_ERROR( num => -20001
                             , msg => 'Update requirement not fulfilled. No update allowed.'
                             )
      ;
    END;
/
ALTER TRIGGER &USIM_SCHEMA..usim_dim_upd_trg ENABLE;
