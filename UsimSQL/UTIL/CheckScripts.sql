-- Collection of check scripts
-- check child parent symmetry
SELECT SUM(child_cnt) AS childs
     , SUM(parent_cnt) AS parents
     , dim_n1_sign
  FROM (SELECT usim_chi.child_count(usim_id_spc) AS child_cnt
             , usim_chi.parent_count(usim_id_spc) AS parent_cnt
             , dim_n1_sign
          FROM usim_spc_v
       )
 GROUP BY dim_n1_sign
;
-- dimension symmetry
SELECT usim_n1_sign
     , MAX(usim_n_dimension) AS max_dim
     , COUNT(*) AS cnt_dim
  FROM usim_rmd_v
 GROUP BY usim_n1_sign
;
-- symmetry processing, modulus 2 should be 0
SELECT usim_planck_aeon
     , usim_planck_time
     , COUNT(*) AS process_cnt
     , MOD(COUNT(*), 2) AS mod_2
  FROM usim_spc_process
 GROUP BY usim_planck_aeon
        , usim_planck_time
;
-- classify check
SELECT CASE usim_dbif.classify_escape(usim_id_spc)
         WHEN 0 THEN 'FULL'
         WHEN 1 THEN 'FREE DIM POS'
         WHEN 2 THEN 'FREE DIM'
         WHEN 3 THEN 'FREE POS'
         WHEN 4 THEN 'DELEGATE DIM'
         WHEN 5 THEN 'DELEGATE POS'
         WHEN 6 THEN 'DELEGATE POS X'
         WHEN 7 THEN 'DELEGATE BETWEEN'
         ELSE 'ERR'
       END AS classify_escape
     , CASE usim_dbif.classify_parent(usim_id_spc)
         WHEN -2 THEN 'ERR'
         WHEN -1 THEN 'DM ERR'
         WHEN 0 THEN 'FULL'
         WHEN 1 THEN 'FREE DIM POS'
         WHEN 2 THEN 'FREE DIM'
         WHEN 3 THEN 'FREE POS'
         WHEN 4 THEN 'FREE AXIS-POS'
         ELSE 'ERR'
       END AS classify_parent
     , CASE usim_dbif.dimension_rating(usim_id_spc)
         WHEN -1 THEN 'ERR'
         WHEN 0 THEN 'BASE0'
         WHEN 1 THEN 'AXIS0 N1'
         WHEN 2 THEN 'AXIS0'
         WHEN 3 THEN 'AXIS'
         WHEN 4 THEN 'BETWEEN'
       END AS dim_rating
     , CASE usim_dbif.overflow_rating(usim_id_spc)
         WHEN 0 THEN 'TOTAL'
         WHEN 1 THEN 'NO'
         WHEN 2 THEN 'POS'
         WHEN 3 THEN 'DIM'
       END AS overflow
     , usim_dbif.is_overflow_dim_spc(usim_id_spc) AS is_overflow_dim
     , usim_dbif.is_overflow_pos_spc(usim_id_spc) AS is_overflow_pos
     , usim_dbif.has_free_between(usim_id_spc) AS free_between
     , usim_spo.is_axis_zero_pos(usim_id_spc) is_zero_axis
     , usim_spc.is_universe_base(usim_id_spc) is_universe_base
     , usim_dbif.max_childs(usim_id_spc) AS max_childs
     , usim_dbif.child_count(usim_id_spc) AS childs
     , usim_spc.get_cur_max_dim_n1(usim_id_spc) AS max_dim_for_id
     , usim_dbif.get_axis_max_pos_dim1(usim_id_spc) AS max_pos_dim1
     , usim_base.get_max_dimension AS max_dim
     , usim_chi.has_child_next_dim(usim_id_spc) AS child_next_dim
     , usim_n_dimension
     , dim_sign
     , dim_n1_sign
     , usim_spo.get_xyz(usim_id_spc) AS xyz
     , usim_id_spc
     , usim_spo.get_axis_max_pos_parent(usim_id_spc) AS max_pos_parent
  FROM usim_spc_v
 ORDER BY dim_n1_sign DESC NULLS FIRST
        , usim_n_dimension
        , ABS(usim_coordinate)
        , usim_dbif.dimension_rating(usim_id_spc)
