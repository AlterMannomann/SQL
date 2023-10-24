CREATE OR REPLACE PACKAGE usim_process
IS
  /**A package for processing space nodes. Depends on all available packages including USIM_CREATOR.*/

  /**
  * Provides a process start node in the queue. The start node is always the base universe seed at position 0 and dimension 0
  * without any parent. The process direction is childs. Should be called only once. Will do nothing if processing nodes already
  * exist. Will create base data with given parameters, if missing, intialize planck time if not done and create a universe seed, if it
  * does not exist using given parameters. Will activate the universe, if not active.
  * @param p_max_dimension The maximum dimensions possible for this multiverse. Base data init.
  * @param p_usim_abs_max_number The absolute maximum number available for this multiverse. Base data init.
  * @param p_usim_overflow_node_seed Defines the overflow behaviour, default 0 means standard overflow behaviour. If set to 1, all new nodes are created with the universe seed at coordinate 0 as the parent. Base data init.
  * @param p_usim_energy_start_value The start value of energy the universe should have. For inserts the absolute value is used or default if NULL or 0. Universe seed init.
  * @param p_usim_planck_time_unit The outside planck time unit for this universe. Will use the absolute value or default if NULL or 0. Universe seed init.
  * @param p_usim_planck_length_unit The outside planck length unit for this universe. Will use the absolute value or default if NULL or 0. Universe seed init.
  * @param p_usim_planck_speed_unit The outside planck speed unit for this universe. Will use the absolute value or default if NULL or 0. Universe seed init.
  * @param p_usim_planck_stable The definition if planck units are stable (1) or can change over time (0) for this universe. Will use 1, if value range (0, 1) is not correct. Universe seed init.
  * @param p_usim_ultimate_border The ultimate border rule for this universe. 1 is ultimate border reached, no childs left, 0 is any border at dimensions axis even with childs left. Universe seed init.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Return 1 if all was successfully processed otherwise 0.
  */
  FUNCTION place_start_node( p_max_dimension            IN NUMBER                                       DEFAULT 42
                           , p_usim_abs_max_number      IN NUMBER                                       DEFAULT 99999999999999999999999999999999999999
                           , p_usim_overflow_node_seed  IN NUMBER                                       DEFAULT 0
                           , p_usim_energy_start_value  IN usim_multiverse.usim_energy_start_value%TYPE DEFAULT 1
                           , p_usim_planck_time_unit    IN usim_multiverse.usim_planck_time_unit%TYPE   DEFAULT 1
                           , p_usim_planck_length_unit  IN usim_multiverse.usim_planck_length_unit%TYPE DEFAULT 1
                           , p_usim_planck_speed_unit   IN usim_multiverse.usim_planck_speed_unit%TYPE  DEFAULT 1
                           , p_usim_planck_stable       IN usim_multiverse.usim_planck_stable%TYPE      DEFAULT 1
                           , p_usim_ultimate_border     IN usim_multiverse.usim_ultimate_border%TYPE    DEFAULT 1
                           , p_do_commit                IN BOOLEAN                                      DEFAULT TRUE
                           )
    RETURN NUMBER
  ;

  /**
  * Processes a given space node by sending out energy either to child or parent nodes. Handles
  * border situation for process direction.
  * Will update table USIM_SPC_PROCESS. Using package USIM_MATHS for calculations.
  * @param p_usim_id_spc The space node to process. Mandatory.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Return 1 if all was successfully processed otherwise 0.
  */
  FUNCTION process_node( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                       , p_do_commit   IN BOOLEAN                     DEFAULT TRUE
                       )
    RETURN NUMBER
  ;

  /**
  * Processes currently open outputs, sums up the target nodes and updates targets energy. Starts
  * then processing target nodes as source nodes. Handles overflows and necessary actions like dimension creation.
  * Overflow can result in infinity or in NUMERIC OVERFLOW!!!!
  * Updates the planck time. Will write result to table USIM_SPC_PROCESS. Using package USIM_MATHS for calculations.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Return 1 if all was successfully processed otherwise 0.
  */
  FUNCTION process_queue(p_do_commit IN BOOLEAN DEFAULT TRUE)
    RETURN NUMBER
  ;

  /**
  * Will update the state of all universes in the multiverse. Run after execution usim_process.process_queue.
  * @return Return 1 if all was successfully processed otherwise 0.
  */
  FUNCTION update_universe_states(p_do_commit IN BOOLEAN DEFAULT TRUE)
    RETURN NUMBER
  ;

  /**
  * Runs the process queue for the given amount of times or as long as the system is valid. Will update
  * state of the current universes.
  * @return Return 1 if all was successfully processed otherwise 0.
  */
  FUNCTION run_samples( p_run_count IN NUMBER
                      , p_do_commit IN BOOLEAN DEFAULT TRUE
                      )
    RETURN NUMBER
  ;

END usim_process;
/
