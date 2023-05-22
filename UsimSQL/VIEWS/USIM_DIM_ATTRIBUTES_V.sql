-- USIM_DIM_ATTRIBUTES_V (datv)
CREATE OR REPLACE FORCE VIEW usim_dim_attributes_v AS
  SELECT usim_n_dimension
       , angular_frequency              AS usim_angular_frequency
       , gravitation_constant           AS usim_gravitation_constant
       , 1 / NVL(angular_frequency, 1)  AS usim_wavelength
       , 1                              AS usim_amplitude
       , usim_id_dim
       , usim_id_psc
    FROM (SELECT usim_n_dimension
               , (nodes_per_dimension / 4) * usim_static.get_pi()        AS angular_frequency
               , 1 / NVL(nodes_per_dimension * usim_static.get_pi(), 1)  AS gravitation_constant
               , usim_id_dim
               , usim_id_psc
            FROM usim_tree_nodes_v
           WHERE usim_id_psc = (SELECT usim_id_psc
                                  FROM usim_poi_dim_position_v
                                 WHERE usim_id_parent IS NULL
                               )
         )
;
COMMENT ON COLUMN usim_dim_attributes_v.usim_n_dimension IS 'The n-sphere dimension for the related attributes.';
COMMENT ON COLUMN usim_dim_attributes_v.usim_angular_frequency IS 'The angular frequency for the related dimension, calculated by dimension points / 4 * PI. 2PI for n=3.';
COMMENT ON COLUMN usim_dim_attributes_v.usim_gravitation_constant IS 'The gravitation constant for the related dimension, calculated by 1 / dimension points * PI. 1/8PI for n=3.';
COMMENT ON COLUMN usim_dim_attributes_v.usim_wavelength IS 'The wavelength for the related dimension without energy, calculated by c / angular frequency. With c = 1 in planck units and planck time.';
COMMENT ON COLUMN usim_dim_attributes_v.usim_amplitude IS 'The amplitude for the related dimension without energy.';
COMMENT ON COLUMN usim_dim_attributes_v.usim_id_psc IS 'The ID of the associated point structure.';
COMMENT ON COLUMN usim_dim_attributes_v.usim_id_dim IS 'The ID of the associated dimension.';

