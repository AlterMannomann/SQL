prompt --application/set_environment
set define off verify off feedback off
whenever sqlerror exit sql.sqlcode rollback
--------------------------------------------------------------------------------
--
-- Oracle APEX export file
--
-- You should run this script using a SQL client connected to the database as
-- the owner (parsing schema) of the application or as a database user with the
-- APEX_ADMINISTRATOR_ROLE role.
--
-- This export file has been automatically generated. Modifying this file is not
-- supported by Oracle and can lead to unexpected application and/or instance
-- behavior now or in the future.
--
-- NOTE: Calls to apex_application_install override the defaults below.
--
--------------------------------------------------------------------------------
begin
wwv_flow_imp.import_begin (
 p_version_yyyy_mm_dd=>'2023.10.31'
,p_default_workspace_id=>3179346209101735
);
end;
/
prompt  WORKSPACE 3179346209101735
--
-- Workspace, User Group, User, and Team Development Export:
--   Date and Time:   00:56 Monday May 27, 2024
--   Exported By:     USIM
--   Export Type:     Workspace Export
--   Version:         23.2.0
--   Instance ID:     977733934190736
--
-- Import:
--   Using Instance Administration / Manage Workspaces
--   or
--   Using SQL*Plus as the Oracle user APEX_230200
 
begin
    wwv_flow_imp.set_security_group_id(p_security_group_id=>3179346209101735);
end;
/
----------------
-- W O R K S P A C E
-- Creating a workspace will not create database schemas or objects.
-- This API creates only the meta data for this APEX workspace
prompt  Creating workspace WS_USIM...
begin
wwv_flow_fnd_user_api.create_company (
  p_id => 3179469294101835
 ,p_provisioning_company_id => 3179346209101735
 ,p_short_name => 'WS_USIM'
 ,p_display_name => 'WS_USIM'
 ,p_first_schema_provisioned => 'USIM_TEST'
 ,p_company_schemas => 'USIM:USIM_TEST'
 ,p_expire_fnd_user_accounts => 'Y'
 ,p_account_lifetime_days => 9999
 ,p_fnd_user_max_login_failures => 4
 ,p_account_status => 'ASSIGNED'
 ,p_allow_plsql_editing => 'Y'
 ,p_allow_app_building_yn => 'Y'
 ,p_allow_packaged_app_ins_yn => 'Y'
 ,p_allow_sql_workshop_yn => 'Y'
 ,p_allow_team_development_yn => 'Y'
 ,p_allow_to_be_purged_yn => 'Y'
 ,p_allow_restful_services_yn => 'Y'
 ,p_source_identifier => 'WS_USIM'
 ,p_webservice_logging_yn => 'Y'
 ,p_path_prefix => 'WS_USIM'
 ,p_builder_notification_message => 'USIM Workspace'
 ,p_files_version => 1
 ,p_max_session_length_sec => 0
 ,p_env_banner_yn => 'N'
 ,p_env_banner_pos => 'LEFT'
);
end;
/
----------------
-- G R O U P S
--
prompt  Creating Groups...
begin
wwv_flow_fnd_user_api.create_user_group (
  p_id => 2205626235253691,
  p_GROUP_NAME => 'OAuth2 Client Developer',
  p_SECURITY_GROUP_ID => 10,
  p_GROUP_DESC => 'Users authorized to register OAuth2 Client Applications');
end;
/
begin
wwv_flow_fnd_user_api.create_user_group (
  p_id => 2205533520253690,
  p_GROUP_NAME => 'RESTful Services',
  p_SECURITY_GROUP_ID => 10,
  p_GROUP_DESC => 'Users authorized to use RESTful Services with this workspace');
end;
/
begin
wwv_flow_fnd_user_api.create_user_group (
  p_id => 2205489255253686,
  p_GROUP_NAME => 'SQL Developer',
  p_SECURITY_GROUP_ID => 10,
  p_GROUP_DESC => 'Users authorized to use SQL Developer with this workspace');
end;
/
prompt  Creating group grants...
----------------
-- U S E R S
-- User repository for use with APEX cookie-based authentication.
--
prompt  Creating Users...
begin
wwv_flow_fnd_user_api.create_fnd_user (
  p_user_id                      => '3179280856101735',
  p_user_name                    => 'USIM',
  p_first_name                   => 'Adi',
  p_last_name                    => '',
  p_description                  => '',
  p_email_address                => 'adi@angewandte-lebenskunst.ch',
  p_web_password                 => '99051632EF89024BDBA857704605C86FCB0E41B79B0A2B7A55967E5BE2639202FA48EF15AAF91CD0708D5BFE3F279989E19289EE78D90ACCE678E3E1B4F08F14',
  p_web_password_format          => '5;5;10000',
  p_group_ids                    => '',
  p_developer_privs              => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL',
  p_default_schema               => 'USIM',
  p_account_locked               => 'N',
  p_account_expiry               => to_date('202405051440','YYYYMMDDHH24MI'),
  p_failed_access_attempts       => 0,
  p_change_password_on_first_use => 'N',
  p_first_password_use_occurred  => 'Y',
  p_allow_app_building_yn        => 'Y',
  p_allow_sql_workshop_yn        => 'Y',
  p_allow_team_development_yn    => 'Y',
  p_allow_access_to_schemas      => '');
end;
/
begin
wwv_flow_fnd_user_api.create_fnd_user (
  p_user_id                      => '7167966890955662',
  p_user_name                    => 'USIM_TEST',
  p_first_name                   => 'Adi',
  p_last_name                    => 'Tester',
  p_description                  => 'Test Account',
  p_email_address                => 'adi@angewandte-lebenskunst.ch',
  p_web_password                 => 'E02DC03716F30D84297A862EA6107E058F418F7FB5FCF212BBE66A2887F4E518C996BC9592F477684A515F185E3F7E075144F9C6E327A6E535C16C57730B9F7E',
  p_web_password_format          => '5;5;10000',
  p_group_ids                    => '',
  p_developer_privs              => 'ADMIN:CREATE:DATA_LOADER:EDIT:HELP:MONITOR:SQL',
  p_default_schema               => 'USIM_TEST',
  p_account_locked               => 'N',
  p_account_expiry               => to_date('202405070000','YYYYMMDDHH24MI'),
  p_failed_access_attempts       => 0,
  p_change_password_on_first_use => 'N',
  p_first_password_use_occurred  => 'N',
  p_allow_app_building_yn        => 'Y',
  p_allow_sql_workshop_yn        => 'Y',
  p_allow_team_development_yn    => 'Y',
  p_allow_access_to_schemas      => '');
