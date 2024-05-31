-- create credentials for scheduler jobs running server scripts
BEGIN
  DBMS_CREDENTIAL.CREATE_CREDENTIAL( username => '&USER_OS'
                                   , password => '&PASS_OS'
                                   , comments => 'OS_ACCESS for server script execution'
                                   , credential_name => 'USIM_OS_ACCESS'
                                   )
  ;
  DBMS_CREDENTIAL.CREATE_CREDENTIAL( username => 'USIM'
                                   , password => '&PASS_USIM'
                                   , comments => 'DB_ACCESS USIM for server script execution'
                                   , credential_name => 'USIM_DB_ACCESS'
                                   )
  ;
  DBMS_CREDENTIAL.CREATE_CREDENTIAL( username => 'USIM_TEST'
                                   , password => '&PASS_USIM_TEST'
                                   , comments => 'DB_ACCESS USIM_TEST for server script execution'
                                   , credential_name => 'USIM_DB_ACCESS_TEST'
                                   )
  ;
END;
/
