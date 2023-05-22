-- USIM_PLANCK_TIME (plt)
CREATE TABLE usim_planck_time
  ( usim_id_plt                CHAR(20) DEFAULT 'USIM_PLANCK_TIME_SEQ'  NOT NULL ENABLE
  , usim_last_planck_time      CHAR(55) DEFAULT 'N/A'                   NOT NULL ENABLE
  , usim_current_planck_time   CHAR(55) DEFAULT 'N/A'                   NOT NULL ENABLE
  )
;
COMMENT ON TABLE usim_planck_time IS 'A table to manage big ids for planck time. Usually contains only one record, but more sequences could be provided. Insert and update is very restricted.';
COMMENT ON COLUMN usim_planck_time.usim_id_plt IS 'The identifier for the sequence responsible to trigger the planck time.';
COMMENT ON COLUMN usim_planck_time.usim_last_planck_time IS 'The last used big planck time id or N/A.';
COMMENT ON COLUMN usim_planck_time.usim_current_planck_time IS 'The current requested and used big planck time id or N/A.';

-- pk
ALTER TABLE usim_planck_time
  ADD CONSTRAINT usim_plt_pk
  PRIMARY KEY (usim_id_plt)
  ENABLE
;

-- seq
CREATE SEQUENCE usim_planck_time_seq
  MINVALUE 1
  MAXVALUE 99999999999999999999999999999999999999
  INCREMENT BY 1
  START WITH 1
  NOCACHE
  ORDER
  CYCLE
  NOKEEP
  NOSCALE
  GLOBAL
;

-- id trigger
CREATE OR REPLACE TRIGGER usim_plt_id_trg
  BEFORE INSERT ON usim_planck_time
    FOR EACH ROW
    BEGIN
      <<COLUMN_SEQUENCES>>
      BEGIN
        IF INSERTING AND :NEW.usim_id_plt IS NULL
        THEN
          :NEW.usim_id_plt := usim_static.usim_planck_timer;
        END IF;
        -- we ignore any input values
        :NEW.usim_last_planck_time := usim_static.usim_not_available;
        :NEW.usim_current_planck_time := usim_static.usim_not_available;
      END COLUMN_SEQUENCES;
    END;
/
ALTER TRIGGER usim_plt_id_trg ENABLE;

-- update trigger
CREATE OR REPLACE TRIGGER usim_plt_upd_trg
  BEFORE UPDATE ON usim_planck_time
    FOR EACH ROW
    BEGIN
      -- don't allow update special pk
      IF     :NEW.usim_id_plt IS NOT NULL
         AND :NEW.usim_id_plt != :OLD.usim_id_plt
         AND :OLD.usim_id_plt = usim_static.usim_planck_timer
      THEN
        :NEW.usim_id_plt := :OLD.usim_id_plt;
      END IF;
      -- switch values, we ignore any update input
      :NEW.usim_last_planck_time := :OLD.usim_current_planck_time;
      :NEW.usim_current_planck_time := usim_static.get_big_pk(usim_planck_time_seq.NEXTVAL);
    END;
/
ALTER TRIGGER usim_plt_upd_trg ENABLE;
