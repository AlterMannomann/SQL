-- SYS view granted to manage install state situations, needed by DBA setup
CREATE OR REPLACE VIEW usim_install_state AS
    WITH lst AS
         (SELECT CASE
                   WHEN SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') = 'USIM'
                   -- adjust list if new packages are released
                   THEN 'USIM_ERL,USIM_DEBUG,USIM_STATIC,USIM_MATHS,USIM_BASE,USIM_MLV,USIM_POS,USIM_DIM,USIM_SPR,USIM_DBIF,USIM_CREATOR,USIM_PROCESS,USIM_NOD,USIM_RMD,USIM_SPC,USIM_CHI,USIM_SPO,USIM_APEX'
                   ELSE 'USIM_ERL,USIM_DEBUG,USIM_STATIC,USIM_MATHS,USIM_BASE,USIM_MLV,USIM_POS,USIM_DIM,USIM_SPR,USIM_DBIF,USIM_CREATOR,USIM_PROCESS,USIM_NOD,USIM_RMD,USIM_SPC,USIM_CHI,USIM_SPO,USIM_APEX,USIM_TEST'
                 END AS object_list
                 -- adjust expected count if new packages are released
               , CASE
                   WHEN SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') = 'USIM' THEN 36
                   WHEN SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') = 'USIM_TEST' THEN 38
                   ELSE -1
                 END AS cnt_expected
               , CASE
                   WHEN SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') = 'USIM' THEN 0
                   WHEN SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') = 'USIM_TEST' THEN 1
                   ELSE -1
                 END AS is_test_env
            FROM dual
         )
       , obj AS
         (SELECT COUNT(*) AS cnt_objects
            FROM all_objects
            LEFT OUTER JOIN lst ON 1 = 1
           WHERE owner = SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA')
             AND INSTR(lst.object_list, all_objects.object_name) > 0
         )
       , val AS
         (SELECT COUNT(CASE WHEN status = 'VALID' THEN 1 END) AS cnt_valid
               , COUNT(CASE WHEN status != 'VALID' THEN 1 END) AS cnt_invalid
            FROM all_objects
                 -- exclude synonyms from SYS
           WHERE owner = SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA')
             AND object_type != 'SYNONYM'
         )
  SELECT CASE
           WHEN SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') IN ('USIM', 'USIM_TEST')
           THEN CASE
                  WHEN SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') = 'USIM'
                  THEN CASE
                         WHEN obj.cnt_objects = lst.cnt_expected
                          AND val.cnt_invalid = 0
                          AND val.cnt_valid  != 0
                         THEN 1
                         WHEN obj.cnt_objects  = lst.cnt_expected
                          AND val.cnt_invalid != 0
                          AND val.cnt_valid   != 0
                         THEN -10
                         WHEN obj.cnt_objects != lst.cnt_expected
                          AND val.cnt_invalid != 0
                          AND val.cnt_valid   != 0
                         THEN -11
                         WHEN obj.cnt_objects != lst.cnt_expected
                          AND val.cnt_invalid  = 0
                          AND val.cnt_valid   != 0
                         THEN -12
                         ELSE 0
                       END
                  ELSE CASE
                         WHEN obj.cnt_objects = lst.cnt_expected
                          AND val.cnt_invalid = 0
                          AND val.cnt_valid  != 0
                         THEN 2
                         WHEN obj.cnt_objects = lst.cnt_expected
                          AND val.cnt_invalid != 0
                          AND val.cnt_valid   != 0
                         THEN -20
                         WHEN obj.cnt_objects != lst.cnt_expected
                          AND val.cnt_invalid != 0
                          AND val.cnt_valid   != 0
                         THEN -21
                         WHEN obj.cnt_objects != lst.cnt_expected
                          AND val.cnt_invalid  = 0
                          AND val.cnt_valid   != 0
                         THEN -22
                         ELSE 0
                       END
                END
           ELSE -99
         END AS status
       , CASE
           WHEN SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') IN ('USIM', 'USIM_TEST')
           THEN CASE
                  WHEN SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') = 'USIM'
                  THEN CASE
                         WHEN obj.cnt_objects = lst.cnt_expected
                          AND val.cnt_invalid = 0
                          AND val.cnt_valid  != 0
                         THEN 'USim system installed and valid'
                         WHEN obj.cnt_objects  = lst.cnt_expected
                          AND val.cnt_invalid != 0
                          AND val.cnt_valid   != 0
                         THEN 'Invalid objects found in USim system, objects complete'
                         WHEN obj.cnt_objects != lst.cnt_expected
                          AND val.cnt_invalid != 0
                          AND val.cnt_valid   != 0
                         THEN 'Invalid and missing objects found in USim system'
                         WHEN obj.cnt_objects != lst.cnt_expected
                          AND val.cnt_invalid  = 0
                          AND val.cnt_valid   != 0
                         THEN 'Missing objects found in USim system, all objects valid'
                         ELSE 'No USim system installed yet'
                       END
                  ELSE CASE
                         WHEN obj.cnt_objects = lst.cnt_expected
                          AND val.cnt_invalid = 0
                          AND val.cnt_valid  != 0
                         THEN 'USim test system installed and valid'
                         WHEN obj.cnt_objects = lst.cnt_expected
                          AND val.cnt_invalid != 0
                          AND val.cnt_valid   != 0
                         THEN 'Invalid objects found in USim test system, objects complete'
                         WHEN obj.cnt_objects != lst.cnt_expected
                          AND val.cnt_invalid != 0
                          AND val.cnt_valid   != 0
                         THEN 'Invalid and missing objects found in USim test system'
                         WHEN obj.cnt_objects != lst.cnt_expected
                          AND val.cnt_invalid  = 0
                          AND val.cnt_valid   != 0
                         THEN 'Missing objects found in USim test system, all objects valid'
                         ELSE 'No USIM test system installed yet'
                       END
                END
           ELSE 'Not a USim system'
         END AS status_txt
       , lst.is_test_env
       , CASE WHEN lst.is_test_env = 1 THEN 'USim Test Environment' ELSE 'USim Live Environment' END AS is_test_env_txt
       , lst.cnt_expected
       , obj.cnt_objects
       , val.cnt_invalid
       , val.cnt_valid
       , USER AS view_user
       , SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS current_schema
       , SYS_CONTEXT('USERENV', 'CURRENT_USER') AS current_user
       , SYS_CONTEXT('USERENV', 'OS_USER') AS os_user
    FROM obj
    LEFT OUTER JOIN val ON 1 = 1
    LEFT OUTER JOIN lst ON 1 = 1
;