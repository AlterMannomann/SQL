CREATE OR REPLACE PACKAGE usim_ctrl IS
  /* Package for application control, needs the whole model implemented
   * before compilation.
   */

  /* Procedure USIM_CTRL.FILLPOINTSTRUCTURE
   * Fills all dimensions of a given point structure with points. Means it
   * builds a perfect binary tree for the point in all dimensions. Therefore
   * only two values can be set, left and right. Which have to be distinct.
   * Attributes like energy, amplitude and wavelength are initialized to 0 by trigger.
   *
   * Parameter
   * P_USIM_ID_PSC      - the id of the point structure to fill.
   * P_POSITION_LEFT    - the usim_position for left node.
   * P_POSITION_RIGHT   - the usim_position for right node.
   * P_USIM_ID_PARENT   - the parent, if needed. If NULL will create a universe
   *                      seed structure where starting point has no parent.
   *
   * THROWS
   * -20100 Given dimension ID (x) does not exist.
   * -20101 Given dimension (x) does not exist.
   * -20102 Given child dimension (x) does not match parent dimension (y) + 1.
   * -20103 Given dimension (x) must be 0 if point has no parent.
   * -20200 Given parent point ID (x) does not exist.
   * -20201 A basic seed point already exists. USIM_ID_PARENT cannot be NULL.
   * -20202 Given parent ID (x) has already the maximum of allowed childs.
   * -20300 Given position ID (x) does not exist.
   * -20400 Given point structure ID (x) does not exist.
   * -20500 Given point structure id (x) is not empty
   */
  PROCEDURE fillPointStructure( p_usim_id_psc       IN usim_poi_structure.usim_id_psc%TYPE
                              , p_position_left     IN usim_position.usim_coordinate%TYPE
                              , p_position_right    IN usim_position.usim_coordinate%TYPE
                              , p_usim_id_parent    IN usim_poi_dim_position.usim_id_pdp%TYPE
                              )
  ;
  /* Procedure USIM_CTRL.PROCESSOUTPUT
   * Processes one entry in the USIM_OUTPUT table.
   *
   * Parameter
   * P_USIM_ID_OUTP     - the usim_id_outp of USIM_OUTPUT table to process
   */
  PROCEDURE processOutput(p_usim_id_outp IN usim_output.usim_id_outp%TYPE)
  ;
  /* Procedure USIM_CTRL.RUNONEDIRECTION
   * Process all not processed entries in USIM_OUTPUT with one direction
   * including new entries for the same direction. Means travel the point
   * tree either in child or parent direction until no child or parent exists.
   * If no entry exist for the given direction, base entries are created,
   * depending on the direction, either from Universe Seed, if direction is childs
   * or from all points on the highest dimension. If attributes are NULL, than
   * existing values are used.
   * Attributes have to be provided, if base entries have NULL attributes. Usually only
   * needed on first init of seed.
   *
   * Parameter
   * P_USIM_DIRECTION     - Either 0 (direction childs) or -1 (direction parents). Any value not 0 is interpreted as -1. Default is 0.
   * P_USIM_ENERGY        - The energy to start with on base entries, if no entries exist. If NULL, current values of points are taken. Default is NULL.
   * P_USIM_AMPLITUDE     - The amplitude to start with on base entries, if no entries exist. If NULL, current values of points are taken. Default is NULL.
   * P_USIM_WAVELENGTH    - The wavelength to start with on base entries, if no entries exist. If NULL, current values of points are taken. Default is NULL.
   *
   * THROWS
   * -20700 NULL Attributes not allowed if some base attributes for direction are NULL and nothing to process.
   */
  PROCEDURE runOneDirection( p_usim_direction   IN usim_output.usim_direction%TYPE  DEFAULT 0
                           , p_usim_energy      IN usim_point.usim_energy%TYPE      DEFAULT NULL
                           , p_usim_amplitude   IN usim_point.usim_amplitude%TYPE   DEFAULT NULL
                           , p_usim_wavelength  IN usim_point.usim_wavelength%TYPE  DEFAULT NULL
                           )
  ;
  /* Procedure USIM_CTRL.RUNPLANCKCYCLE
   * Processes a whole cycle running to the end of the tree and back again.
   * Raises the planck time sequence by 1.
   * Starts with direction childs and ends with direction parent reaching seed.
   *
   * Parameter
   * P_USIM_ENERGY        - The energy to start with on base entries, if no entries exist. If NULL, current values of points are taken. Default is NULL.
   * P_USIM_AMPLITUDE     - The amplitude to start with on base entries, if no entries exist. If NULL, current values of points are taken. Default is NULL.
   * P_USIM_WAVELENGTH    - The wavelength to start with on base entries, if no entries exist. If NULL, current values of points are taken. Default is NULL.
   *
   * THROWS
   * -20700 NULL Attributes not allowed if some base attributes for direction are NULL and nothing to process.
   */
  PROCEDURE runPlanckCycle( p_usim_energy      IN usim_point.usim_energy%TYPE      DEFAULT NULL
                          , p_usim_amplitude   IN usim_point.usim_amplitude%TYPE   DEFAULT NULL
                          , p_usim_wavelength  IN usim_point.usim_wavelength%TYPE  DEFAULT NULL
                          )
  ;
  PROCEDURE addPointHistory( p_usim_id_poi              IN usim_poi_history.usim_id_poi%TYPE
                           , p_usim_id_poi_source       IN usim_poi_history.usim_id_poi_source%TYPE
                           , p_usim_energy              IN usim_poi_history.usim_energy%TYPE
                           , p_usim_energy_source       IN usim_poi_history.usim_energy_source%TYPE
                           , p_usim_amplitude           IN usim_poi_history.usim_amplitude%TYPE
                           , p_usim_amplitude_source    IN usim_poi_history.usim_amplitude_source%TYPE
                           , p_usim_wavelength          IN usim_poi_history.usim_wavelength%TYPE
                           , p_usim_wavelength_source   IN usim_poi_history.usim_wavelength_source%TYPE
                           , p_usim_energy_force        IN usim_poi_history.usim_energy_force%TYPE
                           , p_usim_distance            IN usim_poi_history.usim_distance%TYPE
                           , p_usim_planck_time         IN usim_poi_history.usim_planck_time%TYPE
                           , p_usim_update_direction    IN usim_poi_history.usim_update_direction%TYPE
                           , p_usim_id_pdp              IN usim_poi_history.usim_id_pdp%TYPE
                           , p_usim_id_pdp_source       IN usim_poi_history.usim_id_pdp_source%TYPE
                           )
  ;
  PROCEDURE addOverflow( p_usim_id_pdp      IN usim_overflow.usim_id_pdp%TYPE
                       , p_usim_energy      IN usim_overflow.usim_energy%TYPE
                       , p_usim_amplitude   IN usim_overflow.usim_amplitude%TYPE
                       , p_usim_wavelength  IN usim_overflow.usim_wavelength%TYPE
                       )
  ;
END usim_ctrl;
/