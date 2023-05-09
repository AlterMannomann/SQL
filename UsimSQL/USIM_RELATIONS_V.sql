-- USIM_RELATIONS_V (relv)
CREATE OR REPLACE FORCE VIEW usim_relations_v AS
  SELECT rbsv.usim_id_pdp1
       , rbsv.usim_id_pdp2
       , pdpv1.usim_point_name AS usim_id_point_name1
       , pdpv2.usim_point_name AS usim_id_point_name2
       , pdpv1.usim_dimension AS usim_dimension1
       , pdpv2.usim_dimension AS usim_dimension2
       , pdpv1.usim_coordinate AS usim_coordinate1
       , pdpv2.usim_coordinate AS usim_coordinate2
       , pdpv1.usim_coords AS usim_coords1
       , pdpv2.usim_coords AS usim_coords2
       , usim_utility.vector_distance(pdpv1.usim_coords, pdpv2.usim_coords) AS distance
       , pdpv1.usim_energy AS usim_energy1
       , pdpv2.usim_energy AS usim_energy2
       , pdpv1.usim_amplitude AS usim_amplitude1
       , pdpv2.usim_amplitude AS usim_amplitude2
       , pdpv1.usim_wavelength AS usim_wavelength1
       , pdpv2.usim_wavelength AS usim_wavelength2
       , pdpv1.usim_id_parent AS usim_id_parent1
       , pdpv2.usim_id_parent AS usim_id_parent2
       , pdpv1.usim_id_child_left AS usim_id_child_left1
       , pdpv2.usim_id_child_left AS usim_id_child_left2
       , pdpv1.usim_id_child_right AS usim_id_child_right1
       , pdpv2.usim_id_child_right AS usim_id_child_right2
       , pdpv1.usim_id_psc AS usim_id_psc1
       , pdpv2.usim_id_psc AS usim_id_psc2
       , pdpv1.usim_id_poi AS usim_id_poi1
       , pdpv2.usim_id_poi AS usim_id_poi2
       , pdpv1.usim_id_dim AS usim_id_dim1
       , pdpv2.usim_id_dim AS usim_id_dim2
       , pdpv1.usim_id_dpo AS usim_id_dpo1
       , pdpv2.usim_id_dpo AS usim_id_dpo2
       , pdpv1.usim_id_pos AS usim_id_pos1
       , pdpv2.usim_id_pos AS usim_id_pos2
    FROM usim_relations_base_v rbsv
    LEFT OUTER JOIN usim_poi_dim_position_v pdpv1
      ON rbsv.usim_id_pdp1 = pdpv1.usim_id_pdp
    LEFT OUTER JOIN usim_poi_dim_position_v pdpv2
      ON rbsv.usim_id_pdp2 = pdpv2.usim_id_pdp
;
COMMENT ON COLUMN usim_relations_v.distance IS 'Distance of unequal vectors, missing vector values (dimensions) are interpreted as 0. Calculated by euclidian distance rule.';
-- USIM_RELATIONSX_V (relxv)
CREATE OR REPLACE FORCE VIEW usim_relationsx_v AS
  SELECT rbsxv.usim_id_pdp_in
       , rbsxv.usim_id_pdp_out
       , pdpv1.usim_point_name AS usim_id_point_name1
       , pdpv2.usim_point_name AS usim_id_point_name2
       , pdpv1.usim_dimension AS usim_dimension1
       , pdpv2.usim_dimension AS usim_dimension2
       , pdpv1.usim_coordinate AS usim_coordinate1
       , pdpv2.usim_coordinate AS usim_coordinate2
       , pdpv1.usim_coords AS usim_coords1
       , pdpv2.usim_coords AS usim_coords2
       , usim_utility.vector_distance(pdpv1.usim_coords, pdpv2.usim_coords) AS distance
       , pdpv1.usim_energy AS usim_energy1
       , pdpv2.usim_energy AS usim_energy2
       , pdpv1.usim_amplitude AS usim_amplitude1
       , pdpv2.usim_amplitude AS usim_amplitude2
       , pdpv1.usim_wavelength AS usim_wavelength1
       , pdpv2.usim_wavelength AS usim_wavelength2
       , pdpv1.usim_id_parent AS usim_id_parent1
       , pdpv2.usim_id_parent AS usim_id_parent2
       , pdpv1.usim_id_child_left AS usim_id_child_left1
       , pdpv2.usim_id_child_left AS usim_id_child_left2
       , pdpv1.usim_id_child_right AS usim_id_child_right1
       , pdpv2.usim_id_child_right AS usim_id_child_right2
       , pdpv1.usim_id_psc AS usim_id_psc1
       , pdpv2.usim_id_psc AS usim_id_psc2
       , pdpv1.usim_id_poi AS usim_id_poi1
       , pdpv2.usim_id_poi AS usim_id_poi2
       , pdpv1.usim_id_dim AS usim_id_dim1
       , pdpv2.usim_id_dim AS usim_id_dim2
       , pdpv1.usim_id_dpo AS usim_id_dpo1
       , pdpv2.usim_id_dpo AS usim_id_dpo2
       , pdpv1.usim_id_pos AS usim_id_pos1
       , pdpv2.usim_id_pos AS usim_id_pos2
    FROM usim_relations_basex_v rbsxv
    LEFT OUTER JOIN usim_poi_dim_position_v pdpv1
      ON rbsxv.usim_id_pdp_in = pdpv1.usim_id_pdp
    LEFT OUTER JOIN usim_poi_dim_position_v pdpv2
      ON rbsxv.usim_id_pdp_out = pdpv2.usim_id_pdp
;
COMMENT ON COLUMN usim_relationsx_v.distance IS 'Distance of unequal vectors, missing vector values (dimensions) are interpreted as 0. Calculated by euclidian distance rule.';
