CREATE OR REPLACE PACKAGE usim_dbif
IS
  /**This package is used as an database interface package, handling
  * exceptions from low level packages for the existing tables and
  * applying universe rules on package usage. It has dependencies to
  * all low level packages. Packages on a higher level should only
  * use usim_dbif for accessing objects.</br>
  * Will try to handle exceptions if possible. Severe application or
  * database errors will set all universes to crashed and raise the
  * exception found. All errors get logged as far as the database basically
  * still works.
  */

  /**
  * Sets all multiverses to crashed. This is for application errors like
  * exceptions that invalidate the whole model.
  * Uses an anonymous transaction to be able to write in any case.
  */
  PROCEDURE set_crashed;

  /**
  * Wrapper for usim_mlv.update_state. Runs as autonomous transaction.
  * @param p_usim_id_mlv The id of the universe, that should update its state.
  * @param p_usim_universe_status The new state of the universe. Must match usim_static's usim_multiverse_status_dead, usim_multiverse_status_crashed, usim_multiverse_status_active or usim_multiverse_status_inactive.
  * @return Returns the updated state or NULL on errors.
  */
  FUNCTION set_universe_state( p_usim_id_mlv          IN usim_multiverse.usim_id_mlv%TYPE
                             , p_usim_universe_status IN usim_multiverse.usim_universe_status%TYPE
                             )
    RETURN usim_multiverse.usim_universe_status%TYPE
  ;

  /**
  * Determines the state of the universe, the given space node is in and
  * updates the state as following:</br>
  * Universe is inactive - set it to active.</br>
  * Universe is active   - determine if universe is dead or active and set state accordingly.</br>
  * @param p_usim_id_spc The space id of a node in a universe that should update its state.
  * @return Returns the current state of the universe or NULL on errors.
  */
  FUNCTION set_universe_state(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_multiverse.usim_universe_status%TYPE
  ;

  /**
  * Wrapper for usim_base.init_basedata.
  * Initializes the base data with the attributes that have to be set on insert if no base data
  * exist, otherwise do nothing. As this procedure mimics the constraints, adjusting the constraints needs package adjustment.
  * @param p_max_dimension The maximum dimensions possible for this multiverse.
  * @param p_usim_abs_max_number The absolute maximum number available for this multiverse.
  * @param p_usim_overflow_node_seed Defines the overflow behaviour, default 0 means standard overflow behaviour. If set to 1, all new nodes are created with the universe seed at coordinate 0 as the parent.
  * @return Returns 1 if base data init was successful, 0 on errors.
  */
  FUNCTION init_basedata( p_max_dimension            IN NUMBER DEFAULT 42
                        , p_usim_abs_max_number      IN NUMBER DEFAULT 99999999999999999999999999999999999999
                        , p_usim_overflow_node_seed  IN NUMBER DEFAULT 0
                        )
    RETURN NUMBER
  ;

  /**
  * Initialize the dimensions supported by the multiverse defined by usim_max_dimension in base_data.
  * Does nothing if base data do not exist. Wrapper for usim_dim.init_dimensions.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns 1 if base data exist and init was successful, 0 if base data do not exist and -1 on errors.
  */
  FUNCTION init_dimensions(p_do_commit IN BOOLEAN DEFAULT TRUE)
    RETURN NUMBER
  ;

  /**
  * Initialize the positions supported by the multiverse defined by usim_abs_max_number in base_data.
  * Does nothing if base data do not exist. Wrapper for usim_pos.init_positions.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns 1 if base data exist and init was successful, 0 if base data do not exist and -1 on errors.
  */
  FUNCTION init_positions(p_do_commit IN BOOLEAN DEFAULT TRUE)
    RETURN NUMBER
  ;

  /**
  * Checks if usim_space has already data.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data_spc
    RETURN NUMBER
  ;

  /**
  * Checks if a given usim_multiverse id exists.
  * @param p_usim_id_mlv The id of the universe to check.
  * @return Returns 1 if universe exists, otherwise 0.
  */
  FUNCTION has_data_mlv(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if a given position is in overflow. Depends on init_positions. Overflow is simply detected
  * by a position that does not exist.
  * @param p_usim_coordinate The coordinate to check against overflow.
  * @return Returns 1 if given position coordinate is counted as overflow otherwise 0.
  */
  FUNCTION is_overflow_pos(p_usim_coordinate IN usim_position.usim_coordinate%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if a given universe is in position overflow. Depends on base data. Overflow is detected by highest
  * available space coordinates for every sign and compared against the maximum possible number.
  * @param p_usim_id_mlv The universe id to check against position overflow.
  * @return Returns 1 if given universe is counted as position overflow otherwise 0.
  */
  FUNCTION is_overflow_pos_mlv(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if the universe of a given space id is in position overflow. Depends on base data. Overflow is detected by highest
  * available space coordinates for every sign and compared against the maximum possible number.
  * @param p_usim_id_spc The space id to check the universe it belongs against position overflow.
  * @return Returns 1 if the universe for the given space id is counted as position overflow otherwise 0.
  */
  FUNCTION is_overflow_pos_spc(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if a given dimension is in overflow. Depends on init_dimensions. Overflow is simply detected
  * by a dimension that does not exist.
  * @param p_usim_coordinate The dimension to check against overflow.
  * @return Returns 1 if given dimendion is counted as overflow otherwise 0.
  */
  FUNCTION is_overflow_dim(p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if a given universe is in dimension overflow. Depends on base data. Overflow is detected by highest
  * available rmd dimension for every n1 sign and compared against the maximum possible dimensions.
  * @param p_usim_id_mlv The universe id to check against dimension overflow.
  * @return Returns TRUE if given universe is counted as dimension overflow otherwise FALSE.
  */
  FUNCTION is_overflow_dim_mlv(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if the universe of a given space id is in dimension overflow. Depends on base data. Overflow is detected by highest
  * available space dimension for every n1 sign and compared against the maximum possible dimension.
  * @param p_usim_id_spc The space id to check the universe it belongs against dimension overflow.
  * @return Returns 1 if the universe for the given space id is counted as dimension overflow otherwise 0.
  */
  FUNCTION is_overflow_dim_spc(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if a given energy is in overflow. Depends on base data. Overflow is detected
  * by checking the given value against the maximum number supported.
  * @param p_energy The energy value to check against overflow.
  * @return Returns 1 if energy is counted as overflow otherwise 0 (also if no base data exist).
  */
  FUNCTION is_overflow_energy(p_energy IN NUMBER)
    RETURN NUMBER
  ;

  /**
  * Checks if an addition of  given energies would produce an overflow. Depends on base data. Overflow is detected
  * by checking the given value against the maximum number supported.
  * @param p_energy The energy value to check against overflow.
  * @return Returns 1 if energy is counted as overflow otherwise 0.
  */
  FUNCTION is_overflow_energy_add( p_energy IN NUMBER
                                 , p_add    IN NUMBER
                                 )
    RETURN NUMBER
  ;

  /**
  * Wrapper for usim_spc.get_id_spc_base_universe.
  * Checks if a given space node id is the base universe seed at dimension 0 and position 0.
  * @param p_usim_id_spc The space node id to check.
  * @return Returns 1 space node is base universe seed otherwise 0.
  */
  FUNCTION is_base_universe_seed(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Wrapper for usim_mlv.insert_universe.
  * Inserts a new universe with the given values. Does check if a base universe already exists. USIM_UNIVERSE_STATUS is automatically set
  * to inactive on insert. USIM_IS_BASE_UNIVERSE is determined by existance of data. If no base universe exist, the universe gets the base universe, otherwise
  * the universe will be a sub-universe of the existing base universe.
  * @param p_usim_energy_start_value The start value of energy the universe should have. For inserts the absolute value is used or default if NULL or 0.
  * @param p_usim_planck_time_unit The outside planck time unit for this universe. Will use the absolute value or default if NULL or 0.
  * @param p_usim_planck_length_unit The outside planck length unit for this universe. Will use the absolute value or default if NULL or 0.
  * @param p_usim_planck_speed_unit The outside planck speed unit for this universe. Will use the absolute value or default if NULL or 0.
  * @param p_usim_planck_stable The definition if planck units are stable (1) or can change over time (0) for this universe. Will use 1, if value range (0, 1) is not correct.
  * @param p_usim_ultimate_border The ultimate border rule for this universe. 1 is ultimate border reached, no childs left, 0 is any border at dimensions axis even with childs left.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return The new universe big id or NULL if insert failed.
  */
  FUNCTION create_universe( p_usim_energy_start_value IN usim_multiverse.usim_energy_start_value%TYPE DEFAULT 1
                          , p_usim_planck_time_unit   IN usim_multiverse.usim_planck_time_unit%TYPE   DEFAULT 1
                          , p_usim_planck_length_unit IN usim_multiverse.usim_planck_length_unit%TYPE DEFAULT 1
                          , p_usim_planck_speed_unit  IN usim_multiverse.usim_planck_speed_unit%TYPE  DEFAULT 1
                          , p_usim_planck_stable      IN usim_multiverse.usim_planck_stable%TYPE      DEFAULT 1
                          , p_usim_ultimate_border    IN usim_multiverse.usim_ultimate_border%TYPE    DEFAULT 1
                          , p_do_commit               IN BOOLEAN                                      DEFAULT TRUE
                          )
    RETURN usim_multiverse.usim_id_mlv%TYPE
  ;

  /**
  * Creates a negative and a positive dim axis in usim_rel_mlv_dim if dimension > 0. Dimension 0 has only one
  * axis, in this case positive and negative dimension axis are equal. Wrapper for usim_rmd.insert_rmd.
  * @param p_usim_id_mlv The id of the universe, to add a dimension axis. The universe must exist.
  * @param p_usim_n_dimension The dimension n to create an dimension axis with signs for. Must be >= 0, integer and must exist.
  * @param p_usim_id_rmd_parent The rmd id of the parent axis at n = 1 if dimension > 1 otherwise NULL.
  * @param p_usim_id_rmd_pos The dimension axis for the given dimension with sign 1 if dimension > 0. Otherwise equal to p_usim_id_rmd_neg.
  * @param p_usim_id_rmd_neg The dimension axis for the given dimension with sign -1 if dimension > 0. Otherwise equal to p_usim_id_rmd_pos.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns 1 if dimension axis could be created or retrieved, 0 on errors.
  */
  FUNCTION create_dim_axis( p_usim_id_mlv        IN  usim_multiverse.usim_id_mlv%TYPE
                          , p_usim_n_dimension   IN  usim_dimension.usim_n_dimension%TYPE
                          , p_usim_id_rmd_parent IN  usim_rel_mlv_dim.usim_id_rmd%TYPE
                          , p_usim_id_rmd_pos    OUT usim_rel_mlv_dim.usim_id_rmd%TYPE
                          , p_usim_id_rmd_neg    OUT usim_rel_mlv_dim.usim_id_rmd%TYPE
                          , p_do_commit          IN  BOOLEAN                              DEFAULT TRUE
                          )
    RETURN NUMBER
  ;

  /**
  * Wrapper for usim_spc.insert_spc.
  * Inserts a new space node for the given ids in usim_space if it does not exist yet. Updates childs
  * and space position. Node is created if space node does not exist.
  * @param p_usim_id_rmd The universe/dimension relation id.
  * @param p_usim_id_pos The position id.
  * @param p_usim_id_spc_parent The parent of this space node. NULL only allowed if universe of rmd is base universe and no entry at dimension 0, position 0, sign 0, n1 sign NULL does not exist.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns the new/existing usim_id_spc id or NULL on errors.
  */
  FUNCTION create_space_node( p_usim_id_rmd        IN usim_rel_mlv_dim.usim_id_rmd%TYPE
                            , p_usim_id_pos        IN usim_position.usim_id_pos%TYPE
                            , p_usim_id_spc_parent IN usim_space.usim_id_spc%TYPE
                            , p_do_commit          IN BOOLEAN                           DEFAULT TRUE
                            )
    RETURN usim_space.usim_id_spc%TYPE
  ;

  /**
  * Wrapper for usim_pos.get_id_pos.
  * Retrieve the position id for a given coordinate.
  * @param p_usim_coordinate The coordinate to get the position id for.
  * @return Returns the usim_id_pos for the given coordinate or NULL on errors.
  */
  FUNCTION get_id_pos(p_usim_coordinate IN usim_position.usim_coordinate%TYPE)
    RETURN usim_position.usim_id_pos%TYPE
  ;

  /**
  * Wrapper for usim_spc.get_id_pos.
  * Retrieve the position id for a given coordinate.
  * @param p_usim_id_spc The space id to get the position id for.
  * @return Returns the usim_id_pos for the given coordinate or NULL on errors.
  */
  FUNCTION get_id_pos(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_position.usim_id_pos%TYPE
  ;

  /**
  * Retrieves the current absolute maximum number allowed.
  * @return The current value from column usim_abs_max_number or NULL if base data are not initialized.
  */
  FUNCTION get_abs_max_number
    RETURN NUMBER
  ;

  /**
  * Retrieves the coordinate of a given dimension and space node, if it exists in USIM_SPC_POS. The given dimension
  * may not be initialized yet and defaults to 0 if not available.
  * Relies on the fact, that table holds one position for one dimension, whatever axis the dimension has.
  * @param p_usim_id_spc The space id to get the coordinate for.
  * @param p_usim_n_dimension The dimension to get the coordinate for.
  * @return Returns on success the coordinate of the given dimension, otherwise NULL.
  */
  FUNCTION get_dim_coord( p_usim_id_spc      IN usim_space.usim_id_spc%TYPE
                        , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                        )
    RETURN usim_position.usim_coordinate%TYPE
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
  * Retrieves the dimension sign of a given space node.
  * @param p_usim_id_spc The space id.
  * @return The dimension sign of the space id or NULL, if space id does not exist.
  */
  FUNCTION get_dim_sign(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_rel_mlv_dim.usim_sign%TYPE
  ;

  /**
  * Retrieves the x,y,z coordinates of a given space node, if it exists in USIM_SPC_POS.
  * @param p_usim_id_spc The space id to get the coordinates for.
  * @return Returns on success a comma separated string, format x,y,z, otherwise NULL.
  */
  FUNCTION get_xyz(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN VARCHAR2
  ;

  /**
  * Gets the overflow rating for a given space id. Overflow rating:</br>
  * 0 if universe has overflow in position and dimension.</br>
  * 1 if no overflow at all.</br>
  * 2 if overflow in position.</br>
  * 3 if overflow in dimension.</br>
  * @param p_usim_id_spc The child id to check data for.
  * @return Returns overflow rating as defined.
  */
  FUNCTION overflow_rating(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Gets the dimension axis rating for a given space id and the possible maximum number of childs. Dimension rating:</br>
  * -1 error retrieving axis rating.</br>
  * 0 center axis at dimension n = 0, with position 0 in dimension 0. 2 special childs possible with opposite output energy sign.</br>
  * 1 center axis at dimension n > 0, with position 0 in dimension n and sign (-/+1). 2 childs possible</br>
  * 2 node is pure dimension axis coordinate, all other dimension coordinates are 0 apart from current dimension. 2 x n + 1 possible childs</br>
  * 3 node is in the middle of somewhere. 2 x n connections - x parents = possible childs</br>
  * @param p_usim_id_spc The child id to check data for.
  * @param p_max_childs The maximum childs possible as calculated for dimension axis type.
  * @return Returns dimension rating as defined.
  */
  FUNCTION dimension_rating( p_usim_id_spc IN  usim_space.usim_id_spc%TYPE
                           , p_max_childs  OUT NUMBER
                           )
    RETURN NUMBER
  ;

  /**
  * Gets the dimension axis rating for a given space id. Dimension rating:</br>
  * -1 error retrieving axis rating.</br>
  * 0 center axis at dimension n = 0, with position 0 in dimension 0. 2 special childs possible with opposite output energy sign.</br>
  * 1 center axis at dimension n > 0, with position 0 in dimension n and sign (-/+1). 2 childs possible</br>
  * 2 node is pure dimension axis coordinate, all other dimension coordinates are 0 apart from current dimension. 2 x n + 1 possible childs</br>
  * 3 node is in the middle of somewhere. 2 x n connections - x parents = possible childs</br>
  * @param p_usim_id_spc The child id to check data for.
  * @return Returns dimension rating as defined.
  */
  FUNCTION dimension_rating(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /***
  * Returns the maximum possible childs a given space node can have calculated by the identified dimension axis type.
  * Just a wrapper for dimension_rating.
  * @param p_usim_id_spc The child id to check data for.
  * @return Returns the maximum possible childs for the given space node or < 0 on errors.
  */
  FUNCTION max_childs(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Classifies a space parent node in means of options for connects to new space nodes. Considers only existing dimensions
  * and position. Does not consider situations of escape and extend. Will set universe to crashed on severe errors.</br>
  * Classifications:</br>
  * -2 node not allowed, e.g. from type parent with ancestor in dimension 1 and position != 0.</br>
  * -1 node data model corrupt, e.g. id is NULL or amount of childs not in sync with model.</br>
  * 0 node is fully connected, no further childs or connects are possible.</br>
  * 1 node is ready to get connected, further childs or connects are possible to dimensions and positions.</br>
  * 2 node is ready to get connected, further childs or connects are possible only to dimensions.</br>
  * 3 node is ready to get connected, further childs or connects are possible only to positions.</br>
  * @param p_usim_id_spc The parent space id to classify.
  * @return Returns the classification of the parent space node.
  */
  FUNCTION classify_parent(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Classifies a space node in means of options to escape the universe or extend the existing universe dimensions and
  * positions within the limits, so new connections are possible.</br>
  * Classifications:</br>
  * -1 error.</br>
  * 0 node can only escape to another universe.</br>
  * 1 node can extend dimensions and positions to escape.</br>
  * 2 node can only extend dimensions to escape.</br>
  * 3 node can only extend positions to escape.</br>
  * @param p_usim_id_spc The space id to classify.
  * @return Returns the classification of the space node for escapes.
  */
  FUNCTION classify_escape(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

END usim_dbif;
/