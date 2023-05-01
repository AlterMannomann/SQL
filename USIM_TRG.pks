CREATE OR REPLACE PACKAGE usim_trg IS
  /* A package for use with instead of triggers
   * providing trigger conform functions and procedures.
   * Will raise application errors if trigger requirements are
   * not fulfilled.
   */

  FUNCTION get_usim_id_dim( p_usim_id_dim             IN usim_dimension.usim_id_dim%TYPE
                          , p_usim_dimension          IN usim_dimension.usim_dimension%TYPE
                          )
    RETURN usim_dimension.usim_id_dim%TYPE
  ;

  FUNCTION get_usim_id_parent(p_usim_id_parent        IN usim_poi_dim_position.usim_id_pdp%TYPE)
    RETURN usim_poi_dim_position.usim_id_pdp%TYPE
  ;

  PROCEDURE chk_parent_dimension( p_usim_id_dim       IN usim_dimension.usim_id_dim%TYPE
                                , p_usim_id_parent    IN usim_poi_dim_position.usim_id_pdp%TYPE
                                )
  ;
  -- will create a new position, if it does not exist - no commit
  FUNCTION get_usim_id_pos( p_usim_id_pos             IN usim_position.usim_id_pos%TYPE
                          , p_usim_coordinate         IN usim_position.usim_coordinate%TYPE
                          )
    RETURN usim_position.usim_id_pos%TYPE
  ;
  -- will create a new point structure, if it does not exist - no commit
  FUNCTION get_usim_id_psc( p_usim_id_psc             IN usim_poi_structure.usim_id_psc%TYPE
                          , p_usim_point_name         IN usim_poi_structure.usim_point_name%TYPE
                          )
    RETURN usim_poi_structure.usim_id_psc%TYPE
  ;

  PROCEDURE chk_parent_childs( p_usim_id_parent       IN usim_poi_dim_position.usim_id_pdp%TYPE
                             , p_usim_id_psc          IN usim_poi_structure.usim_id_psc%TYPE
                             )
  ;

  FUNCTION get_usim_coords( p_usim_id_pos             IN usim_position.usim_id_pos%TYPE
                          , p_usim_id_parent          IN usim_poi_dim_position.usim_id_pdp%TYPE
                          )
    RETURN usim_poi_dim_position.usim_coords%TYPE
  ;

  PROCEDURE insert_point( p_usim_id_dim               IN usim_dimension.usim_id_dim%TYPE
                        , p_usim_dimension            IN usim_dimension.usim_dimension%TYPE
                        , p_usim_id_pos               IN usim_position.usim_id_pos%TYPE
                        , p_usim_coordinate           IN usim_position.usim_coordinate%TYPE
                        , p_usim_id_psc               IN usim_poi_structure.usim_id_psc%TYPE
                        , p_usim_point_name           IN usim_poi_structure.usim_point_name%TYPE
                        , p_usim_id_parent            IN usim_poi_dim_position.usim_id_pdp%TYPE
                        , p_usim_energy               IN usim_point.usim_energy%TYPE
                        , p_usim_amplitude            IN usim_point.usim_amplitude%TYPE
                        , p_usim_wavelength           IN usim_point.usim_wavelength%TYPE
                        )
  ;
END usim_trg;
/