end;
/
begin
wwv_flow_fnd_user_api.create_fnd_user (
  p_user_id                      => '7664421738478589',
  p_user_name                    => 'USIM_TEST_USER',
  p_first_name                   => 'User',
  p_last_name                    => 'USIM_TEST',
  p_description                  => '',
  p_email_address                => 'adi@angewandte-lebenskunst.ch',
  p_web_password                 => '2192D875C9141113059EB50563560EC318F855EEA9DCBB0A5CAC21A39996803E0786AF8F89CC1D939D2E5221F5C301F5B7F666AD282520657720CE58C39BBCBF',
  p_web_password_format          => '5;5;10000',
  p_group_ids                    => '',
  p_developer_privs              => '',
  p_default_schema               => 'USIM_TEST',
  p_account_locked               => 'N',
  p_account_expiry               => to_date('202405090000','YYYYMMDDHH24MI'),
  p_failed_access_attempts       => 0,
  p_change_password_on_first_use => 'N',
  p_first_password_use_occurred  => 'N',
  p_allow_app_building_yn        => 'N',
  p_allow_sql_workshop_yn        => 'N',
  p_allow_team_development_yn    => 'N',
  p_allow_access_to_schemas      => '');
end;
/
begin
wwv_flow_fnd_user_api.create_fnd_user (
  p_user_id                      => '7664209638471244',
  p_user_name                    => 'USIM_USER',
  p_first_name                   => 'User',
  p_last_name                    => 'USIM',
  p_description                  => '',
  p_email_address                => 'adi@angewandte-lebenskunst.ch',
  p_web_password                 => '6FE426059F9648081AFAAF09E23F81CE94FB56F76F90CE8D2D89970ADCD491E48AEC8AF70D8C437313DB9DEAC8F12F29A091B5E373C7AFAAD34AE98F7E3AC976',
  p_web_password_format          => '5;5;10000',
  p_group_ids                    => '',
  p_developer_privs              => '',
  p_default_schema               => 'USIM',
  p_account_locked               => 'N',
  p_account_expiry               => to_date('202405090000','YYYYMMDDHH24MI'),
  p_failed_access_attempts       => 0,
  p_change_password_on_first_use => 'N',
  p_first_password_use_occurred  => 'N',
  p_allow_app_building_yn        => 'N',
  p_allow_sql_workshop_yn        => 'N',
  p_allow_team_development_yn    => 'N',
  p_allow_access_to_schemas      => '');
end;
/
---------------------------
-- D G  B L U E P R I N T S
-- Creating Data Generator Blueprints...
----------------
--Click Count Logs
--
----------------
--mail
--
----------------
--mail log
--
----------------
--app models
--
----------------
--password history
--
begin
  wwv_imp_workspace.create_password_history (
    p_id => 7664314406471306,
    p_user_id => 7664209638471244,
    p_password => '6FE426059F9648081AFAAF09E23F81CE94FB56F76F90CE8D2D89970ADCD491E48AEC8AF70D8C437313DB9DEAC8F12F29A091B5E373C7AFAAD34AE98F7E3AC976');
end;
/
begin
  wwv_imp_workspace.create_password_history (
    p_id => 7664555007478623,
    p_user_id => 7664421738478589,
    p_password => '2192D875C9141113059EB50563560EC318F855EEA9DCBB0A5CAC21A39996803E0786AF8F89CC1D939D2E5221F5C301F5B7F666AD282520657720CE58C39BBCBF');
end;
/
begin
  wwv_imp_workspace.create_password_history (
    p_id => 7168097537955748,
    p_user_id => 7167966890955662,
    p_password => 'E02DC03716F30D84297A862EA6107E058F418F7FB5FCF212BBE66A2887F4E518C996BC9592F477684A515F185E3F7E075144F9C6E327A6E535C16C57730B9F7E');
end;
/
begin
  wwv_imp_workspace.create_password_history (
    p_id => 3179620579102079,
    p_user_id => 3179280856101735,
    p_password => '99051632EF89024BDBA857704605C86FCB0E41B79B0A2B7A55967E5BE2639202FA48EF15AAF91CD0708D5BFE3F279989E19289EE78D90ACCE678E3E1B4F08F14');
