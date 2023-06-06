-- drop basic packages
DROP PACKAGE BODY usim_static;
DROP PACKAGE usim_static;
DROP PACKAGE BODY usim_utility;
DROP PACKAGE usim_utility;
DROP PACKAGE BODY usim_ctrl;
DROP PACKAGE usim_ctrl;
DROP PACKAGE BODY usim_debug;
DROP PACKAGE usim_debug;

-- drop sequences
DROP SEQUENCE usim_dim_id_seq;
DROP SEQUENCE usim_pos_id_seq;
DROP SEQUENCE usim_poi_id_seq;
DROP SEQUENCE usim_psc_id_seq;
DROP SEQUENCE usim_dpo_id_seq;
DROP SEQUENCE usim_pdp_id_seq;
DROP SEQUENCE usim_pdc_id_seq;
DROP SEQUENCE usim_planck_time_seq;
DROP SEQUENCE usim_outp_id_seq;
DROP SEQUENCE usim_phis_id_seq;
DROP SEQUENCE usim_dlg_id_seq;
-- drop foreign key constraints
ALTER TABLE usim_pdp_parent DROP CONSTRAINT usim_pdr_pdp_fk;
ALTER TABLE usim_pdp_parent DROP CONSTRAINT usim_pdr_parent_fk;
ALTER TABLE usim_pdp_childs DROP CONSTRAINT usim_pdc_pdp_fk;
ALTER TABLE usim_pdp_childs DROP CONSTRAINT usim_pdc_child_fk;
ALTER TABLE usim_dim_point DROP CONSTRAINT usim_dpo_poi_fk;
ALTER TABLE usim_dim_point DROP CONSTRAINT usim_dpo_dim_fk;
ALTER TABLE usim_poi_dim_position DROP CONSTRAINT usim_pdp_psc_fk;
ALTER TABLE usim_poi_dim_position DROP CONSTRAINT usim_pdp_dpo_fk;
ALTER TABLE usim_poi_dim_position DROP CONSTRAINT usim_pdp_pos_fk;
-- reverse order for tables
DROP TABLE usim_poi_structure PURGE;
DROP TABLE usim_pdp_parent PURGE;
DROP TABLE usim_pdp_childs PURGE;
DROP TABLE usim_poi_dim_position PURGE;
DROP TABLE usim_dim_point PURGE;
DROP TABLE usim_overflow PURGE;
DROP TABLE usim_point PURGE;
DROP TABLE usim_position PURGE;
DROP TABLE usim_dimension PURGE;
DROP TABLE usim_output PURGE;
DROP TABLE usim_poi_history PURGE;
DROP TABLE usim_planck_time PURGE;
DROP TABLE usim_debug_log PURGE;
DROP TABLE usim_levels PURGE;
-- views
DROP VIEW usim_poi_dim_position_v;
DROP VIEW usim_point_insert_v;
DROP VIEW usim_tree_nodes_v;
DROP VIEW usim_tree_check_v;
DROP VIEW usim_relations_base_v;
DROP VIEW usim_relations_basex_v;
DROP VIEW usim_relations_v;
DROP VIEW usim_relationsx_v;
DROP VIEW usim_poi_relations_v;
DROP VIEW usim_energy_state_v;
DROP VIEW usim_output_v;
DROP VIEW usim_output_order_v;
DROP VIEW usim_poi_mirror_v;
DROP VIEW usim_overflow_v;
DROP VIEW usim_dim_attributes_v;
DROP VIEW usim_position_v;
DROP VIEW usim_dim_coord_limits_v;
-- drop trigger package
DROP PACKAGE BODY usim_trg;
DROP PACKAGE usim_trg;

-- empty recycle bin
PURGE recyclebin;

SELECT COUNT(*) AS objects_after_cleanup
  FROM user_objects
;
-- overview remaining objects after cleanup
SELECT object_type
     , COUNT(*) AS object_cnt
  FROM user_objects
 GROUP BY object_type
;
