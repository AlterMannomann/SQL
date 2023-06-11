CREATE OR REPLACE PACKAGE usim_ctrl IS
  /** Package for application control.
  *
  * Needs the whole model implemented before compilation.
  */

  /**
  * Fills specified dimensions of a given point structure with points. Means it
  * builds a perfect binary tree for the point in all dimensions. Therefore
  * only two values can be set, left and right. Which have to be distinct.
  * Attributes like energy, amplitude and wavelength are initialized to 0 by trigger.
  * Does not check the positions, this should be done by calling procedures.
  * @param p_usim_id_psc The id of the point structure to fill.
  * @param p_position_left The usim_position for left node.
  * @param p_position_right The usim_position for right node.
  * @param p_usim_id_parent The parent, if needed. If NULL will create a universe
                            seed structure where starting point has no parent. Parent
                            defines the starting dimension, from where to fill.
  * @param p_usim_id_dim_max The maximum dimension, which should be filled. If not set
                             (Default), the maximum supported dimension is used.
  * @throws 20100 Given dimension ID (x) does not exist.
  * @throws 20101 Given dimension (x) does not exist.
  * @throws 20102 Given child dimension (x) does not match parent dimension (y) + 1.
  * @throws 20103 Given dimension (x) must be 0 if point has no parent.
  * @throws 20200 Given parent point ID (x) does not exist.
  * @throws 20201 A basic seed point already exists. USIM_ID_PARENT cannot be NULL.
  * @throws 20202 Given parent ID (x) has already the maximum of allowed childs.
  * @throws 20300 Given position ID (x) does not exist.
  * @throws 20400 Given point structure ID (x) does not exist.
  * @throws 20500 Given point structure id (x) is not empty
  * @throws 20701 Invalid positions provided, if positions would leave holes in the position matrix or cause duplicates of positions already exist in specified dimensions.
  * @throws 20702 Invalid maximum dimension, if given dimension is not found or dimension is lower than parent dimension + 1.
  */
  PROCEDURE fill_point_structure( p_usim_id_psc       IN usim_poi_structure.usim_id_psc%TYPE
                                , p_position_left     IN usim_position.usim_coordinate%TYPE
                                , p_position_right    IN usim_position.usim_coordinate%TYPE
                                , p_usim_id_parent    IN usim_poi_dim_position.usim_id_pdp%TYPE
                                , p_usim_id_dim_max   IN usim_dimension.usim_id_dim%TYPE DEFAULT NULL
                                )
  ;

  /**
  * Processes one entry in the USIM_OUTPUT table.
  * @param p_usim_id_outp The usim_id_outp of USIM_OUTPUT table to process
  */
  PROCEDURE process_output(p_usim_id_outp IN usim_output.usim_id_outp%TYPE)
  ;

  /**
  * Process all not processed entries in USIM_OUTPUT with one direction
  * including new entries for the same direction. Means travel the point
  * tree either in child or parent direction until no child or parent exists.
  * If no entry exist for the given direction, base entries are created,
  * depending on the direction, either from Universe Seed, if direction is childs
  * or from all points on the highest dimension. If attributes are NULL, than
  * existing values are used.
  * Attributes have to be provided, if base entries have NULL attributes. Usually only
  * needed on first init of seed. Will not be used, if seed attributes are already set.
  * @param p_usim_direction Either 0 (direction childs) or -1 (direction parents). Any value not 0 is interpreted as -1. Default is 0.
  * @param p_usim_energy The energy to start with on base entries, if no entries exist. If NULL, current values of points are taken. Default is NULL.
  * @param p_usim_amplitude The amplitude to start with on base entries, if no entries exist. If NULL, current values of points are taken. Default is NULL.
  * @param p_usim_wavelength The wavelength to start with on base entries, if no entries exist. If NULL, current values of points are taken. Default is NULL.
  * @param p_usim_frequency The frequency to start with on base entries, if no entries exist. If NULL, current values of points are taken. Default is NULL.
  * @throws 20700 NULL Attributes not allowed if some base attributes for direction are NULL and nothing to process.
  */
  PROCEDURE run_one_direction( p_usim_direction   IN usim_output.usim_direction%TYPE  DEFAULT 0
                             , p_usim_energy      IN usim_point.usim_energy%TYPE      DEFAULT NULL
                             , p_usim_amplitude   IN usim_point.usim_amplitude%TYPE   DEFAULT NULL
                             , p_usim_wavelength  IN usim_point.usim_wavelength%TYPE  DEFAULT NULL
                             , p_usim_frequency   IN usim_point.usim_frequency%TYPE   DEFAULT NULL
                             )
  ;

  /**
  * Processes a whole cycle running to the end of the tree and back again.
  * Raises the planck time sequence by 1.
  * Starts with direction childs and ends with direction parent reaching seed.
  * Will check on overflows and process them.
  * @param p_usim_energy The energy to start with on base entries, if no entries exist. If NULL, current values of points are taken. Default is NULL.
  * @param p_usim_amplitude The amplitude to start with on base entries, if no entries exist. If NULL, current values of points are taken. Default is NULL.
  * @param p_usim_wavelength The wavelength to start with on base entries, if no entries exist. If NULL, current values of points are taken. Default is NULL.
  * @throws 20700 NULL Attributes not allowed if some base attributes for direction are NULL and nothing to process.
  */
  PROCEDURE run_planck_cycle( p_usim_energy      IN usim_point.usim_energy%TYPE      DEFAULT NULL
                            , p_usim_amplitude   IN usim_point.usim_amplitude%TYPE   DEFAULT NULL
                            , p_usim_wavelength  IN usim_point.usim_wavelength%TYPE  DEFAULT NULL
                            , p_usim_frequency   IN usim_point.usim_frequency%TYPE   DEFAULT NULL
                            )
  ;

  /**
  * Processes a given amount of whole cycles running to the end of the tree and back again.
  * Raises the planck time sequence by 1 for every run.
  * Starts with direction childs and ends with direction parent reaching seed.
  * Initialization values are only used once.
  * @param p_usim_energy The energy to start with on base entries, if no entries exist. If NULL, current values of points are taken. Default is NULL.
  * @param p_usim_amplitude The amplitude to start with on base entries, if no entries exist. If NULL, current values of points are taken. Default is NULL.
  * @param p_usim_wavelength The wavelength to start with on base entries, if no entries exist. If NULL, current values of points are taken. Default is NULL.
  * @throws 20700 NULL Attributes not allowed if some base attributes for direction are NULL and nothing to process.
  */
  PROCEDURE run_planck_cycles( p_usim_runs        IN NUMBER DEFAULT 1
                             , p_usim_energy      IN usim_point.usim_energy%TYPE      DEFAULT NULL
                             , p_usim_amplitude   IN usim_point.usim_amplitude%TYPE   DEFAULT NULL
                             , p_usim_wavelength  IN usim_point.usim_wavelength%TYPE  DEFAULT NULL
                             , p_usim_frequency   IN usim_point.usim_frequency%TYPE   DEFAULT NULL
                             )
  ;

  /** NOT IMPLEMENTED YET
  */
  PROCEDURE handle_overflows
  ;

  /**
  * Adds the current state of points during a planck cycle to the USIM_POI_HISTORY table, which can be used for playbacks.
  *
  * @param p_usim_id_poi_target The id of the point that was the target of attribute action.
  * @param p_usim_id_poi_source The id of the point that was the source of attribute action.
  * @param p_usim_planck_time The planck time at action happening.
  * @param p_usim_energy_result The result of the energy reaction and new value for the target.
  * @param p_usim_energy_source The energy of the source before reaction.
  * @param p_usim_energy_target The energy of the target before reaction
  * @param p_usim_amplitude_result The result of the amplitude reaction and new value for the target.
  * @param p_usim_amplitude_source The amplitude of the source before reaction.
  * @param p_usim_amplitude_target The amplitude of the target before reaction.
  * @param p_usim_wavelength_result The result of the wavelength reaction and new value for the target.
  * @param p_usim_wavelength_source The wavelength of the source before reaction.
  * @param p_usim_wavelength_target The wavelength of the target before reaction.
  * @param p_usim_frequency_result The result of the frequency reaction and new value for the target.
  * @param p_usim_frequency_source The frequency of the source before reaction.
  * @param p_usim_frequency_target The frequency of the target before reaction.
  * @param p_usim_dimension_source The dimension of the source.
  * @param p_usim_dimension_target The dimension of the target.
  * @param p_usim_coords_source The coords string for the source.
  * @param p_usim_coords_target The coords string for the target.
  * @param p_usim_energy_force The force of the energy causing reaction.
  * @param p_usim_distance The distance between source and target point.
  * @param p_usim_update_direction The update direction (up or down the tree).
  */
  PROCEDURE add_point_history( p_usim_id_poi_target     IN usim_poi_history.usim_id_poi_target%TYPE
                             , p_usim_id_poi_source     IN usim_poi_history.usim_id_poi_source%TYPE
                             , p_usim_planck_time       IN usim_poi_history.usim_planck_time%TYPE
                             , p_usim_energy_result     IN usim_poi_history.usim_energy_result%TYPE
                             , p_usim_energy_source     IN usim_poi_history.usim_energy_source%TYPE
                             , p_usim_energy_target     IN usim_poi_history.usim_energy_target%TYPE
                             , p_usim_amplitude_result  IN usim_poi_history.usim_amplitude_result%TYPE
                             , p_usim_amplitude_source  IN usim_poi_history.usim_amplitude_source%TYPE
                             , p_usim_amplitude_target  IN usim_poi_history.usim_amplitude_target%TYPE
                             , p_usim_wavelength_result IN usim_poi_history.usim_wavelength_result%TYPE
                             , p_usim_wavelength_source IN usim_poi_history.usim_wavelength_source%TYPE
                             , p_usim_wavelength_target IN usim_poi_history.usim_wavelength_target%TYPE
                             , p_usim_frequency_result  IN usim_poi_history.usim_frequency_result%TYPE
                             , p_usim_frequency_source  IN usim_poi_history.usim_frequency_source%TYPE
                             , p_usim_frequency_target  IN usim_poi_history.usim_frequency_target%TYPE
                             , p_usim_dimension_source  IN usim_poi_history.usim_dimension_source%TYPE
                             , p_usim_dimension_target  IN usim_poi_history.usim_dimension_target%TYPE
                             , p_usim_coords_source     IN usim_poi_history.usim_coords_source%TYPE
                             , p_usim_coords_target     IN usim_poi_history.usim_coords_target%TYPE
                             , p_usim_energy_force      IN usim_poi_history.usim_energy_force%TYPE
                             , p_usim_distance          IN usim_poi_history.usim_distance%TYPE
                             , p_usim_update_direction  IN usim_poi_history.usim_update_direction%TYPE
                             )
  ;

  /**
  * Adds an overflow record.
  * Used if calculation of any attribute value reaches INFINITY.
  * @param p_usim_id_outp The id referencing the USIM_OUTPUT table containing the action causing an overflow.
  */
  PROCEDURE add_overflow(p_usim_id_outp IN usim_overflow.usim_id_outp%TYPE)
  ;
END usim_ctrl;
/