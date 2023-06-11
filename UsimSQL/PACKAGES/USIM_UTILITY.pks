CREATE OR REPLACE PACKAGE usim_utility IS
  /** A Package containing utility functions and procedures.
  * To be used in views. Create package before view creation.
  */

  /**
  * Extracts a coordinate substring from a coords string containing a defined delimiter at
  * the desired position. Ignores portions of the string that are surrounded
  * by the given ignore delimiters, like relative number levels.
  * @param p_string The string with delimiters to extract a value from. Values are either positive, no sign or negative with a leading minus sign.
                    The expected string has the formatting "value(level),value(level),...", e.g. "0(1),2(1),-2(1)". Number level is always positive.
  * @param p_position The position of the extract value, first position = 0, any value below 0 is treated as first position.
  * @param p_delimiter The delimiter used in the string, defaults to a comma ",".
  * @param p_ignore_start The start delimiter for levels to ignore, defaults to an open bracket "(".
  * @param p_ignore_end The end delimiter for levels to ignore, defaults to an closing bracket ")".
  * @return The extracted substring or NULL if delimiters not found as expected.
  */
  FUNCTION extract_coordinate( p_string         IN usim_poi_dim_position.usim_coords%TYPE
                             , p_position       IN NUMBER
                             , p_delimiter      IN VARCHAR2 DEFAULT ','
                             , p_ignore_start   IN VARCHAR2 DEFAULT '('
                             , p_ignore_end     IN VARCHAR2 DEFAULT ')'
                             )
    RETURN VARCHAR2
  ;

  /**
  * Extracts a number level substring from a coords string containing a defined delimiter at
  * the desired position. Ignores coordinate portions of the string.
  * @param p_string The string with delimiters to extract a value from.
  * @param p_position The position of the extract value, first position = 0, any value below 0 is treated as first position.
  * @param p_delimiter The delimiter used in the string, defaults to a comma ",".
  * @param p_level_start The start delimiter for levels, defaults to an open bracket "(".
  * @param p_level_end The end delimiter for levels, defaults to an closing bracket ")".
  * @return The extracted substring or NULL if no level delimiters are found.
  */
  FUNCTION extract_number_level( p_string         IN usim_poi_dim_position.usim_coords%TYPE
                               , p_position       IN NUMBER
                               , p_delimiter      IN VARCHAR2 DEFAULT ','
                               , p_level_start    IN VARCHAR2 DEFAULT '('
                               , p_level_end      IN VARCHAR2 DEFAULT ')'
                               )
    RETURN VARCHAR2
  ;

  /**
  * Extracts the nth coordinate out of the comma separated coordinate string. Ignores the relative level of the number, as
  * this would cause overflow of numbers supported by the system.
  * @param p_usim_coords The usim_coords string representing the coordinates over all supported dimensions, comma separated.
  * @param p_position The position of the extract value, first position = 0, any value below 0 is treated as first position.
  * @return The coordinate for the given position or 0.
  */
  FUNCTION get_coordinate( p_string         IN usim_poi_dim_position.usim_coords%TYPE
                         , p_position       IN NUMBER
                         )
    RETURN NUMBER
  ;

  /**
  * Extracts the nth level of a coordinate out of the comma separated coordinate string. Ignores coordinate portions of the string.
  * @param p_usim_coords The usim_coords string representing the coordinates over all supported dimensions, comma separated.
  * @param p_position The position of the extract value, first position = 0, any value below 0 is treated as first position.
  * @return The level for the given position or 0.
  */
  FUNCTION get_number_level( p_string         IN usim_poi_dim_position.usim_coords%TYPE
                           , p_position       IN NUMBER
                           )
    RETURN NUMBER
  ;

  /**
  * Extracts the x coordinate out of the comma separated coordinate string. Ignores the relative level of the number, as
  * this would cause overflow of numbers supported by the system.
  * @param p_usim_coords The usim_coords string representing the coordinates over all supported dimensions, comma separated.
  * @return The coordinate for the x axis as USIM_COORDINATE type or 0.
  */
  FUNCTION get_x(p_usim_coords IN usim_poi_dim_position.usim_coords%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
  ;

  /**
  * Extracts the number level of the x coordinate out of the comma separated coordinate string. Ignores coordinate portions of the string.
  * @param p_usim_coords The usim_coords string representing the coordinates over all supported dimensions, comma separated.
  * @return The number level for the x axis as USIM_COORD_LEVEL type or 0.
  */
  FUNCTION get_x_level(p_usim_coords IN usim_poi_dim_position.usim_coords%TYPE)
    RETURN usim_position.usim_coord_level%TYPE
  ;

  /**
  * Extracts the y coordinate out of the comma separated coordinate string. Ignores the relative level of the number, as
  * this would cause overflow of numbers supported by the system.
  * @param p_usim_coords The usim_coords string representing the coordinates over all supported dimensions, comma separated.
  * @return The coordinate for the y axis as USIM_COORDINATE type or 0.
  */
  FUNCTION get_y(p_usim_coords IN usim_poi_dim_position.usim_coords%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
  ;

  /**
  * Extracts the number level of the y coordinate out of the comma separated coordinate string. Ignores coordinate portions of the string.
  * @param p_usim_coords The usim_coords string representing the coordinates over all supported dimensions, comma separated.
  * @return The number level for the y axis as USIM_COORD_LEVEL type or 0.
  */
  FUNCTION get_y_level(p_usim_coords IN usim_poi_dim_position.usim_coords%TYPE)
    RETURN usim_position.usim_coord_level%TYPE
  ;

  /**
  * Extracts the z coordinate out of the comma separated coordinate string. Ignores the relative level of the number, as
  * this would cause overflow of numbers supported by the system.
  * @param p_usim_coords The usim_coords string representing the coordinates over all supported dimensions, comma separated.
  * @return The coordinate for the z axis as USIM_COORDINATE type or 0.
  */
  FUNCTION get_z(p_usim_coords IN usim_poi_dim_position.usim_coords%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
  ;

  /**
  * Extracts the number level of the z coordinate out of the comma separated coordinate string. Ignores coordinate portions of the string.
  * @param p_usim_coords The usim_coords string representing the coordinates over all supported dimensions, comma separated.
  * @return The number level for the z axis as USIM_COORD_LEVEL type or 0.
  */
  FUNCTION get_z_level(p_usim_coords IN usim_poi_dim_position.usim_coords%TYPE)
    RETURN usim_position.usim_coord_level%TYPE
  ;

  /**
  * Updates current planck time to retrieve a new planck time big id.
  * @return The new current planck time.
  */
  FUNCTION next_planck_time
    RETURN VARCHAR2
  ;

  /**
  * Retrieves the current planck time as a planck time big id.
  * @return The current planck time.
  */
  FUNCTION current_planck_time
    RETURN VARCHAR2
  ;

  /**
  * Retrieves the last planck time before the current as a planck time big id.
  * @return The last planck time before the current.
  */
  FUNCTION last_planck_time
    RETURN VARCHAR2
  ;

  /**
  * Calculates the difference from relative position to relative position.
  * To overcome number limitation for point positions MAX(NUMBER(38, 0)) every
  * position has a relative factor/level for the number space it is in. Producing MAX^MAX numbers.
  * As positions are build on pairs of coordinates, the differences between the real numbers
  * having different number spaces should be very small. Energy flows only within its point
  * structure, not between point structures. Of course at the nodes of point
  * structures, the parent point structure is impacted.
  * Limitation is that level difference <= 1, otherwise there is no way to express the difference
  * in supported numbers. If the level difference is > 1 than the result of the difference will
  * always be 0, means this points are unreachable and no energy calculation is done for this points.
  *
  * Example:
  * Limitation numbers 99 = max value
  * Level difference max = 1
  * So 98(1) - 2(2) equals (98 - MAX) - 2 = (98-99) - 2 = -1 - 2 = -3
  *
  * @param p_usim_coords1 The usim_coords string representing the first coordinates over all supported dimensions, comma separated for first vector.
                          input value expected is one single coordinate in the format n(n), e.g. 1(1).
  * @param p_usim_coords2 The usim_coords string representing the second coordinates over all supported dimensions, comma separated for first vector.
                          input value expected is one single coordinate in the format n(n), e.g. 2(1).
  * @return The difference of the coordinate values considering number level or 0.
  */
  FUNCTION coords_diff( p_usim_coords1  IN usim_poi_dim_position.usim_coords%TYPE
                      , p_usim_coords2  IN usim_poi_dim_position.usim_coords%TYPE
                      )
    RETURN NUMBER
  ;

  /**
  * Calculates the euclidian distance between two point coordinates.
  * Ignores the dimension, draws and measures an imaginary line between the points.
  * If number levels have a difference > 1 the result will always be 0.
  * @param p_usim_coords1 The usim_coords string representing the first coordinates over all supported dimensions, comma separated for first vector.
  * @param p_usim_coords2 The usim_coords string representing the second coordinates over all supported dimensions, comma separated for first vector.
  * @return The euclidian distance between both vectors or 0.
  */
  FUNCTION vector_distance( p_usim_coords1  IN usim_poi_dim_position.usim_coords%TYPE
                          , p_usim_coords2  IN usim_poi_dim_position.usim_coords%TYPE
                          )
    RETURN NUMBER
  ;

  /**
  * Determines the energy force for two points, interpreting energy as mass.
  * <b>F = (e1 x e2) / distance<sup>2</sup></b>
  * Special cases are distance 0 which means either, source and target are the same
  * so we only set the value (Universe Seed) or point is unreachable far away.
  * If parent of source is NULL we interact with the Universe Seed, which will react
  * with positive and negative energy, depending on the target. Sign is derived from
  * position (usim_coordinate).
  * @param p_usim_energy_source The source energy.
  * @param p_usim_energy_target The target energy.
  * @param p_usim_distance The distance between the two points.
  * @param p_usim_target_sign The sign of usim_coordinate of the target.
  * @param p_usim_gravitation_constant The gravitational constant valid for the target.
  * @return The force acting evenly distributed on source and target.
  */
  FUNCTION energy_force( p_usim_energy_source         IN usim_point.usim_energy%TYPE
                       , p_usim_energy_target         IN usim_point.usim_energy%TYPE
                       , p_usim_distance              IN NUMBER
                       , p_usim_target_sign           IN NUMBER
                       , p_usim_gravitation_constant  IN NUMBER
                       )
    RETURN NUMBER
  ;

  /**
  * Get the maximum position value used for the current number level.
  * @param p_sign The sign for the coordinate, either positive or negative. 0 is considered as positive.
  * @return The maximum current position for the current number level.
  */
  FUNCTION get_max_position(p_sign IN NUMBER DEFAULT 1)
    RETURN NUMBER
  ;

  /**
  * Get the first new position value used for the current number level.
  * @param p_sign The sign for the coordinate, either positive or negative. 0 is considered as positive.
  * @return The maximum current position +/- 1.
  */
  FUNCTION get_max_position_1st(p_sign IN NUMBER DEFAULT 1)
    RETURN NUMBER
  ;

  /**
  * Get the second new position value used for the current number level.
  * @param p_sign The sign for the coordinate, either positive or negative. 0 is considered as positive.
  * @return The maximum current position +/- 2.
  */
  FUNCTION get_max_position_2nd(p_sign IN NUMBER DEFAULT 1)
    RETURN NUMBER
  ;

  /**
  * Not implemented yet
  */
  FUNCTION amplitude( p_usim_energy_source      IN usim_point.usim_energy%TYPE
                    , p_usim_angular_frequency  IN NUMBER
                    )
    RETURN NUMBER
  ;

  /**
  * Not implemented yet
  */
  FUNCTION wavelength( p_usim_angular_frequency   IN NUMBER
                     , p_usim_velocity            IN NUMBER DEFAULT 1
                     )
    RETURN NUMBER
  ;
END usim_utility;
/