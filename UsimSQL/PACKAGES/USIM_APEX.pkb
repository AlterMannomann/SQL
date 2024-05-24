-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
CREATE OR REPLACE PACKAGE BODY &USIM_SCHEMA..usim_apex
IS
  -- see header for documentation
  FUNCTION is_test_env
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  IS
    l_result NUMBER;
  BEGIN
    l_result := CASE USER
                  WHEN usim_apex.TEST_SCHEMA
                  THEN 1
                  WHEN usim_apex.PROD_SCHEMA
                  THEN 0
                  ELSE -1
                END
    ;
    RETURN l_result;
  END is_test_env
  ;

  FUNCTION is_installed
    RETURN NUMBER
  IS
    CURSOR cur_valid IS
        -- use a fast as possible version < 1 sec runtime
        WITH lst AS
             (SELECT CASE
                       WHEN USER = usim_apex.TEST_SCHEMA
                       -- adjust list if new packages are released
                       THEN 'USIM_ERL,USIM_DEBUG,USIM_STATIC,USIM_MATHS,USIM_BASE,USIM_MLV,USIM_POS,USIM_DIM,USIM_SPR,USIM_DBIF,USIM_CREATOR,USIM_PROCESS,USIM_NOD,USIM_RMD,USIM_SPC,USIM_CHI,USIM_SPO,USIM_APEX,USIM_TEST'
                       ELSE 'USIM_ERL,USIM_DEBUG,USIM_STATIC,USIM_MATHS,USIM_BASE,USIM_MLV,USIM_POS,USIM_DIM,USIM_SPR,USIM_DBIF,USIM_CREATOR,USIM_PROCESS,USIM_NOD,USIM_RMD,USIM_SPC,USIM_CHI,USIM_SPO,USIM_APEX'
                     END AS object_list
                     -- adjust expected count if new packages are released
                   , CASE WHEN USER = usim_apex.TEST_SCHEMA THEN 38 ELSE 36 END AS cnt_expected
                FROM dual
             )
           , obj AS
             (SELECT COUNT(*) AS cnt_objects
                FROM user_objects
                LEFT OUTER JOIN lst ON 1 = 1
               WHERE INSTR(lst.object_list, user_objects.object_name) > 0
             )
           , val AS
             (SELECT COUNT(CASE WHEN status = 'VALID' THEN 1 END) AS cnt_valid
                   , COUNT(CASE WHEN status != 'VALID' THEN 1 END) AS cnt_invalid
                FROM user_objects
                     -- exclude synonyms from SYS
               WHERE object_type != 'SYNONYM'
             )
      SELECT CASE
               WHEN USER IN (usim_apex.PROD_SCHEMA, usim_apex.TEST_SCHEMA)
               THEN CASE
                      WHEN USER = usim_apex.PROD_SCHEMA
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
        FROM obj
        LEFT OUTER JOIN val ON 1 = 1
        LEFT OUTER JOIN lst ON 1 = 1
    ;
    l_result NUMBER;
  BEGIN
    OPEN cur_valid;
    FETCH cur_valid INTO l_result;
    CLOSE cur_valid;
    RETURN l_result;
  END is_installed
  ;

  FUNCTION is_installed_text
    RETURN VARCHAR2
  IS
    l_result VARCHAR2(128);
  BEGIN
    l_result := CASE is_installed
                  WHEN 0    THEN 'No USIM system installed yet'
                  WHEN 1    THEN 'USIM system installed and valid'
                  WHEN 2    THEN 'USIM test system installed and valid'
                  WHEN -10  THEN 'Invalid objects found in USIM system, objects complete'
                  WHEN -11  THEN 'Invalid and missing objects found in USIM system'
                  WHEN -12  THEN 'Missing objects found in USIM system, all objects valid'
                  WHEN -20  THEN 'Invalid objects found in USIM test system, objects complete'
                  WHEN -21  THEN 'Invalid and missing objects found in USIM test system'
                  WHEN -22  THEN 'Missing objects found in USIM test system, all objects valid'
                  WHEN -99  THEN 'Not a USIM system'
                  ELSE 'ERROR Unknown state'
                END
    ;
    RETURN l_result;
  END is_installed_text
  ;

END usim_apex;
/