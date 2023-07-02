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
-- USIM_REL_MLV_DIM_POS (rmdp) sequence
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../SEQUENCES/USIM_RMDP_ID_SEQ.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Sequence USIM_RMDP_ID_SEQ still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_RMDP_ID_SEQ'
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
@@../FK/USIM_DIM_MLV_FK.sql
-- usim_dimension package
@@../PACKAGES/USIM_DIM.pks
@@../PACKAGES/USIM_DIM.pkb
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
--== base tables end ==--

--== relation tables start ==--
-- USIM_REL_MLV_DIM_POS (rmdp)
SELECT CASE
         WHEN COUNT(*) = 0
         THEN '../TABLES/USIM_REL_MLV_DIM_POS_TBL.sql'
         ELSE '../UTIL/EXIT_SCRIPT_WITH_ERROR.sql "Table USIM_REL_MLV_DIM_POS still exists."'
       END AS SCRIPTFILE
  FROM user_objects
 WHERE object_name = 'USIM_REL_MLV_DIM_POS'
   AND object_type = 'TABLE'
;
@@&SCRIPTFILE
-- foreign keys
@@../FK/USIM_RMDP_DIM_FK.sql
@@../FK/USIM_RMDP_POS_FK.sql
-- views
@@../VIEW/USIM_RMDP_V.sql
--== relation tables end ==--
