CREATE OR REPLACE PACKAGE usim_pos
IS
  /**A package for actions on table usim_position.*/

  /**
  * Checks a given number for the sign and retrieves +1 or -1 for any number.
  * Special case coordinate 0 with sign 0 for dimension 0 not handled.
  * @param p_number Any number to determine a sign != 0.
  * @param p_sign_default Handles the default sign for 0 values, as Oracle cannot distinguish between -0 and +1. If not +1/-1 defaults to +1.
  * @return Either +1 or -1 as the sign for any number.
  */
  FUNCTION get_sign( p_number       IN NUMBER
                   , p_sign_default IN NUMBER DEFAULT 1
                   )
    RETURN NUMBER
  ;

  /**
  * Checks if usim_position has already data.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data
    RETURN NUMBER
  ;

  /**
  * Checks if usim_position has the given position id.
  * @param p_usim_id_pos The position id to verify.
  * @return Returns 1 if position id exists, otherwise 0.
  */
  FUNCTION has_data(p_usim_id_pos IN usim_position.usim_id_pos%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if usim_position has all coordinates for a dimension axis volume (line). For a given position the next position with
  * distance 1 must be available in positive and negative number space, e.g. +1, +2, -1, -2.
  * Coordinates are calculated by given ABS(coordinate).
  * @param p_usim_coordinate The coordinate for the start value with a positive sign of a volume. Always interpreted as positive value.
  * @return Returns 1 if dimension axis volume positions exist, otherwise 0.
  */
  FUNCTION has_dim_pair(p_usim_coordinate IN usim_position.usim_coordinate%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if usim_position has all coordinates for a dimension axis volume (line). For a given position the next position with
  * distance 1 must be available in positive and negative number space, e.g. +1, +2, -1, -2.
  * Coordinates are calculated by given ABS(coordinate).
  * @param p_usim_id_pos The coordinate id for the from value with a positive sign of a volume. Always interpreted as positive coordinate value.
  * @return Returns 1 if dimension axis volume positions exist, otherwise 0.
  */
  FUNCTION has_dim_pair(p_usim_id_pos IN usim_position.usim_id_pos%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if usim_position has the given coordinate.
  * @param p_usim_coordinate The coordinate to verify.
  * @return Returns 1 if coordinate with sign exists, otherwise 0.
  */
  FUNCTION coordinate_exists(p_usim_coordinate IN usim_position.usim_coordinate%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if usim_position has reached overflow state for positive and negative coordinates.
  * @return Returns 1 if base data exist and overflow is reached, otherwise 0.
  */
  FUNCTION overflow_reached
    RETURN NUMBER
  ;

  /**
  * Checks if usim_position has reached overflow state for positive or negative coordinates.
  * @param p_sign The sign of the coordinate. Any value different from -1 is interpreted as 1.
  * @return Returns 1 if base data exist and overflow is reached for given sign, otherwise 0.
  */
  FUNCTION overflow_reached(p_sign IN NUMBER)
    RETURN NUMBER
  ;

  /**
  * Gets the maximum coordinate for a given sign.
  * @param p_sign The sign of the coordinate. 0 is always included in both number spaces and if given interpreted as 1.
  * @return Returns max usim_coordinate for given sign or NULL if no coordinate exists for this sign.
  */
  FUNCTION get_max_coordinate(p_sign IN NUMBER DEFAULT 1)
    RETURN usim_position.usim_coordinate%TYPE
  ;

  /**
  * Gets the coordinate for a given position id.
  * @param p_usim_id_pos The position id to get the coordinate for.
  * @return Returns usim_coordinate for given id or NULL if position id does not exists.
  */
  FUNCTION get_coordinate(p_usim_id_pos IN usim_position.usim_id_pos%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
  ;

  /**
  * Gets the sign of the coordinate for a given position id.
  * @param p_usim_id_pos The position id to get the sign of the coordinate for.
  * @return Returns the sign of the coordinate for a given id or NULL if position id does not exists.
  */
  FUNCTION get_coord_sign(p_usim_id_pos IN usim_position.usim_id_pos%TYPE)
    RETURN NUMBER
  ;

  /**
  * Gets the position id for a given coordinate.
  * @param p_usim_coordinate The coordinate to get the position id for.
  * @return Returns usim_id_pos for given coordinate or NULL if coordinate with sign does not exists.
  */
  FUNCTION get_id_pos(p_usim_coordinate  IN usim_position.usim_coordinate%TYPE)
    RETURN usim_position.usim_id_pos%TYPE
  ;

  /**
  * Retrieve the related to position id with the same sign for a given from position id, if the dimension axis volume to position
  * exists. Special situation 0, with sign zero which has two possible relations.
  * @param p_usim_id_pos The supposed from coordinate id.
  * @param p_zero_sign Only used for coordinate zero to decide, which relation to retrieve. Only -1 or +1 allowed if used. Default 1.
  * @return Returns the dimension axis volume to position id with the same sign, if it exists, otherwise NULL.
  */
  FUNCTION get_dim_pos_rel( p_usim_id_pos IN usim_position.usim_id_pos%TYPE
                          , p_zero_sign   IN NUMBER                         DEFAULT 1
                          )
    RETURN usim_position.usim_id_pos%TYPE
  ;

  /**
  * Retrieve the position id with the opposite sign for a given position id, if the position
  * exists. Special situation 0, as the opposite of zero is 0.
  * @param p_usim_id_pos The coordinate id to get the mirror for.
  * @return Returns the mirror position id with the opposite sign, if it exists, otherwise NULL.
  */
  FUNCTION get_pos_mirror(p_usim_id_pos IN usim_position.usim_id_pos%TYPE)
    RETURN usim_position.usim_id_pos%TYPE
  ;

  /**
  * Inserts a new coordinate (max +1) in positive or negative number space.
  * Won't do anything, if maximum allowed coordinate is exceeded. Special case coordinate 0:</br>
  * If table is empty the first position inserted is always 0 with sign 0.
  * @param p_sign The sign relevant for the number space to use. Must be 1 or -1.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use). Should be given to avoid signature conflicts.
  * @return Returns the new position id for the coordinate with the positive sign or NULL.
  */
  FUNCTION insert_next_position( p_sign       IN NUMBER   DEFAULT 1
                               , p_do_commit  IN BOOLEAN  DEFAULT TRUE
                               )
    RETURN usim_position.usim_id_pos%TYPE
  ;

  /**
  * Inserts a coordinate (max +1) if the coordinate is the next possible coordinate in positive or negative
  * number space or returns the position id of the coordinate.
  * Won't do anything, if maximum allowed coordinate is exceeded. Special case coordinate 0:</br>
  * If table is empty the first position inserted is always 0 with sign 0.
  * @param p_usim_coordinate The coordinate. All other cases get calculated.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns the new/existing position id or NULL if not a next coordinate.
  */
  FUNCTION insert_next_coord( p_usim_coordinate  IN usim_position.usim_coordinate%TYPE
                            , p_do_commit        IN BOOLEAN                            DEFAULT TRUE
                            )
    RETURN usim_position.usim_id_pos%TYPE
  ;

  /**
  * Verifies and if necessary inserts coordinates for a dimension axis with distance 1 in positive
  * and negative number space based on given coordinate.
  * @param p_usim_coordinate The from coordinate. All other cases get calculated.
  * @return Returns 1 if sucessfully inserted or verified, otherwise 0.
  */
  FUNCTION insert_dim_pair( p_usim_coordinate  IN usim_position.usim_coordinate%TYPE
                          , p_do_commit        IN BOOLEAN                            DEFAULT TRUE
                          )
    RETURN NUMBER
  ;

  /**
  * Verifies and if necessary inserts coordinates for a dimension axis with distance 1 in positive
  * and negative number space based on given position id.
  * @param p_usim_id_pos The absolute from coordinate id. All other cases get calculated.
  * @return Returns 1 if sucessfully inserted or verified, otherwise 0.
  */
  FUNCTION insert_dim_pair( p_usim_id_pos IN usim_position.usim_id_pos%TYPE
                          , p_do_commit   IN BOOLEAN                        DEFAULT TRUE
                          )
    RETURN NUMBER
  ;

END usim_pos;
/