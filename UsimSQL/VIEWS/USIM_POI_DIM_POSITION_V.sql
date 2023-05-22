-- USIM_POI_DIM_POSITION_V (pdpv)
CREATE OR REPLACE FORCE VIEW usim_poi_dim_position_v AS
    WITH pdc AS
         (SELECT usim_id_pdp
               , MIN(usim_id_child) AS usim_id_child_left
               , CASE
                   WHEN MAX(usim_id_child) = MIN(usim_id_child)
                   THEN NULL
                   ELSE MAX(usim_id_child)
                 END AS usim_id_child_right
            FROM usim_pdp_childs
           GROUP BY usim_id_pdp
         )
  SELECT psc.usim_point_name
       , poi.usim_energy
       , poi.usim_amplitude
       , poi.usim_wavelength
       , poi.usim_frequency
       , dim.usim_n_dimension
       , pos.usim_coordinate
       , pdp.usim_coords
       , pdp.usim_abs_coords
       , usim_utility.get_x(pdp.usim_coords) AS pos_x
       , usim_utility.get_y(pdp.usim_coords) AS pos_y
       , usim_utility.get_z(pdp.usim_coords) AS pos_z
       , pdr.usim_id_parent
       , pdc.usim_id_child_left
       , pdc.usim_id_child_right
       , poi.usim_id_poi
       , dim.usim_id_dim
       , dpo.usim_id_dpo
       , pos.usim_id_pos
       , pdp.usim_id_pdp
       , pdp.usim_id_psc
       , dpo.usim_id_poi AS dpo_usim_id_poi
       , dpo.usim_id_dim AS dpo_usim_id_dim
       , pdp.usim_id_dpo AS pdp_usim_id_dpo
       , pdp.usim_id_pos AS pdp_usim_id_pos
       , pdr.usim_id_pdp AS pdr_usim_id_pdp
       , pdc.usim_id_pdp AS pdc_usim_id_pdp
    FROM usim_point poi
    LEFT OUTER JOIN usim_dim_point dpo
      ON poi.usim_id_poi = dpo.usim_id_poi
    LEFT OUTER JOIN usim_dimension dim
      ON dpo.usim_id_dim = dim.usim_id_dim
    LEFT OUTER JOIN usim_poi_dim_position pdp
      ON dpo.usim_id_dpo = pdp.usim_id_dpo
    LEFT OUTER JOIN usim_position pos
      ON pdp.usim_id_pos = pos.usim_id_pos
    LEFT OUTER JOIN usim_pdp_parent pdr
      ON pdp.usim_id_pdp = pdr.usim_id_pdp
    LEFT OUTER JOIN pdc
      ON pdp.usim_id_pdp = pdc.usim_id_pdp
    LEFT OUTER JOIN usim_poi_structure psc
      ON pdp.usim_id_psc = psc.usim_id_psc
   ORDER BY dim.usim_n_dimension
          , pdr.usim_id_parent NULLS FIRST
;