SET ECHO OFF
SET VERIFY OFF
ALTER SESSION SET NLS_LENGTH_SEMANTICS = 'CHAR';
--== drop section start ==--
@@USIM_DROP.sql
--== drop section end ==--

--== create static packages section start ==--
@@PACKAGES/USIM_STATIC.pks
@@PACKAGES/USIM_STATIC.pkb
--== create static packages section end ==--

--== create section, basic table definitions and prefill start ==--
-- USIM_POI_STRUCTURE (psc)
@@TABLES/USIM_POI_STRUCTURE_TBL.sql
-- provide basic point structure
@@INS/USIM_POI_STRUCTURE_INS.sql

-- USIM_DIMENSION (dim)
@@TABLES/USIM_DIMENSION_TBL.sql
-- provide dimensions 0 - 4
@@INS/USIM_DIMENSION_INS.sql

-- USIM_POSITION (pos)
@@TABLES/USIM_POSITION_TBL.sql
-- provide 0
@@INS/USIM_POSITION_INS.sql

-- USIM_POINT (poi)
@@TABLES/USIM_POINT_TBL.sql

-- USIM_PLANCK_TIME (plt)
@@TABLES/USIM_PLANCK_TIME_TBL.sql
-- initialize without setting sequence
@@INS/USIM_PLANCK_TIME_INS.sql
--== create section, basic table definitions and prefill end ==--

--== create section, relations table definitions start ==--
-- USIM_DIM_POINT (dpo)
@@TABLES/USIM_DIM_POINT_TBL.sql

-- USIM_POI_DIM_POSITION (pdp)
@@TABLES/USIM_POI_DIM_POSITION_TBL.sql

-- USIM_PDP_CHILDS (pdc)
@@TABLES/USIM_PDP_CHILDS_TBL.sql

-- USIM_PDP_PARENT (pdr)
@@TABLES/USIM_PDP_PARENT_TBL.sql

-- USIM_OUTPUT (outp)
@@TABLES/USIM_OUTPUT_TBL.sql

-- USIM_OVERFLOW (ovr)
@@TABLES/USIM_OVERFLOW_TBL.sql

-- USIM_POI_HISTORY (phis)
@@TABLES/USIM_POI_HISTORY_TBL.sql
--== create section, relations table definitions end ==--

--== create foreign keys start ==--
-- USIM_DIM_POINT (dpo)
@@FK/USIM_DIM_POINT_FK.sql

-- USIM_POI_DIM_POSITION
@@FK/USIM_POI_DIM_POSITION_FK.sql

-- USIM_PDP_CHILDS (pdc)
@@FK/USIM_PDP_CHILDS_FK.sql

-- USIM_PDP_PARENT (pdr)
@@FK/USIM_PDP_PARENT_FK.sql
--== create foreign keys end ==--

--== create utility package start ==--
@@PACKAGES/USIM_UTILITY.pks
@@PACKAGES/USIM_UTILITY.pkb
--== create utility package end ==--

--== create views start ==--
-- USIM_POSITION_V (posv)
@@VIEWS\USIM_POSITION_V.sql
-- USIM_POI_DIM_POSITION_V (pdpv)
@@VIEWS\USIM_POI_DIM_POSITION_V.sql

-- USIM_TREE_NODES_V (tnv)
@@VIEWS\USIM_TREE_NODES_V.sql

-- USIM_DIM_ATTRIBUTES_V (datv)
@@VIEWS\USIM_DIM_ATTRIBUTES_V.sql

-- USIM_TREE_CHECK_V (tcv)
@@VIEWS\USIM_TREE_CHECK_V.sql

-- USIM_RELATIONS_BASE_V (relbv)
@@VIEWS\USIM_RELATIONS_BASE_V.sql
--== create views end ==--

--== create views depending on views start ==--
-- USIM_RELATIONS_V (relv)
@@VIEWS\USIM_RELATIONS_V.sql

-- USIM_POI_RELATIONS_V (relpv)
@@VIEWS\USIM_POI_RELATIONS_V.sql

-- USIM_ENERGY_STATE (ensv)
@@VIEWS\USIM_ENERGY_STATE_V.sql

-- USIM_OUTPUT_V (outpv)
@@VIEWS\USIM_OUTPUT_V.sql

-- USIM_POI_MIRROR_V (poim)
@@VIEWS\USIM_POI_MIRROR_V.sql

-- USIM_OVERFLOW_V (ovrv)
@@VIEWS\USIM_OVERFLOW_V.sql
--== create views depending on views end ==--

--== create trigger package start ==--
@@PACKAGES/USIM_TRG.pks
@@PACKAGES/USIM_TRG.pkb
--== create trigger package end ==--

--== create insert views start ==--
-- USIM_POINT_INSERT_V (poiv)
@@VIEWS\USIM_POINT_INSERT_V.sql
--== create insert views end ==--

--== create other packages start ==--
@@PACKAGES/USIM_CTRL.pks
@@PACKAGES/USIM_CTRL.pkb
--== create other packages end ==--

-- insert base points
@@INS/USIM_POINT_INS.sql
-- insert first action on start point
@@INS/USIM_OUTPUT_INS.sql

