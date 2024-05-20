COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
-- USIM_DEBUG_LOG (dlg)
CREATE TABLE &USIM_SCHEMA..usim_debug_log
  ( usim_id_dlg         NUMBER(38, 0)
  , usim_timestamp      TIMESTAMP
  , usim_status         NUMBER(1, 0)
  , usim_log_object     VARCHAR2(1000)
  , usim_log_content    CLOB
  )
;
COMMENT ON TABLE &USIM_SCHEMA..usim_debug_log IS 'A table for logging temporary debug results. Will use the alias dlg.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_debug_log.usim_id_dlg IS 'The id for debug log action.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_debug_log.usim_timestamp IS 'The timestamp for a debug log action.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_debug_log.usim_status IS 'Status of debug action -1 = ERROR, 0 = WARNING, 1 = SUCCESS, 2 = INFO.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_debug_log.usim_log_object IS 'The object of a debug log action.';
COMMENT ON COLUMN &USIM_SCHEMA..usim_debug_log.usim_log_content IS 'The debug information content of a debug log action.';

-- idx
CREATE INDEX &USIM_SCHEMA..usim_dlg_idx
    ON &USIM_SCHEMA..usim_debug_log
       (usim_id_dlg)
;
