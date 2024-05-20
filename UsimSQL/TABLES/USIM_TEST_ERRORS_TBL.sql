COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
-- USIM_TEST_ERRORS (ter)
CREATE TABLE &USIM_SCHEMA..usim_test_errors
  ( usim_id_tsu       NUMBER                                NOT NULL ENABLE
  , usim_timestamp    TIMESTAMP       DEFAULT SYSTIMESTAMP  NOT NULL ENABLE
  , usim_error_msg    VARCHAR2(4000)                        NOT NULL ENABLE
  )
;
COMMENT ON TABLE &USIM_SCHEMA..usim_test_errors IS 'Contains errors that occured in executed tests. Will use the alias ter.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_test_errors.usim_id_tsu IS 'The related id in usim_test_summary. No FK used, only controlled by application.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_test_errors.usim_timestamp IS 'The time stamp of the error in a test.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_test_errors.usim_error_msg IS 'The error message of the test.';
