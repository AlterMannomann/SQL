CREATE OR REPLACE PACKAGE usim_pos
IS
  /**A package for actions on table usim_position.*/

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
  * @return Returns 1 if coordinate exists, otherwise 0.
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
  * Gets the maximum coordinate.
  * @param p_sign The sign of the coordinate. 0 is interpreted as positive.
  * @return Returns max usim_coordinate for given sign or -1 if no coordinate exists.
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
  * Gets the position id for a given coordinate.
  * @param p_usim_coordinate The coordinate to get the position id for.
  * @return Returns usim_id_pos for given coordinate or NULL if coordinate does not exists.
  */
  FUNCTION get_id_pos(p_usim_coordinate IN usim_position.usim_coordinate%TYPE)
    RETURN usim_position.usim_id_pos%TYPE
  ;

  /**
  * Inserts a new coordinate (max +1) for a given sign until the maximum allowed coordinate is reached.
  * Won't do anything, if maximum allowed coordinate is exceeded.
  * @param p_sign The sign of the coordinate. 0 is interpreted as positive.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns the new position id or NULL.
  */
  FUNCTION insert_next_position( p_sign       IN NUMBER   DEFAULT 1
                               , p_do_commit  IN BOOLEAN  DEFAULT TRUE
                               )
    RETURN usim_position.usim_id_pos%TYPE
  ;

END usim_pos;
/