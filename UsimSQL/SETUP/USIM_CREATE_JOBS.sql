-- prebuild programs and jobs to create or recreate the schema DDL
BEGIN
  DBMS_SCHEDULER.CREATE_PROGRAM( program_name => 'RUN_SQL'
                               , program_type => 'EXTERNAL_SCRIPT'
                               , program_action => '&USIM_SHELL./run_sql.sh'
                               , number_of_arguments => 3
                               , enabled => FALSE
                               , comments => 'Provide program with parameters to run sql script on server in the correct directory'
                               )
  ;
  DBMS_SCHEDULER.DEFINE_PROGRAM_ARGUMENT( program_name => 'RUN_SQL'
                                        , argument_position => 1
                                        , argument_name => 'SCRIPT_PATH'
                                        , argument_type => 'VARCHAR2'
                                        , default_value => '&USIM_SETUP'
                                        )
  ;
  DBMS_SCHEDULER.DEFINE_PROGRAM_ARGUMENT( program_name => 'RUN_SQL'
                                        , argument_position => 2
                                        , argument_name => 'SCRIPT_NAME'
                                        , argument_type => 'VARCHAR2'
                                        , default_value => 'USIM_SETUP.sql'
                                        )
  ;
  DBMS_SCHEDULER.DEFINE_PROGRAM_ARGUMENT( program_name => 'RUN_SQL'
                                        , argument_position => 3
                                        , argument_name => 'DB_USER'
                                        , argument_type => 'VARCHAR2'
                                        , default_value => 'USIM'
                                        )
  ;
  DBMS_SCHEDULER.ENABLE( name => 'RUN_SQL');


  DBMS_SCHEDULER.CREATE_PROGRAM( program_name => 'RUN_SQL_TEST'
                               , program_type => 'EXTERNAL_SCRIPT'
                               , program_action => '&USIM_SHELL./run_sql.sh'
                               , number_of_arguments => 3
                               , enabled => FALSE
                               , comments => 'Provide program with parameters to run sql script on server in the correct directory'
                               )
  ;
  DBMS_SCHEDULER.DEFINE_PROGRAM_ARGUMENT( program_name => 'RUN_SQL_TEST'
                                        , argument_position => 1
                                        , argument_name => 'SCRIPT_PATH'
                                        , argument_type => 'VARCHAR2'
                                        , default_value => '&USIM_SETUP'
                                        )
  ;
  DBMS_SCHEDULER.DEFINE_PROGRAM_ARGUMENT( program_name => 'RUN_SQL_TEST'
                                        , argument_position => 2
                                        , argument_name => 'SCRIPT_NAME'
                                        , argument_type => 'VARCHAR2'
                                        , default_value => 'USIM_TEST_SETUP.sql'
                                        )
  ;
  DBMS_SCHEDULER.DEFINE_PROGRAM_ARGUMENT( program_name => 'RUN_SQL_TEST'
                                        , argument_position => 3
                                        , argument_name => 'DB_USER'
                                        , argument_type => 'VARCHAR2'
                                        , default_value => 'USIM_TEST'
                                        )
  ;
  DBMS_SCHEDULER.ENABLE( name => 'RUN_SQL_TEST');
  DBMS_SCHEDULER.CREATE_JOB( job_name => 'RUN_SERVER_SQL'
                           , program_name => 'RUN_SQL'
                           , start_date => NULL
                           , repeat_interval => NULL
                           , end_date => NULL
                           , enabled => FALSE
                           , auto_drop => FALSE
                           , comments => 'Runs sql scripts on the server'
                           , credential_name => 'OS_ACCESS'
                           , job_style => 'REGULAR'
                           );

  DBMS_SCHEDULER.SET_ATTRIBUTE( name => 'RUN_SERVER_SQL'
                              , attribute => 'store_output'
                              , value => TRUE
                              )
  ;
  DBMS_SCHEDULER.SET_ATTRIBUTE( name => 'RUN_SERVER_SQL'
                              , attribute => 'logging_level'
                              , value => DBMS_SCHEDULER.LOGGING_FULL
                              )
  ;
  DBMS_SCHEDULER.SET_ATTRIBUTE( name => 'RUN_SERVER_SQL'
                              , attribute => 'connect_credential_name'
                              , value => 'DB_ACCESS'
                              )
  ;
  DBMS_SCHEDULER.CREATE_JOB( job_name => 'RUN_SERVER_SQL_TEST'
                           , program_name => 'RUN_SQL_TEST'
                           , start_date => NULL
                           , repeat_interval => NULL
                           , end_date => NULL
                           , enabled => FALSE
                           , auto_drop => FALSE
                           , comments => 'Runs sql scripts on the server'
                           , credential_name => 'OS_ACCESS'
                           , job_style => 'REGULAR'
                           );

  DBMS_SCHEDULER.SET_ATTRIBUTE( name => 'RUN_SERVER_SQL_TEST'
                              , attribute => 'store_output'
                              , value => TRUE
                              )
  ;
  DBMS_SCHEDULER.SET_ATTRIBUTE( name => 'RUN_SERVER_SQL_TEST'
                              , attribute => 'logging_level'
                              , value => DBMS_SCHEDULER.LOGGING_FULL
                              )
  ;
  DBMS_SCHEDULER.SET_ATTRIBUTE( name => 'RUN_SERVER_SQL_TEST'
                              , attribute => 'connect_credential_name'
                              , value => 'DB_ACCESS_TEST'
                              )
  ;
  -- no job enable, runs instantly
END;
/
