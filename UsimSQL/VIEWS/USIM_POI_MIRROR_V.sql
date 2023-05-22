-- USIM_POI_MIRROR_V (poim)
CREATE OR REPLACE FORCE VIEW usim_poi_mirror_v AS
  SELECT pdpv.usim_id_pdp
       , mir.usim_id_pdp AS usim_id_pdp_mirror
       , pdpv.usim_coords
       , mir.usim_coords AS usim_coords_mirror
       , pdpv.usim_abs_coords
       , mir.usim_abs_coords AS usim_abs_coords_mirror
    FROM usim_poi_dim_position_v pdpv
    LEFT OUTER JOIN usim_poi_dim_position_v mir
      ON pdpv.usim_abs_coords = mir.usim_abs_coords
     AND pdpv.usim_id_pdp != mir.usim_id_pdp
;