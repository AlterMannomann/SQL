-- prebuild programs and jobs to create or recreate the schema DDL
BEGIN
  DBMS_SCHEDULER.CREATE_JOB_CLASS( job_class_name => 'USIM_JOBS'
                                 , resource_consumer_group => 'SYS_GROUP'
                                 , logging_level => DBMS_SCHEDULER.LOGGING_FULL
                                 )
  ;
  DBMS_SCHEDULER.CREATE_PROGRAM( program_name => 'USIM_RUN_SQL'
                               , program_type => 'EXTERNAL_SCRIPT'
                               , program_action => '&USIM_SHELL./run_sql.sh'
                               , number_of_arguments => 3
                               , enabled => FALSE
                               , comments => 'Provide program with parameters to run sql script on server in the correct directory for USIM'
                               )
  ;
  DBMS_SCHEDULER.DEFINE_PROGRAM_ARGUMENT( program_name => 'USIM_RUN_SQL'
                                        , argument_position => 1
                                        , argument_name => 'SCRIPT_PATH'
                                        , argument_type => 'VARCHAR2'
                                        , default_value => '&USIM_SETUP'
                                        )
  ;
  DBMS_SCHEDULER.DEFINE_PROGRAM_ARGUMENT( program_name => 'USIM_RUN_SQL'
                                        , argument_position => 2
                                        , argument_name => 'SCRIPT_NAME'
                                        , argument_type => 'VARCHAR2'
                                        , default_value => 'USIM_SETUP.sql'
                                        )
  ;
  DBMS_SCHEDULER.DEFINE_PROGRAM_ARGUMENT( program_name => 'USIM_RUN_SQL'
                                        , argument_position => 3
                                        , argument_name => 'DB_USER'
                                        , argument_type => 'VARCHAR2'
                                        , default_value => 'USIM'
                                        )
  ;
  DBMS_SCHEDULER.ENABLE( name => 'USIM_RUN_SQL');
  DBMS_SCHEDULER.CREATE_PROGRAM( program_name => 'USIM_RUN_SQL_TEST'
                               , program_type => 'EXTERNAL_SCRIPT'
                               , program_action => '&USIM_SHELL./run_sql.sh'
                               , number_of_arguments => 3
                               , enabled => FALSE
                               , comments => 'Provide program with parameters to run sql script on server in the correct directory for USIM_TEST'
                               )
  ;
  DBMS_SCHEDULER.DEFINE_PROGRAM_ARGUMENT( program_name => 'USIM_RUN_SQL_TEST'
                                        , argument_position => 1
                                        , argument_name => 'SCRIPT_PATH'
                                        , argument_type => 'VARCHAR2'
                                        , default_value => '&USIM_SETUP'
                                        )
  ;
  DBMS_SCHEDULER.DEFINE_PROGRAM_ARGUMENT( program_name => 'USIM_RUN_SQL_TEST'
                                        , argument_position => 2
                                        , argument_name => 'SCRIPT_NAME'
                                        , argument_type => 'VARCHAR2'
                                        , default_value => 'USIM_TEST_SETUP.sql'
                                        )
  ;
  DBMS_SCHEDULER.DEFINE_PROGRAM_ARGUMENT( program_name => 'USIM_RUN_SQL_TEST'
                                        , argument_position => 3
                                        , argument_name => 'DB_USER'
                                        , argument_type => 'VARCHAR2'
                                        , default_value => 'USIM_TEST'
                                        )
  ;
  DBMS_SCHEDULER.ENABLE( name => 'USIM_RUN_SQL_TEST');
  DBMS_SCHEDULER.CREATE_JOB( job_name => 'USIM_RUN_SERVER_SQL'
                           , program_name => 'USIM_RUN_SQL'
                           , start_date => NULL
                           , repeat_interval => NULL
                           , end_date => NULL
                           , enabled => FALSE
                           , job_class => 'USIM_JOBS'
                           , auto_drop => FALSE
                           , comments => 'Runs sql scripts on the server for USIM'
                           , credential_name => 'USIM_OS_ACCESS'
                           , job_style => 'REGULAR'
                           );

  DBMS_SCHEDULER.SET_ATTRIBUTE( name => 'USIM_RUN_SERVER_SQL'
                              , attribute => 'store_output'
                              , value => TRUE
                              )
  ;
  DBMS_SCHEDULER.SET_ATTRIBUTE( name => 'USIM_RUN_SERVER_SQL'
                              , attribute => 'logging_level'
                              , value => DBMS_SCHEDULER.LOGGING_FULL
                              )
  ;
  DBMS_SCHEDULER.SET_ATTRIBUTE( name => 'USIM_RUN_SERVER_SQL'
                              , attribute => 'connect_credential_name'
                              , value => 'USIM_DB_ACCESS'
                              )
  ;
  DBMS_SCHEDULER.CREATE_JOB( job_name => 'USIM_RUN_SERVER_SQL_TEST'
                           , program_name => 'USIM_RUN_SQL_TEST'
                           , start_date => NULL
                           , repeat_interval => NULL
                           , end_date => NULL
                           , enabled => FALSE
                           , job_class => 'USIM_JOBS'
                           , auto_drop => FALSE
                           , comments => 'Runs sql scripts on the server for USIM_TEST'
                           , credential_name => 'USIM_OS_ACCESS'
                           , job_style => 'REGULAR'
                           )
  ;
  DBMS_SCHEDULER.SET_ATTRIBUTE( name => 'USIM_RUN_SERVER_SQL_TEST'
                              , attribute => 'store_output'
                              , value => TRUE
                              )
  ;
  DBMS_SCHEDULER.SET_ATTRIBUTE( name => 'USIM_RUN_SERVER_SQL_TEST'
                              , attribute => 'logging_level'
                              , value => DBMS_SCHEDULER.LOGGING_FULL
                              )
  ;
  DBMS_SCHEDULER.SET_ATTRIBUTE( name => 'USIM_RUN_SERVER_SQL_TEST'
                              , attribute => 'connect_credential_name'
                              , value => 'USIM_DB_ACCESS_TEST'
                              )
  ;
  -- no job enable, runs instantly
END;
/
