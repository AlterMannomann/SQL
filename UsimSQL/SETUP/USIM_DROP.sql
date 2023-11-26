
SELECT 'Remove all USIM objects if needed.' AS info FROM dual;
--== basic packages start ==--
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_STATIC_PKB.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package body USIM_STATIC does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_STATIC'
   AND object_type = 'PACKAGE BODY'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_STATIC_PKS.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package header USIM_STATIC does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_STATIC'
   AND object_type = 'PACKAGE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_MATHS_PKB.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package body USIM_MATHS does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_MATHS'
   AND object_type = 'PACKAGE BODY'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_MATHS_PKS.sql'
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
         THEN '../SEQUENCES/DROP/DROP_USIM_DLG_ID_SEQ.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Sequence USIM_DLG_ID_SEQ does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_DLG_ID_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../SEQUENCES/DROP/DROP_USIM_ERL_TICK_SEQ.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Sequence USIM_ERL_TICK_SEQ does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_ERL_TICK_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../SEQUENCES/DROP/DROP_USIM_MLV_ID_SEQ.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Sequence USIM_MLV_ID_SEQ does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_MLV_ID_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../SEQUENCES/DROP/DROP_USIM_PLANCK_TIME_SEQ.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Sequence USIM_PLANCK_TIME_SEQ does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_PLANCK_TIME_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../SEQUENCES/DROP/DROP_USIM_PLANCK_AEON_SEQ.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Sequence USIM_PLANCK_AEON_SEQ does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_PLANCK_AEON_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../SEQUENCES/DROP/DROP_USIM_DIM_ID_SEQ.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Sequence USIM_DIM_ID_SEQ does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_DIM_ID_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../SEQUENCES/DROP/DROP_USIM_TSU_ID_SEQ.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Sequence USIM_TSU_ID_SEQ does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_TSU_ID_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../SEQUENCES/DROP/DROP_USIM_POS_ID_SEQ.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Sequence USIM_POS_ID_SEQ does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_POS_ID_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../SEQUENCES/DROP/DROP_USIM_NOD_ID_SEQ.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Sequence USIM_NOD_ID_SEQ does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_NOD_ID_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../SEQUENCES/DROP/DROP_USIM_RMD_ID_SEQ.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Sequence USIM_RMD_ID_SEQ does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_RMD_ID_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../SEQUENCES/DROP/DROP_USIM_SPC_ID_SEQ.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Sequence USIM_SPC_ID_SEQ does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_SPC_ID_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../SEQUENCES/DROP/DROP_USIM_SPR_ID_SEQ.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Sequence USIM_SPR_ID_SEQ does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_SPR_ID_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
--== sequences end ==--

