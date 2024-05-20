-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
CREATE OR REPLACE PACKAGE &USIM_SCHEMA..usim_mlv
IS
  /**A low level package for actions on table usim_multiverse and its associated
  * view. No other dependencies apart from USIM_STATIC. Package may throw exceptions
  * from constraints, triggers and foreign keys. Caller is responsible to handle
  * possible exceptions.
  */

  /**
  * Checks if usim_multiverse has already data.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data
    RETURN NUMBER
  ;

  /**
  * Checks if a given usim_multiverse id exists.
  * @param p_usim_id_mlv The id of the universe to check.
  * @return Returns 1 if universe exists, otherwise 0.
  */
 FUNCTION has_data(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN NUMBER
  ;

  /**
  * Determines if a base universe already exists in usim_multiverse.
  * @return Returns 1 if a base universe exists, otherwise 0.
  */
  FUNCTION has_base
    RETURN NUMBER
  ;

  /**
  * Checks if a given universe is a base universe.
  * @param p_usim_id_mlv The id of the universe to get usim_planck_stable from.
  * @return Returns 1 if universe is base, otherwise 0 or NULL, if universe does not exist.
  */
  FUNCTION is_base(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN NUMBER
  ;

  /**
  * Gets the current state of the universe. See USIM_STATIC for allowed state.
  * @param p_usim_id_mlv The id of the universe to get usim_planck_stable from.
  * @return Returns the current state of the universe or NULL, if universe does not exist.
  */
  FUNCTION get_state(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN usim_multiverse.usim_universe_status%TYPE
  ;

  /**
  * Gets the current value of usim_planck_stable for the given universe.
  * @param p_usim_id_mlv The id of the universe to get usim_planck_stable from.
  * @return Returns usim_planck_stable if given universe exists, otherwise -1.
  */
  FUNCTION get_planck_stable(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN NUMBER
  ;

  /**
  * Gets the rule for ultimate or any border for a given universe.
  * @param p_usim_id_mlv The id of the universe to get usim_ultimate_border from.
  * @return Returns 1, rule for ultimate border or 0, rule for any border if given universe exists, otherwise -1.
  */
  FUNCTION get_ultimate_border(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN usim_multiverse.usim_ultimate_border%TYPE
  ;

  /**
  * Inserts a new universe with the given values. Does not check if a base universe already exists. USIM_UNIVERSE_STATUS is automatically set
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
  FUNCTION insert_universe( p_usim_energy_start_value IN usim_multiverse.usim_energy_start_value%TYPE DEFAULT 1
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
  * Updates the universe state for the given universe id.
  * @param p_usim_id_mlv The id of the universe, that should update its state.
  * @param p_usim_universe_status The new state of the universe. Must match usim_static's usim_multiverse_status_dead, usim_multiverse_status_crashed, usim_multiverse_status_active or usim_multiverse_status_inactive.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns the new state or NULL on errors.
  */
  FUNCTION update_state( p_usim_id_mlv          IN usim_multiverse.usim_id_mlv%TYPE
                       , p_usim_universe_status IN usim_multiverse.usim_universe_status%TYPE
                       , p_do_commit            IN BOOLEAN                                   DEFAULT TRUE
                       )
    RETURN usim_multiverse.usim_universe_status%TYPE
  ;

  /**
  * Updates all planck units by new time and speed unit if usim_planck_stable = 0 for the given universe and the universe exists.
  * @param p_usim_id_mlv The id of the universe, that should update planck units.
  * @param p_usim_planck_time_unit The new planck time unit for the given universe. Will replace existing values with absolute values. If NULL/0 default 1 is used.
  * @param p_usim_planck_speed_unit The new planck speed unit for the given universe. Will replace existing values with absolute values. If NULL/0 default 1 is used.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns 1 if update was possible, otherwise 0.
  */
  FUNCTION update_planck_unit_time_speed( p_usim_id_mlv             IN usim_multiverse.usim_id_mlv%TYPE
                                        , p_usim_planck_time_unit   IN usim_multiverse.usim_planck_time_unit%TYPE
                                        , p_usim_planck_speed_unit  IN usim_multiverse.usim_planck_speed_unit%TYPE
                                        , p_do_commit               IN BOOLEAN                                      DEFAULT TRUE
                                        )
    RETURN NUMBER
  ;

  /**
  * Updates all planck units by new time and length unit if usim_planck_stable = 0 for the given universe and the universe exists.
  * @param p_usim_id_mlv The id of the universe, that should update planck units.
  * @param p_usim_planck_time_unit The new planck time unit for the given universe. Will replace existing values with absolute values. If NULL/0 default 1 is used.
  * @param p_usim_planck_length_unit The new planck length unit for the given universe. Will replace existing values with absolute values. If NULL/0 default 1 is used.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns 1 if update was possible, otherwise 0.
  */
  FUNCTION update_planck_unit_time_length( p_usim_id_mlv             IN usim_multiverse.usim_id_mlv%TYPE
                                         , p_usim_planck_time_unit   IN usim_multiverse.usim_planck_time_unit%TYPE
                                         , p_usim_planck_length_unit IN usim_multiverse.usim_planck_length_unit%TYPE
                                         , p_do_commit               IN BOOLEAN                                      DEFAULT TRUE
                                         )
    RETURN NUMBER
  ;

  /**
  * Updates all planck units by new speed and length unit if usim_planck_stable = 0 for the given universe and the universe exists.
  * @param p_usim_id_mlv The id of the universe, that should update planck units.
  * @param p_usim_planck_speed_unit The new planck speed unit for the given universe. Will replace existing values with absolute values. If NULL/0 default 1 is used.
  * @param p_usim_planck_length_unit The new planck length unit for the given universe. Will replace existing values with absolute values. If NULL/0 default 1 is used.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns 1 if update was possible, otherwise 0.
  */
  FUNCTION update_planck_unit_speed_length( p_usim_id_mlv             IN usim_multiverse.usim_id_mlv%TYPE
                                          , p_usim_planck_speed_unit  IN usim_multiverse.usim_planck_speed_unit%TYPE
                                          , p_usim_planck_length_unit IN usim_multiverse.usim_planck_length_unit%TYPE
                                          , p_do_commit               IN BOOLEAN                                      DEFAULT TRUE
                                         )
    RETURN NUMBER
  ;

END usim_mlv;
/