;
-- inspect processing
SELECT spr.usim_planck_time
     , spr.is_processed
     , xyz_src.xyz_coord AS from_xyz
     , xyz_src.usim_process_spin AS from_spin
     , xyz_src.usim_n_dimension AS from_dim
     , xyz_src.dim_n1_sign AS from_n1_sign
     , xyz_src.dim_sign AS from_n_sign
     , xyz_tgt.xyz_coord AS to_xyz
     , xyz_tgt.usim_process_spin AS to_spin
     , xyz_tgt.usim_n_dimension AS to_dim
     , xyz_tgt.dim_n1_sign AS to_n1_sign
     , xyz_tgt.dim_sign AS to_n_sign
     , spr.usim_energy_source
     , spr.usim_energy_target
     , spr.usim_energy_output
     , spr.usim_id_spc_source
     , spr.usim_id_spc_target
     , spr.usim_planck_aeon
     , spr.usim_real_time
  FROM usim_spc_process spr
  LEFT OUTER JOIN usim_spo_xyz_v xyz_src
    ON spr.usim_id_spc_source = xyz_src.usim_id_spc
  LEFT OUTER JOIN usim_spo_xyz_v xyz_tgt
    ON spr.usim_id_spc_target = xyz_tgt.usim_id_spc
-- WHERE spr.usim_planck_time = 2
 ORDER BY spr.usim_planck_aeon
        , spr.usim_planck_time
        , xyz_src.usim_n_dimension
        , xyz_tgt.usim_n_dimension
        , xyz_src.dim_n1_sign
;
-- create overview tabs
SELECT usim_timestamp, SUBSTR(usim_err_object, 1, 50) AS usim_err_object, usim_err_info FROM usim_error_log ORDER BY usim_timestamp, usim_tick;
SELECT usim_timestamp, SUBSTR(usim_log_object, 1, 50) AS usim_log_object, usim_log_content FROM usim_debug_log ORDER BY usim_timestamp, ROWID;
SELECT * FROM usim_spc_v;
SELECT * FROM usim_spc_chi_v;
SELECT * FROM usim_spo_v;
SELECT * FROM usim_rmd_v;
SELECT * FROM usim_position;
SELECT * FROM usim_spo_xyz_v;
SELECT * FROM usim_spr_v;
SELECT * FROM usim_mlv_state_v;

-- spo testing does not get correct 0 dimension of dimensions between 1 and final dimension
--     as other dimensions are only connected to dimension 1
SELECT *
  FROM usim_chi_v
 WHERE parent_dimension < child_dimension
   AND parent_id_mlv    = &ID_MLV
  START WITH usim_id_spc_child = &ID_NEW_POS
CONNECT BY PRIOR usim_id_spc = usim_id_spc_child
;
-- if dimension is not in this select, the zero position of the missing
-- dimension must be added with correct rmd, n1_sign equal, dim_sign equal to dim 2 if dim > 2
-- we got parent axis dim 1 so dim_n1_sign is set, dim_sign depends on the second dim, where 2 dim axis exist
-- next dim axis are in the quarter of second dim axis and have the same dim sign

-- all coordinates in one direction from processing
SELECT src_xyz, tgt_xyz FROM usim_spr_v WHERE usim_spo.get_magnitude(usim_id_spc_source, 3) <= usim_spo.get_magnitude(usim_id_spc_target, 3) GROUP BY src_xyz, tgt_xyz;
-- all coordinates from childs with from magnitude to get possibly missing structure
SELECT usim_dbif.get_xyz(usim_id_spc) AS src_xyz, usim_dbif.get_xyz(usim_id_spc_child) AS tgt_xyz FROM usim_spc_child GROUP BY usim_dbif.get_xyz(usim_id_spc), usim_dbif.get_xyz(usim_id_spc_child);

-- get some log
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  l_return NUMBER;
BEGIN
  usim_erl.purge_log;
  usim_debug.purge_log;
  usim_debug.set_debug_on;
  l_return := usim_creator.create_space_log(usim_dbif.get_planck_aeon_seq_current, 20, 60);
END;
/
SELECT usim_timestamp, SUBSTR(usim_err_object, 1, 50) AS usim_err_object, usim_err_info FROM usim_error_log ORDER BY usim_timestamp, usim_tick;
SELECT usim_timestamp, SUBSTR(usim_log_object, 1, 50) AS usim_log_object, usim_log_content FROM usim_debug_log ORDER BY usim_timestamp, ROWID;

