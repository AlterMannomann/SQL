CREATE OR REPLACE PACKAGE usim_spc
IS
  /**A package for actions on table usim_space.*/

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
  * Checks if the given universe id has an unused dimension in usim_space.
  * @param p_usim_id_mlv The id of the universe.
  * @return Returns 1 if an unused dimension exists, otherwise 0.
  */
  FUNCTION has_free_dimension(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
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
  * Checks if the space id is a from type as usim_static.usim_side_from.
  * @param p_usim_id_spc The space id.
  * @return Returns 1 if the entry exists and is a from type, otherwise 0.
  */
  FUNCTION is_from_type(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if the space id is a from type as usim_static.usim_side_from and has position 0 in dimension 1.
  * @param p_usim_id_spc The space id.
  * @return Returns 1 if the entry exists and is a from type with position 0 in dimension 1, otherwise 0.
  */
  FUNCTION is_zero_from_type(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if overflow reached on positions for the dimension the space id is associated.
  * @param p_usim_id_spc The space id.
  * @return Returns 1 if overflow on positions for related dimension reached, otherwise 0.
  */
  FUNCTION overflow_pos(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if overflow reached on positions for the universe the space id is associated. Means
  * that at least one of the ultimate possible positions is used in the universe of the given
  * space id.
  * @param p_usim_id_spc The space id.
  * @return Returns 1 if overflow on positions for related universe is reached, otherwise 0.
  */
  FUNCTION overflow_mlv_pos(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if overflow reached on dimensions for the universe the space id is associated. Means
  * that at least one of the ultimate possible dimension is used in the universe of the given
  * space id.
  * @param p_usim_id_spc The space id.
  * @return Returns 1 if overflow on dimensions for related universe is reached, otherwise 0.
  */
  FUNCTION overflow_mlv_dim(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Returns the maximum available dimensions for a space id and the related universe in general.
  * @param p_usim_id_spc The space id.
  * @return Returns the maximum available dimensions for the related universe or -1 if no dimension available.
  */
  FUNCTION get_max_dimension(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_dimension.usim_n_dimension%TYPE
  ;

  /**
  * Returns the maximum available dimensions for a space id and the related universe in usim_space.
  * @param p_usim_id_spc The space id.
  * @return Returns the maximum available dimensions for the related universe or -1 if no dimension available.
  */
  FUNCTION get_cur_max_dimension(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
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
  * @param p_usim_id_nod The node id.
  * @return Returns usim_id_spc if it exists, otherwise NULL.
  */
  FUNCTION get_id_spc( p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE
                     , p_usim_id_pos IN usim_position.usim_id_pos%TYPE
                     , p_usim_id_nod IN usim_node.usim_id_nod%TYPE
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
  * Retrieves the maximum available dimension id for the universe of a given node.
  * @param p_usim_id_spc The space id to get the max dimension.
  * @return Returns the max dimension id or NULL if node does not exist.
  */
  FUNCTION get_max_id_rmd(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
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
  * Inserts a new space node for the given ids in usim_space if it does not exist yet. The process spin is
  * set automatically based on the space node. Every space node without childs gets the direction to parent
  * apart from nodes in dimension 0 which will always have direction childs.
  * @param p_usim_id_rmd The universe/dimension relation id.
  * @param p_usim_id_pos The position id.
  * @param p_usim_id_nod The node id.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns the new/existing usim_id_spc id or NULL if given ids do not exist or volume does not match position.
  */
  FUNCTION insert_spc( p_usim_id_rmd    IN usim_rel_mlv_dim.usim_id_rmd%TYPE
                     , p_usim_id_pos    IN usim_position.usim_id_pos%TYPE
                     , p_usim_id_nod    IN usim_node.usim_id_nod%TYPE
                     , p_do_commit      IN BOOLEAN                            DEFAULT TRUE
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