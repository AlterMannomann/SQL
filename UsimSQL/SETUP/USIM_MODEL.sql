SELECT 'Create or recreate USIM objects.' AS info FROM dual;
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
-- USIM_VOLUME (vol) sequence
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../SEQUENCES/USIM_VOL_ID_SEQ.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Sequence USIM_VOL_ID_SEQ still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_VOL_ID_SEQ'
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
-- USIM_REL_RMD_POS_NOD (rrpn)
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../SEQUENCES/USIM_RRPN_ID_SEQ.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Sequence USIM_RRPN_ID_SEQ still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_RRPN_ID_SEQ'
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
-- USIM_VOLUME (vol)
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../TABLES/USIM_VOLUME_TBL.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Table USIM_VOLUME still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_VOLUME'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
-- foreign keys
@@../FK/USIM_VOL_MLV_FK.sql
@@../FK/USIM_VOL_POS1_FK.sql
@@../FK/USIM_VOL_POS2_FK.sql
@@../FK/USIM_VOL_POS3_FK.sql
@@../FK/USIM_VOL_POS4_FK.sql
-- views
@@../VIEW/USIM_VOL_V.sql
@@../VIEW/USIM_VOL_JOIN_V.sql
-- usim_volume packages
@@../PACKAGES/USIM_VOL.pks
@@../PACKAGES/USIM_VOL.pkb
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
-- USIM_REL_RMD_POS_NOD (rrpn)
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../TABLES/USIM_REL_RMD_POS_NOD_TBL.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Table USIM_REL_RMD_POS_NOD still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_REL_RMD_POS_NOD'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
-- foreign keys
@@../FK/USIM_RRPN_RMD_FK.sql
@@../FK/USIM_RRPN_POS_FK.sql
@@../FK/USIM_RRPN_NOD_FK.sql
-- views
@@../VIEW/USIM_RRPN_V.sql
-- usim_rel_rmd_pos_nod package
@@../PACKAGES/USIM_RRPN.pks
@@../PACKAGES/USIM_RRPN.pkb

--== relation tables end ==--
