-- USIM_REL_VOL_MLV (rvm)
CREATE TABLE usim_rel_vol_mlv
  ( usim_id_vol  CHAR(55) NOT NULL ENABLE
  , usim_id_mlv  CHAR(55) NOT NULL ENABLE
  )
;
COMMENT ON TABLE usim_rel_vol_mlv IS 'Describes the parent-child relation between a volume (parent) and a universe (child). Will use the alias rvm.';
COMMENT ON COLUMN usim_rel_vol_mlv.usim_id_vol IS 'The parent volume id. A volume can have only one parent-child relation.';
COMMENT ON COLUMN usim_rel_vol_mlv.usim_id_mlv IS 'The child universe id. A universe can only be child of a volume, if the universe is not the base universe.';

-- pk
ALTER TABLE usim_rel_vol_mlv
  ADD CONSTRAINT usim_rvm_pk
  PRIMARY KEY (usim_id_vol)
  ENABLE
;

-- uk
ALTER TABLE usim_rel_vol_mlv
  ADD CONSTRAINT usim_rvm_uk
  UNIQUE (usim_id_mlv)
  ENABLE
;

-- insert trigger
CREATE OR REPLACE TRIGGER usim_rmv_ins_trg
  BEFORE INSERT ON usim_rel_vol_mlv
    FOR EACH ROW
    BEGIN
      IF usim_mlv.is_base(:NEW.usim_id_mlv) != 0
      THEN
        RAISE_APPLICATION_ERROR( num => -20000
                               , msg => 'Insert requirement not fulfilled. Base universe not allowed.'
                               )
        ;
      END IF;
    END;
/
ALTER TRIGGER usim_rmv_ins_trg ENABLE;

-- update trigger
CREATE OR REPLACE TRIGGER usim_rmv_upd_trg
  BEFORE UPDATE ON usim_rel_vol_mlv
    FOR EACH ROW
    BEGIN
      RAISE_APPLICATION_ERROR( num => -20001
                             , msg => 'Update requirement not fulfilled. No update allowed.'
                             )
      ;
    END;
/
ALTER TRIGGER usim_rmv_upd_trg ENABLE;