-- Scheduler information
SELECT * FROM dba_scheduler_jobs;
SELECT * FROM dba_scheduler_running_jobs;
SELECT * FROM dba_scheduler_job_log ORDER BY log_date DESC;
SELECT * FROM dba_scheduler_job_run_details ORDER BY log_date DESC;
SELECT * FROM dba_scheduler_notifications;
CREATE SYNONYM usim_test.run_server_sql FOR sys.run_server_sql_test;
BEGIN
  DBMS_SCHEDULER.DROP_JOB_CLASS(job_class_name => 'USIM_JOBS', force => TRUE);
  DBMS_SCHEDULER.CREATE_JOB_CLASS( job_class_name => 'USIM_JOBS'
                                 , resource_consumer_group => 'SYS_GROUP'
                                 , logging_level => DBMS_SCHEDULER.LOGGING_FULL
                                 )
  ;
END;
/
-- profile limitations
select profile from dba_users where username = 'USIM_TEST';
select resource_name, limit from dba_profiles where profile=
( select profile from dba_users where username = 'USIM_TEST');
-- get script to adjust server NLS settings for SYS jobs
-- run on client to get the statements for system running the DBA setup, e.g. SQL Developer on windows
SELECT 'Client To Server NLS' AS direction
     , 'ALTER SESSION SET ' || parameter || ' = ''' || value || ''';' AS statement
  FROM nls_database_parameters
 WHERE parameter IN ('NLS_LANGUAGE', 'NLS_TERRITORY', 'NLS_CURRENCY', 'NLS_ISO_CURRENCY', 'NLS_NUMERIC_CHARACTERS', 'NLS_CALENDAR', 'NLS_DATE_FORMAT', 'NLS_DATE_LANGUAGE', 'NLS_SORT', 'NLS_TIME_FORMAT', 'NLS_TIMESTAMP_FORMAT', 'NLS_TIME_TZ_FORMAT', 'NLS_TIMESTAMP_TZ_FORMAT', 'NLS_DUAL_CURRENCY', 'NLS_COMP', 'NLS_LENGTH_SEMANTICS', 'NLS_NCHAR_CONV_EXCP', 'NLS_CHARACTERSET')
 UNION ALL
SELECT 'Client Back To Client NLS' AS direction
     , 'ALTER SESSION SET ' || parameter || ' = ''' || value || ''';' AS statement
  FROM v$nls_parameters
 WHERE parameter IN ('NLS_LANGUAGE', 'NLS_TERRITORY', 'NLS_CURRENCY', 'NLS_ISO_CURRENCY', 'NLS_NUMERIC_CHARACTERS', 'NLS_CALENDAR', 'NLS_DATE_FORMAT', 'NLS_DATE_LANGUAGE', 'NLS_SORT', 'NLS_TIME_FORMAT', 'NLS_TIMESTAMP_FORMAT', 'NLS_TIME_TZ_FORMAT', 'NLS_TIMESTAMP_TZ_FORMAT', 'NLS_DUAL_CURRENCY', 'NLS_COMP', 'NLS_LENGTH_SEMANTICS', 'NLS_NCHAR_CONV_EXCP', 'NLS_CHARACTERSET')
;
-- NLS equal to server
SELECT srv.parameter
     , srv.value
     , cli.value
  FROM nls_database_parameters srv
  LEFT OUTER JOIN v$nls_parameters cli
    ON srv.parameter = cli.parameter
-- WHERE srv.value != cli.value
;
SELECT 'NLS settings for ' || LISTAGG(srv.parameter, ', ') || ' do not match. Jobs will have different NLS settings.' AS info
  FROM nls_database_parameters srv
  LEFT OUTER JOIN v$nls_parameters cli
    ON srv.parameter = cli.parameter
 WHERE srv.value != cli.value
;
-- get base path
SELECT directory_path
  FROM dba_directories
 WHERE directory_name = 'USIM_SCRIPT_DIR'
;
-- testing in vscode
SELECT * FROM all_objects WHERE object_name LIKE 'RUN%' OR object_name LIKE 'USIM%RUN%';
SELECT * FROM all_scheduler_jobs;