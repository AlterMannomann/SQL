-- USIM_DEBUG_LOG (dlg)
CREATE TABLE usim_debug_log
  ( usim_id_dlg         NUMBER(38, 0)
  , usim_timestamp      TIMESTAMP
  , usim_status         NUMBER(1, 0)
  , usim_log_object     VARCHAR2(1000)
  , usim_log_content    CLOB
  )
;
COMMENT ON TABLE usim_debug_log IS 'A table for logging temporary debug results. Will use the alias dlg.';
COMMENT ON COLUMN usim_debug_log.usim_id_dlg IS 'The id for debug log action.';
COMMENT ON COLUMN usim_debug_log.usim_timestamp IS 'The timestamp for a debug log action.';
COMMENT ON COLUMN usim_debug_log.usim_status IS 'Status of debug action -1 = ERROR, 0 = WARNING, 1 = SUCCESS.';
COMMENT ON COLUMN usim_debug_log.usim_log_object IS 'The object of a debug log action.';
COMMENT ON COLUMN usim_debug_log.usim_log_content IS 'The debug information content of a debug log action.';

-- idx
CREATE INDEX usim_dlg_idx
    ON usim_debug_log
       (usim_id_dlg)
;
