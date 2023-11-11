SELECT 'Create or recreate USIM objects.' AS info FROM dual;
--== error logging start ==--
-- USIM_ERL_TICK_SEQ
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../SEQUENCES/USIM_ERL_TICK_SEQ.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Sequence USIM_ERL_TICK_SEQ still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_ERL_TICK_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
-- USIM_ERROR_LOG (erl)
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../TABLES/USIM_ERROR_LOG_TBL.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Table USIM_ERROR_LOG still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_ERROR_LOG'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
-- USIM_DLG_ID_SEQ
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
-- USIM_DEBUG_LOG (dlg)
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../TABLES/USIM_DEBUG_LOG_TBL.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Table USIM_DEBUG_LOG still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_DEBUG_LOG'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
-- error logging package
@@../PACKAGES/USIM_ERL.pks
@@../PACKAGES/USIM_ERL.pkb
@@../PACKAGES/USIM_DEBUG.pks
@@../PACKAGES/USIM_DEBUG.pkb
--== error logging end ==--

--== basic packages start ==--
@@../PACKAGES/USIM_STATIC.pks
@@../PACKAGES/USIM_STATIC.pkb
@@../PACKAGES/USIM_MATHS.pks
@@../PACKAGES/USIM_MATHS.pkb
--== basic packages end ==--

--== sequences start ==--
-- USIM_MULTIVERSE (mlv) sequence
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../SEQUENCES/USIM_MLV_ID_SEQ.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Sequence USIM_MLV_ID_SEQ still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_MLV_ID_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
-- USIM_PLANCK_TIME_SEQ
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../SEQUENCES/USIM_PLANCK_TIME_SEQ.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Sequence USIM_PLANCK_TIME_SEQ still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_PLANCK_TIME_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
-- USIM_PLANCK_AEON_SEQ
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../SEQUENCES/USIM_PLANCK_AEON_SEQ.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Sequence USIM_PLANCK_AEON_SEQ still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_PLANCK_AEON_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
-- USIM_DIMENSION (dim) sequence
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../SEQUENCES/USIM_DIM_ID_SEQ.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Sequence USIM_DIM_ID_SEQ still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_DIM_ID_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
-- USIM_POSITION (pos) sequence
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../SEQUENCES/USIM_POS_ID_SEQ.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Sequence USIM_POS_ID_SEQ still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_POS_ID_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
-- USIM_NODE (nod) sequence
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../SEQUENCES/USIM_NOD_ID_SEQ.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Sequence USIM_NOD_ID_SEQ still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_NOD_ID_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
-- USIM_REL_MLV_DIM (rmd) sequence
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../SEQUENCES/USIM_RMD_ID_SEQ.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Sequence USIM_RMD_ID_SEQ still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_RMD_ID_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
-- USIM_SPACE (spc)
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../SEQUENCES/USIM_SPC_ID_SEQ.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Sequence USIM_SPC_ID_SEQ still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_SPC_ID_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
-- USIM_SPC_PROCESS (spr)
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../SEQUENCES/USIM_SPR_ID_SEQ.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Sequence USIM_SPR_ID_SEQ still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_SPR_ID_SEQ'
   AND object_type = 'SEQUENCE'
;
@@&SCRIPTFILE
--== sequences end ==--

--== base data start ==--
-- USIM_BASEDATA (bda)
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../TABLES/USIM_BASEDATA_TBL.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Table USIM_BASEDATA still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_BASEDATA'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
-- base data package
@@../PACKAGES/USIM_BASE.pks
@@../PACKAGES/USIM_BASE.pkb
--== base data end ==--

