-- USIM_REL_MLV_DIM (rmd)
CREATE TABLE usim_rel_mlv_dim
  ( usim_id_rmd  CHAR(55)      NOT NULL ENABLE
  , usim_id_mlv  CHAR(55)      NOT NULL ENABLE
  , usim_id_dim  CHAR(55)      NOT NULL ENABLE
  , usim_sign    NUMBER(1, 0)  NOT NULL ENABLE
  , usim_n1_sign NUMBER(1, 0)
  )
;
COMMENT ON TABLE usim_rel_mlv_dim IS 'A table describing the relation between dimension and a specific universe. Will use the alias rmd.';
COMMENT ON COLUMN usim_rel_mlv_dim.usim_id_rmd IS 'The unique id of the relation between universe and dimension. Automatically set, ignored on update';
COMMENT ON COLUMN usim_rel_mlv_dim.usim_id_mlv IS 'The universe id to relate to a dimension. Must be set on insert, ignored on update.';
COMMENT ON COLUMN usim_rel_mlv_dim.usim_id_dim IS 'The dimension id to relate to a universe. Must be set on insert, ignored on update.';
COMMENT ON COLUMN usim_rel_mlv_dim.usim_sign IS 'The sign of the dimension axis to relate to a universe. Only 0, 1 and -1 allowed. Must be set on insert, ignored on update.';
COMMENT ON COLUMN usim_rel_mlv_dim.usim_n1_sign IS 'The sign of the ancestor dimension axis at n = 1. NULL, 1 and -1 allowed. Must be set on insert, ignored on update.';

-- pk
ALTER TABLE usim_rel_mlv_dim
  ADD CONSTRAINT usim_rmd_pk
  PRIMARY KEY (usim_id_rmd)
  ENABLE
;

-- uk universe/dim/sign/n1 sign is unique
ALTER TABLE usim_rel_mlv_dim
  ADD CONSTRAINT usim_rmd_uk
  UNIQUE (usim_id_mlv, usim_id_dim, usim_sign, usim_n1_sign)
  ENABLE
;

-- uk universe/dim/sign is unique
ALTER TABLE usim_rel_mlv_dim
  ADD CONSTRAINT usim_rmd_chk_sign
  CHECK (usim_sign IN (0, 1, -1))
  ENABLE
;

-- insert trigger
CREATE OR REPLACE TRIGGER usim_rmd_ins_trg
  BEFORE INSERT ON usim_rel_mlv_dim
    FOR EACH ROW
    BEGIN
      -- ignore input on pk
      :NEW.usim_id_rmd := usim_static.get_big_pk(usim_rmd_id_seq.NEXTVAL);
      -- check sign
      IF usim_dim.get_dimension(:NEW.usim_id_dim) = 0
      THEN
        IF :NEW.usim_sign != 0
        THEN
          RAISE_APPLICATION_ERROR( num => -20000
                                , msg => 'Insert requirement not fulfilled. USIM_SIGN must be 0 for dimension 0.'
                                )
          ;
        END IF;
      ELSE
        IF     usim_dim.get_dimension(:NEW.usim_id_dim) > 1
           AND :NEW.usim_n1_sign NOT IN (1, -1)
        THEN
          RAISE_APPLICATION_ERROR( num => -20000
                                , msg => 'Insert requirement not fulfilled. USIM_N1_SIGN must be 1 or -1 for dimension > 1.'
                                )
          ;
        END IF;
        IF :NEW.usim_sign NOT IN (1, -1)
        THEN
          RAISE_APPLICATION_ERROR( num => -20000
                                , msg => 'Insert requirement not fulfilled. USIM_SIGN must be +1 or -1 for dimension > 0.'
                                )
          ;
        END IF;
      END IF;
    END;
/
ALTER TRIGGER usim_rmd_ins_trg ENABLE;

-- update trigger to prevent updates
CREATE OR REPLACE TRIGGER usim_rmd_upd_trg
  BEFORE UPDATE ON usim_rel_mlv_dim
    FOR EACH ROW
    BEGIN
      RAISE_APPLICATION_ERROR( num => -20001
                             , msg => 'Update requirement not fulfilled. No update allowed.'
                             )
      ;
    END;
/
ALTER TRIGGER usim_rmd_upd_trg ENABLE;
