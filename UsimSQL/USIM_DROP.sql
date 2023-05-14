-- drop basic packages
DROP PACKAGE BODY usim_static;
DROP PACKAGE usim_static;
DROP PACKAGE BODY usim_utility;
DROP PACKAGE usim_utility;
DROP PACKAGE BODY usim_ctrl;
DROP PACKAGE usim_ctrl;

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
-- drop foreign key constraints
ALTER TABLE usim_pdp_parent DROP CONSTRAINT usim_pdr_pdp_fk;
ALTER TABLE usim_pdp_parent DROP CONSTRAINT usim_pdr_parent_fk;
ALTER TABLE usim_pdp_childs DROP CONSTRAINT usim_pdc_pdp_fk;
ALTER TABLE usim_pdp_childs DROP CONSTRAINT usim_pdc_child_fk;
ALTER TABLE usim_overflow DROP CONSTRAINT usim_ovr_pdp_fk;
ALTER TABLE usim_dim_point DROP CONSTRAINT usim_dpo_poi_fk;
ALTER TABLE usim_dim_point DROP CONSTRAINT usim_dpo_dim_fk;
ALTER TABLE usim_poi_dim_position DROP CONSTRAINT usim_pdp_psc_fk;
ALTER TABLE usim_poi_dim_position DROP CONSTRAINT usim_pdp_dpo_fk;
ALTER TABLE usim_poi_dim_position DROP CONSTRAINT usim_pdp_pos_fk;
ALTER TABLE usim_point_h DROP CONSTRAINT usim_hpoi_poi_fk;
-- reverse order for tables
DROP TABLE usim_poi_structure;
DROP TABLE usim_pdp_parent;
DROP TABLE usim_pdp_childs;
DROP TABLE usim_poi_dim_position;
DROP TABLE usim_dim_point;
DROP TABLE usim_overflow;
DROP TABLE usim_point;
DROP TABLE usim_position;
DROP TABLE usim_dimension;
DROP TABLE usim_point_h;
DROP TABLE usim_output;
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
-- drop trigger package
DROP PACKAGE BODY usim_trg;
DROP PACKAGE usim_trg;
