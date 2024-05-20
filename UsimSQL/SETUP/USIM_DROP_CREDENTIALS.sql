DECLARE
  l_result INTEGER;
BEGIN
  SELECT COUNT(*)
    INTO l_result
    FROM dba_credentials
   WHERE owner = USER
     AND credential_name = 'OS_ACCESS'
  ;
  IF l_result = 1
  THEN
    DBMS_CREDENTIAL.DROP_CREDENTIAL('OS_ACCESS', TRUE);
  END IF;
  SELECT COUNT(*)
    INTO l_result
    FROM dba_credentials
   WHERE owner = USER
     AND credential_name = 'DB_ACCESS'
  ;
  IF l_result = 1
  THEN
    DBMS_CREDENTIAL.DROP_CREDENTIAL('DB_ACCESS', TRUE);
  END IF;
  SELECT COUNT(*)
    INTO l_result
    FROM dba_credentials
   WHERE owner = USER
     AND credential_name = 'DB_ACCESS_TEST'
  ;
  IF l_result = 1
  THEN
    DBMS_CREDENTIAL.DROP_CREDENTIAL('DB_ACCESS_TEST', TRUE);
  END IF;
END;
/