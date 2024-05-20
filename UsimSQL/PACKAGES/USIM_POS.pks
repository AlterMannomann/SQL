-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
CREATE OR REPLACE PACKAGE &USIM_SCHEMA..usim_pos
IS
  /**A low level package for actions on table usim_position and its associated
  * views. Views can be seen as interfaces and dependency. No other package dependencies
  * apart from USIM_STATIC. ATTENTION Package may throw exceptions
  * from constraints, triggers and foreign keys. Caller is responsible to handle
  * possible exceptions.
  */

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
  * Checks if usim_position has the given position.
  * @param p_usim_coordinate The position coordinate to verify.
  * @return Returns 1 if position exists, otherwise 0.
  */
  FUNCTION has_data(p_usim_coordinate IN usim_position.usim_coordinate%TYPE)
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
  * Gets the maximum coordinate for a given sign.
  * @param p_sign The sign of the max coordinate (1, -1). Position 0 is always included in both number spaces.
  * @return Returns max usim_coordinate for given sign or NULL if no coordinates exists or wrong sign.
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
  * Inserts a new coordinate if it does not exist.
  * @param p_usim_coordinate The coordinate to insert.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use). Should be given to avoid signature conflicts.
  * @return Returns the new/existing position id for the coordinate or NULL if insert fails.
  */
  FUNCTION insert_position( p_usim_coordinate IN usim_position.usim_coordinate%TYPE
                          , p_do_commit       IN BOOLEAN                            DEFAULT TRUE
                          )
    RETURN usim_position.usim_id_pos%TYPE
  ;

  /**
  * Creates all coordinates including given max coordinate. Inserts positive and negative coordinates.
  * Can be used to initialize the available positions for a multiverse.
  * @param p_max_coordinate The maximum coordinate to insert. Valid for positive and negative numbers.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns 1 one success 0 on errors.
  */
  FUNCTION init_positions( p_max_coordinate IN usim_position.usim_coordinate%TYPE
                         , p_do_commit      IN BOOLEAN                            DEFAULT TRUE
                         )
    RETURN NUMBER
  ;

END usim_pos;
/