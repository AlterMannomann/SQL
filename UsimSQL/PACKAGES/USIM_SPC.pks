CREATE OR REPLACE PACKAGE usim_spc
IS
  /**A low level package for actions on table usim_space and its associated
  * views. Views can be seen as interfaces and dependency. No other package dependencies
  * apart from USIM_STATIC. ATTENTION Package may throw exceptions
  * from constraints, triggers and foreign keys. Caller is responsible to handle
  * possible exceptions.
  */

  /**
  * Checks if usim_space has already data.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data
    RETURN NUMBER
  ;

  /**
  * Checks if usim_space has already data for a given space id.
  * @param p_usim_id_spc The relation id of universe/dimension/position/node.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if usim_space has already data for given relation ids.
  * @param p_usim_id_rmd The relation id of universe/dimension.
  * @param p_usim_id_pos The id of the position.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data( p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE
                   , p_usim_id_pos IN usim_position.usim_id_pos%TYPE
                   )
    RETURN NUMBER
  ;

  /**
  * Checks if usim_space has already data for given relation ids.
  * @param p_usim_id_rmd The relation id of universe/dimension.
  * @param p_usim_id_pos The id of the position.
  * @param p_usim_id_nod The id of the node.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data( p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE
                   , p_usim_id_pos IN usim_position.usim_id_pos%TYPE
                   , p_usim_id_nod IN usim_node.usim_id_nod%TYPE
                   )
    RETURN NUMBER
  ;

  /**
  * Checks if usim_space has a entry for the base universe with dimension 0, position 0 and sign 0.
  * @return Returns 1 if base universe exists, otherwise 0.
  */
  FUNCTION has_base_universe
    RETURN NUMBER
  ;

  /**
  * Checks if the space id is a universe base entry with dimension 0, position 0 and sign 0. Not necessarily the base universe.
  * @param p_usim_id_spc The space id.
  * @return Returns 1 if universe base entry exists, otherwise 0.
  */
  FUNCTION is_universe_base(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Returns the maximum available dimensions for a space id and the related universe in usim_space. Considers
  * all dimensions, not caring about the n1 sign.
  * @param p_usim_id_spc The space id.
  * @return Returns the maximum available dimensions for the related universe or -1 if no dimension available.
  */
  FUNCTION get_cur_max_dimension(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_dimension.usim_n_dimension%TYPE
  ;

  /**
  * Returns the maximum available dimensions for a space id and the related universe in usim_space. Considers
  * only n1 dimensions.
  * @param p_usim_id_spc The space id.
  * @return Returns the maximum available n=1 related dimensions for the related universe or -1 if no dimension available.
  */
  FUNCTION get_cur_max_dim_n1(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_dimension.usim_n_dimension%TYPE
  ;

  /**
  * Retrieves the universe/dimension id for a given space id if it exists in usim_space.
  * @param p_usim_id_spc The space id.
  * @return Returns usim_id_rmd if space id exists, otherwise NULL.
  */
  FUNCTION get_id_rmd(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
  ;

  /**
  * Retrieves the universe/dimension id for a given space id if it exists in usim_space.
  * @param p_usim_id_spc The space id.
  * @return Returns usim_id_rmd if space id exists, otherwise NULL.
  */
  FUNCTION get_id_pos(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_position.usim_id_pos%TYPE
  ;

  /**
  * Retrieves the universe id for a given space id if it exists in usim_space.
  * @param p_usim_id_spc The space id.
  * @return Returns usim_id_mlv if space id exists, otherwise NULL.
  */
  FUNCTION get_id_mlv(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_multiverse.usim_id_mlv%TYPE
  ;

  /**
  * Retrieves the node id for a given space id if it exists in usim_space.
  * @param p_usim_id_spc The space id.
  * @return Returns usim_id_nod if space id exists, otherwise NULL.
  */
  FUNCTION get_id_nod(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_node.usim_id_nod%TYPE
  ;

  /**
  * Retrieves a space id for a given ids if it exists in usim_space.
  * @param p_usim_id_rmd The universe/dimension relation id.
  * @param p_usim_id_pos The position id.
  * @return Returns usim_id_spc if it exists, otherwise NULL.
  */
  FUNCTION get_id_spc( p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE
                     , p_usim_id_pos IN usim_position.usim_id_pos%TYPE
                     )
    RETURN usim_space.usim_id_spc%TYPE
  ;

  /**
  * Retrieves the space id for the base universe if it exists in usim_space.
  * @return Returns usim_id_spc if base universe exists, otherwise NULL.
  */
  FUNCTION get_id_spc_base_universe
    RETURN usim_space.usim_id_spc%TYPE
  ;

  /**
  * Retrieves the dimension sign of a given space node.
  * @param p_usim_id_spc The space id.
  * @return The dimension sign of the space id or NULL, if space id does not exist.
  */
  FUNCTION get_dim_sign(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_rel_mlv_dim.usim_sign%TYPE
  ;

  /**
  * Retrieves the dimension n=1 sign of a given space node.
  * @param p_usim_id_spc The space id.
  * @return The dimension n=1 sign of the space id or NULL, if space id does not exist.
  */
  FUNCTION get_dim_n1_sign(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_rel_mlv_dim.usim_sign%TYPE
  ;

  /**
  * Retrieves the dimension for a given node.
  * @param p_usim_id_spc The space id to get the dimension.
  * @return Returns the dimension or -1 if node does not exist.
  */
  FUNCTION get_dimension(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_dimension.usim_n_dimension%TYPE
  ;

  /**
  * Retrieves the coordinate for a given node.
  * @param p_usim_id_spc The space id to get the dimension.
  * @return Returns the coordinate or NULL if node does not exist.
  */
  FUNCTION get_coordinate(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
  ;

  /**
  * Retrieves the process direction of a given space node.
  * @param p_usim_id_spc The space id to get the process direction.
  * @return Returns the process directions or NULL if space node does not exist.
  */
  FUNCTION get_process_spin(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_space.usim_process_spin%TYPE
  ;

  /**
  * Get basic details about a given space node.
  * @param p_usim_id_spc The space id to get the details for.
  * @param p_usim_id_rmd The associated dimension axis id.
  * @param p_usim_id_pos The associated position id.
  * @param p_usim_id_nod The associated node id.
  * @param p_process_spin The current process spin of the space node.
  * @return Returns 1 if data could be fetched or 0 on errors.
  */
  FUNCTION get_spc_details( p_usim_id_spc  IN  usim_space.usim_id_spc%TYPE
                          , p_usim_id_rmd  OUT usim_rel_mlv_dim.usim_id_rmd%TYPE
                          , p_usim_id_pos  OUT usim_position.usim_id_pos%TYPE
                          , p_usim_id_nod  OUT usim_node.usim_id_nod%TYPE
                          , p_process_spin OUT usim_space.usim_process_spin%TYPE
                          )
    RETURN NUMBER
  ;

  /**
  * Get all details about a given space node.
  * @param p_usim_id_spc The space id to get the details for.
  * @param p_usim_id_rmd The associated dimension axis id.
  * @param p_usim_id_pos The associated position id.
  * @param p_usim_id_nod The associated node id.
  * @param p_process_spin The current process spin of the space node.
  * @param p_usim_id_mlv The associated universe id.
  * @param p_n_dimension The associated dimension n.
  * @param p_dim_sign The associated sign of the dimension axis.
  * @param p_dim_n1_sign The associated n1 sign of the dimension axis.
  * @param p_coordinate The associated coordinate.
  * @param p_is_base The associated universe type.
  * @param p_energy The associated node energy.
  * @return Returns 1 if data could be fetched or 0 on errors.
  */
  FUNCTION get_spc_details( p_usim_id_spc  IN  usim_space.usim_id_spc%TYPE
                          , p_usim_id_rmd  OUT usim_rel_mlv_dim.usim_id_rmd%TYPE
                          , p_usim_id_pos  OUT usim_position.usim_id_pos%TYPE
                          , p_usim_id_nod  OUT usim_node.usim_id_nod%TYPE
                          , p_process_spin OUT usim_space.usim_process_spin%TYPE
                          , p_usim_id_mlv  OUT usim_multiverse.usim_id_mlv%TYPE
                          , p_n_dimension  OUT usim_dimension.usim_n_dimension%TYPE
                          , p_dim_sign     OUT usim_rel_mlv_dim.usim_sign%TYPE
                          , p_dim_n1_sign  OUT usim_rel_mlv_dim.usim_n1_sign%TYPE
                          , p_coordinate   OUT usim_position.usim_coordinate%TYPE
                          , p_is_base      OUT usim_multiverse.usim_is_base_universe%TYPE
                          , p_energy       OUT usim_node.usim_energy%TYPE
                          )
    RETURN NUMBER
  ;

  /**
  * Inserts a new space node for the given ids in usim_space if it does not exist yet.
  * @param p_usim_id_rmd The universe/dimension relation id.
  * @param p_usim_id_pos The position id.
  * @param p_usim_id_nod The node id.
  * @param p_usim_process_spin The process spin (1, -1).
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns the new/existing usim_id_spc id or NULL on errors.
  */
  FUNCTION insert_spc( p_usim_id_rmd       IN usim_rel_mlv_dim.usim_id_rmd%TYPE
                     , p_usim_id_pos       IN usim_position.usim_id_pos%TYPE
                     , p_usim_id_nod       IN usim_node.usim_id_nod%TYPE
                     , p_usim_process_spin IN usim_space.usim_process_spin%TYPE
                     , p_do_commit         IN BOOLEAN                           DEFAULT TRUE
                     )
    RETURN usim_space.usim_id_spc%TYPE
  ;

  /**
  * Updates usim_process_spin by flipping the existing value (1 to -1 and vice versa)
  * if the given space node is not in dimension 0 with position 0. Otherwise does nothing.
  * @param p_usim_id_spc The space id to get the max dimension.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns 1 if no errors or 0 if space id does not exist.
  */
  FUNCTION flip_process_spin( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                            , p_do_commit   IN BOOLEAN                     DEFAULT TRUE
                            )
    RETURN NUMBER
  ;

END usim_spc;
/