--== base tables start ==--
-- USIM_MULTIVERSE (mlv)
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../TABLES/USIM_MULTIVERSE_TBL.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Table USIM_MULTIVERSE still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_MULTIVERSE'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
-- usim_multiverse package
@@../PACKAGES/USIM_MLV.pks
@@../PACKAGES/USIM_MLV.pkb
-- USIM_POSITION (pos)
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../TABLES/USIM_POSITION_TBL.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Table USIM_POSITION still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_POSITION'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
-- usim_position package
@@../PACKAGES/USIM_POS.pks
@@../PACKAGES/USIM_POS.pkb
-- USIM_DIMENSION (dim)
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../TABLES/USIM_DIMENSION_TBL.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Table USIM_DIMENSION still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_DIMENSION'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
-- usim_dimension package
@@../PACKAGES/USIM_DIM.pks
@@../PACKAGES/USIM_DIM.pkb
-- USIM_NODE (nod)
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../TABLES/USIM_NODE_TBL.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Table USIM_NODE still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_NODE'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
-- usim_node packages
@@../PACKAGES/USIM_NOD.pks
@@../PACKAGES/USIM_NOD.pkb
--== base tables end ==--

--== relation tables start ==--
-- USIM_REL_MLV_DIM (rmd)
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../TABLES/USIM_REL_MLV_DIM_TBL.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Table USIM_REL_MLV_DIM still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_REL_MLV_DIM'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
-- foreign keys
@@../FK/USIM_RMD_MLV_FK.sql
@@../FK/USIM_RMD_DIM_FK.sql
-- views
@@../VIEW/USIM_RMD_V.sql
-- usim_rel_mlv_dim package
@@../PACKAGES/USIM_RMD.pks
@@../PACKAGES/USIM_RMD.pkb
-- USIM_SPACE (spc)
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../TABLES/USIM_SPACE_TBL.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Table USIM_SPACE still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_SPACE'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
-- foreign keys
@@../FK/USIM_SPC_RMD_FK.sql
@@../FK/USIM_SPC_POS_FK.sql
@@../FK/USIM_SPC_NOD_FK.sql
--@@../FK/USIM_SPC_VOL_FK.sql
-- views
@@../VIEW/USIM_SPC_V.sql
-- usim_space package
@@../PACKAGES/USIM_SPC.pks
@@../PACKAGES/USIM_SPC.pkb
-- USIM_SPC_CHILD (chi)
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../TABLES/USIM_SPC_CHILD_TBL.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Table USIM_SPC_CHILD still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_SPC_CHILD'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
-- foreign keys
@@../FK/USIM_CHI_PARENT_FK.sql
@@../FK/USIM_CHI_CHILD_FK.sql
-- views
@@../VIEW/USIM_CHI_V.sql
@@../VIEW/USIM_SPC_CHI_V.sql
-- usim_spc_child package
@@../PACKAGES/USIM_CHI.pks
@@../PACKAGES/USIM_CHI.pkb
-- USIM_SPC_POS (spo)
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../TABLES/USIM_SPC_POS_TBL.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Table USIM_SPC_POS still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_SPC_POS'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
-- foreign keys
@@../FK/USIM_SPO_SPC_FK.sql
@@../FK/USIM_SPO_RMD_FK.sql
@@../FK/USIM_SPO_POS_FK.sql
-- views
@@../VIEW/USIM_SPO_V.sql
-- usim_spc_pos package
@@../PACKAGES/USIM_SPO.pks
@@../PACKAGES/USIM_SPO.pkb
-- package depend view
@@../VIEW/USIM_SPO_XYZ_V.sql
-- USIM_SPC_PROCESS (SPR)
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../TABLES/USIM_SPC_PROCESS_TBL.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Table USIM_SPC_PROCESS still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_SPC_PROCESS'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
-- foreign keys
@@../FK/USIM_SPR_SRC_FK.sql
@@../FK/USIM_SPR_TGT_FK.sql
-- views
@@../VIEW/USIM_SPR_V.sql
-- usim_spc_process package
@@../PACKAGES/USIM_SPR.pks
@@../PACKAGES/USIM_SPR.pkb
--== relation tables end ==--

--== other views start ==--
@@../VIEW/USIM_MLV_STATE_V.sql
--== other views end ==--

--== interface package start ==--
@@../PACKAGES/USIM_DBIF.pks
@@../PACKAGES/USIM_DBIF.pkb
--== interface package end ==--

--== processing packages start ==--
@@../PACKAGES/USIM_CREATOR.pks
@@../PACKAGES/USIM_CREATOR.pkb
@@../PACKAGES/USIM_PROCESS.pks
@@../PACKAGES/USIM_PROCESS.pkb
--== processing packages end ==--

