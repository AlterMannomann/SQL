CREATE OR REPLACE PACKAGE usim_utility IS
  /* Package containing utility functions and procedures
   * To be used in views. Create package before view creation.
   */

  /* Function USIM_UTILITY.EXTRACTVALUE
   * Extracts a substring from a string containing a defined delimiter at
   * the desired position.
   *
   * Parameter
   * P_DELIMITER      - the delimiter used in the string.
   * P_STRING         - the string with delimiters to extract a value from
   * P_POSITION       - the position of the extract value
   *
   * RETURNS
   * The extracted substring.
   */
   FUNCTION extractValue( p_delimiter     IN VARCHAR2
                        , p_string        IN VARCHAR2
                        , p_position      IN NUMBER
                        )
    RETURN VARCHAR2
  ;

  /* Function USIM_UTILITY.GETX
   * Extracts the x coordinate out of the comma separated coordinate string.
   *
   * Parameter
   * P_USIM_COORDS      - the usim_coords string representing the coordinates over
   *                      all supported dimensions, comma separated.
   * RETURNS
   * The coordinate for the x axis as USIM_COORDS type.
   */
  FUNCTION getX(p_usim_coords IN usim_poi_dim_position.usim_coords%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
  ;

  /* Function USIM_UTILITY.GETY
   * Extracts the y coordinate out of the comma separated coordinate string.
   *
   * Parameter
   * P_USIM_COORDS      - the usim_coords string representing the coordinates over
   *                      all supported dimensions, comma separated.
   * RETURNS
   * The coordinate for the y axis as USIM_COORDS type.
   */
  FUNCTION getY(p_usim_coords IN usim_poi_dim_position.usim_coords%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
  ;

  /* Function USIM_UTILITY.GETZ
   * Extracts the z coordinate out of the comma separated coordinate string.
   *
   * Parameter
   * P_USIM_COORDS      - the usim_coords string representing the coordinates over
   *                      all supported dimensions, comma separated.
   * RETURNS
   * The coordinate for the z axis as USIM_COORDS type.
   */
  FUNCTION getZ(p_usim_coords IN usim_poi_dim_position.usim_coords%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
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
   * P_USIM_ENERGY_SOURCE  - the source energy.
   * P_USIM_ENERGY_TARGET  - the target energy.
   * P_USIM_DISTANCE       - the distance between the two points.
   * P_USIM_TARGET_SIGN    - the sign of usim_coordinate of the target.
   * P_USIM_ID_PARENT      - the parent (pdp) of the source or NULL.
   *
   * RETURNS
   * The force acting evenly distributed on source and target.
   */
  FUNCTION energy_force( p_usim_energy_source   IN usim_point.usim_energy%TYPE
                       , p_usim_energy_target   IN usim_point.usim_energy%TYPE
                       , p_usim_distance        IN NUMBER
                       , p_usim_target_sign     IN NUMBER
                       , p_usim_id_parent       IN usim_poi_dim_position.usim_id_pdp%TYPE
                       )
    RETURN NUMBER
  ;
END usim_utility;
/