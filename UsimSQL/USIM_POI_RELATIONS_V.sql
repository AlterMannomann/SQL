-- USIM_POI_RELATIONS_V (relpv)
CREATE OR REPLACE FORCE VIEW usim_poi_relations_v AS
  SELECT pdpv.usim_point_name
       , pdpv.usim_energy
       , pdpv.usim_amplitude
       , pdpv.usim_wavelength
       , pdpv.usim_dimension
       , pdpv.usim_coordinate
       , pdpv.usim_coords
       , pdpv.pos_x
       , pdpv.pos_y
       , pdpv.pos_z
       , pdpv.usim_id_parent
       , pdpv.usim_id_child_left
       , pdpv.usim_id_child_right
       , pdpv.usim_id_poi
       , pdpv.usim_id_dim
       , pdpv.usim_id_dpo
       , pdpv.usim_id_pos
       , pdpv.usim_id_pdp
       , pdpv.usim_id_psc
       , pdpv.dpo_usim_id_poi
       , pdpv.dpo_usim_id_dim
       , pdpv.pdp_usim_id_dpo
       , pdpv.pdp_usim_id_pos
       , pdpv.pdr_usim_id_pdp
       , pdpv.pdc_usim_id_pdp
       , parentpoint.usim_id_poi AS usim_id_poi_parent
       , leftchild.usim_id_poi AS usim_id_poi_leftchild
       , rightchild.usim_id_poi AS usim_id_poi_rightchild
    FROM usim_poi_dim_position_v pdpv
    LEFT OUTER JOIN usim_poi_dim_position_v parentpoint
      ON pdpv.usim_id_parent = parentpoint.usim_id_pdp
    LEFT OUTER JOIN usim_poi_dim_position_v leftchild
      ON pdpv.usim_id_child_left = leftchild.usim_id_pdp
    LEFT OUTER JOIN usim_poi_dim_position_v rightchild
      ON pdpv.usim_id_child_right = rightchild.usim_id_pdp
;