end;
/
----------------
--preferences
--
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 4087475119135229,
    p_user_id => 'USIM',
    p_preference_name => 'PERSISTENT_ITEM_P1_DISPLAY_MODE',
    p_attribute_value => 'ICONS',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 9701819172443288,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_9658295273627201_CURRENT_REPORT',
    p_attribute_value => '9659119397627204:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 4087708778135268,
    p_user_id => 'USIM',
    p_preference_name => 'FB_FLOW_ID',
    p_attribute_value => '428',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 9842637735985050,
    p_user_id => 'USIM_USER',
    p_preference_name => 'APEX_IG_9658295273627201_CURRENT_REPORT',
    p_attribute_value => '9659119397627204:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 9842973134996116,
    p_user_id => 'USIM',
    p_preference_name => 'FSP4000_P129_R183075524876689047_SORT',
    p_attribute_value => 'sort_3_asc',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 12850829189215734,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4000_P4003_W632908938554265910',
    p_attribute_value => '632910390117265918____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 4952285131805325,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_21515661633785596_CURRENT_REPORT',
    p_attribute_value => '21952299068924429:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 4952349583805339,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_262121216799808381_CURRENT_REPORT',
    p_attribute_value => '2113442552309866:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 4952932785843669,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_21546336307856480_CURRENT_REPORT',
    p_attribute_value => '21982973742995313:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 5353211584443320,
    p_user_id => 'USIM',
    p_preference_name => 'PERSISTENT_ITEM_P34_ROWS',
    p_attribute_value => '',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 5358227064034151,
    p_user_id => 'USIM',
    p_preference_name => 'PD_GAL_CUR_TAB',
    p_attribute_value => '0',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 5571379240177258,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_5555022944051887_CURRENT_REPORT',
    p_attribute_value => '5555927804051888:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 5756332571736866,
    p_user_id => 'USIM',
    p_preference_name => 'F4000_203906404237009921_SPLITTER_STATE',
    p_attribute_value => '347:false',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 5758973361864365,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_665073618803777080_CURRENT_REPORT',
    p_attribute_value => '665079563548779201:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 5759059830870862,
    p_user_id => 'USIM',
    p_preference_name => 'CODE_LANGUAGE',
    p_attribute_value => 'PLSQL',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 7561102625169960,
    p_user_id => 'USIM',
    p_preference_name => 'PERSISTENT_ITEM_P25_DATE',
    p_attribute_value => '.125',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 7751289970752378,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'APEX_IG_7687421512178002_CURRENT_REPORT',
    p_attribute_value => '7748025030750496:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 6969475576629687,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_6807121496113325_CURRENT_REPORT',
    p_attribute_value => '7643052530907465:DETAIL',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 8704163909358883,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4000_P2300_W92468021968325911',
    p_attribute_value => '95148537308558700____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 7573774527910464,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_22147801256189259_CURRENT_REPORT',
    p_attribute_value => '22584438691328092:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 8704485037366750,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4000_P801_W47918412797645641',
    p_attribute_value => '47921608032702994____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 7577006399057114,
    p_user_id => 'USIM',
    p_preference_name => 'PERSISTENT_ITEM_P707_ROWS',
    p_attribute_value => '',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 7664727059488191,
    p_user_id => 'USIM_TEST_USER',
    p_preference_name => 'APEX_IG_17861242795472325_CURRENT_REPORT',
    p_attribute_value => '17862147655472326:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 7664867467488192,
    p_user_id => 'USIM_TEST_USER',
    p_preference_name => 'APEX_IG_6807121496113325_CURRENT_REPORT',
    p_attribute_value => '7643052530907465:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 7667879181548146,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'FSP_IR_100_P10010_W3888316452134980',
    p_attribute_value => '3893827251134991____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 7668056978551695,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'FSP_IR_100_P10041_W3988245573135073',
    p_attribute_value => '3991061544135076____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 7684875983093018,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'FSP100_P3_R7675907279086818_SORT',
    p_attribute_value => 'sort_1_asc',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 7718615136187051,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'APEX_IG_7675907279086818_CURRENT_REPORT',
    p_attribute_value => '7699442628185962:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 7720404307248630,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_7675907279086818_CURRENT_REPORT',
    p_attribute_value => '7699442628185962:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 7728603553385571,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'APEX_IG_7722514473335601_CURRENT_REPORT',
    p_attribute_value => '7723411589335603:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 7738755423568416,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'APEX_IG_7731827587551154_CURRENT_REPORT',
    p_attribute_value => '7732766786551160:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 7747066483662079,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'APEX_IG_7741085082643661_CURRENT_REPORT',
    p_attribute_value => '7741994367643664:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 9684380974860511,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4000_P889_W253961723059367687',
    p_attribute_value => '253963809229374878____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 7826807546349081,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'APEX_IG_7802857251331098_CURRENT_REPORT',
    p_attribute_value => '7803728123331099:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 8703901470358820,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4000_P2300_W2050828593861326',
    p_attribute_value => '2117833588027975____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 9701644768371757,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4000_P4850_W663191354226602129',
    p_attribute_value => '663193778295677089____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 10843823132128450,
    p_user_id => 'USIM_TEST_USER',
    p_preference_name => 'APEX_IG_10633516683071527_CURRENT_REPORT',
    p_attribute_value => '10634419656071539:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 10844510968282982,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'FSP_IR_4000_P40_W48117227188266087',
    p_attribute_value => '48118623144274016____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 12240955238574020,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4000_P1620_W312277037396040233',
    p_attribute_value => '312279461465115193____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 12251362590052960,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_12231351609073003_CURRENT_REPORT',
    p_attribute_value => '12243151165005725:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 12631374730547496,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4000_P666_W623982508550484061',
    p_attribute_value => '623985406251567425____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 10655266130439638,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'FSP_IR_4000_P1500_W3519715528105919',
    p_attribute_value => '3521529006112497____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 10663423199477220,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'FSP_IR_4000_P546_W30205316146531602',
    p_attribute_value => '30206031208532453____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 10663815302504643,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'FSP_IR_4000_P405_W3852329031687921',
    p_attribute_value => '3853503855690337____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 5961496053072459,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_11506447564123521_CURRENT_REPORT',
    p_attribute_value => '11507352424123522:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 6792938972331100,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_6778139733288407_CURRENT_REPORT',
    p_attribute_value => '6788166172330535:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 10663913299504912,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'APEX_IG_665073618803777080_CURRENT_REPORT',
    p_attribute_value => '665079563548779201:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 10676058455664702,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_10657427958461230_CURRENT_REPORT',
    p_attribute_value => '10658387926461236:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 10681135418067507,
    p_user_id => 'USIM_USER',
    p_preference_name => 'APEX_IG_10633516683071527_CURRENT_REPORT',
    p_attribute_value => '10634419656071539:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 10455866608150852,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4000_P546_W30205316146531602',
    p_attribute_value => '30206031208532453____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 10654160983344538,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'APEX_IG_10644242626297712_CURRENT_REPORT',
    p_attribute_value => '10645106704297716:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 10843698044125535,
    p_user_id => 'USIM_TEST_USER',
    p_preference_name => 'APEX_IG_10657427958461230_CURRENT_REPORT',
    p_attribute_value => '10658387926461236:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 10843797380125535,
    p_user_id => 'USIM_TEST_USER',
    p_preference_name => 'APEX_IG_10834943950115101_CURRENT_REPORT',
    p_attribute_value => '10840444553124042:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 10843988232130520,
    p_user_id => 'USIM_TEST_USER',
    p_preference_name => 'APEX_IG_10432334117010038_CURRENT_REPORT',
    p_attribute_value => '10433226971010042:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 12240028784527380,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4350_P53_W34954404769221837',
    p_attribute_value => '34956410007247564____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 12240299920527544,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4350_P51_W441077109644796807',
    p_attribute_value => '441077718682801782____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 12240493850529624,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4000_P1931_W249349528073883039',
    p_attribute_value => '309920184639832447____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 12241184749580386,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4000_P4100_W3727618522871356',
    p_attribute_value => '3728530690872449____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 12241348678580690,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4000_P130_W5051906577678195',
    p_attribute_value => '5053430969682717____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 12241540115581490,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4000_P4910_W3738700462051133',
    p_attribute_value => '3741124531126093____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 12631186290534334,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4000_P4110_W1548412223182178',
    p_attribute_value => '1550029190194632____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 12631477898549795,
    p_user_id => 'USIM',
    p_preference_name => 'FSP4350_P33_R47031617128214415_SORT',
    p_attribute_value => 'sort_1_asc',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 12631645088551121,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4350_P78_W169333814048245920',
    p_attribute_value => '169335112738260044____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 12632235382581850,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4000_P273_W48571614952501952',
    p_attribute_value => '48572307979502610____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 12632418135582571,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4000_P959_W483659607062898467',
    p_attribute_value => '483660631524898748____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 12632530373583060,
    p_user_id => 'USIM',
    p_preference_name => 'FSP4000_P34_R77549119545304597_SORT',
    p_attribute_value => 'sort_1_asc',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 12632768965583249,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4000_P19_W451745617575288584',
    p_attribute_value => '451746507039288843____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 12633249522583857,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4000_P431_W478896025956673213',
    p_attribute_value => '478896612991674411____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 12849674576064350,
    p_user_id => 'USIM_USER',
    p_preference_name => 'APEX_IG_12231351609073003_CURRENT_REPORT',
    p_attribute_value => '12243151165005725:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 12849788657068113,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'APEX_IG_12231351609073003_CURRENT_REPORT',
    p_attribute_value => '12243151165005725:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 10655374893440060,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'PERSISTENT_ITEM_P1_DISPLAY_MODE',
    p_attribute_value => 'ICONS',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 10655578726440121,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'FSP_IR_4000_P1_W3326806401130228',
    p_attribute_value => '3328003692130542____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 10655666610440172,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'FB_FLOW_ID',
    p_attribute_value => '428',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 10664504837518031,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'APEX_IG_10657427958461230_CURRENT_REPORT',
    p_attribute_value => '10658387926461236:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 10676698958673774,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_10644242626297712_CURRENT_REPORT',
    p_attribute_value => '10645106704297716:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 10676795874674453,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_10633516683071527_CURRENT_REPORT',
    p_attribute_value => '10634419656071539:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 10850762987578458,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'FSP4000_P197_R935666971301945228_SORT',
    p_attribute_value => 'sort_2_asc',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 10877811698716163,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'APEX_IG_10834943950115101_CURRENT_REPORT',
    p_attribute_value => '10840444553124042:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 13433299820239309,
    p_user_id => 'USIM_TEST_USER',
    p_preference_name => 'APEX_IG_12231351609073003_CURRENT_REPORT',
    p_attribute_value => '12243151165005725:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 6367863151368243,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_17861242795472325_CURRENT_REPORT',
    p_attribute_value => '17862147655472326:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 7364806381048814,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'APEX_IG_17861242795472325_CURRENT_REPORT',
    p_attribute_value => '17862147655472326:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 7364933978048814,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'APEX_IG_6807121496113325_CURRENT_REPORT',
    p_attribute_value => '7643052530907465:DETAIL',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 7365020637048814,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'APEX_IG_6777506822288401_CURRENT_REPORT',
    p_attribute_value => '6783066104303797:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 7365152136048814,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'APEX_IG_6778139733288407_CURRENT_REPORT',
    p_attribute_value => '6788166172330535:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 8694117797855760,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4000_P1500_W3519715528105919',
    p_attribute_value => '3521529006112497____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 8694637419943582,
    p_user_id => 'USIM',
    p_preference_name => 'FSP4000_P197_R935666971301945228_SORT',
    p_attribute_value => 'sort_2_asc',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 4969644116942844,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_4957297745941507_CURRENT_REPORT',
    p_attribute_value => '4958185908941509:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 8698013339002622,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4000_P312_W26482817283914173',
    p_attribute_value => '26483725907914179____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 8702828457199870,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4350_P55_W10236304983033455',
    p_attribute_value => '10238325656034902____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 8704502514367342,
    p_user_id => 'USIM',
    p_preference_name => 'FSP4000_P817_R1384333522660578_SORT',
    p_attribute_value => 'sort_4_asc',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 5177110235163270,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_925260747421540222_CURRENT_REPORT',
    p_attribute_value => '2807177378527946:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 8704771499368453,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4000_P4070_W47949429235486335',
    p_attribute_value => '47951124794493113____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 8707802077778840,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4000_P405_W3852329031687921',
    p_attribute_value => '3853503855690337____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 9631977470022052,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4500_P1004_W467833818073240350',
    p_attribute_value => '467836414517307027____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 9632692068031400,
    p_user_id => 'USIM',
    p_preference_name => 'FSP4500_P1220_R11177418830226625_SORT',
    p_attribute_value => 'fsp_sort_8',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 5354998881771695,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_20915676136405505_CURRENT_REPORT',
    p_attribute_value => '21352313571544338:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 5355049703771703,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_266470409881026219_CURRENT_REPORT',
    p_attribute_value => '6462635633527704:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 5355142990787739,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_20118983404167526_CURRENT_REPORT',
    p_attribute_value => '20555620839306359:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 9632922770031536,
    p_user_id => 'USIM',
    p_preference_name => 'PERSISTENT_ITEM_P1225_VIEW_MODE',
    p_attribute_value => '',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 9633099191031804,
    p_user_id => 'USIM',
    p_preference_name => 'FSP4500_P1225_R164053306541529880_SORT',
    p_attribute_value => 'sort_1_asc',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 5760910201959747,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_15002873478753519_CURRENT_REPORT',
    p_attribute_value => '26501553497477617:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 9633119233076555,
    p_user_id => 'USIM',
    p_preference_name => 'APEX$RDS_4500_1100_2000395581438701_active_tab',
    p_attribute_value => 'diagram',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 6368786411425907,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_712080000591813402_CURRENT_REPORT',
    p_attribute_value => '712386498335634625:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 6368827940427308,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_9499495849275742_CURRENT_REPORT',
    p_attribute_value => '23204494782337413:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 9633813835099276,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4500_P1040_W34145524067104114',
    p_attribute_value => '34146803034108603____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 9673499143744605,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'APEX_IG_9658295273627201_CURRENT_REPORT',
    p_attribute_value => '9659119397627204:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 10455229992051975,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'APEX_IG_10432334117010038_CURRENT_REPORT',
    p_attribute_value => '10433226971010042:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 6787055821304500,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_6777506822288401_CURRENT_REPORT',
    p_attribute_value => '6783066104303797:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 10640929209148248,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'APEX_IG_10633516683071527_CURRENT_REPORT',
    p_attribute_value => '10634419656071539:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 10663567291501860,
    p_user_id => 'USIM_TEST',
    p_preference_name => 'CODE_LANGUAGE',
    p_attribute_value => 'PLSQL',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 6981388337854781,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_24836763758242567_CURRENT_REPORT',
    p_attribute_value => '24837668618242568:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 6981488851854782,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_13782642458883567_CURRENT_REPORT',
    p_attribute_value => '13940454867399162:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 6981567081854782,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_13753027785058643_CURRENT_REPORT',
    p_attribute_value => '13758587067074039:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 6981671223854782,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_13753660696058649_CURRENT_REPORT',
    p_attribute_value => '13763687135100777:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 6981755744896371,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_WINDOW_MGMT_MODE',
    p_attribute_value => 'FOCUS',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 6981891020896371,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_WINDOW_MGMT_SHARE_WINDOW',
    p_attribute_value => 'N',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 6981918889896375,
    p_user_id => 'USIM',
    p_preference_name => 'F4500_CSV_DOWNLOAD_UNICODE',
    p_attribute_value => 'Y',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 7984330925788890,
    p_user_id => 'USIM',
    p_preference_name => 'APEX_IG_22115650667121016_CURRENT_REPORT',
    p_attribute_value => '22552288102259849:GRID',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 7984479142825374,
    p_user_id => 'USIM',
    p_preference_name => 'F4000_1157687726908338238_SPLITTER_STATE',
    p_attribute_value => '199:false',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 8693800579814912,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4000_P1_W3326806401130228',
    p_attribute_value => '3328003692130542____',
    p_tenant_id => '');