--== foreign keys drop for easy delete start ==--
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../FK/DROP/DROP_USIM_RMD_MLV_FK.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Foreign key USIM_RMD_MLV_FK does not exist."'
       END AS SCRIPTFILE
  FROM user_constraints
 WHERE constraint_type  = 'R'
   AND table_name       = 'USIM_REL_MLV_DIM'
   AND constraint_name  = 'USIM_RMD_MLV_FK'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../FK/DROP/DROP_USIM_RMD_DIM_FK.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Foreign key USIM_RMD_DIM_FK does not exist."'
       END AS SCRIPTFILE
  FROM user_constraints
 WHERE constraint_type  = 'R'
   AND table_name       = 'USIM_REL_MLV_DIM'
   AND constraint_name  = 'USIM_RMD_DIM_FK'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../FK/DROP/DROP_USIM_RCHI_PARENT_FK.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Foreign key USIM_RCHI_PARENT_FK does not exist."'
       END AS SCRIPTFILE
  FROM user_constraints
 WHERE constraint_type  = 'R'
   AND table_name       = 'USIM_RMD_CHILD'
   AND constraint_name  = 'USIM_RCHI_PARENT_FK'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../FK/DROP/DROP_USIM_RCHI_CHILD_FK.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Foreign key USIM_RCHI_CHILD_FK does not exist."'
       END AS SCRIPTFILE
  FROM user_constraints
 WHERE constraint_type  = 'R'
   AND table_name       = 'USIM_RMD_CHILD'
   AND constraint_name  = 'USIM_RCHI_CHILD_FK'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../FK/DROP/DROP_USIM_SPC_POS_FK.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Foreign key USIM_SPC_POS_FK does not exist."'
       END AS SCRIPTFILE
  FROM user_constraints
 WHERE constraint_type  = 'R'
   AND table_name       = 'USIM_SPACE'
   AND constraint_name  = 'USIM_SPC_POS_FK'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../FK/DROP/DROP_USIM_SPC_NOD_FK.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Foreign key USIM_SPC_NOD_FK does not exist."'
       END AS SCRIPTFILE
  FROM user_constraints
 WHERE constraint_type  = 'R'
   AND table_name       = 'USIM_SPACE'
   AND constraint_name  = 'USIM_SPC_NOD_FK'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../FK/DROP/DROP_USIM_SPC_RMD_FK.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Foreign key USIM_SPC_RMD_FK does not exist."'
       END AS SCRIPTFILE
  FROM user_constraints
 WHERE constraint_type  = 'R'
   AND table_name       = 'USIM_SPACE'
   AND constraint_name  = 'USIM_SPC_RMD_FK'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../FK/DROP/DROP_USIM_CHI_PARENT_FK.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Foreign key USIM_CHI_PARENT_FK does not exist."'
       END AS SCRIPTFILE
  FROM user_constraints
 WHERE constraint_type  = 'R'
   AND table_name       = 'USIM_SPC_CHILD'
   AND constraint_name  = 'USIM_CHI_PARENT_FK'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../FK/DROP/DROP_USIM_CHI_CHILD_FK.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Foreign key USIM_CHI_CHILD_FK does not exist."'
       END AS SCRIPTFILE
  FROM user_constraints
 WHERE constraint_type  = 'R'
   AND table_name       = 'USIM_SPC_CHILD'
   AND constraint_name  = 'USIM_CHI_CHILD_FK'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../FK/DROP/DROP_USIM_SPO_SPC_FK.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Foreign key USIM_SPO_SPC_FK does not exist."'
       END AS SCRIPTFILE
  FROM user_constraints
 WHERE constraint_type  = 'R'
   AND table_name       = 'USIM_SPC_POS'
   AND constraint_name  = 'USIM_SPO_SPC_FK'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../FK/DROP/DROP_USIM_SPO_RMD_FK.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Foreign key USIM_SPO_RMD_FK does not exist."'
       END AS SCRIPTFILE
  FROM user_constraints
 WHERE constraint_type  = 'R'
   AND table_name       = 'USIM_SPC_POS'
   AND constraint_name  = 'USIM_SPO_RMD_FK'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../FK/DROP/DROP_USIM_SPO_POS_FK.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Foreign key USIM_SPO_POS_FK does not exist."'
       END AS SCRIPTFILE
  FROM user_constraints
 WHERE constraint_type  = 'R'
   AND table_name       = 'USIM_SPC_POS'
   AND constraint_name  = 'USIM_SPO_POS_FK'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../FK/DROP/DROP_USIM_SPR_SRC_FK.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Foreign key USIM_SPR_SRC_FK does not exist."'
       END AS SCRIPTFILE
  FROM user_constraints
 WHERE constraint_type  = 'R'
   AND table_name       = 'USIM_SPC_PROCESS'
   AND constraint_name  = 'USIM_SPR_SRC_FK'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../FK/DROP/DROP_USIM_SPR_TGT_FK.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Foreign key USIM_SPR_TGT_FK does not exist."'
       END AS SCRIPTFILE
  FROM user_constraints
 WHERE constraint_type  = 'R'
   AND table_name       = 'USIM_SPC_PROCESS'
   AND constraint_name  = 'USIM_SPR_TGT_FK'
;
@@&SCRIPTFILE
--== foreign keys drop for easy delete end ==--

