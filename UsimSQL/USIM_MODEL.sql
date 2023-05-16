SET ECHO OFF
SET VERIFY OFF
--== drop section start ==--
@@USIM_DROP.sql
--== drop section end ==--

--== create table independent sequences start ==--
@@USIM_PLANCK_TIME_SEQ.sql
--== create table independent sequences end ==--

--== create static packages section start ==--
@@USIM_STATIC.pks
@@USIM_STATIC.pkb
--== create static packages section end ==--

--== create section, basic table definitions and prefill start ==--
-- USIM_DIMENSION (dim)
@@USIM_DIMENSION_TBL.sql
-- provide dimensions 0 - 4
@@USIM_DIMENSION_INS.sql

-- USIM_POSITION (pos)
@@USIM_POSITION_TBL.sql
-- provide 0, 1, -1
@@USIM_POSITION_INS.sql

-- USIM_POINT (poi)
@@USIM_POINT_TBL.sql

-- USIM_OVERFLOW (ovr)
@@USIM_OVERFLOW_TBL.sql

-- USIM_POI_HISTORY (phis)
@@USIM_POI_HISTORY_TBL.sql

-- USIM_POI_STRUCTURE (psc)
@@USIM_POI_STRUCTURE_TBL.sql
-- provide basic point structure
@@USIM_POI_STRUCTURE_INS.sql
--== create section, basic table definitions and prefill end ==--

--== create section, relations table definitions start ==--
-- USIM_DIM_POINT (dpo)
@@USIM_DIM_POINT_TBL.sql

-- USIM_POI_DIM_POSITION (pdp)
@@USIM_POI_DIM_POSITION_TBL.sql

-- USIM_PDP_CHILDS (pdc)
@@USIM_PDP_CHILDS_TBL.sql

-- USIM_PDP_PARENT (pdr)
@@USIM_PDP_PARENT_TBL.sql

-- USIM_POINT_H (hpoi)
@@USIM_POINT_H_TBL.sql

-- USIM_OUTPUT (outp)
@@USIM_OUTPUT_TBL.sql
--== create section, relations table definitions end ==--

--== create foreign keys start ==--
-- USIM_OVERFLOW (ovr)
@@USIM_OVERFLOW_FK.sql

-- USIM_DIM_POINT (dpo)
@@USIM_DIM_POINT_FK.sql

-- USIM_POI_DIM_POSITION
@@USIM_POI_DIM_POSITION_FK.sql

-- USIM_PDP_CHILDS (pdc)
@@USIM_PDP_CHILDS_FK.sql

-- USIM_PDP_PARENT (pdr)
@@USIM_PDP_PARENT_FK.sql

-- USIM_POINT_H (hpoi)
@@USIM_POINT_H_FK.sql
--== create foreign keys end ==--

--== create utility package start ==--
@@USIM_UTILITY.pks
@@USIM_UTILITY.pkb
--== create utility package end ==--

--== create views start ==--
-- USIM_POI_DIM_POSITION_V (pdpv)
@@USIM_POI_DIM_POSITION_V.sql

-- USIM_TREE_NODES_V (tnv)
@@USIM_TREE_NODES_V.sql

-- USIM_TREE_CHECK_V (tcv)
@@USIM_TREE_CHECK_V.sql

-- USIM_RELATIONS_BASE_V (relbv)
@@USIM_RELATIONS_BASE_V.sql
--== create views end ==--

--== create views depending on views start ==--
-- USIM_RELATIONS_V (relv)
@@USIM_RELATIONS_V.sql

-- USIM_POI_RELATIONS_V (relpv)
@@USIM_POI_RELATIONS_V.sql

-- USIM_ENERGY_STATE (ensv)
@@USIM_ENERGY_STATE_V.sql

-- USIM_OUTPUT_V (outpv)
@@USIM_OUTPUT_V.sql
--== create views depending on views end ==--

--== create trigger package start ==--
@@USIM_TRG.pks
@@USIM_TRG.pkb
--== create trigger package end ==--

--== create insert views start ==--
-- USIM_POINT_INSERT_V (poiv)
@@USIM_POINT_INSERT_V.sql
--== create insert views end ==--

--== create other packages start ==--
@@USIM_CTRL.pks
@@USIM_CTRL.pkb
--== create other packages end ==--

-- initialize the planck time
SELECT usim_planck_time_seq.NEXTVAL FROM dual;

-- insert base points
@@USIM_POINT_INS.sql
-- insert first action on start point
@@USIM_OUTPUT_INS.sql

