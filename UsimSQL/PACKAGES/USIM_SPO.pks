-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
CREATE OR REPLACE PACKAGE &USIM_SCHEMA..usim_spo
IS
  /**A low level package for actions on table usim_spc_pos and its associated
  * views. Views can be seen as interfaces and dependency. No other package dependencies
  * apart from USIM_STATIC. ATTENTION Package may throw exceptions
  * from constraints, triggers and foreign keys. Caller is responsible to handle
  * possible exceptions.
  */

  /**
  * Checks if usim_spc_pos has already data.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data
    RETURN NUMBER
  ;

  /**
  * Checks if usim_spc_pos has already data for a given space node.
  * @param p_usim_id_spc The space id to check for data.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if usim_spc_pos has a given dimension for the given space node.
  * @param p_usim_id_spc The space id to check for data.
  * @param p_usim_n_dimension The dimension of the space node to check for data.
  * @return Returns 1 if space node has given dimension, otherwise 0.
  */
  FUNCTION has_data( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                   , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                   )
    RETURN NUMBER
  ;

  /**
  * Checks if for the given space id a maximum position on the dimension axis of the space
  * node exists, that may or may not be different to the given space id. Handles escape situation 4 where
  * dimension axis zero nodes can trigger new positions on their dimension axis.
  * @param p_usim_id_spc The space id to check for max position on its dimension axis.
  * @return Returns the count of maximum positions on the given dimension axis, any value not in 0,1 indicates an error in dimension symmetry.
  */
  FUNCTION has_axis_max_pos_parent(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Retrieves the x,y,z coordinates of a given space node, if it exists in USIM_SPC_POS.
  * @param p_usim_id_spc The space id to get the coordinates for.
  * @return Returns on success a comma separated string, format x,y,z, otherwise NULL.
  */
  FUNCTION get_xyz(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN VARCHAR2
  ;

  /**
  * Retrieves the coordinate of a given dimension and space node, if it exists in USIM_SPC_POS. The given dimension
  * may not be initialized yet and defaults to 0 if not available.
  * Relies on the fact, that table holds one position for one dimension, whatever axis the dimension has.
  * @param p_usim_id_spc The space id to get the coordinate for.
  * @param p_usim_n_dimension The dimension to get the coordinate for.
  * @return Returns on success the coordinate of the given dimension, otherwise NULL.
  */
  FUNCTION get_dim_coord( p_usim_id_spc      IN usim_space.usim_id_spc%TYPE
                        , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                        )
    RETURN usim_position.usim_coordinate%TYPE
  ;

  /**
  * Retrieves the magnitude of a vector for the given dimension.
  * @param p_usim_id_spc The space id to get the magnitude for.
  * @param p_usim_n_dimension The dimension for the magnitude calculation.
  * @return Returns the magnitude of the vector associated to the given space id or NULL on errors.
  */
  FUNCTION get_magnitude( p_usim_id_spc      IN usim_space.usim_id_spc%TYPE
                        , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                        )
    RETURN NUMBER
  ;

  /**
  * Builds a dimension coordinate index for a given space id, if the
  * index fits within VARCHAR2. Builds coordinate index like x,y,z but using
  * all supported dimension. Includes coordinate for dimension 0.
  * @param p_usim_id_spc The space id to build a dimension coordinate index.
  * @return Returns a coordinate string in the form of x,y,z with all dimensions, otherwise NULL.
  */
  FUNCTION get_coord_id(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN VARCHAR2
  ;

  /**
  * Checks if the given node is a 0 coordinate on all dimension axis.
  * @param p_usim_id_spc The space id to check.
  * @return Returns 1 if is a zero position node, otherwise 0.
  */
  FUNCTION is_axis_zero_pos(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if the given node is a coordinate on a dimension axis, e.g. 1,0,0, 0,2,0.
  * @param p_usim_id_spc The space id to check.
  * @return Returns 1 if is an axis position node, otherwise 0.
  */
  FUNCTION is_axis_pos(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Gets the space node with the maximum position on the given dimension axis. The dimension sign is
  * used to identify the expected coordinate sign, the dimension n1 sign is used to limit the space
  * which is divided into two subspaces by dimension 1. The dimension itself is used to identify the
  * dimension axis, we want to get a new parent node from to extend the dimension and universe.
  * Used with escape situation 4 where dimension axis zero nodes can trigger new positions on their dimension axis.
  * @param p_usim_id_spc The space id ancestor node which may be itself the parent node or a 0 node on a dimension axis that can trigger new coordinates.
  * @return The space node with the highest position on a dimension axis, sign and n1 sign of the given ancestor node, otherwise NULL on errors. Use has_axis_max_pos_parent to check before call.
  */
  FUNCTION get_axis_max_pos_parent(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_space.usim_id_spc%TYPE
  ;

  /**
  * Gets the space node with the position 0 on the given dimension axis.
  * @param p_usim_id_spc The space id ancestor node which may be itself the parent node.
  * @return The space node with the position 0 on a dimension axis, otherwise NULL on errors. Every dimension axis should have a zero entry.
  */
  FUNCTION get_axis_zero_pos_parent(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_space.usim_id_spc%TYPE
  ;

  /**
  * Inserts a coordinate and its dimension position and extends dimension position by
  * parent, if no dimension entry exists yet. Does nothing if all dimension positions exist
  * already. Dimensions with position 0 are ignored if not in dimension 0 which is the root of all.
  * @param p_usim_id_spc The space id to insert a coordinate.
  * @param p_usim_id_spc_parent The parent space id to check or extend coordinate.
  * @return Returns 1 on success, otherwise 0 (also on exception which is logged).
  */
  FUNCTION insert_spc_pos( p_usim_id_spc        IN usim_space.usim_id_spc%TYPE
                         , p_usim_id_spc_parent IN usim_space.usim_id_spc%TYPE
                         , p_do_commit          IN BOOLEAN                     DEFAULT TRUE
                         )
    RETURN NUMBER
  ;

END usim_spo;
/