CREATE OR REPLACE PACKAGE usim_creator
IS
  /**A package providing creator function on objects needed */

 /**
  * Creates a universe, with a basic position coordinate 0, dimension 0 and node for it. If first universe, it will be the base universe.
  * Parent volume is only allowed for non-base universes, if base universe is filled and has overflow state in dimensions, volumes and positions.
  * Otherwise escape strategy is a new volume or a new dimension.
  * @param p_usim_energy_start_value The start value of energy the universe should have. For inserts the absolute value is used and default if NULL or 0.
  * @param p_usim_planck_time_unit The outside planck time unit for this universe. Will use the absolute value and default if NULL or 0.
  * @param p_usim_planck_length_unit The outside planck length unit for this universe. Will use the absolute value and default if NULL or 0.
  * @param p_usim_planck_speed_unit The outside planck speed unit for this universe. Will use the absolute value and default if NULL or 0.
  * @param p_usim_planck_stable The definition if planck units are stable (1) or can change over time (0) for this universe. Will use 1, if value range (0, 1) is not correct.
  * @param p_usim_base_sign The numeric sign of the base for this universe. The mirror sign is calculated from this value.
  * @param p_usim_id_vol_parent The id of the volume, that is the parent of this universe. Ignored, if universe is base universe or volume is already parent of a universe.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return The new universe id or NULL if error or base data are not available.
  */
  FUNCTION create_new_universe( p_usim_energy_start_value IN usim_multiverse.usim_energy_start_value%TYPE DEFAULT 1
                              , p_usim_planck_time_unit   IN usim_multiverse.usim_planck_time_unit%TYPE   DEFAULT 1
                              , p_usim_planck_length_unit IN usim_multiverse.usim_planck_length_unit%TYPE DEFAULT 1
                              , p_usim_planck_speed_unit  IN usim_multiverse.usim_planck_speed_unit%TYPE  DEFAULT 1
                              , p_usim_planck_stable      IN usim_multiverse.usim_planck_stable%TYPE      DEFAULT 1
                              , p_usim_base_sign          IN usim_multiverse.usim_base_sign%TYPE          DEFAULT 1
                              , p_usim_id_vol_parent      IN usim_volume.usim_id_vol%TYPE                 DEFAULT NULL
                              , p_do_commit               IN BOOLEAN                                      DEFAULT TRUE
                              )
    RETURN usim_multiverse.usim_id_mlv%TYPE
  ;

  /**
  * Creates the next volume for a given universe. Will create also the needed positions and nodes and spread them
  * over all existing dimensions for the given universe. If no dimension > 0 exists, will also create a dimension n = 1.
  * Will do nothing if overflow state for volume is reached.
  * @param p_usim_id_mlv The id of the universe to create the volume for.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return The new volume id or NULL if overflow state is reached or universe does not exist.
  */
  FUNCTION create_next_volume( p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE
                             , p_do_commit   IN BOOLEAN                           DEFAULT TRUE
                             )
    RETURN usim_volume.usim_id_vol%TYPE
  ;

  /**
  * Creates the next dimension for a given universe. Will create all needed positions and nodes to spread all existing
  * volumes over the new dimension. Will do nothing if overflow state is reached.
  * @param p_usim_id_mlv The id of the universe to create the dimension for.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return The new relation id for universe/dimension or NULL if overflow state is reached.
  */
  FUNCTION create_next_dimension(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
  ;

END usim_creator;