--== drop views start ==--
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../VIEW/DROP/DROP_USIM_RMD_V.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "View USIM_RMD_V does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_type = 'VIEW'
   AND object_name = 'USIM_RMD_V'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../VIEW/DROP/DROP_USIM_SPC_CHI_V.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "View USIM_SPC_CHI_V does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_type = 'VIEW'
   AND object_name = 'USIM_SPC_CHI_V'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../VIEW/DROP/DROP_USIM_SPC_V.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "View USIM_SPC_V does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_type = 'VIEW'
   AND object_name = 'USIM_SPC_V'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../VIEW/DROP/DROP_USIM_CHI_V.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "View USIM_CHI_V does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_type = 'VIEW'
   AND object_name = 'USIM_CHI_V'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../VIEW/DROP/DROP_USIM_SPO_V.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "View USIM_SPO_V does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_type = 'VIEW'
   AND object_name = 'USIM_SPO_V'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../VIEW/DROP/DROP_USIM_SPO_XYZ_V.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "View USIM_SPO_XYZ_V does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_type = 'VIEW'
   AND object_name = 'USIM_SPO_XYZ_V'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../VIEW/DROP/DROP_USIM_SPO_BASE3D_V.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "View USIM_SPO_BASE3D_V does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_type = 'VIEW'
   AND object_name = 'USIM_SPO_BASE3D_V'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../VIEW/DROP/DROP_USIM_SPO_ZERO3D_V.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "View USIM_SPO_ZERO3D_V does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_type = 'VIEW'
   AND object_name = 'USIM_SPO_ZERO3D_V'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../VIEW/DROP/DROP_USIM_SPR_V.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "View USIM_SPR_V does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_type = 'VIEW'
   AND object_name = 'USIM_SPR_V'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../VIEW/DROP/DROP_USIM_MLV_STATE_V.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "View USIM_MLV_STATE_V does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_type = 'VIEW'
   AND object_name = 'USIM_MLV_STATE_V'
;
@@&SCRIPTFILE
--== drop views end ==--

--== debug tables start ==--
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../TABLES/DROP/DROP_USIM_DEBUG_LOG_TBL.sql'
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
         THEN '../PACKAGES/DROP/DROP_USIM_DEBUG_PKB.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package body USIM_DEBUG does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_DEBUG'
   AND object_type = 'PACKAGE BODY'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_DEBUG_PKS.sql'
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
         THEN '../TABLES/DROP/DROP_USIM_TEST_SUMMARY_TBL.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Table USIM_TEST_SUMMARY does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_TEST_SUMMARY'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../TABLES/DROP/DROP_USIM_TEST_ERRORS_TBL.sql'
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
         THEN '../PACKAGES/DROP/DROP_USIM_TEST_PKB.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package body USIM_TEST does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_TEST'
   AND object_type = 'PACKAGE BODY'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_TEST_PKS.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package header USIM_TEST does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_TEST'
   AND object_type = 'PACKAGE'
;
@@&SCRIPTFILE
--== test package end ==--

