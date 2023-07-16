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
  * Checks if usim_position has the given coordinate.
  * @param p_usim_coordinate The coordinate to verify.
  * @param p_sign_default The sign default for the coordinate (+1/-1), if the coordinate is 0. Otherwise sign is calculated from coordinate.
  * @return Returns 1 if coordinate with sign exists, otherwise 0.
  */
  FUNCTION coordinate_exists( p_usim_coordinate IN usim_position.usim_coordinate%TYPE
                            , p_sign_default    IN NUMBER                             DEFAULT 1
                            )
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
  * Checks if usim_position has reached overflow state for given sign.
  * @param p_sign The sign (+1/-1) to use. If 0 or NULL is given will default to +1.
  * @return Returns 1 if base data exist and overflow is reached for sign, otherwise 0.
  */
  FUNCTION overflow_reached(p_sign IN NUMBER)
    RETURN NUMBER
  ;

  /**
  * Gets the maximum coordinate for a given sign.
  * @param p_sign The sign of the coordinate. 0 or NULL is interpreted as positive.
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
  * @return Returns usim_sign for given id or NULL if position id does not exists.
  */
  FUNCTION get_coord_sign(p_usim_id_pos IN usim_position.usim_id_pos%TYPE)
    RETURN usim_position.usim_sign%TYPE
  ;

  /**
  * Gets the position id for a given coordinate.
  * @param p_usim_coordinate The coordinate to get the position id for.
  * @param p_usim_sign The sign of the coordinate to get the position id for.
  * @return Returns usim_id_pos for given coordinate or NULL if coordinate with sign does not exists.
  */
  FUNCTION get_id_pos( p_usim_coordinate  IN usim_position.usim_coordinate%TYPE
                     , p_usim_sign        IN usim_position.usim_sign%TYPE
                     )
    RETURN usim_position.usim_id_pos%TYPE
  ;

  /**
  * Inserts a new coordinate (max +1) for a given sign until the maximum allowed coordinate is reached.
  * Won't do anything, if maximum allowed coordinate is exceeded. Special case coordinate 0:</br>
  * If table is empty the first position inserted is alway 0 (as +-0) with sign 0. The next 0 coordinates
  * depend on the sign. If no coordinate exists for the given sign, the first coordinate is 0 with the given
  * sign, e.g. +0 (sign 1) and -0 (sign -1).
  * @param p_sign The sign relevant for the coordinate 0 (1, 0, -1). All other cases get calculated.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use). Should be given to avoid signature conflicts.
  * @return Returns the new position id or NULL.
  */
  FUNCTION insert_next_position( p_sign       IN NUMBER   DEFAULT 1
                               , p_do_commit  IN BOOLEAN  DEFAULT TRUE
                               )
    RETURN usim_position.usim_id_pos%TYPE
  ;

  /**
  * Inserts a coordinate (max +1) for a given sign if the coordinate is the next possible coordinate
  * or returns the position id of the coordinate.
  * Won't do anything, if maximum allowed coordinate is exceeded. Special case coordinate 0:</br>
  * If table is empty the first position inserted is alway 0 (as +-0) with sign 0. The next 0 coordinates
  * depend on the sign. If no coordinate exists for the given sign, the first coordinate is 0 with the given
  * sign, e.g. +0 (sign 1) and -0 (sign -1).
  * @param p_usim_coordinate The sign relevant for the coordinate 0 (1, 0, -1). All other cases get calculated.
  * @param p_sign The sign relevant for the coordinate 0 (1, 0, -1). All other cases get calculated. Should be given to avoid signature conflicts.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns the new/existing position id or NULL if not a next coordinate.
  */
  FUNCTION insert_next_position( p_usim_coordinate  IN usim_position.usim_coordinate%TYPE
                               , p_sign             IN NUMBER                             DEFAULT 1
                               , p_do_commit        IN BOOLEAN                            DEFAULT TRUE
                               )
    RETURN usim_position.usim_id_pos%TYPE
  ;

END usim_pos;
/