end;
/
begin
  wwv_imp_workspace.create_preferences$ (
    p_id => 8697876921001525,
    p_user_id => 'USIM',
    p_preference_name => 'FSP_IR_4000_P40_W48117227188266087',
    p_attribute_value => '48118623144274016____',
    p_tenant_id => '');
end;
/
----------------
--query builder
--
----------------
--sql scripts
--
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2D2D206F6E6C792072657475726E206120726F77206966206F626A656374732061726520696E7374616C6C65640D0A53454C4543542027494E5354414C4C4544270D0A202046524F4D206475616C0D0A205748455245202853454C45435420434F554E54';
wwv_flow_imp.g_varchar2_table(2) := '282A29200D0A2020202020202020202046524F4D20757365725F6F626A656374730D0A2020202020202020205748455245206F626A6563745F6E616D6520494E202820275553494D5F4D4C565F53544154455F56270D0A20202020202020202020202020';
wwv_flow_imp.g_varchar2_table(3) := '20202020202020202020202020202020202C20275553494D5F5350435F50524F43455353270D0A2020202020202020202020202020202020202020202020202020202020202C20275553494D5F4552524F525F4C4F47270D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(4) := '202020202020202020202020202020202020202C20275553494D5F44454255475F4C4F47270D0A202020202020202020202020202020202020202020202020202020202020290D0A2020202020202020202020414E44206F626A6563745F747970652049';
wwv_flow_imp.g_varchar2_table(5) := '4E2028202756494557270D0A2020202020202020202020202020202020202020202020202020202020202C20275441424C45270D0A202020202020202020202020202020202020202020202020202020202020290D0A2020202020202020202020414E44';
wwv_flow_imp.g_varchar2_table(6) := '20737461747573202020202020203D202756414C4944270D0A202020202020202029203D20340D0A3B';
end;
/
begin
  wwv_imp_workspace.create_script (
    p_id => 9684622120070110,
    p_flow_id => 4500,
    p_name => '9684622120070110/IsInstalled',
    p_pathid => null,
    p_filename => 'IsInstalled',
    p_title => 'IsInstalled',
    p_mime_type => 'text/plain',
    p_dad_charset => '',
    p_created_by => 'USIM',
    p_created_on => to_date('202405121430','YYYYMMDDHH24MI'),
    p_updated_by => 'USIM',
    p_updated_on => to_date('202405121431','YYYYMMDDHH24MI'),
    p_deleted_as_of => to_date('000101010000','YYYYMMDDHH24MI'),
    p_content_type => 'BLOB',
    p_blob_content => wwv_flow_imp.g_varchar2_table,
    p_language => '',
    p_description => '',
    p_file_type => 'SCRIPT',
    p_file_charset => 'utf-8');
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9688721696078607
    ,p_file_id => 9684622120070110
    ,p_stmt_number => 3
    ,p_src_line_number => 16
    ,p_offset => -1
    ,p_length => 1
    ,p_stmt_class => 4
    ,p_stmt_id => 80
    ,p_isrunnable => 'N'
    ,p_stmt_vc2 => ';'
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9687332400078606
    ,p_file_id => 9684622120070110
    ,p_stmt_number => 2
    ,p_src_line_number => 2
    ,p_offset => 48
    ,p_length => 19
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => 'SELECT ''INSTALLED'' '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9687430327078606
    ,p_file_id => 9684622120070110
    ,p_stmt_number => 2
    ,p_src_line_number => 3
    ,p_offset => 68
    ,p_length => 12
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => '  FROM dual '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9687580201078606
    ,p_file_id => 9684622120070110
    ,p_stmt_number => 2
    ,p_src_line_number => 4
    ,p_offset => 81
    ,p_length => 25
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => ' WHERE (SELECT COUNT(*)  '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9687618326078606
    ,p_file_id => 9684622120070110
    ,p_stmt_number => 2
    ,p_src_line_number => 5
    ,p_offset => 107
    ,p_length => 28
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => '          FROM user_objects '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9687712690078606
    ,p_file_id => 9684622120070110
    ,p_stmt_number => 2
    ,p_src_line_number => 6
    ,p_offset => 136
    ,p_length => 51
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => '         WHERE object_name IN ( ''USIM_MLV_STATE_V'' '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9687827885078607
    ,p_file_id => 9684622120070110
    ,p_stmt_number => 2
    ,p_src_line_number => 7
    ,p_offset => 188
    ,p_length => 51
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => '                              , ''USIM_SPC_PROCESS'' '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9687997483078607
    ,p_file_id => 9684622120070110
    ,p_stmt_number => 2
    ,p_src_line_number => 8
    ,p_offset => 240
    ,p_length => 49
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => '                              , ''USIM_ERROR_LOG'' '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9688062738078607
    ,p_file_id => 9684622120070110
    ,p_stmt_number => 2
    ,p_src_line_number => 9
    ,p_offset => 290
    ,p_length => 49
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => '                              , ''USIM_DEBUG_LOG'' '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9688138948078607
    ,p_file_id => 9684622120070110
    ,p_stmt_number => 2
    ,p_src_line_number => 10
    ,p_offset => 340
    ,p_length => 32
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => '                              ) '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9688231681078607
    ,p_file_id => 9684622120070110
    ,p_stmt_number => 2
    ,p_src_line_number => 11
    ,p_offset => 373
    ,p_length => 39
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => '           AND object_type IN ( ''VIEW'' '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9688308742078607
    ,p_file_id => 9684622120070110
    ,p_stmt_number => 2
    ,p_src_line_number => 12
    ,p_offset => 413
    ,p_length => 40
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => '                              , ''TABLE'' '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9688433535078607
    ,p_file_id => 9684622120070110
    ,p_stmt_number => 2
    ,p_src_line_number => 13
    ,p_offset => 454
    ,p_length => 32
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => '                              ) '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9688566575078607
    ,p_file_id => 9684622120070110
    ,p_stmt_number => 2
    ,p_src_line_number => 14
    ,p_offset => 487
    ,p_length => 38
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => '           AND status       = ''VALID'' '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9688678007078607
    ,p_file_id => 9684622120070110
    ,p_stmt_number => 2
    ,p_src_line_number => 15
    ,p_offset => 526
    ,p_length => 14
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => '        ) = 4 '
);
end;
/
begin
  wwv_imp_workspace.create_sw_results (
    p_id => 9685647189070483,
    p_file_id => 9684622120070110,
    p_job_id => null,
    p_run_by => 'USIM',
    p_run_as => 'USIM',
    p_started => to_date('202405121430','YYYYMMDDHH24MI'),
    p_start_time => 1070490,
    p_ended => to_date('202405121430','YYYYMMDDHH24MI'),
    p_end_time => 1070494,
    p_status => 'COMPLETE',
    p_run_comments => '');
