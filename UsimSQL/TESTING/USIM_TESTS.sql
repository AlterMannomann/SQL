SELECT 'Execute tests on USIM model.' AS info FROM dual;
-- do not keep old results
DELETE usim_test_errors;
DELETE usim_test_summary;
COMMIT;
@@TEST_USIM_STATIC.sql
@@TEST_USIM_MATHS.sql
@@TEST_USIM_DEBUG.sql
@@TEST_USIM_BASEDATA.sql
@@TEST_USIM_BASE.sql
@@TEST_USIM_MULTIVERSE.sql
@@TEST_USIM_MLV.sql
@@TEST_USIM_DIMENSION.sql
@@TEST_USIM_DIM.sql
@@TEST_USIM_POSITION.sql
@@TEST_USIM_POS.sql
@@TEST_USIM_NODE.sql
@@TEST_USIM_NOD.sql
@@TEST_USIM_VOLUME.sql
@@TEST_USIM_VOL.sql
@@TEST_USIM_REL_MLV_DIM.sql
@@TEST_USIM_RMD.sql
@@TEST_USIM_REL_RMD_POS_NOD.sql
@@TEST_USIM_RRPN.sql
@@TEST_USIM_REL_VOL_MLV.sql
@@TEST_USIM_RVM.sql
