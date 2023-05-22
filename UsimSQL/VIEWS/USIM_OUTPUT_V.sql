-- USIM_OUTPUT_V (outpv)
CREATE OR REPLACE FORCE VIEW usim_output_v AS
  SELECT outp.usim_id_outp
       , outp.usim_id_source
       , outp.usim_id_target
       , outp.usim_plancktime
       , outp.usim_direction
       , outp.usim_processed
       , outp.usim_energy_source
       , outp.usim_amplitude_source
       , outp.usim_wavelength_source
       , outp.usim_frequency_source
       , outp.usim_energy_target
       , outp.usim_amplitude_target
       , outp.usim_wavelength_target
       , outp.usim_frequency_target
       , usim_utility.energy_force( outp.usim_energy_source
                                  , outp.usim_energy_target
                                  , usim_utility.vector_distance(pdpvs.usim_coords, pdpvt.usim_coords)
                                  , SIGN(pdpvt.usim_coordinate)
                                  , datvt.usim_gravitation_constant
                                  )                                         AS usim_energy_force
       , SIGN(pdpvs.usim_coordinate)                                        AS usim_source_sign
       , SIGN(pdpvt.usim_coordinate)                                        AS usim_target_sign
       , pdpvs.usim_id_pdp                                                  AS usim_id_pdp_source
       , pdpvs.usim_energy                                                  AS usim_energy_source_cur
       , pdpvs.usim_amplitude                                               AS usim_amplitude_source_cur
       , pdpvs.usim_wavelength                                              AS usim_wavelength_source_cur
       , pdpvs.usim_frequency                                               AS usim_frequency_source_cur
       , pdpvs.usim_id_parent                                               AS usim_id_parent_source
       , pdpvs.usim_n_dimension                                             AS usim_dimension_source
       , pdpvs.usim_coordinate                                              AS usim_coordinate_source
       , pdpvs.usim_coords                                                  AS usim_coords_source
       , datvs.usim_angular_frequency                                       AS usim_angular_frequency_source
       , datvs.usim_gravitation_constant                                    AS usim_gravitation_constant_source
       , datvs.usim_wavelength                                              AS usim_dim_wavelength_source
       , datvs.usim_amplitude                                               AS usim_dim_amplitude_source
       , pdpvt.usim_id_pdp                                                  AS usim_id_pdp_target
       , pdpvt.usim_id_parent                                               AS usim_id_parent_target
       , pdpvt.usim_energy                                                  AS usim_energy_target_cur
       , pdpvt.usim_amplitude                                               AS usim_amplitude_target_cur
       , pdpvt.usim_wavelength                                              AS usim_wavelength_target_cur
       , pdpvt.usim_frequency                                               AS usim_frequency_target_cur
       , pdpvt.usim_n_dimension                                             AS usim_dimension_target
       , pdpvt.usim_coordinate                                              AS usim_coordinate_target
       , pdpvt.usim_coords                                                  AS usim_coords_target
       , datvt.usim_angular_frequency                                       AS usim_angular_frequency_target
       , datvt.usim_gravitation_constant                                    AS usim_gravitation_constant_target
       , datvt.usim_wavelength                                              AS usim_dim_wavelength_target
       , datvt.usim_amplitude                                               AS usim_dim_amplitude_target
       , usim_utility.vector_distance(pdpvs.usim_coords, pdpvt.usim_coords) AS usim_distance
       , parentpoint.usim_id_poi                                            AS usim_id_poi_parent_target
    FROM usim_output outp
    LEFT OUTER JOIN usim_poi_dim_position_v pdpvs
      ON outp.usim_id_source = pdpvs.usim_id_poi
    LEFT OUTER JOIN usim_dim_attributes_v datvs
      ON pdpvs.usim_id_dim = datvs.usim_id_dim
    LEFT OUTER JOIN usim_poi_dim_position_v pdpvt
      ON outp.usim_id_target = pdpvt.usim_id_poi
    LEFT OUTER JOIN usim_dim_attributes_v datvt
      ON pdpvt.usim_id_dim = datvt.usim_id_dim
    LEFT OUTER JOIN usim_poi_dim_position_v parentpoint
      ON pdpvt.usim_id_parent = parentpoint.usim_id_pdp
;
-- USIM_OUTPUT_ORDER_V (outpov)
CREATE OR REPLACE FORCE VIEW usim_output_order_v AS
  SELECT usim_plancktime
       , usim_id_source
       , usim_id_target
       , usim_direction
       , usim_dimension_source
       , usim_dimension_target
       , usim_coordinate_source
       , usim_coordinate_target
       , usim_source_sign
       , usim_target_sign
       , usim_distance
       , usim_energy_force
       , usim_energy_source
       , usim_energy_target
       , usim_energy_source_cur
       , usim_energy_target_cur
       , usim_amplitude_source
       , usim_amplitude_target
       , usim_amplitude_source_cur
       , usim_amplitude_target_cur
       , usim_wavelength_source
       , usim_wavelength_target
       , usim_wavelength_source_cur
       , usim_wavelength_target_cur
       , usim_frequency_source
       , usim_frequency_target
       , usim_angular_frequency_source
       , usim_angular_frequency_target
       , usim_gravitation_constant_source
       , usim_gravitation_constant_target
       , usim_processed
       , usim_id_outp
       , usim_id_pdp_source
       , usim_id_pdp_target
       , usim_id_poi_parent_target
    FROM usim_output_v
  ORDER BY usim_plancktime
         , usim_direction
         , usim_dimension_target
         , usim_dimension_source
         , usim_distance
         , ABS(usim_coordinate_target)
         , ABS(usim_coordinate_source)
;
