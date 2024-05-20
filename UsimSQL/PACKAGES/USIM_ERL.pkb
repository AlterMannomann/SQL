-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
CREATE OR REPLACE PACKAGE BODY &USIM_SCHEMA..usim_erl
IS
  -- see header for documentation
  PROCEDURE log_error( p_usim_err_object  IN VARCHAR2
                     , p_usim_err_info    IN VARCHAR2
                     )
  IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    INSERT INTO usim_error_log
      ( usim_timestamp
      , usim_err_object
      , usim_err_info
      )
      VALUES
      ( SYSTIMESTAMP
      , NVL(SUBSTR(p_usim_err_object, 1, 200), 'ERROR MISSING object definition')
      , NVL(SUBSTR(p_usim_err_info, 1, 4000), 'ERROR MISSING error description')
      )
    ;
    COMMIT;
  END log_error
  ;

  PROCEDURE purge_log
  IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    DELETE usim_error_log;
    COMMIT;
  END purge_log
  ;

END usim_erl;
/