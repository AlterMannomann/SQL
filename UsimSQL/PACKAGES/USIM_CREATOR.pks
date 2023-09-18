CREATE OR REPLACE PACKAGE usim_creator
IS
  /**A package providing creator function on objects needed */

  /**
  * Writes a given CLOB with JSON data to usim_space_log.json in directory USIM_DIR. Copies existing files
  * to the directory USIM_HIST_DIR and renames them to usim_space_log_YYYYMMDDHH24MISS.json.
  * @param p_json_clob The JSON formatted CLOB to write to usim_space_log.json.
  * @return Return 1 if file was written, 0 on errors.
  */
  FUNCTION write_json_log(p_json_clob IN CLOB)
    RETURN NUMBER
  ;

  /**
  * Builds a JSON representation of the USIM_SPC_PROCESS content for the given range. Size is limited to roughly
  * about 5 MB each. If the total log size is over 5 MB, the log is divided at planck time ticks returning the
  * new start planck aeon and time and a return value of 0.
  * @param p_planck_aeon The valid planck time aeon for the log.
  * @param p_from_planck_time The valid planck time tick for start of log. Will return the new start planck time if log file has to be splitted by size.
  * @param p_to_planck_time The valid planck time tick for end of log.
  * @param p_json_log The JSON formatted log chunk.
  * @return Return 1 if log was completely delivered, 0 if more log chunks can be delivered or -1 on errors.
  */
  FUNCTION get_json_log( p_planck_aeon      IN     usim_spc_process.usim_planck_aeon%TYPE
                       , p_from_planck_time IN OUT usim_spc_process.usim_planck_time%TYPE
                       , p_to_planck_time   IN     usim_spc_process.usim_planck_time%TYPE
                       , p_json_log            OUT CLOB
                       )
    RETURN NUMBER
  ;

  /**
  * Writes a space log file in JSON format with maximum size of roughly 5 MB. The name of the file
  * is fixed to usim_space_log.json. The file is written to the directory USIM_DIR. If a file already
  * exists, it is copied before to the directory USIM_HIST_DIR and renamed to a unique file name by
  * current date extension. If the range of the space log is bigger than 5 MB it is cutted in 5 MB
  * pieces where the last piece remains in directory USIM_DIR. If planck aeon changes, start a new log
  * as only one planck aeon is supported. Callers must ensure that at least a second has past before
  * a new log is written to have unique names in the history log directory.
  * @param p_planck_aeon The planck time aeon for of the log. If NULL, p_from_planck_time is ignored and log starts from beginning of USIM_SPC_PROCESS.
  * @param p_from_planck_time The planck time tick for start of log. Ignored if p_from_planck_aeon is NULL.
  * @param p_to_planck_aeon The planck time aeon for end of log.
  * @param p_to_planck_time The planck time tick for end of log. if NULL, log contains every record after of USIM_SPC_PROCESS after log start.
  * @return Return 1 if operation was successful otherwise 0.
  */
  FUNCTION create_space_log( p_planck_aeon      IN usim_spc_process.usim_planck_aeon%TYPE
                           , p_from_planck_time IN usim_spc_process.usim_planck_time%TYPE
                           , p_to_planck_time   IN usim_spc_process.usim_planck_time%TYPE
                           )
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
  * Creates a universe, with a basic position coordinate 0, dimension 0 and node for it. If first universe, it will be the base universe.
  * Will create also dimension 1 axis with position 1 and sign of axis. Parent node is only allowed for non-base universes otherwise ignored.
  * Will only commit changes if all steps have been executed without errors otherwise rollback is executed.
  * @param p_usim_energy_start_value The start value of energy the universe should have. For inserts the absolute value is used and default if NULL or 0.
  * @param p_usim_planck_time_unit The outside planck time unit for this universe. Will use the absolute value and default if NULL or 0.
  * @param p_usim_planck_length_unit The outside planck length unit for this universe. Will use the absolute value and default if NULL or 0.
  * @param p_usim_planck_speed_unit The outside planck speed unit for this universe. Will use the absolute value and default if NULL or 0.
  * @param p_usim_planck_stable The definition if planck units are stable (1) or can change over time (0) for this universe. Will use 1, if value range (0, 1) is not correct.
  * @param p_usim_ultimate_border The energy flow rule for ultimate border (1) or any dimension border (0). NULL is interpreted as 1.
  * @param p_usim_id_spc_parent The usim_space id of the node, that is the parent of this universe. Ignored, if universe is base universe. Mandatory for non-base universes.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return The new usim_space id for dimension 0 or NULL if error or base data are not available.
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

END usim_creator;
/