end;
/
begin
  wwv_imp_workspace.create_sw_detail_results (
    p_id => 9685717408070491
    ,p_result_id => 9685647189070483
    ,p_file_id => 9684622120070110
    ,p_seq_id => 1
    ,p_stmt_num => 2
 ,p_stmt_text => 
'SELECT ''INSTALLED''   FROM dual  WHERE (SELECT COUNT(*)            FROM user_objects          WHERE object_name IN (''USIM_MLV_STATE_V'', ''USIM_SPC_PROCESS'', ''USIM_ERROR_LOG'', ''USIM_DEBUG_LOG'')            AND object_type IN (''VIEW'', ''TABLE'')            AND status       = ''VALID''         ) = 4 '
 ,p_result => 
'<table aria-label="Results" cellpadding="0" cellspacing="0" border="0" class="u-Report u-Report--stretch">'||wwv_flow.LF||
'<tr><th id="&#x27;INSTALLED&#x27;">&#x27;INSTALLED&#x27;</th></tr><tr><td headers="&#x27;INSTALLED&#x27;">INSTALLED</td></tr>'||wwv_flow.LF||
'</table>'
    ,p_result_size => 241
    ,p_result_rows => 1
    ,p_msg => 'Statement processed.'
    ,p_success => 'Y'
    ,p_failure => 'N'
    ,p_started => to_date('202405121430','YYYYMMDDHH24MI')
    ,p_start_time => 1070491
    ,p_ended => to_date('202405121430','YYYYMMDDHH24MI')
    ,p_end_time => 1070494
    ,p_run_complete => 'Y'
    ,p_last_updated => to_date('202405121430','YYYYMMDDHH24MI'));
