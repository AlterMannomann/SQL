CREATE OR REPLACE PACKAGE usim_utility IS
  /* Package containing utility functions and procedures
   * To be used in views. Create package before view creation.
   */

  /* Function USIM_UTILITY.EXTRACT_VALUE
   * Extracts a substring from a string containing a defined delimiter at
   * the desired position.
   *
   * Parameter
   * P_DELIMITER      - the delimiter used in the string.
   * P_STRING         - the string with delimiters to extract a value from
   * P_POSITION       - the position of the extract value, first position = 0
   *
   * RETURNS
   * The extracted substring.
   */
   FUNCTION extract_value( p_delimiter     IN VARCHAR2
                         , p_string        IN VARCHAR2
                         , p_position      IN NUMBER
                         )
    RETURN VARCHAR2
  ;

  /* Function USIM_UTILITY.GET_X
   * Extracts the x coordinate out of the comma separated coordinate string.
   *
   * Parameter
   * P_USIM_COORDS      - the usim_coords string representing the coordinates over
   *                      all supported dimensions, comma separated.
   * RETURNS
   * The coordinate for the x axis as USIM_COORDS type.
   */
  FUNCTION get_x(p_usim_coords IN usim_poi_dim_position.usim_coords%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
  ;

  /* Function USIM_UTILITY.GET_Y
   * Extracts the y coordinate out of the comma separated coordinate string.
   *
   * Parameter
   * P_USIM_COORDS      - the usim_coords string representing the coordinates over
   *                      all supported dimensions, comma separated.
   * RETURNS
   * The coordinate for the y axis as USIM_COORDS type.
   */
  FUNCTION get_y(p_usim_coords IN usim_poi_dim_position.usim_coords%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
  ;

  /* Function USIM_UTILITY.GET_Z
   * Extracts the z coordinate out of the comma separated coordinate string.
   *
   * Parameter
   * P_USIM_COORDS      - the usim_coords string representing the coordinates over
   *                      all supported dimensions, comma separated.
   * RETURNS
   * The coordinate for the z axis as USIM_COORDS type.
   */
  FUNCTION get_z(p_usim_coords IN usim_poi_dim_position.usim_coords%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
  ;
  FUNCTION next_planck_time
    RETURN VARCHAR2
  ;
  FUNCTION current_planck_time
    RETURN VARCHAR2
  ;
  FUNCTION last_planck_time
    RETURN VARCHAR2
  ;
  /* Function USIM_UTILITY.VECTOR_DISTANCE
   * Calculates the euclidian distance between two point coordinates.
   * Ignores the dimension, draws and measures an imaginary line between the points.
   *
   * Parameter
   * P_USIM_COORDS1     - the usim_coords string representing the coordinates over
   *                      all supported dimensions, comma separated for first vector.
   * P_USIM_COORDS1     - the usim_coords string representing the coordinates over
   *                      all supported dimensions, comma separated for second vector.
   * RETURNS
   * The euclidian distance between both vectors.
   */
  FUNCTION vector_distance( p_usim_coords1  IN usim_poi_dim_position.usim_coords%TYPE
                          , p_usim_coords2  IN usim_poi_dim_position.usim_coords%TYPE
                          )
    RETURN NUMBER
  ;
  /* Function USIM_UTILITY.ENERGY_FORCE
   * Determines the energy force for two points, interpreting energy as mass.
   * F = (e1*e2)/distance^2
   * Special cases are distance 0 which means, source and target are the same
   * so we only set the value (Universe Seed).
   * If parent of source is NULL we interact with the Universe Seed, which will react
   * with positive and negative energy, depending on the target. Sign is derived from
   * position (usim_coordinate).
   *
   * Parameter
   * P_USIM_ENERGY_SOURCE         - the source energy.
   * P_USIM_ENERGY_TARGET         - the target energy.
   * P_USIM_DISTANCE              - the distance between the two points.
   * P_USIM_TARGET_SIGN           - the sign of usim_coordinate of the target.
   * p_usim_gravitation_constant  - the gravitational constant valid for the target.
   *
   * RETURNS
   * The force acting evenly distributed on source and target.
   */
  FUNCTION energy_force( p_usim_energy_source         IN usim_point.usim_energy%TYPE
                       , p_usim_energy_target         IN usim_point.usim_energy%TYPE
                       , p_usim_distance              IN NUMBER
                       , p_usim_target_sign           IN NUMBER
                       , p_usim_gravitation_constant  IN NUMBER
                       )
    RETURN NUMBER
  ;
  FUNCTION amplitude( p_usim_energy_source      IN usim_point.usim_energy%TYPE
                    , p_usim_angular_frequency  IN NUMBER
                    )
    RETURN NUMBER
  ;

  FUNCTION wavelength( p_usim_angular_frequency   IN NUMBER
                     , p_usim_velocity            IN NUMBER DEFAULT 1
                     )
    RETURN NUMBER
  ;
END usim_utility;
/