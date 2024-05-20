COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
-- USIM_ERROR_LOG (erl)
CREATE TABLE &USIM_SCHEMA..usim_error_log
  ( usim_timestamp    TIMESTAMP       DEFAULT SYSTIMESTAMP  NOT NULL ENABLE
  , usim_tick         NUMBER                                NOT NULL ENABLE
  , usim_err_object   VARCHAR2(200)                         NOT NULL ENABLE
  , usim_err_info     VARCHAR2(4000)                        NOT NULL ENABLE
  )
;
COMMENT ON TABLE &USIM_SCHEMA..usim_error_log IS 'Used by package functions returning NULL to report the error condition. Will use the alias erl.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_error_log.usim_timestamp IS 'The timestamp of the error logging action.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_error_log.usim_err_object IS 'The object description in form of package.function.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_error_log.usim_err_info IS 'The short details on the error, e.g. used parameters.';

-- insert trigger
CREATE OR REPLACE TRIGGER &USIM_SCHEMA..usim_erl_ins_trg
  BEFORE INSERT ON &USIM_SCHEMA..usim_error_log
    FOR EACH ROW
    BEGIN
      :NEW.usim_tick := usim_erl_tick_seq.NEXTVAL;
    END;
/
ALTER TRIGGER &USIM_SCHEMA..usim_erl_ins_trg ENABLE;