end;
/
begin
wwv_flow_imp.g_varchar2_table := wwv_flow_imp.empty_varchar2_table;
wwv_flow_imp.g_varchar2_table(1) := '2D2D206F6E6C792072657475726E206120726F77206966206F626A656374732061726520696E7374616C6C65640D0A53454C4543542027494E5354414C4C4544270D0A202046524F4D206475616C0D0A205748455245202853454C45435420434F554E54';
wwv_flow_imp.g_varchar2_table(2) := '282A29200D0A2020202020202020202046524F4D20757365725F6F626A656374730D0A2020202020202020205748455245206F626A6563745F6E616D6520494E202820275553494D5F4D4C565F53544154455F56270D0A20202020202020202020202020';
wwv_flow_imp.g_varchar2_table(3) := '20202020202020202020202020202020202C20275553494D5F5350435F50524F43455353270D0A2020202020202020202020202020202020202020202020202020202020202C20275553494D5F4552524F525F4C4F47270D0A2020202020202020202020';
wwv_flow_imp.g_varchar2_table(4) := '202020202020202020202020202020202020202C20275553494D5F44454255475F4C4F47270D0A2020202020202020202020202020202020202020202020202020202020202C20275553494D5F544553545F53554D4D415259270D0A2020202020202020';
wwv_flow_imp.g_varchar2_table(5) := '202020202020202020202020202020202020202020202C20275553494D5F544553545F4552524F5253270D0A202020202020202020202020202020202020202020202020202020202020290D0A2020202020202020202020414E44206F626A6563745F74';
wwv_flow_imp.g_varchar2_table(6) := '79706520494E2028202756494557270D0A2020202020202020202020202020202020202020202020202020202020202C20275441424C45270D0A202020202020202020202020202020202020202020202020202020202020290D0A202020202020202020';
wwv_flow_imp.g_varchar2_table(7) := '2020414E4420737461747573202020202020203D202756414C4944270D0A202020202020202029203D20360D0A3B';
end;
/
begin
  wwv_imp_workspace.create_script (
    p_id => 9688826291081170,
    p_flow_id => 4500,
    p_name => '9688826291081170/IsInstalledWithTesting',
    p_pathid => null,
    p_filename => 'IsInstalledWithTesting',
    p_title => 'IsInstalledWithTesting',
    p_mime_type => 'text/plain',
    p_dad_charset => '',
    p_created_by => 'USIM',
    p_created_on => to_date('202405121432','YYYYMMDDHH24MI'),
    p_updated_by => 'USIM',
    p_updated_on => to_date('202405121433','YYYYMMDDHH24MI'),
    p_deleted_as_of => to_date('000101010000','YYYYMMDDHH24MI'),
    p_content_type => 'BLOB',
    p_blob_content => wwv_flow_imp.g_varchar2_table,
    p_language => '',
    p_description => '',
    p_file_type => 'SCRIPT',
    p_file_charset => 'utf-8');
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9695669605091538
    ,p_file_id => 9688826291081170
    ,p_stmt_number => 3
    ,p_src_line_number => 18
    ,p_offset => -1
    ,p_length => 1
    ,p_stmt_class => 4
    ,p_stmt_id => 80
    ,p_isrunnable => 'N'
    ,p_stmt_vc2 => ';'
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9694051914091538
    ,p_file_id => 9688826291081170
    ,p_stmt_number => 2
    ,p_src_line_number => 2
    ,p_offset => 48
    ,p_length => 19
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => 'SELECT ''INSTALLED'' '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9694165491091538
    ,p_file_id => 9688826291081170
    ,p_stmt_number => 2
    ,p_src_line_number => 3
    ,p_offset => 68
    ,p_length => 12
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => '  FROM dual '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9694205346091538
    ,p_file_id => 9688826291081170
    ,p_stmt_number => 2
    ,p_src_line_number => 4
    ,p_offset => 81
    ,p_length => 25
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => ' WHERE (SELECT COUNT(*)  '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9694337414091538
    ,p_file_id => 9688826291081170
    ,p_stmt_number => 2
    ,p_src_line_number => 5
    ,p_offset => 107
    ,p_length => 28
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => '          FROM user_objects '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9694452633091538
    ,p_file_id => 9688826291081170
    ,p_stmt_number => 2
    ,p_src_line_number => 6
    ,p_offset => 136
    ,p_length => 51
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => '         WHERE object_name IN ( ''USIM_MLV_STATE_V'' '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9694540314091538
    ,p_file_id => 9688826291081170
    ,p_stmt_number => 2
    ,p_src_line_number => 7
    ,p_offset => 188
    ,p_length => 51
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => '                              , ''USIM_SPC_PROCESS'' '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9694675799091538
    ,p_file_id => 9688826291081170
    ,p_stmt_number => 2
    ,p_src_line_number => 8
    ,p_offset => 240
    ,p_length => 49
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => '                              , ''USIM_ERROR_LOG'' '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9694778474091538
    ,p_file_id => 9688826291081170
    ,p_stmt_number => 2
    ,p_src_line_number => 9
    ,p_offset => 290
    ,p_length => 49
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => '                              , ''USIM_DEBUG_LOG'' '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9694805842091538
    ,p_file_id => 9688826291081170
    ,p_stmt_number => 2
    ,p_src_line_number => 10
    ,p_offset => 340
    ,p_length => 52
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => '                              , ''USIM_TEST_SUMMARY'' '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9694989406091538
    ,p_file_id => 9688826291081170
    ,p_stmt_number => 2
    ,p_src_line_number => 11
    ,p_offset => 393
    ,p_length => 51
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => '                              , ''USIM_TEST_ERRORS'' '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9695034664091538
    ,p_file_id => 9688826291081170
    ,p_stmt_number => 2
    ,p_src_line_number => 12
    ,p_offset => 445
    ,p_length => 32
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => '                              ) '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9695198839091538
    ,p_file_id => 9688826291081170
    ,p_stmt_number => 2
    ,p_src_line_number => 13
    ,p_offset => 478
    ,p_length => 39
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => '           AND object_type IN ( ''VIEW'' '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9695293856091538
    ,p_file_id => 9688826291081170
    ,p_stmt_number => 2
    ,p_src_line_number => 14
    ,p_offset => 518
    ,p_length => 40
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => '                              , ''TABLE'' '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9695309125091538
    ,p_file_id => 9688826291081170
    ,p_stmt_number => 2
    ,p_src_line_number => 15
    ,p_offset => 559
    ,p_length => 32
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => '                              ) '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9695472082091538
    ,p_file_id => 9688826291081170
    ,p_stmt_number => 2
    ,p_src_line_number => 16
    ,p_offset => 592
    ,p_length => 38
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => '           AND status       = ''VALID'' '
);
end;
/
begin
  wwv_imp_workspace.create_sw_stmts (
    p_id => 9695597156091538
    ,p_file_id => 9688826291081170
    ,p_stmt_number => 2
    ,p_src_line_number => 17
    ,p_offset => 631
    ,p_length => 14
    ,p_stmt_class => 2
    ,p_stmt_id => 72
    ,p_isrunnable => 'Y'
    ,p_stmt_vc2 => '        ) = 6 '
);
end;
/
begin
  wwv_imp_workspace.create_sw_results (
    p_id => 9690453974081581,
    p_file_id => 9688826291081170,
    p_job_id => null,
    p_run_by => 'USIM',
    p_run_as => 'USIM',
    p_started => to_date('202405121432','YYYYMMDDHH24MI'),
    p_start_time => 1081586,
    p_ended => to_date('202405121432','YYYYMMDDHH24MI'),
    p_end_time => 1081629,
    p_status => 'COMPLETE',
    p_run_comments => '');
