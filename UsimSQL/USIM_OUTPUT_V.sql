-- USIM_OUTPUT_V (outpv)
CREATE OR REPLACE FORCE VIEW usim_output_v AS
  SELECT outp.usim_id_outp
       , outp.usim_id_source
       , outp.usim_id_target
       , outp.usim_plancktime
       , outp.usim_timestamp
       , outp.usim_direction
       , outp.usim_processed
       , outp.usim_energy
       , outp.usim_amplitude
       , outp.usim_wavelength
       , usim_utility.energy_force( outp.usim_energy
                                  , pdpvt.usim_energy
                                  , usim_utility.vector_distance(pdpvs.usim_coords, pdpvt.usim_coords)
                                  , SIGN(pdpvt.usim_coordinate)
                                  , pdpvs.usim_id_parent
                                  )                                         AS usim_energy_force
       , SIGN(pdpvs.usim_coordinate)                                        AS usim_source_sign
       , SIGN(pdpvt.usim_coordinate)                                        AS usim_target_sign
       , pdpvs.usim_id_pdp                                                  AS usim_id_pdp_source
       , pdpvs.usim_energy                                                  AS usim_energy_source
       , pdpvs.usim_amplitude                                               AS usim_amplitude_source
       , pdpvs.usim_wavelength                                              AS usim_wavelength_source
       , pdpvs.usim_id_parent                                               AS usim_id_parent_source
       , pdpvs.usim_dimension                                               AS usim_dimension_source
       , pdpvs.usim_coordinate                                              AS usim_coordinate_source
       , pdpvt.usim_id_pdp                                                  AS usim_id_pdp_target
       , pdpvt.usim_energy                                                  AS usim_energy_target
       , pdpvt.usim_amplitude                                               AS usim_amplitude_target
       , pdpvt.usim_wavelength                                              AS usim_wavelength_target
       , pdpvt.usim_dimension                                               AS usim_dimension_target
       , pdpvt.usim_coordinate                                              AS usim_coordinate_target
       , usim_utility.vector_distance(pdpvs.usim_coords, pdpvt.usim_coords) AS usim_distance
       , parentpoint.usim_id_poi                                            AS usim_id_poi_parent_target
    FROM usim_output outp
    LEFT OUTER JOIN usim_poi_dim_position_v pdpvs
      ON outp.usim_id_source = pdpvs.usim_id_poi
    LEFT OUTER JOIN usim_poi_dim_position_v pdpvt
      ON outp.usim_id_target = pdpvt.usim_id_poi
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
       , usim_energy
       , usim_energy_force
       , usim_energy_source
       , usim_energy_target
       , usim_amplitude
       , usim_amplitude_source
       , usim_amplitude_target
       , usim_wavelength
       , usim_wavelength_source
       , usim_wavelength_target
       , usim_processed
       , usim_id_outp
       , usim_timestamp
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
