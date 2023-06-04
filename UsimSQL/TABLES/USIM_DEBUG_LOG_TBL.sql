-- USIM_DEBUG_LOG (dlg)
CREATE TABLE usim_debug_log
  ( usim_id_dlg         NUMBER(38, 0)
  , usim_timestamp      TIMESTAMP
  , usim_status         NUMBER(1, 0)
  , usim_log_object     VARCHAR2(1000)
  , usim_log_content    CLOB
  )
;
COMMENT ON COLUMN usim_debug_log.usim_status IS 'Status of debug action -1 = ERROR, 0 = WARNING, 1 = SUCCESS';
-- idx
CREATE INDEX usim_dlg_idx
    ON usim_debug_log
       (usim_id_dlg)
;
-- seq
CREATE SEQUENCE usim_dlg_id_seq
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