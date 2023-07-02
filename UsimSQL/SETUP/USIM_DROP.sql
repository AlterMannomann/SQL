
SELECT 'Remove all USIM objects if needed.' AS info FROM dual;
--== basic packages start ==--
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP_USIM_STATIC_PKB.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package body USIM_STATIC does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_STATIC'
   AND object_type = 'PACKAGE BODY'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP_USIM_STATIC_PKS.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package header USIM_STATIC does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_STATIC'
   AND object_type = 'PACKAGE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP_USIM_MATHS_PKB.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package body USIM_MATHS does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_MATHS'
   AND object_type = 'PACKAGE BODY'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP_USIM_MATHS_PKS.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package header USIM_MATHS does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_MATHS'
   AND object_type = 'PACKAGE'
;
@@&SCRIPTFILE
--== basic packages end ==--

--== sequences start ==--
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../SEQUENCES/DROP_USIM_DLG_ID_SEQ.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Sequence USIM_DLG_ID_SEQ does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_DLG_ID_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../SEQUENCES/DROP_USIM_MLV_ID_SEQ.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Sequence USIM_MLV_ID_SEQ does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_MLV_ID_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../SEQUENCES/DROP_USIM_PLANCK_TIME_SEQ.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Sequence USIM_PLANCK_TIME_SEQ does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_PLANCK_TIME_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../SEQUENCES/DROP_USIM_PLANCK_AEON_SEQ.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Sequence USIM_PLANCK_AEON_SEQ does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_PLANCK_AEON_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../SEQUENCES/DROP_USIM_DIM_ID_SEQ.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Sequence USIM_DIM_ID_SEQ does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_DIM_ID_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../SEQUENCES/DROP_USIM_TSU_ID_SEQ.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Sequence USIM_TSU_ID_SEQ does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_TSU_ID_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../SEQUENCES/DROP_USIM_POS_ID_SEQ.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Sequence USIM_POS_ID_SEQ does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_POS_ID_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../SEQUENCES/DROP_USIM_RMDP_ID_SEQ.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Sequence USIM_RMDP_ID_SEQ does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_RMDP_ID_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
--== sequences end ==--

--== foreign keys drop for easy delete start ==--
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../FK/DROP_USIM_DIM_MLV_FK.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Foreign key USIM_DIM_MLV_FK does not exist."'
       END AS SCRIPTFILE
  FROM user_constraints
 WHERE constraint_type  = 'R'
   AND table_name       = 'USIM_DIMENSION'
   AND constraint_name  = 'USIM_DIM_MLV_FK'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../FK/DROP_USIM_RMDP_DIM_FK.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Foreign key USIM_RMDP_DIM_FK does not exist."'
       END AS SCRIPTFILE
  FROM user_constraints
 WHERE constraint_type  = 'R'
   AND table_name       = 'USIM_REL_MLV_DIM_POS'
   AND constraint_name  = 'USIM_RMDP_DIM_FK'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../FK/DROP_USIM_RMDP_POS_FK.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Foreign key USIM_RMDP_POS_FK does not exist."'
       END AS SCRIPTFILE
  FROM user_constraints
 WHERE constraint_type  = 'R'
   AND table_name       = 'USIM_REL_MLV_DIM_POS'
   AND constraint_name  = 'USIM_RMDP_POS_FK'
;
@@&SCRIPTFILE
--== foreign keys drop for easy delete end ==--

--== drop views start ==--
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../VIEW/DROP_USIM_RMDP_V.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Foreign key USIM_RMDP_V does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_type = 'VIEW'
   AND object_name = 'USIM_RMDP_V'
;
@@&SCRIPTFILE
--== drop views end ==--

--== debug tables start ==--
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../TABLES/DROP_USIM_DEBUG_LOG_TBL.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Table USIM_DEBUG_LOG does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_DEBUG_LOG'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
--== debug tables end ==--

--== debug package start ==--
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP_USIM_DEBUG_PKB.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package body USIM_DEBUG does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_DEBUG'
   AND object_type = 'PACKAGE BODY'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP_USIM_DEBUG_PKS.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package header USIM_DEBUG does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_DEBUG'
   AND object_type = 'PACKAGE'
;
@@&SCRIPTFILE
--== debug package end ==--

--== test tables start ==--
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../TABLES/DROP_USIM_TEST_SUMMARY_TBL.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Table USIM_TEST_SUMMARY does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_TEST_SUMMARY'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../TABLES/DROP_USIM_TEST_ERRORS_TBL.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Table USIM_TEST_ERRORS does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_TEST_ERRORS'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
--== test tables end ==--

--== test package start ==--
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP_USIM_TEST_PKB.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package body USIM_TEST does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_TEST'
   AND object_type = 'PACKAGE BODY'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP_USIM_TEST_PKS.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package header USIM_TEST does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_TEST'
   AND object_type = 'PACKAGE'
;
@@&SCRIPTFILE
--== test package end ==--

--== base data start ==--
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP_USIM_BASE_PKB.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package body USIM_BASE does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_BASE'
   AND object_type = 'PACKAGE BODY'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP_USIM_BASE_PKS.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package header USIM_BASE does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_BASE'
   AND object_type = 'PACKAGE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../TABLES/DROP_USIM_BASEDATA_TBL.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Table USIM_BASEDATA does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_BASEDATA'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
--== base data end ==--

--== base tables start ==--
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP_USIM_MLV_PKB.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package body USIM_MLV does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_MLV'
   AND object_type = 'PACKAGE BODY'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP_USIM_MLV_PKS.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package header USIM_MLV does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_MLV'
   AND object_type = 'PACKAGE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../TABLES/DROP_USIM_MULTIVERSE_TBL.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Table USIM_MULTIVERSE does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_MULTIVERSE'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP_USIM_DIM_PKB.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package body USIM_DIM does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_DIM'
   AND object_type = 'PACKAGE BODY'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP_USIM_DIM_PKS.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package header USIM_DIM does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_DIM'
   AND object_type = 'PACKAGE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../TABLES/DROP_USIM_DIMENSION_TBL.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Table USIM_DIMENSION does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_DIMENSION'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP_USIM_POS_PKB.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package body USIM_POS does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_POS'
   AND object_type = 'PACKAGE BODY'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP_USIM_POS_PKS.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package header USIM_POS does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_POS'
   AND object_type = 'PACKAGE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../TABLES/DROP_USIM_POSITION_TBL.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Table USIM_POSITION does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_POSITION'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
--== base tables end ==--

--== relation tables start ==--
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../TABLES/DROP_USIM_REL_MLV_DIM_POS_TBL.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Table USIM_REL_MLV_DIM_POS does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_REL_MLV_DIM_POS'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
--== relation tables end ==--



-- empty recycle bin
PURGE recyclebin;
