CREATE OR REPLACE PACKAGE usim_trg IS
  /** A package for use with instead of triggers.
  *
  * Providing trigger conform functions and procedures.
  * Will raise application errors if trigger requirements are not fulfilled.
  * Create the package before creating instead of triggers which use this package.
  */

  /**
  * Get and check the USIM_ID_DIM either by id or dimension.
  * One of the given values must match to identiy the USIM_ID_DIM.
  * Code uses USIM_ID_DIM, if both values are given.
  * @param p_usim_id_dim The USIM_ID_DIM to check, can be NULL if USIM_DIMENSION is given.
  * @param p_usim_dimension The USIM_DIMENSION to get the id for, can be NULL if USIM_ID_DIM is given.
  * @return The USIM_ID_DIM for the given parameter.
  * @throws 20100 Given dimension ID (x) does not exist.
  * @throws 20101 Given dimension (x) does not exist.
  */
  FUNCTION get_usim_id_dim( p_usim_id_dim             IN usim_dimension.usim_id_dim%TYPE
                          , p_usim_dimension          IN usim_dimension.usim_n_dimension%TYPE
                          )
    RETURN usim_dimension.usim_id_dim%TYPE
  ;

  /**
  * Get and check the USIM_ID_PARENT. NULL is only allowed for one point
  * in the whole point structures. Only one point allowed without parent.
  * @param p_usim_id_parent The USIM_ID_PARENT to check, can be NULL if no point without parent exists.
  * @return The USIM_ID_PARENT for the given parameter.
  * @throws 20200 Given parent point ID (x) does not exist.
  * @throws 20201 A basic seed point already exists. USIM_ID_PARENT cannot be NULL.
  */
  FUNCTION get_usim_id_parent(p_usim_id_parent        IN usim_poi_dim_position.usim_id_pdp%TYPE)
    RETURN usim_poi_dim_position.usim_id_pdp%TYPE
  ;

  /**
  * Verfiy that dimension for a given parent is correct.
  * Dimension = Parent dimension + 1
  * @param p_usim_id_dim The child dimension to check, MANDATORY.
  * @param p_usim_id_parent The parent id to check the dimension, MANDATORY.
  * @throws 20102 Given child dimension (x) does not match parent dimension (y) + 1.
  * @throws 20103 Given dimension (x) must be 0 if point has no parent.
  */
  PROCEDURE chk_parent_dimension( p_usim_id_dim       IN usim_dimension.usim_id_dim%TYPE
                                , p_usim_id_parent    IN usim_poi_dim_position.usim_id_pdp%TYPE
                                )
  ;

  /**
  * Retrieves the next number level. Updates USIM_LEVELS. Commit is up to user, as used in insert trigger.
  * @param p_sign A positive (including 0) or negative number to define the type of number level.
  * @return The next number level.
  */
  FUNCTION next_number_level(p_sign IN NUMBER)
    RETURN NUMBER
  ;

  /**
  * Retrieves the current number level.
  * @param p_sign A positive (including 0) or negative number to define the type of number level.
  * @return The current number level.
  */
  FUNCTION current_number_level(p_sign IN NUMBER)
    RETURN NUMBER
  ;

  /**
  * Insert a position if necessary or return the index of this position.
  * Handle level on possible numeric overflows for coordinates.
  * If a coordinate reaches the max for numbers, the level is raised.
  * Will only insert the coordinate, if it does not exist yet. The level assumed for insert is the current level.
  * On inserts the given coordinate value is ignored, always inserts the next maximum value based on sign of the coordinate.
  * No commit as used in insert trigger.
  * @param p_usim_coordinate The new coordinate to insert.
  * @return The new big id for this position or the big id found for this position.
  */
  FUNCTION insert_position(p_usim_coordinate IN usim_position.usim_coordinate%TYPE)
    RETURN VARCHAR2
  ;

  /**
  * Get, check and optionally create the USIM_ID_POS. Either USIM_ID_POS or
  * USIM_COORDINATE has to be given. If USIM_ID_POS is given, it must exist.
  * Code uses P_USIM_COORDINATE is both values are given. Will insert not
  * existing coordinates at current level.
  * @param p_usim_id_pos The position id to check. Can be NULL if P_USIM_COORDINATE is given.
  * @param p_usim_coordinate the position to check or create, if it does not exist.
  * @throws 20300 Given position ID (x) does not exist.
  * @return The USIM_ID_POS for the given parameter.
  */
  FUNCTION get_usim_id_pos( p_usim_id_pos             IN usim_position.usim_id_pos%TYPE
                          , p_usim_coordinate         IN usim_position.usim_coordinate%TYPE
                          )
    RETURN usim_position.usim_id_pos%TYPE
  ;

  /**
  * Get, check and optionally create a point structure. Either USIM_ID_PSC or
  * USIM_POINT_NAME has to be given. If USIM_ID_POS is given, it must exist.
  * Code uses P_USIM_POINT_NAME is both values are given.
  * @param p_usim_id_psc The point structure id to check, can be NULL if P_USIM_POINT_NAME is given.
  * @param p_usim_point_name The point structure to check or create, if it does not exist.
  * @throws 20400 Given point structure ID (x) does not exist.
  * @return The USIM_ID_PSC for the given parameter.
  */
  FUNCTION get_usim_id_psc( p_usim_id_psc             IN usim_poi_structure.usim_id_psc%TYPE
                          , p_usim_point_name         IN usim_poi_structure.usim_point_name%TYPE
                          )
    RETURN usim_poi_structure.usim_id_psc%TYPE
  ;

  /**
  * Verfiy that parent has no more than maximum childs as
  * defined in USIM_STATIC.GET_MAX_CHILDS.
  * @param p_usim_id_parent The parent id to check the childs for, MANDATORY.
  * @param p_usim_id_psc The point structure assigned to the childs, MANDATORY.
  * @throws 20202 Given parent ID (x) has already the maximum of allowed childs.
  */
  PROCEDURE chk_parent_childs( p_usim_id_parent       IN usim_poi_dim_position.usim_id_pdp%TYPE
                             , p_usim_id_psc          IN usim_poi_structure.usim_id_psc%TYPE
                             )
  ;

  /**
  * Builds the usim_coords string, all positions in current and all subsequent dimensions
  * as a comma separated list. Coords are created for every point, so the parent always
  * contains the complete subset of the lower dimensions.
  * @param p_usim_id_pos The current position of the point, MANDATORY.
  * @param p_usim_id_parent The parent id of the point, MANDATORY.
  * @return The USIM_COORDS for the given parameter.
  */
  FUNCTION get_usim_coords( p_usim_id_pos             IN usim_position.usim_id_pos%TYPE
                          , p_usim_id_parent          IN usim_poi_dim_position.usim_id_pdp%TYPE
                          )
    RETURN usim_poi_dim_position.usim_coords%TYPE
  ;

  /**
  * Builds the usim_coords string, all absolute positions in current and all subsequent dimensions
  * as a comma separated list. Coords are created for every point, so the parent always contains the complete
  * subset of the lower dimensions.
  * @param p_usim_id_pos The current position of the point, MANDATORY.
  * @param p_usim_id_parent The parent id of the point, MANDATORY.
  * @return The USIM_ABS_COORDS for the given parameter.
  */
  FUNCTION get_usim_abs_coords( p_usim_id_pos             IN usim_position.usim_id_pos%TYPE
                              , p_usim_id_parent          IN usim_poi_dim_position.usim_id_pdp%TYPE
                              )
    RETURN usim_poi_dim_position.usim_coords%TYPE
  ;
  /**
  * Used in the instead of trigger USIM_POIV_INSERT_TRG from USIM_POINT_INSERT_V.
  * On insert attributes, like energy, amplitude and wavelength are always set to NULL.
  * @param p_usim_id_dim The USIM_ID_DIM from the insert.
  * @param p_usim_dimension The USIM_DIMENSION from the insert.
  * @param p_usim_id_pos The USIM_ID_POS from the insert.
  * @param p_usim_coordinate The USIM_COORDINATE from the insert.
  * @param p_usim_id_psc The USIM_ID_PSC from the insert.
  * @param p_usim_point_name The USIM_POINT_NAME from the insert.
  * @param p_usim_id_parent The USIM_ID_PARENT from the insert.
  * @throws 20100 Given dimension ID (x) does not exist.
  * @throws 20101 Given dimension (x) does not exist.
  * @throws 20102 Given child dimension (x) does not match parent dimension (y) + 1.
  * @throws 20103 Given dimension (x) must be 0 if point has no parent.
  * @throws 20200 Given parent point ID (x) does not exist.
  * @throws 20201 A basic seed point already exists. USIM_ID_PARENT cannot be NULL.
  * @throws 20202 Given parent ID (x) has already the maximum of allowed childs.
  * @throws 20300 Given position ID (x) does not exist.
  * @throws 20400 Given point structure ID (x) does not exist.
  */
  PROCEDURE insert_point( p_usim_id_dim               IN usim_dimension.usim_id_dim%TYPE
                        , p_usim_dimension            IN usim_dimension.usim_n_dimension%TYPE
                        , p_usim_id_pos               IN usim_position.usim_id_pos%TYPE
                        , p_usim_coordinate           IN usim_position.usim_coordinate%TYPE
                        , p_usim_id_psc               IN usim_poi_structure.usim_id_psc%TYPE
                        , p_usim_point_name           IN usim_poi_structure.usim_point_name%TYPE
                        , p_usim_id_parent            IN usim_poi_dim_position.usim_id_pdp%TYPE
                        )
  ;
END usim_trg;
/