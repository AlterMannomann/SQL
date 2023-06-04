-- USIM_POINT_INSERT_V (poiv)
CREATE OR REPLACE FORCE NONEDITIONABLE VIEW usim_point_insert_v AS
  SELECT psc.usim_point_name
       , poi.usim_energy
       , poi.usim_amplitude
       , poi.usim_wavelength
       , dim.usim_n_dimension
       , pos.usim_coordinate
       , pos.usim_coord_level
       , pdp.usim_coords
       , pdr.usim_id_parent
       , pdc.usim_id_child
       , poi.usim_id_poi
       , dim.usim_id_dim
       , dpo.usim_id_dpo
       , pos.usim_id_pos
       , pdp.usim_id_pdp
       , pdc.usim_id_pdc
       , pdp.usim_id_psc
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
    LEFT OUTER JOIN usim_pdp_childs pdc
      ON pdp.usim_id_pdp = pdc.usim_id_pdp
    LEFT OUTER JOIN usim_poi_structure psc
      ON pdp.usim_id_psc = psc.usim_id_psc
;
COMMENT ON COLUMN usim_point_insert_v.usim_n_dimension IS 'Dimension of the point. Dimension or dimension ID is MANDATORY on INSERT.';
COMMENT ON COLUMN usim_point_insert_v.usim_id_dim IS 'The ID of the dimension, related to the point. Dimension or dimension ID is MANDATORY on INSERT. If given, any given dimension is ignored.';
COMMENT ON COLUMN usim_point_insert_v.usim_coordinate IS 'The position coordinate of the point. Position coordinate or position ID is MANDATORY on INSERT.';
COMMENT ON COLUMN usim_point_insert_v.usim_id_pos IS 'The ID of a position. Position or position ID is MANDATORY on INSERT.';
COMMENT ON COLUMN usim_point_insert_v.usim_point_name IS 'The name of the associated point structure. Name or ID is MANDATORY on INSERT.';
COMMENT ON COLUMN usim_point_insert_v.usim_id_psc IS 'The ID of the associated point structure. Name or ID is optional on INSERT. IF NULL the universe seed is used.';
COMMENT ON COLUMN usim_point_insert_v.usim_id_parent IS 'The ID of a parent point (USIM_ID_PDP). Optional for first point, all other points MANDATORY NOT NULL. If given, the parent point with dimension and position must exist. Points can only have one parent.';
COMMENT ON COLUMN usim_point_insert_v.usim_energy IS 'The energy of the point. Optional on INSERT.';
COMMENT ON COLUMN usim_point_insert_v.usim_amplitude IS 'The amplitude of the point. Optional on INSERT.';
COMMENT ON COLUMN usim_point_insert_v.usim_wavelength IS 'The wavelength of the point. Optional on INSERT.';
COMMENT ON COLUMN usim_point_insert_v.usim_coord_level IS 'The level of the position coordinate of the point. Never used on inserts.';
COMMENT ON COLUMN usim_point_insert_v.usim_coords IS 'The xyz like coordinates of the point including parent coordinates. Never used on inserts. Build by any insert.';
COMMENT ON COLUMN usim_point_insert_v.usim_id_pdp IS 'The ID of the point with dimension and position. Never used on inserts.';
COMMENT ON COLUMN usim_point_insert_v.usim_id_child IS 'The ID of a child point (USIM_ID_PDP). Never used on inserts.';
COMMENT ON COLUMN usim_point_insert_v.usim_id_poi IS 'The ID of the point. Never used on inserts.';
COMMENT ON COLUMN usim_point_insert_v.usim_id_dpo IS 'The ID of the point with dimension. Never used on inserts.';
COMMENT ON COLUMN usim_point_insert_v.usim_id_pdc IS 'The ID of the child of the point with dimension and position. Never used on inserts.';

-- INSTEAD OF Trigger filling all relevant tables
CREATE OR REPLACE TRIGGER usim_poiv_insert_trg
  INSTEAD OF INSERT ON usim_point_insert_v
  -- Use dimension, position, (parent), point structure to insert a new point.
  -- see USIM_TRG package for more information
  BEGIN
    usim_trg.insert_point( :NEW.usim_id_dim
                         , :NEW.usim_n_dimension
                         , :NEW.usim_id_pos
                         , :NEW.usim_coordinate
                         , :NEW.usim_id_psc
                         , :NEW.usim_point_name
                         , :NEW.usim_id_parent
                         )
    ;
  END usim_point_insert_v
;
/