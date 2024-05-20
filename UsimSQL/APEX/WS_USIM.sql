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
--   Date and Time:   04:37 Monday May 20, 2024
--   Exported By:     ADMIN
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
  p_first_name                   => '',
  p_last_name                    => '',
  p_description                  => '',
  p_email_address                => '',
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
  p_first_name                   => '',
  p_last_name                    => 'Tester',
  p_description                  => 'Test Account',
  p_email_address                => '',
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
  p_email_address                => '',
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
  p_email_address                => '',
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

begin
wwv_flow_imp.import_end(p_auto_install_sup_obj => nvl(wwv_flow_application_install.get_auto_install_sup_obj, false));
commit;
end;
/
set verify on feedback on define on
prompt  ...done
