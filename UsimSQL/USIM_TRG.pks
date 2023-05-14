CREATE OR REPLACE PACKAGE usim_trg IS
  /* A package for use with instead of triggers
   * providing trigger conform functions and procedures.
   * Will raise application errors if trigger requirements are
   * not fulfilled.
   * Create the package before creating instead of triggers which
   * use this package.
   */

  /* Function USIM_TRG.GET_USIM_ID_DIM
   * Get and check the USIM_ID_DIM either by id or dimension.
   * One of the given values must match to identiy the USIM_ID_DIM.
   * Code uses USIM_ID_DIM, if both values are given.
   *
   * Parameter
   * P_USIM_ID_DIM      - the USIM_ID_DIM to check, can be NULL if USIM_DIMENSION is given.
   * P_USIM_DIMENSION   - the USIM_DIMENSION to get the id for, can be NULL if USIM_ID_DIM
   *                      is given.
   *
   * RETURNS
   * The USIM_ID_DIM for the given parameter.
   *
   * THROWS
   * -20100 Given dimension ID (x) does not exist.
   * -20101 Given dimension (x) does not exist.
   */
  FUNCTION get_usim_id_dim( p_usim_id_dim             IN usim_dimension.usim_id_dim%TYPE
                          , p_usim_dimension          IN usim_dimension.usim_dimension%TYPE
                          )
    RETURN usim_dimension.usim_id_dim%TYPE
  ;

  /* Function USIM_TRG.GET_USIM_ID_PARENT
   * Get and check the USIM_ID_PARENT. NULL is only allowed for one point
   * in the whole point structures. Only one point allowed without parent.
   *
   * Parameter
   * P_USIM_ID_PARENT   - the USIM_ID_PARENT to check, can be NULL if no point without parent exists.
   *
   * RETURNS
   * The USIM_ID_PARENT for the given parameter.
   *
   * THROWS
   * -20200 Given parent point ID (x) does not exist.
   * -20201 A basic seed point already exists. USIM_ID_PARENT cannot be NULL.
   */
  FUNCTION get_usim_id_parent(p_usim_id_parent        IN usim_poi_dim_position.usim_id_pdp%TYPE)
    RETURN usim_poi_dim_position.usim_id_pdp%TYPE
  ;

  /* Procedure USIM_TRG.CHK_PARENT_DIMENSION
   * Verfiy that dimension for a given parent is correct.
   * Dimension = Parent dimension + 1
   *
   * Parameter
   * P_USIM_ID_DIM      - the child dimension to check, MANDATORY.
   * P_USIM_ID_PARENT   - the parent id to check the dimension, MANDATORY.
   *
   * THROWS
   * -20102 Given child dimension (x) does not match parent dimension (y) + 1.
   * -20103 Given dimension (x) must be 0 if point has no parent.
   */
  PROCEDURE chk_parent_dimension( p_usim_id_dim       IN usim_dimension.usim_id_dim%TYPE
                                , p_usim_id_parent    IN usim_poi_dim_position.usim_id_pdp%TYPE
                                )
  ;

  /* Function USIM_TRG.GET_USIM_ID_POS
   * Get, check and optionally create the USIM_ID_POS. Either USIM_ID_POS or
   * USIM_COORDINATE has to be given. If USIM_ID_POS is given, it must exist.
   * Code uses P_USIM_COORDINATE is both values are given.
   *
   * Parameter
   * P_USIM_ID_POS      - the position id to check, can be NULL if P_USIM_COORDINATE is given.
   * P_USIM_COORDINATE  - the position to check or create, if it does not exist.
   *
   * RETURNS
   * The USIM_ID_POS for the given parameter.
   *
   * THROWS
   * -20300 Given position ID (x) does not exist.
   */
  FUNCTION get_usim_id_pos( p_usim_id_pos             IN usim_position.usim_id_pos%TYPE
                          , p_usim_coordinate         IN usim_position.usim_coordinate%TYPE
                          )
    RETURN usim_position.usim_id_pos%TYPE
  ;

  /* Function USIM_TRG.GET_USIM_ID_PSC
   * Get, check and optionally create a point structure. Either USIM_ID_PSC or
   * USIM_POINT_NAME has to be given. If USIM_ID_POS is given, it must exist.
   * Code uses P_USIM_POINT_NAME is both values are given.
   *
   * Parameter
   * P_USIM_ID_PSC      - the point structure id to check, can be NULL if P_USIM_POINT_NAME is given.
   * P_USIM_POINT_NAME  - the point structure to check or create, if it does not exist.
   *
   * RETURNS
   * The USIM_ID_PSC for the given parameter.
   *
   * THROWS
   * -20400 Given point structure ID (x) does not exist.
   */
  FUNCTION get_usim_id_psc( p_usim_id_psc             IN usim_poi_structure.usim_id_psc%TYPE
                          , p_usim_point_name         IN usim_poi_structure.usim_point_name%TYPE
                          )
    RETURN usim_poi_structure.usim_id_psc%TYPE
  ;

  /* Procedure USIM_TRG.CHK_PARENT_CHILDS
   * Verfiy that parent has no more than maximum childs as
   * defined in USIM_STATIC.GET_MAX_CHILDS.
   *
   * Parameter
   * P_USIM_ID_PARENT   - the parent id to check the childs for, MANDATORY.
   * P_USIM_ID_PSC      - the point structure assigned to the childs, MANDATORY.
   *
   * THROWS
   * -20202 Given parent ID (x) has already the maximum of allowed childs.
   */
  PROCEDURE chk_parent_childs( p_usim_id_parent       IN usim_poi_dim_position.usim_id_pdp%TYPE
                             , p_usim_id_psc          IN usim_poi_structure.usim_id_psc%TYPE
                             )
  ;

  /* Function USIM_TRG.GET_USIM_COORDS
   * Builds the usim_coords string, all positions in current and all subsequent dimensions
   * as a comma separated list.
   * Coords are created for every point, so the parent always contains the complete
   * subset of the lower dimensions.
   *
   * Parameter
   * P_USIM_ID_POS      - the current position of the point, MANDATORY.
   * P_USIM_ID_PARENT   - the parent id of the point, MANDATORY.
   *
   * RETURNS
   * The USIM_COORDS for the given parameter.
   */
  FUNCTION get_usim_coords( p_usim_id_pos             IN usim_position.usim_id_pos%TYPE
                          , p_usim_id_parent          IN usim_poi_dim_position.usim_id_pdp%TYPE
                          )
    RETURN usim_poi_dim_position.usim_coords%TYPE
  ;

  /* Procedure USIM_TRG.INSERT_POINT
   * Used in the instead of trigger USIM_POIV_INSERT_TRG from USIM_POINT_INSERT_V.
   * On insert attributes, like energy, amplitude and wavelength are always set to NULL.
   *
   * Parameter
   * P_USIM_ID_DIM      - the USIM_ID_DIM from the insert.
   * P_USIM_DIMENSION   - the USIM_DIMENSION from the insert.
   * P_USIM_ID_POS      - the USIM_ID_POS from the insert.
   * P_USIM_COORDINATE  - the USIM_COORDINATE from the insert.
   * P_USIM_ID_PSC      - the USIM_ID_PSC from the insert.
   * P_USIM_POINT_NAME  - the USIM_POINT_NAME from the insert.
   * P_USIM_ID_PARENT   - the USIM_ID_PARENT from the insert.
   *
   * THROWS
   * -20100 Given dimension ID (x) does not exist.
   * -20101 Given dimension (x) does not exist.
   * -20102 Given child dimension (x) does not match parent dimension (y) + 1.
   * -20103 Given dimension (x) must be 0 if point has no parent.
   * -20200 Given parent point ID (x) does not exist.
   * -20201 A basic seed point already exists. USIM_ID_PARENT cannot be NULL.
   * -20202 Given parent ID (x) has already the maximum of allowed childs.
   * -20300 Given position ID (x) does not exist.
   * -20400 Given point structure ID (x) does not exist.
   */
  PROCEDURE insert_point( p_usim_id_dim               IN usim_dimension.usim_id_dim%TYPE
                        , p_usim_dimension            IN usim_dimension.usim_dimension%TYPE
                        , p_usim_id_pos               IN usim_position.usim_id_pos%TYPE
                        , p_usim_coordinate           IN usim_position.usim_coordinate%TYPE
                        , p_usim_id_psc               IN usim_poi_structure.usim_id_psc%TYPE
                        , p_usim_point_name           IN usim_poi_structure.usim_point_name%TYPE
                        , p_usim_id_parent            IN usim_poi_dim_position.usim_id_pdp%TYPE
                        )
  ;
END usim_trg;
/