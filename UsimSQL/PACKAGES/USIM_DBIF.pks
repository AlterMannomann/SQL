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
  * Wrapper for usim_mlv.update_state. Updates state by USIM_MLV_STATE_V valid and calculated state.
  * If state does not match (STATUS_VALID = 0) the calculated state is set. If state is valid, do nothing.
  * @param p_usim_id_mlv The id of the universe, that should update its state.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns the updated state or NULL on errors.
  */
  FUNCTION set_universe_state( p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE
                             , p_do_commit   IN BOOLEAN                          DEFAULT TRUE
                             )
    RETURN usim_multiverse.usim_universe_status%TYPE
  ;

  /**
  * Determines the state of the universe, the given space node is in and updates the state to the calculated state
  * of USIM_MLV_STATE_V if current state is not valid.
  * @param p_usim_id_spc The space id of a node in a universe that should update its state.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns the current state of the universe or NULL on errors.
  */
  FUNCTION set_universe_state_spc( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                                 , p_do_commit   IN BOOLEAN                     DEFAULT TRUE
                                 )
    RETURN usim_multiverse.usim_universe_status%TYPE
  ;

  /**
  * Sets the seed universe active ignoring any current state. Used for placing start node and activate the seed universe for the
  * first run. Afterwards the universe state should be determined after running a process queue.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns the activated state of the universe or NULL on errors.
  */
  FUNCTION set_seed_active(p_do_commit IN BOOLEAN DEFAULT TRUE)
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
  * Checks if base data have been initialized.
  * @return Returns 1 if base data are available, otherwise 0.
  */
  FUNCTION has_basedata
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
  * Checks if usim_space has already data for a given space id.
  * @param p_usim_id_spc The relation id of universe/dimension/position/node.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data_spc(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if usim_spc_process has already data.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data_spr
    RETURN NUMBER
  ;

  /**
  * Checks if usim_spc_process has already data for a given process id.
  * @param p_usim_id_spr The process id to check.
  * @return Returns 1 if data are available for this id, otherwise 0.
  */
  FUNCTION has_data_spr(p_usim_id_spr IN usim_spc_process.usim_id_spr%TYPE)
    RETURN NUMBER
  ;

  /**
  * Wrapper for usim_spr.has_unprocessed.
  * Checks if usim_spc_process has unprocessed data.
  * @return Returns 1 if unprocessed data are available, otherwise 0.
  */
  FUNCTION has_unprocessed
    RETURN NUMBER
  ;

  /**
  * Checks if usim_multiverse has data.
  * @return Returns 1 if data exists, otherwise 0.
  */
  FUNCTION has_data_mlv
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
  * Wrapper for usim_spo.has_axis_max_pos_parent.
  * Checks if for the given space id a maximum position on the dimension axis of the space
  * node exists, that may or may not be different to the given space id. Handles escape situation 4 where
  * dimension axis zero nodes can trigger new positions on their dimension axis.
  * @param p_usim_id_spc The space id to check for max position on its dimension axis.
  * @return Returns 1 for maximum dimension position found, 0 for not found and -1 for errors in dimension symmetry.
  */
  FUNCTION has_axis_max_pos_parent(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if the universe seed is active.
  * @return Returns 1 if universe seed is active, otherwise 0.
  */
  FUNCTION is_seed_active
    RETURN NUMBER
  ;

  /**
  * Checks if the universe is active the given space node is in.
  * @param p_usim_id_spc The id of the space node to check universe state.
  * @return Returns 1 if universe is active, otherwise 0 for dead, crashed or inactive.
  */
  FUNCTION is_universe_active(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if the given space node is a base universe, not necessarily the base universe seed. Must have position 0
  * at dimension 0. Parents are not considered.
  * @param p_usim_id_spc The id of the space node to check universe base state.
  * @return Returns 1 if universe is a base type universe otherwise 0.
  */
  FUNCTION is_universe_base_type(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
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
  * Checks if the universe for a given space id is in dimension overflow. Depends on base data. Overflow is detected by highest
  * available space dimension for every n1 sign and compared against the maximum possible dimension.
  * @param p_usim_id_spc The space id to check the universe it belongs against dimension overflow.
  * @return Returns 1 if the universe for the given space id is counted as dimension overflow otherwise 0.
  */
  FUNCTION is_overflow_dim_spc(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if the universe for a given space id is in position overflow. Means that for this specific space
  * id no position is free. Positions itself may not be in overflow.
  * @param p_usim_id_spc The space id to check the universe it belongs against position overflow.
  * @return Returns 1 if the universe for the given space id is counted as position overflow otherwise 0.
  */
  FUNCTION is_overflow_pos_spc(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
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
  * Wrapper for usim_spr.is_queue_valid.
  * Checks if the current unprocessed queue is valid. All unprocessed records must have the current
  * planck aeon and time and if the table is not empty, there must be at least 2 process records.
  * Count of process records must be a multitude of 2. An empty table will also return 1.
  * @return Returns 1 if queue is ready to be processed, otherwise error code: 0 no unprocessed records, -1 planck aeon/time error, -2 record count wrong.
  */
  FUNCTION is_queue_valid
    RETURN NUMBER
  ;

  /**
  * Checks if a given space id is extendable with a new position. Space node must either be a zero position axis node or
  * a node that has no child it its dimension to match.
  * @param p_usim_id_spc The space node id to check.
  * @return Returns 1 if node has no child in its dimension, 2 if node is a zero position axis node else 0.
  */
  FUNCTION is_pos_extendable(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if a given space id is extendable with a new dimension.
  * @param p_usim_id_spc The space node id to check.
  * @param p_use_parent The parent space node id to use for dimension extend. NULL on return 0.
  * @param p_next_dim The next available dimension to create. NULL on return 0.
  * @return Returns 1 if node has no child in free dimension, 2 if new dimension on zero axis should be build else error 0.
  */
  FUNCTION is_dim_extendable( p_usim_id_spc IN  usim_space.usim_id_spc%TYPE
                            , p_use_parent  OUT usim_space.usim_id_spc%TYPE
                            , p_next_dim    OUT usim_dimension.usim_n_dimension%TYPE
                            )
    RETURN NUMBER
  ;

  /**
  * Get the child count of a given space node either in related universe are in all
  * universes.
  * @param p_usim_id_spc The space node id to check.
  * @param p_ignore_mlv Defines if childs are only counted within universe of the space node (0) or childs are counted regardless of the universe they are in.
  * @return Returns amount of childs for the given space node and universe mode or NULL on errors.
  */
  FUNCTION child_count( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                      , p_ignore_mlv  IN NUMBER                      DEFAULT 0
                      )
    RETURN NUMBER
  ;

  /**
  * Get the parent count of a given space node either in related universe are in all
  * universes.
  * @param p_usim_id_spc The space node id to check.
  * @param p_ignore_mlv Defines if parents are only counted within universe of the space node (0) or parents are counted regardless of the universe they are in.
  * @return Returns amount of parents for the given space node and universe mode or NULL on errors.
  */
  FUNCTION parent_count( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                       , p_ignore_mlv  IN NUMBER                      DEFAULT 0
                       )
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
  * Inserts a new space node for the given ids in usim_space. Updates childs
  * and space position. Node is created for the space node.
  * @param p_usim_id_rmd The universe/dimension relation id.
  * @param p_usim_id_pos The position id.
  * @param p_usim_parents An array of position parent ids for this space node. EMPTY only allowed if universe of rmd is base universe and no entry at dimension 0, position 0, sign 0, n1 sign NULL does not exist.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns the new usim_id_spc id or NULL on errors.
  */
  FUNCTION create_space_node( p_usim_id_rmd  IN usim_rel_mlv_dim.usim_id_rmd%TYPE
                            , p_usim_id_pos  IN usim_position.usim_id_pos%TYPE
                            , p_usim_parents IN usim_static.usim_ids_type
                            , p_do_commit    IN BOOLEAN                           DEFAULT TRUE
                            )
    RETURN usim_space.usim_id_spc%TYPE
  ;

  /**
  * Wrapper for usim_spr.insert_spr.
  * Inserts a new process record with status IS_PROCESSED = 0 and current real time, planck aeon
  * and planck tick.
  * @param p_usim_id_spc_source The space id of the process that emits energy. Must exist.
  * @param p_usim_id_spc_target The space id of the process that receives energy. Must exist.
  * @param p_usim_energy_source The energy of the source before processing. NULL not allowed.
  * @param p_usim_energy_target The energy of the target before processing.
  * @param p_usim_energy_output The energy output of the source before processing. NULL not allowed.
  * @return Returns the process id, otherwise NULL if constraints are not fulfilled.
  */
  FUNCTION create_process( p_usim_id_spc_source IN usim_space.usim_id_spc%TYPE
                         , p_usim_id_spc_target IN usim_space.usim_id_spc%TYPE
                         , p_usim_energy_source IN usim_spc_process.usim_energy_source%TYPE
                         , p_usim_energy_target IN usim_spc_process.usim_energy_target%TYPE
                         , p_usim_energy_output IN usim_spc_process.usim_energy_output%TYPE
                         , p_do_commit          IN BOOLEAN                                  DEFAULT TRUE
                         )
    RETURN usim_spc_process.usim_id_spr%TYPE
  ;

  /**
  * Checks border situation for a given space node and flips, depending on the border rule,
  * the process spin to the correct direction.
  * @param p_usim_id_spc The space node to check. Mandatory.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Return 1 if all was successfully processed otherwise 0.
  */
  FUNCTION check_border( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                       , p_do_commit   IN BOOLEAN                     DEFAULT TRUE
                       )
    RETURN NUMBER
  ;

  /**
  * Wrapper for usim_spc.flip_process_spin.
  * Updates usim_process_spin by flipping the existing value (1 to -1 and vice versa)
  * if the given space node is not in dimension 0 with position 0. Otherwise does nothing.
  * @param p_usim_id_spc The space id to flip process spin.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns 1 if no errors or 0 if space id does not exist.
  */
  FUNCTION flip_process_spin( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                            , p_do_commit   IN BOOLEAN                     DEFAULT TRUE
                            )
    RETURN NUMBER
  ;

  /**
  * Wrapper for usim_spr.set_processed.
  * Sets the given process step to processed.
  * @param p_usim_id_spr The process id of the process that should be set to processed. Must exist.
  * @param p_process_state The process state to set. 1=processed, 2=universe not active, not processed. Default is 1.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns 1 if processed state could be set otherwise 0.
  */
  FUNCTION set_processed( p_usim_id_spr   IN usim_spc_process.usim_id_spr%TYPE
                        , p_process_state IN usim_spc_process.is_processed%TYPE DEFAULT 1
                        , p_do_commit     IN BOOLEAN                            DEFAULT TRUE
                        )
    RETURN NUMBER
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
  * Wrapper for usim_spc.get_id_nod.
  * Retrieves the node id for a given space id if it exists in usim_space.
  * @param p_usim_id_spc The space id.
  * @return Returns usim_id_nod if space id exists, otherwise NULL.
  */
  FUNCTION get_id_nod(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_node.usim_id_nod%TYPE
  ;

  /**
  * Wrapper for usim_spc.get_id_mlv.
  * Retrieves the universe id for a given space id if it exists in usim_space.
  * @param p_usim_id_spc The space id.
  * @return Returns usim_id_mlv if space id exists, otherwise NULL.
  */
  FUNCTION get_id_mlv(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_multiverse.usim_id_mlv%TYPE
  ;

  /**
  * Wrapper for usim_spc.get_id_spc_base_universe.
  * Retrieve the space id of the universe base seed at position 0 and dimension 0 without any parents.
  * @return Returns the usim_id_spc if a base universe seed exists or NULL.
  */
  FUNCTION get_id_spc_base_universe
    RETURN usim_space.usim_id_spc%TYPE
  ;

  /**
  * Retrieve details about the space id for creation new dimensions.
  * @param p_usim_id_spc The space id to get data for.
  * @param p_usim_id_mlv The universe id of the space node.
  * @param p_usim_id_rmd The dimension axis id of the space node.
  * @param p_usim_sign The dimension sign of the space node.
  * @param p_usim_n1_sign The dimension n1 sign of the space node.
  * @return Returns 1 if data exist for space id or 0 if space id does not exist.
  */
  FUNCTION get_spc_dim_details( p_usim_id_spc  IN  usim_space.usim_id_spc%TYPE
                              , p_usim_id_mlv  OUT usim_multiverse.usim_id_mlv%TYPE
                              , p_usim_id_rmd  OUT usim_rel_mlv_dim.usim_id_rmd%TYPE
                              , p_usim_sign    OUT usim_rel_mlv_dim.usim_sign%TYPE
                              , p_usim_n1_sign OUT usim_rel_mlv_dim.usim_n1_sign%TYPE
                              )
    RETURN NUMBER
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
  * Retrieves the dimension n=1 sign of a given space node.
  * @param p_usim_id_spc The space id.
  * @return The dimension n1 sign of the space id, 0 for base universe nodes or NULL, if space id does not exist.
  */
  FUNCTION get_dim_n1_sign(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_rel_mlv_dim.usim_n1_sign%TYPE
  ;

  /**
  * Wrapper for usim_spo.get_xyz.
  * Retrieves the x,y,z coordinates of a given space node, if it exists in USIM_SPC_POS.
  * @param p_usim_id_spc The space id to get the coordinates for.
  * @return Returns on success a comma separated string, format x,y,z, otherwise NULL.
  */
  FUNCTION get_xyz(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN VARCHAR2
  ;

  /**
  * Wrapper for usim_spc.get_process_spin.
  * Retrieves the process direction of a given space node.
  * @param p_usim_id_spc The space id to get the process direction.
  * @return Returns the process directions or NULL if space node does not exist.
  */
  FUNCTION get_process_spin(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_space.usim_process_spin%TYPE
  ;

  /**
  * Retrieves the text expression of the universe state of the given space node.
  * @param p_usim_id_spc The space id to get the universe state description for.
  * @return Returns ACTIVE, INACTIVE, CRASHED, DEAD or UNKNOWN if universe does not exist.
  */
  FUNCTION get_universe_state_desc(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN VARCHAR2
  ;

  /**
  * Wrapper for usim_base.get_planck_time_current
  * Retrieves the current planck time tick.
  * @return The current value from column usim_planck_time_seq_curr or NULL if not initialized.
  */
  FUNCTION get_planck_time_current
    RETURN NUMBER
  ;

  /**
  * Wrapper for usim_base.get_planck_aeon_seq_current.
  * Retrieves the current planck aeon sequence big id.
  * @return The current value from column usim_planck_aeon_seq_curr or usim_static.usim_not_available if not initialized.
  */
  FUNCTION get_planck_aeon_seq_current
    RETURN VARCHAR2
  ;

  /**
  * Wrapper for usim_base.get_planck_time_next.
  * Retrieves the next planck time tick. Will update current and last planck time as well as planck
  * aeon if planck time sequence will cycle. If planck aeon is not set, it will be initialized.
  * @return The next planck time tick number or NULL if not initialized/sequence does not exist.
  */
  FUNCTION get_planck_time_next
    RETURN NUMBER
  ;

  /**
  * Wrapper for usim_spr.get_unprocessed_planck.
  * Fetches the current planck aeon and time if the queue is valid. Will not operate on empty tables.
  * @param p_usim_planck_aeon The planck aeon for the current unprocessed records.
  * @param p_usim_planck_time The planck time for the current unprocessed records.
  * @return Returns 1 if planck data could be fetched, otherwise error code from USIM_SPR.IS_QUEUE_VALID: 0 no unprocessed records, -1 planck aeon/time error, -2 record count wrong.
  */
  FUNCTION get_unprocessed_planck( p_usim_planck_aeon OUT usim_spc_process.usim_planck_aeon%TYPE
                                 , p_usim_planck_time OUT usim_spc_process.usim_planck_time%TYPE
                                 )
    RETURN NUMBER
  ;

  /**
  * Wrapper for usim_spo.get_axis_max_pos_parent.
  * Gets the space node with the maximum position on the given dimension axis. The dimension sign is
  * used to identify the expected coordinate sign, the dimension n1 sign is used to limit the space
  * which is divided into two subspaces by dimension 1. The dimension itself is used to identify the
  * dimension axis, we want to get a new parent node from to extend the dimension and universe.
  * Used with escape situation 4 where dimension axis zero nodes can trigger new positions on their dimension axis.
  * @param p_usim_id_spc The space id ancestor node which may be itself the parent node or a 0 node on a dimension axis that can trigger new coordinates.
  * @return The space node with the highest position on a dimension axis, sign and n1 sign of the given ancestor node, otherwise NULL on errors. Use has_axis_max_pos_parent to check before call.
  */
  FUNCTION get_axis_max_pos_parent(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_space.usim_id_spc%TYPE
  ;

  /**
  * Retrieve the the next position and axis for a given space id.
  * @param p_usim_id_spc The space id ancestor node which may be itself the parent node or a 0 node on a dimension axis that can trigger new coordinates.
  * @return Return 1 if the operation was successful otherwise 0.
  */
  FUNCTION get_next_pos_on_axis( p_usim_id_spc IN  usim_space.usim_id_spc%TYPE
                               , p_usim_id_pos OUT usim_position.usim_id_pos%TYPE
                               , p_usim_id_rmd OUT usim_rel_mlv_dim.usim_id_rmd%TYPE
                               )
    RETURN NUMBER
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
  * 1 center axis at dimension n > 0, with position 0 in dimension n and sign (-/+1). 2 x n + 1 child possible</br>
  * 2 node is pure dimension axis coordinate, all other dimension coordinates are 0 apart from current dimension. 1 possible child</br>
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
  * 4 node is ready to get connected, only new positions on dimension 1 axis possible.</br>
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
  * 4 node can only extend positions on dimension 1 axis to escape.</br>
  * @param p_usim_id_spc The space id to classify.
  * @return Returns the classification of the space node for escapes.
  */
  FUNCTION classify_escape(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Retrieves the dimensional gravitational constant for a given space node and its dimension.
  * A wrapper for usim_maths.calc_dim_G.
  * @param p_usim_id_spc The space node to get G for. Mandatory.
  * @param p_node_G The dimensional gravitational constant for the space node as OUT parameter.
  * @return Returns 1 if G could be calculated, 0 if an overflow happened or -1 on not supported errors or missing space id.
  */
  FUNCTION get_dim_G( p_usim_id_spc IN  usim_space.usim_id_spc%TYPE
                    , p_node_G      OUT NUMBER
                    )
    RETURN NUMBER
  ;

  /**
  * Retrieves the outer radius for a given space node. Radius r is the distance from one node to another node.
  * @param p_usim_id_spc The space node to get G for. Mandatory.
  * @param p_outer_planck_r The outer planck radius, the distance between space nodes, as OUT parameter.
  * @return Returns 1 if radius could be calculated, 0 if an overflow happened or -1 on not supported errors or missing space id.
  */
  FUNCTION get_outer_planck_r( p_usim_id_spc    IN  usim_space.usim_id_spc%TYPE
                             , p_outer_planck_r OUT NUMBER
                             )
    RETURN NUMBER
  ;

  /**
  * Retrieves the energy as acceleration to add to the target node.
  * A wrapper for usim_maths.calc_planck_a2.
  * @param p_energy The energy of the source space node that accelerates its energy to the position of the target space node.
  * @param p_radius The outer distance between neighbor space nodes.
  * @param p_G The dimensional gravitational constant G for the source space node and its dimension.
  * @param p_target_energy The energy to add to the target energy as OUT parameter.
  * @return Returns 1 if target energy could be calculated, 0 on overflow or -1 on not supported errors or missing space id.
  */
  FUNCTION get_acceleration( p_energy         IN  NUMBER
                           , p_radius         IN  NUMBER
                           , p_G              IN  NUMBER
                           , p_target_energy  OUT NUMBER
                           )
    RETURN NUMBER
  ;

END usim_dbif;
/