end;
/
begin
  wwv_imp_workspace.create_sw_detail_results (
    p_id => 9690585338081586
    ,p_result_id => 9690453974081581
    ,p_file_id => 9688826291081170
    ,p_seq_id => 1
    ,p_stmt_num => 2
 ,p_stmt_text => 
'SELECT ''INSTALLED''   FROM dual  WHERE (SELECT COUNT(*)            FROM user_objects          WHERE object_name IN ( ''USIM_MLV_STATE_V''                               , ''USIM_SPC_PROCESS''                               , ''USIM_ERROR_LOG''                               , ''USIM_DEBUG_LOG''                               )            AND object_type IN ( ''VIEW''                               , ''TABLE''      '||
'                         )            AND status       = ''VALID''         ) = 4 '
 ,p_result => 
'<table aria-label="Results" cellpadding="0" cellspacing="0" border="0" class="u-Report u-Report--stretch">'||wwv_flow.LF||
'<tr><th id="&#x27;INSTALLED&#x27;">&#x27;INSTALLED&#x27;</th></tr><tr><td headers="&#x27;INSTALLED&#x27;">INSTALLED</td></tr>'||wwv_flow.LF||
'</table>'
    ,p_result_size => 241
    ,p_result_rows => 1
    ,p_msg => 'Statement processed.'
    ,p_success => 'Y'
    ,p_failure => 'N'
    ,p_started => to_date('202405121432','YYYYMMDDHH24MI')
    ,p_start_time => 1081586
    ,p_ended => to_date('202405121432','YYYYMMDDHH24MI')
    ,p_end_time => 1081612
    ,p_run_complete => 'Y'
    ,p_last_updated => to_date('202405121432','YYYYMMDDHH24MI'));
end;
/
begin
  wwv_imp_workspace.create_sw_results (
    p_id => 9695787794091760,
    p_file_id => 9688826291081170,
    p_job_id => null,
    p_run_by => 'USIM',
    p_run_as => 'USIM',
    p_started => to_date('202405121434','YYYYMMDDHH24MI'),
    p_start_time => 1091763,
    p_ended => to_date('202405121434','YYYYMMDDHH24MI'),
    p_end_time => 1091785,
    p_status => 'COMPLETE',
    p_run_comments => '');
end;
/
begin
  wwv_imp_workspace.create_sw_detail_results (
    p_id => 9695849928091764
    ,p_result_id => 9695787794091760
    ,p_file_id => 9688826291081170
    ,p_seq_id => 1
    ,p_stmt_num => 2
 ,p_stmt_text => 
'SELECT ''INSTALLED''   FROM dual  WHERE (SELECT COUNT(*)            FROM user_objects          WHERE object_name IN ( ''USIM_MLV_STATE_V''                               , ''USIM_SPC_PROCESS''                               , ''USIM_ERROR_LOG''                               , ''USIM_DEBUG_LOG''                               , ''USIM_TEST_SUMMARY''                               , ''USIM_TEST_ERRORS''              '||
'                 )            AND object_type IN ( ''VIEW''                               , ''TABLE''                               )            AND status       = ''VALID''         ) = 6 '
 ,p_result => 
'no data found'
    ,p_result_size => 13
    ,p_result_rows => 0
    ,p_msg => 'Statement processed.'
    ,p_success => 'Y'
    ,p_failure => 'N'
    ,p_started => to_date('202405121434','YYYYMMDDHH24MI')
    ,p_start_time => 1091764
    ,p_ended => to_date('202405121434','YYYYMMDDHH24MI')
    ,p_end_time => 1091780
    ,p_run_complete => 'Y'
    ,p_last_updated => to_date('202405121434','YYYYMMDDHH24MI'));
