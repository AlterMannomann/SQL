CREATE OR REPLACE PACKAGE usim_mlv
IS
  /**A package for actions on table usim_multiverse.*/

  /**
  * Checks if usim_multiverse has already data.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data
    RETURN NUMBER
  ;

  /**
  * Checks if a given usim_multiverse id exists.
  * @return Returns 1 if universe exists, otherwise 0.
  */
 FUNCTION has_data(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if a given universe is a base universe.
  * @return Returns 1 if universe is base, otherwise 0 or NULL, if universe does not exist.
  */
  FUNCTION is_base(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN NUMBER
  ;

  /**
  * Inserts a new universe and sets automatically base universe, if the universe is the first universe inserted.
  * All other universes will not be considered as base universe (usim_is_base_universe).
  * Only provides columns, that have to be set on insert and can't be changed afterwards. Will only insert, if base data exist.
  * @param p_usim_energy_start_value The start value of energy the universe should have. For inserts the absolute value is used and default if NULL or 0.
  * @param p_usim_planck_time_unit The outside planck time unit for this universe. Will use the absolute value and default if NULL or 0.
  * @param p_usim_planck_length_unit The outside planck length unit for this universe. Will use the absolute value and default if NULL or 0.
  * @param p_usim_planck_speed_unit The outside planck speed unit for this universe. Will use the absolute value and default if NULL or 0.
  * @param p_usim_planck_stable The definition if planck units are stable (1) or can change over time (0) for this universe. Will use 1, if value range (0, 1) is not correct.
  * @param p_usim_base_sign The numeric sign of the base for this universe. The mirror sign is calculated from this value.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return The new universe big id or NULL if base data are not available.
  */
  FUNCTION insert_universe( p_usim_energy_start_value IN usim_multiverse.usim_energy_start_value%TYPE DEFAULT 1
                          , p_usim_planck_time_unit   IN usim_multiverse.usim_planck_time_unit%TYPE   DEFAULT 1
                          , p_usim_planck_length_unit IN usim_multiverse.usim_planck_length_unit%TYPE DEFAULT 1
                          , p_usim_planck_speed_unit  IN usim_multiverse.usim_planck_speed_unit%TYPE  DEFAULT 1
                          , p_usim_planck_stable      IN usim_multiverse.usim_planck_stable%TYPE      DEFAULT 1
                          , p_usim_base_sign          IN usim_multiverse.usim_base_sign%TYPE          DEFAULT 1
                          , p_do_commit               IN BOOLEAN                                      DEFAULT TRUE
                          )
    RETURN usim_multiverse.usim_id_mlv%TYPE
  ;

  /**
  * Updates the energy for a given universe. If the universe does not exist, nothing will happen.
  * If any energy value is NULL, 0 will be used, which may crash the given universe.
  * @param p_usim_id_mlv The id of the universe, that should update energy values.
  * @param p_usim_energy_positive The positive energy value. Will replace the old energy value. If NULL, 0 is used.
  * @param p_usim_energy_negative The negative energy value. Will replace the old energy value. If NULL, 0 is used.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns 1 if update was possible, otherwise 0.
  */
  FUNCTION update_energy( p_usim_id_mlv          IN usim_multiverse.usim_id_mlv%TYPE
                        , p_usim_energy_positive IN usim_multiverse.usim_energy_positive%TYPE
                        , p_usim_energy_negative IN usim_multiverse.usim_energy_negative%TYPE
                        , p_do_commit            IN BOOLEAN                                    DEFAULT TRUE
                        )
    RETURN NUMBER
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
  * Gets the base sign of a given universe.
  * @param p_usim_id_mlv The id of the universe to get usim_base_sign from.
  * @return Returns usim_base_sign if given universe exists, otherwise 0.
  */
  FUNCTION get_base_sign(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN usim_multiverse.usim_base_sign%TYPE
  ;
  /**
  * Gets the mirror sign of a given universe.
  * @param p_usim_id_mlv The id of the universe to get usim_mirror_sign from.
  * @return Returns usim_mirror_sign if given universe exists, otherwise 0.
  */
  FUNCTION get_mirror_sign(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN usim_multiverse.usim_mirror_sign%TYPE
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