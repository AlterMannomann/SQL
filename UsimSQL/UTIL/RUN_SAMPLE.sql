@@SET_DEFAULT_TEST_SPOOL.sql

DECLARE
  l_result NUMBER;
BEGIN
  l_result := usim_process.run_samples(1);
  IF l_result = 1
  THEN
    usim_debug.debug_log('basic_test_data_setup', 'Sample run: ' || usim_dbif.get_planck_time_current);
  ELSE
    usim_debug.debug_log('basic_test_data_setup', 'Error running sample.');
  END IF;
END;
/
-- list error and debug messages
SELECT usim_timestamp, SUBSTR(usim_err_object, 1, 50) AS usim_err_object, usim_err_info FROM usim_error_log ORDER BY usim_timestamp, usim_tick;
SELECT usim_timestamp, SUBSTR(usim_log_object, 1, 50) AS usim_log_object, usim_log_content FROM usim_debug_log ORDER BY usim_timestamp, ROWID;