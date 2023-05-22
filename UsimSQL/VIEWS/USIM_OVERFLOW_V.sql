-- USIM_OVERFLOW_V (ovrv)
CREATE OR REPLACE FORCE VIEW usim_overflow_v AS
  SELECT ovr.usim_id_outp
       , ovr.usim_processed
       , outpv.usim_id_source
       , outpv.usim_id_target
       , outpv.usim_plancktime
       , outpv.usim_direction
       , outpv.usim_processed AS usim_processed_out
       , outpv.usim_energy_source
       , outpv.usim_energy_target
       , outpv.usim_amplitude_source
       , outpv.usim_amplitude_target
       , outpv.usim_wavelength_source
       , outpv.usim_wavelength_target
       , outpv.usim_frequency_source
       , outpv.usim_frequency_target
       , outpv.usim_energy_force
       , outpv.usim_source_sign
       , outpv.usim_target_sign
       , outpv.usim_id_pdp_source
       , outpv.usim_energy_source_cur
       , outpv.usim_amplitude_source_cur
       , outpv.usim_wavelength_source_cur
       , outpv.usim_id_parent_source
       , outpv.usim_dimension_source
       , outpv.usim_coordinate_source
       , outpv.usim_angular_frequency_source
       , outpv.usim_gravitation_constant_source
       , outpv.usim_dim_wavelength_source
       , outpv.usim_dim_amplitude_source
       , outpv.usim_id_pdp_target
       , outpv.usim_energy_target_cur
       , outpv.usim_amplitude_target_cur
       , outpv.usim_wavelength_target_cur
       , outpv.usim_dimension_target
       , outpv.usim_coordinate_target
       , outpv.usim_angular_frequency_target
       , outpv.usim_gravitation_constant_target
       , outpv.usim_dim_wavelength_target
       , outpv.usim_dim_amplitude_target
       , outpv.usim_distance
       , outpv.usim_id_poi_parent_target
    FROM usim_overflow ovr
    LEFT OUTER JOIN usim_output_v outpv
      ON ovr.usim_id_outp = outpv.usim_id_outp
;