CREATE OR REPLACE PACKAGE usim_spo
IS
  /**A package for actions on table usim_spc_pos.*/

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
  * Checks if the given space node is on a dimension axis, means only one position != 0 for all dimensions. Position 0
  * is always on the dimension axis.
  * @param p_usim_id_spc The space id to check for dimension axis.
  * @return Returns 1 if the space node is on a dimension axis, otherwise 0.
  */
  FUNCTION is_dim_axis(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
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