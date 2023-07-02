--== sequences start ==--
-- USIM_DEBUG_LOG (dlg) sequence
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../SEQUENCES/USIM_DLG_ID_SEQ.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Sequence USIM_DLG_ID_SEQ still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_DLG_ID_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
-- USIM_TEST_SUMMARY (tsu) sequence
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../SEQUENCES/USIM_TSU_ID_SEQ.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Sequence USIM_TSU_ID_SEQ still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_TSU_ID_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
--== sequences end ==--

--== debug tables start ==--
-- USIM_DEBUG_LOG (dlg)
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../TABLES/USIM_DEBUG_LOG_TBL.sql'
         ELSE '../UTIL/../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Table USIM_DEBUG_LOG still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_DEBUG_LOG'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
--== debug tables end ==--

--== debug package start ==--
@@../PACKAGES/USIM_DEBUG.pks
@@../PACKAGES/USIM_DEBUG.pkb
--== debug package end ==--

--== test tables start ==--
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../TABLES/USIM_TEST_SUMMARY_TBL.sql'
         ELSE '../UTIL/../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Table USIM_TEST_SUMMARY still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_TEST_SUMMARY'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
-- USIM_TEST_ERRORS (ter)
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../TABLES/USIM_TEST_ERRORS_TBL.sql'
         ELSE '../UTIL/../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Table USIM_TEST_ERRORS still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_TEST_ERRORS'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
-- test package
@@../PACKAGES/USIM_TEST.pks
@@../PACKAGES/USIM_TEST.pkb
--== test tables end ==--


--== packages with debug code overrides start ==--
-- you may add any packages with debug code to override the standard packages here
--== packages with debug code overrides end ==--