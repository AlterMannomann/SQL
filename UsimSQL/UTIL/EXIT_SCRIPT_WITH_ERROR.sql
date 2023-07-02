SELECT 'Error occured, exit script. ' || NVL('&1', 'No further information available.') AS info FROM dual;
EXIT FAILURE ROLLBACK