end;
/
----------------
--sql commands
--
----------------
--Quick SQL saved models
--
----------------
--user access log
--
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405051445','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405051617','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405051634','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405072004','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405072018','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405072053','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405072106','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405072107','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405120256','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405120258','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405121948','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_USER',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405121949','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405071815','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405071819','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405091408','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405091603','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405091705','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST_USER',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405091929','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405091931','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405091932','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405091936','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405091941','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405091944','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405091946','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405091947','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405091947','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST_USER',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405092003','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405092003','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405092136','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405092137','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405111433','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405111540','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405111540','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405111612','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405111615','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405112103','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST_USER',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405120129','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM',
    p_access_date => to_date('202405120151','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST_USER',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405121304','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405121521','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405051440','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 5,
    p_custom_status_text => 'Invalid Login Credentials');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405051440','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405051442','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 101,
    p_owner => 'USIM',
    p_access_date => to_date('202405062321','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405062338','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405142230','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405060028','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405072053','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405081706','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405081711','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405091238','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405091301','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.131',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'WS_USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405112203','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 1,
    p_custom_status_text => 'Invalid Login Credentials');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405112204','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405112208','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405112213','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405112221','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405112223','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405112242','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST_USER',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405112242','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405112308','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405121543','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405142122','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST_USER',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405142308','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405142308','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405060014','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405061824','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405061825','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405061909','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405061925','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405061927','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405061928','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405062315','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 101,
    p_owner => 'USIM',
    p_access_date => to_date('202405062326','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 101,
    p_owner => 'USIM',
    p_access_date => to_date('202405062331','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405081710','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405091413','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405111433','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405111449','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405111522','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405111524','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405111539','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405112208','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405112208','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405112210','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405112212','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405112212','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405112213','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405112215','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST_USER',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405112236','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405120003','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405120128','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST_USER',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405120128','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405120235','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST_USER',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405120244','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405120247','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405120253','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405121133','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 100,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405121151','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405121208','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405121304','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405121950','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405122028','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405122043','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405122143','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405122238','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405130006','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405131838','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405131839','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405132352','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405140001','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log1$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405142123','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405250019','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405250030','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405251258','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405261446','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405270030','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM_TEST_USER',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405161951','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405162031','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405252017','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405252148','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405252206','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405260119','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405261110','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405261120','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405261711','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405261712','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM_USER',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405150015','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405150037','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405150039','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405150041','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405161948','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405251304','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405252036','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405261225','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405261326','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM_USER',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405261356','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405261357','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405261602','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405150017','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405150038','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405251634','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405251653','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405251708','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405261348','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405261447','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405261449','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405261449','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Internal Authentication',
    p_app => 4500,
    p_owner => 'APEX_230200',
    p_access_date => to_date('202405262342','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM_USER',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405270004','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405270013','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM_TEST_USER',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405270017','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405270017','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
begin
  wwv_imp_workspace.create_user_access_log2$ (
    p_login_name => 'USIM_TEST',
    p_auth_method => 'Oracle APEX Accounts',
    p_app => 428,
    p_owner => 'USIM_TEST',
    p_access_date => to_date('202405270049','YYYYMMDDHH24MI'),
    p_ip_address => '192.168.1.128',
    p_remote_user => 'APEX_PUBLIC_USER',
    p_auth_result => 0,
    p_custom_status_text => '');
end;
/
prompt Check Compatibility...
begin
-- This date identifies the minimum version required to import this file.
wwv_flow_team_api.check_version(p_version_yyyy_mm_dd=>'2010.05.13');
end;
/
 
begin wwv_flow.g_import_in_progress := true; wwv_flow.g_user := USER; end; 
/
 
--
prompt ...feedback
--
begin
null;
end;
/
--
prompt ...Issue Templates
--
begin
null;
end;
/
--
prompt ...Issue Email Prefs
--
begin
null;
end;
/
--
prompt ...Label Groups
--
begin
null;
end;
/
--
prompt ...Labels
--
begin
null;
end;
/
--
prompt ... Milestones
--
begin
null;
end;
/
--
prompt ... Issues
--
begin
null;
end;
/
--
prompt ... Issue Attachments
--
begin
null;
end;
/
--
prompt ... Issues Milestones
--
begin
null;
end;
/
--
prompt ... Issues Labels
--
begin
null;
end;
/
--
prompt ... Issues stakeholders
--
begin
null;
end;
/
--
prompt ... Issues Comments
--
begin
null;
end;
/
--
prompt ... Issues Events
--
begin
null;
end;
/
--
prompt ... Issues Notifications
--
begin
null;
end;
/
 
prompt ... Extension Links
 
 
prompt ...workspace objects
 
begin
wwv_imp_workspace.create_credential(
 p_id=>wwv_flow_imp.id(4086960020135133)
,p_name=>'App 100 Push Notifications Credentials'
,p_static_id=>'App_100_Push_Notifications_Credentials'
,p_authentication_type=>'KEY_PAIR'
,p_prompt_on_install=>false
);
end;
/
begin
wwv_imp_workspace.create_credential(
 p_id=>wwv_flow_imp.id(8693263177814826)
,p_name=>'App 428 Push Notifications Credentials'
,p_static_id=>'App_428_Push_Notifications_Credentials'
,p_authentication_type=>'KEY_PAIR'
,p_prompt_on_install=>false
);
end;
/
 
prompt ...RESTful Services
 
-- SET SCHEMA
 
begin
 
   wwv_flow_imp.g_id_offset := 0;
   wwv_flow_hint.g_schema   := 'USIM';
   wwv_flow_hint.check_schema_privs;
 
end;
/

 
--------------------------------------------------------------------
prompt  SCHEMA USIM - User Interface Defaults, Table Defaults
--
-- Import using sqlplus as the Oracle user: APEX_230200
-- Exported 00:56 Monday May 27, 2024 by: USIM
--
-- SET SCHEMA
 
begin
 
   wwv_flow_imp.g_id_offset := 0;
   wwv_flow_hint.g_schema   := 'USIM_TEST';
   wwv_flow_hint.check_schema_privs;
 
end;
/

 
--------------------------------------------------------------------
prompt  SCHEMA USIM_TEST - User Interface Defaults, Table Defaults
--
-- Import using sqlplus as the Oracle user: APEX_230200
-- Exported 00:56 Monday May 27, 2024 by: USIM
--
 
--------------------------------------------------------------------
prompt User Interface Defaults, Attribute Dictionary
--
-- Exported 00:56 Monday May 27, 2024 by: USIM
--
-- SHOW EXPORTING WORKSPACE
 
begin
 
   wwv_flow_imp.g_id_offset := 0;
   wwv_flow_hint.g_exp_workspace := 'WS_USIM';
 
end;
/

begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
