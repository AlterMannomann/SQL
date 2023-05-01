-- USIM_PDP_CHILDS (pdc)
CREATE TABLE usim_pdp_childs
  ( usim_id_pdc         NUMBER(38, 0)               NOT NULL ENABLE
  , usim_id_pdp         NUMBER(38, 0)               NOT NULL ENABLE
  , usim_id_child       NUMBER(38, 0)               NOT NULL ENABLE
  )
;
COMMENT ON TABLE usim_pdp_childs IS 'Relates point/dimension/position to childs. Amount of possible childs has to be controlled by the application. Will use the alias pdc.';
COMMENT ON COLUMN usim_pdp_childs.usim_id_pdc IS 'Generic ID to identify a child relation for a point with position in a dimension.';
COMMENT ON COLUMN usim_pdp_childs.usim_id_pdp IS 'ID in USIM_POI_DIM_POSITION to identify a point with position in a dimension.';
COMMENT ON COLUMN usim_pdp_childs.usim_id_child IS 'Child ID in USIM_POI_DIM_POSITION to identify a point with position in a dimension.';

-- pk
ALTER TABLE usim_pdp_childs
  ADD CONSTRAINT usim_pdc_pk
  PRIMARY KEY (usim_id_pdc)
  ENABLE
;

-- uk - pdp child relation is unique, no twins allowed
ALTER TABLE usim_pdp_childs
  ADD CONSTRAINT usim_pdc_uk
  UNIQUE (usim_id_pdp, usim_id_child)
  ENABLE
;

-- seq
CREATE SEQUENCE usim_pdc_id_seq
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
CREATE OR REPLACE TRIGGER usim_pdc_id_trg
  BEFORE INSERT ON usim_pdp_childs
    FOR EACH ROW
    BEGIN
      <<COLUMN_SEQUENCES>>
      BEGIN
        IF INSERTING AND :NEW.usim_id_pdc IS NULL
        THEN
          SELECT usim_pdc_id_seq.NEXTVAL INTO :NEW.usim_id_pdc FROM SYS.dual;
        END IF;
      END COLUMN_SEQUENCES;
    END;
/
ALTER TRIGGER usim_pdc_id_trg ENABLE;

