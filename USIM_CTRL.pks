CREATE OR REPLACE PACKAGE usim_ctrl IS
  /* Package for application control, needs the whole model implemented
   * before compilation.
   */

  /* PROCEDURE USIM_CTRL.FILLPOINTSTRUCTURE
   * Fills all dimensions of a given point structure with points. Means it
   * builds a perfect binary tree for the point in all dimensions. Therefore
   * only two values can be set, left and right. Which have to be distinct.
   *
   * Parameter
   * P_USIM_ID_PSC      - the id of the point structure to fill.
   * P_POSITION_LEFT    - the usim_position for left node.
   * P_POSITION_RIGHT   - the usim_position for right node.
   * P_USIM_ID_PARENT   - the parent, if needed. If NULL will create a universe
   *                      seed structure where starting point has no parent.
   * P_USIM_ENERGY      - the energy to initialize the point with.
   * P_USIM_AMPLITUDE   - the amplitude to initialize the point with.
   * P_USIM_WAVELENGTH  - the wavelength to initialize the point with.
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
                              , p_usim_energy       IN usim_point.usim_energy%TYPE
                              , p_usim_amplitude    IN usim_point.usim_amplitude%TYPE
                              , p_usim_wavelength   IN usim_point.usim_wavelength%TYPE
                              )
  ;
END usim_ctrl;
/