--== packages depending on tables start ==--
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_ERL_PKB.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package body USIM_ERL does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_ERL'
   AND object_type = 'PACKAGE BODY'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_ERL_PKS.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package header USIM_ERL does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_ERL'
   AND object_type = 'PACKAGE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_BASE_PKB.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package body USIM_BASE does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_BASE'
   AND object_type = 'PACKAGE BODY'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_BASE_PKS.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package header USIM_BASE does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_BASE'
   AND object_type = 'PACKAGE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_MLV_PKB.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package body USIM_MLV does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_MLV'
   AND object_type = 'PACKAGE BODY'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_MLV_PKS.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package header USIM_MLV does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_MLV'
   AND object_type = 'PACKAGE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_DIM_PKB.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package body USIM_DIM does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_DIM'
   AND object_type = 'PACKAGE BODY'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_DIM_PKS.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package header USIM_DIM does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_DIM'
   AND object_type = 'PACKAGE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_POS_PKB.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package body USIM_POS does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_POS'
   AND object_type = 'PACKAGE BODY'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_POS_PKS.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package header USIM_POS does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_POS'
   AND object_type = 'PACKAGE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_NOD_PKB.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package body USIM_NOD does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_NOD'
   AND object_type = 'PACKAGE BODY'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_NOD_PKS.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package header USIM_NOD does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_NOD'
   AND object_type = 'PACKAGE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_RMD_PKB.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package body USIM_RMD does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_RMD'
   AND object_type = 'PACKAGE BODY'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_RMD_PKS.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package header USIM_RMD does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_RMD'
   AND object_type = 'PACKAGE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_SPC_PKB.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package body USIM_SPC does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_SPC'
   AND object_type = 'PACKAGE BODY'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_SPC_PKS.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package header USIM_SPC does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_SPC'
   AND object_type = 'PACKAGE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_CHI_PKB.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package body USIM_CHI does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_CHI'
   AND object_type = 'PACKAGE BODY'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_CHI_PKS.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package header USIM_CHI does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_CHI'
   AND object_type = 'PACKAGE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_SPO_PKB.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package body USIM_SPO does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_SPO'
   AND object_type = 'PACKAGE BODY'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_SPO_PKS.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package header USIM_SPO does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_SPO'
   AND object_type = 'PACKAGE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_SPR_PKB.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package body USIM_SPR does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_SPR'
   AND object_type = 'PACKAGE BODY'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_SPR_PKS.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package header USIM_SPR does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_SPR'
   AND object_type = 'PACKAGE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_CREATOR_PKB.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package body USIM_CREATOR does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_CREATOR'
   AND object_type = 'PACKAGE BODY'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_CREATOR_PKS.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package header USIM_CREATOR does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_CREATOR'
   AND object_type = 'PACKAGE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_PROCESS_PKB.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package body USIM_PROCESS does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_PROCESS'
   AND object_type = 'PACKAGE BODY'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_PROCESS_PKS.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package header USIM_PROCESS does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_PROCESS'
   AND object_type = 'PACKAGE'
;
@@&SCRIPTFILE


SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_DBIF_PKB.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package body USIM_DBIF does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_DBIF'
   AND object_type = 'PACKAGE BODY'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../PACKAGES/DROP/DROP_USIM_DBIF_PKS.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Package header USIM_DBIF does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_DBIF'
   AND object_type = 'PACKAGE'
;
@@&SCRIPTFILE
--== packages depending on tables end ==--

--== base data start ==--
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../TABLES/DROP/DROP_USIM_BASEDATA_TBL.sql'
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
         THEN '../TABLES/DROP/DROP_USIM_ERROR_LOG_TBL.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Table USIM_ERROR_LOG does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_ERROR_LOG'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../TABLES/DROP/DROP_USIM_MULTIVERSE_TBL.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Table USIM_MULTIVERSE does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_MULTIVERSE'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../TABLES/DROP/DROP_USIM_DIMENSION_TBL.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Table USIM_DIMENSION does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_DIMENSION'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../TABLES/DROP/DROP_USIM_POSITION_TBL.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Table USIM_POSITION does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_POSITION'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../TABLES/DROP/DROP_USIM_NODE_TBL.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Table USIM_NODE does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_NODE'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
--== base tables end ==--

--== relation tables start ==--
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../TABLES/DROP/DROP_USIM_REL_MLV_DIM_TBL.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Table USIM_REL_MLV_DIM does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_REL_MLV_DIM'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../TABLES/DROP/DROP_USIM_RMD_CHILD_TBL.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Table USIM_RMD_CHILD does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_RMD_CHILD'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../TABLES/DROP/DROP_USIM_SPACE_TBL.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Table USIM_SPACE does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_SPACE'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../TABLES/DROP/DROP_USIM_SPC_CHILD_TBL.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Table USIM_SPC_CHILD does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_SPC_CHILD'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../TABLES/DROP/DROP_USIM_SPC_POS_TBL.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Table USIM_SPC_POS does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_SPC_POS'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
SELECT CASE
         WHEN COUNT(*) > 0
         THEN '../TABLES/DROP/DROP_USIM_SPC_PROCESS_TBL.sql'
         ELSE '../UTIL/NOTHING_TO_DO.sql "Table USIM_SPC_PROCESS does not exist."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_SPC_PROCESS'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
--== relation tables end ==--

--== log tables start ==--
--== log tables end ==--


-- empty recycle bin
PURGE recyclebin;
