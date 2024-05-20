COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
-- USIM_TEST_SUMMARY (tsu)
CREATE TABLE &USIM_SCHEMA..usim_test_summary
  ( usim_id_tsu         NUMBER          NOT NULL ENABLE
  , usim_test_object    VARCHAR2(128)   NOT NULL ENABLE
  , usim_tests_success  NUMBER
  , usim_tests_failed   NUMBER
  )
;
COMMENT ON TABLE &USIM_SCHEMA..usim_test_summary IS 'Table to contain test summary of tests executed. Will use the alias tsu.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_test_summary.usim_id_tsu IS 'Unique id of an executed test.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_test_summary.usim_test_object IS 'Description of the test executed.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_test_summary.usim_tests_success IS 'Amount of successful executed tests for the test object.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_test_summary.usim_tests_failed IS 'Amount of failed executed tests for the test object.';

-- pk
ALTER TABLE &USIM_SCHEMA..usim_test_summary
  ADD CONSTRAINT usim_tsu_pk
  PRIMARY KEY (usim_id_tsu)
  ENABLE
;

-- insert trigger
CREATE OR REPLACE TRIGGER &USIM_SCHEMA..usim_tsu_ins_trg
  BEFORE INSERT ON &USIM_SCHEMA..usim_test_summary
    FOR EACH ROW
    BEGIN
      -- always set this values on insert, do not care about input
      :NEW.usim_id_tsu := usim_tsu_id_seq.NEXTVAL;
    END;
/
ALTER TRIGGER &USIM_SCHEMA..usim_tsu_ins_trg ENABLE;
