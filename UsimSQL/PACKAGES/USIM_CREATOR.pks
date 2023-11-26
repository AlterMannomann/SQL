CREATE OR REPLACE PACKAGE usim_creator
IS
  /**A package providing creator function on objects needed */

  /**
  * Writes a given CLOB with JSON data to the given filename with extension .json in directory USIM_DIR. Copies existing files
  * to the directory USIM_HIST_DIR and renames them to [filename]_YYYYMMDDHH24MISS.json.
  * @param p_json_clob The JSON formatted CLOB to write to [p_filename].json.
  * @param p_filename The filename for the JSON file to write. Do not use special chars and spaces. Lenght limited to 100.
  * @return Return 1 if file was written, 0 on errors.
  */
  FUNCTION write_json_file( p_json_clob IN CLOB
                          , p_filename  IN VARCHAR2 DEFAULT 'usim_space_log'
                          )
    RETURN NUMBER
  ;

  /**
  * Builds a JSON representation of the USIM_SPC_PROCESS content for the given range. If size too long for JS P5 limit the size by choosen range.
  * Will also create an assoziated structure.
  * @param p_planck_aeon The valid planck time aeon for the log.
  * @param p_from_planck_time The valid planck time tick for start of log.
  * @param p_to_planck_time The valid planck time tick for end of log.
  * @param p_json_log The JSON formatted log chunk as CLOB.
  * @return Return 1 if log was completely delivered or -1 on errors.
  */
  FUNCTION get_json_log( p_planck_aeon      IN     usim_spc_process.usim_planck_aeon%TYPE
                       , p_from_planck_time IN     usim_spc_process.usim_planck_time%TYPE
                       , p_to_planck_time   IN     usim_spc_process.usim_planck_time%TYPE
                       , p_json_log            OUT CLOB
                       )
    RETURN NUMBER
  ;

  /**
  * Builds a JSON representation of the USIM_SPACE content in means of coordinates and child relations for all
  * existing universes. No limitation in size. The given aeon and from to ticks will only mark current log content range
  * as active for display from the first tick they occured in the log. Structure will not know current energy of node.
  * @param p_planck_aeon The valid planck time aeon for the log to mark node as active.
  * @param p_from_planck_time The valid planck time tick for start of log to mark node as active.
  * @param p_to_planck_time The valid planck time tick for end of log to mark node as active.
  * @param p_json_struct The JSON formatted structure chunk as CLOB.
  * @return Return 1 if structure was completely delivered or -1 on errors.
  */
  FUNCTION get_json_struct( p_planck_aeon      IN     usim_spc_process.usim_planck_aeon%TYPE
                          , p_from_planck_time IN     usim_spc_process.usim_planck_time%TYPE
                          , p_to_planck_time   IN     usim_spc_process.usim_planck_time%TYPE
                          , p_json_struct         OUT CLOB
                          )
    RETURN NUMBER
  ;

  /**
  * Writes a space structure file in JSON format. The name of the file is fixed to usim_space_struct.json.
  * The file is written to the directory USIM_DIR. If a file already exists, it is copied before to the directory
  * USIM_HIST_DIR and renamed to a unique file name by current date extension. The given aeon and from to ticks will only mark current log content range
  * as active for display from the first tick they occured in the log. Structure will not know current energy of node.
  * As the structure for all existing universes is build, the file may get too big for JS P5. Row Order:</br>
  * 0:from x, 1:from y, 2:from z, 3:from dimension, 4:from dim sign, 5:from n1 sign, 6:first from tick active, 7:to x, 8:to y, 9:to z, 10:to dimension, 11:to dim sign, 12:to n1 sign, 13:first to tick active</br>
  * @param p_planck_aeon The valid planck time aeon for the log to mark node as active or ignored.
  * @param p_from_planck_time The valid planck time tick for start of log to mark node as active or ignored.
  * @param p_to_planck_time The valid planck time tick for end of log to mark node as active or ignored.
  * @return Return 1 if operation was successful otherwise 0.
  */
  FUNCTION create_json_struct( p_planck_aeon      IN usim_spc_process.usim_planck_aeon%TYPE
                             , p_from_planck_time IN usim_spc_process.usim_planck_time%TYPE
                             , p_to_planck_time   IN usim_spc_process.usim_planck_time%TYPE
                             )
    RETURN NUMBER
  ;

  /**
  * Writes a space log file in JSON format. The name of the file is fixed to usim_space_log.json. The file is written to the directory USIM_DIR.
  * If a file already exists, it is copied before to the directory USIM_HIST_DIR and renamed to a unique file name by
  * current date extension. Only one planck aeon supported. Will create also an associated structure, where log content is marked as active in
  * the created structure. To keep space as low as possible an array structure is used per row. Order:</br>
  * 0:from x, 1:from y, 2:from z, 3:from dimension, 4:from dim sign, 5:from n1 sign, 6:from energy, 7:to x, 8:to y, 9:to z, 10:to dimension, 11:to dim sign, 12:to n1 sign, 13:to energy, 14:output energy</br>
  * @param p_planck_aeon The planck time aeon for of the log. If NULL, p_from_planck_time is ignored and log starts with current aeon.
  * @param p_from_planck_time The planck time tick for start of log. Ignored if p_from_planck_aeon is NULL using first planck time tick in aeon given or found.
  * @param p_to_planck_time The planck time tick for end of log. if NULL, log contains every record of USIM_SPC_PROCESS for aeon given or found.
  * @return Return 1 if operation was successful otherwise 0.
  */
  FUNCTION create_space_log( p_planck_aeon      IN usim_spc_process.usim_planck_aeon%TYPE
                           , p_from_planck_time IN usim_spc_process.usim_planck_time%TYPE
                           , p_to_planck_time   IN usim_spc_process.usim_planck_time%TYPE
                           )
    RETURN NUMBER
  ;

  FUNCTION create_next_dimension(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Retrieves the dimension id for a given dimension and creates necessary dimensions, if they
  * do not exist. Given dimension must be within the base data limits.
  * @param p_usim_n_dimension The dimension to verify.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return The dimension id for given dimension or NULL if error or base data are not available.
  */
  FUNCTION init_dimension( p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                         , p_do_commit        IN BOOLEAN                              DEFAULT TRUE
                         )
    RETURN usim_dimension.usim_id_dim%TYPE
  ;

  /**
  * Retrieves the universe dimension axis id for a given universe and dimension id. Creates necessary dimension axis, if it
  * does not exist.
  * @param p_usim_id_mlv The universe id for the dimension axis.
  * @param p_usim_id_dim The dimension id for the dimension axis.
  * @param p_usim_sign The sign of the dimension axis.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return The rmd id of the dimension axis or NULL if error or base data are not available.
  */
  FUNCTION init_dim_axis( p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE
                        , p_usim_id_dim IN usim_dimension.usim_id_dim%TYPE
                        , p_usim_sign   IN usim_rel_mlv_dim.usim_sign%TYPE
                        , p_do_commit   IN BOOLEAN                          DEFAULT TRUE
                        )
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
  ;

  /**
  * Verifies that dimension and dimension axis exist for the given universe. Creates all necessary objects.
  * @param p_usim_id_mlv The universe id for the dimension.
  * @param p_usim_n_dimension The dimension to verify.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Return 1 if all was successfully verified or created otherwise 0.
  */
  FUNCTION init_dim_all( p_usim_id_mlv      IN usim_multiverse.usim_id_mlv%TYPE
                       , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                       , p_do_commit        IN BOOLEAN                              DEFAULT TRUE
                       )
    RETURN NUMBER
  ;

  /**
  * Verifies that a zero position has all connected space nodes. Creates all necessary objects.
  * Positions are set (0, 1, -1) and connections are defined.
  * @param p_usim_id_mlv The universe id for the space nodes. Mandatory.
  * @param p_usim_id_spc_parent The parent space node with position 0 and dimension one lower than the given dimension. Mandatory.
  * @param p_usim_n_dimension The dimension to use. Given dimension must be one greater than parent dimension. Mandatory.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Return 1 if all was successfully verified or created otherwise 0.
  */
  FUNCTION init_zero_dim_nodes( p_usim_id_mlv        IN usim_multiverse.usim_id_mlv%TYPE
                              , p_usim_id_spc_parent IN usim_space.usim_id_spc%TYPE
                              , p_usim_n_dimension   IN usim_dimension.usim_n_dimension%TYPE
                              , p_do_commit          IN BOOLEAN                              DEFAULT TRUE
                              )
    RETURN NUMBER
  ;

  /**
  * Creates a universe, with a basic position coordinate 0, dimension 0 and node for it. If first universe, it will be the base universe. Will
  * create also the basic connections to dimension 1 with positions +0/-0 and +1/-1 for both dimension axis.
  * Will only commit changes (if p_do_commit is TRUE) if all steps have been executed without errors. On errors always a rollback is executed.
  * @param p_usim_energy_start_value The start value of energy the universe should have. For inserts the absolute value is used and default if NULL or 0.
  * @param p_usim_planck_time_unit The outside planck time unit for this universe. Will use the absolute value and default if NULL or 0.
  * @param p_usim_planck_length_unit The outside planck length unit for this universe. Will use the absolute value and default if NULL or 0.
  * @param p_usim_planck_speed_unit The outside planck speed unit for this universe. Will use the absolute value and default if NULL or 0.
  * @param p_usim_planck_stable The definition if planck units are stable (1) or can change over time (0) for this universe. Will use 1, if value range (0, 1) is not correct.
  * @param p_usim_ultimate_border The energy flow rule for ultimate border (1) or any dimension border (0). NULL is interpreted as 1.
  * @param p_usim_id_spc_parent The usim_space id of the node, that is the parent of this universe. Ignored, if universe is base universe. Mandatory for non-base universes.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return The new usim_space id for dimension 0 or NULL if error or base data / mandatory parent in populated universe are not available.
  */
  FUNCTION create_new_universe( p_usim_energy_start_value IN usim_multiverse.usim_energy_start_value%TYPE DEFAULT 1
                              , p_usim_planck_time_unit   IN usim_multiverse.usim_planck_time_unit%TYPE   DEFAULT 1
                              , p_usim_planck_length_unit IN usim_multiverse.usim_planck_length_unit%TYPE DEFAULT 1
                              , p_usim_planck_speed_unit  IN usim_multiverse.usim_planck_speed_unit%TYPE  DEFAULT 1
                              , p_usim_planck_stable      IN usim_multiverse.usim_planck_stable%TYPE      DEFAULT 1
                              , p_usim_ultimate_border    IN usim_multiverse.usim_ultimate_border%TYPE    DEFAULT 1
                              , p_usim_id_spc_parent      IN usim_space.usim_id_spc%TYPE                  DEFAULT NULL
                              , p_do_commit               IN BOOLEAN                                      DEFAULT TRUE
                              )
    RETURN usim_space.usim_id_spc%TYPE
  ;

  /**
  * In case of dimension overflow either a new node is created, if a higher free dimension is available
  * or the creation of a new dimension with pos 0 and 1 is triggered.
  * @param p_usim_id_spc The space node id causing the overflow.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns 1 on success or 0 on errors.
  */
  FUNCTION handle_overflow_dim( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                              , p_do_commit   IN BOOLEAN                     DEFAULT TRUE
                              )
    RETURN NUMBER
  ;

  /**
  * Creates a new node in case of position overflow. Will add a new position on the axis the
  * given node is. Depends on correct identified escape strategy (3, 4) which imply the creation
  * of a new position. Will only accept nodes that are either 0 coordinate on the dimension axis or
  * nodes that have no child in current dimension.
  * @param p_usim_id_spc The space node id causing the overflow.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns 1 on success or 0 on errors.
  */
  FUNCTION handle_overflow_pos( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                              , p_do_commit   IN BOOLEAN                     DEFAULT TRUE
                              )
    RETURN NUMBER
  ;

  /**
  * Creates a new node in case of between node is needed. Between nodes are filled from bottom up.
  * @param p_usim_id_spc The space node id causing the overflow.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns 1 on success or 0 on errors.
  */
  FUNCTION handle_overflow_between( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                                  , p_do_commit   IN BOOLEAN                     DEFAULT TRUE
                                  )
    RETURN NUMBER
  ;

  /**
  * Main hub to handle overflow situations. Depending on escape classify an appropriate
  * action is executed. Will create necessary space nodes for positions, dimensions or universes.
  * @param p_usim_id_spc The usim_space id causing the overflow.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns 1 if overflow could be handled otherwise 0.
  */
  FUNCTION handle_overflow( p_usim_id_spc   IN usim_space.usim_id_spc%TYPE
                          , p_do_commit     IN BOOLEAN                     DEFAULT TRUE
                          )
    RETURN NUMBER
  ;

END usim_creator;
/
