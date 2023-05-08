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

END usim_utility;
/