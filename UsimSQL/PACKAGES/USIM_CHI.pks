CREATE OR REPLACE PACKAGE usim_chi
IS
  /**A package for actions on table usim_spc_child.*/
  /**A low level package for actions on table usim_spc_child and its associated
  * views. Views can be seen as interfaces and dependency. No other package dependencies
  * apart from USIM_STATIC. ATTENTION Package may throw exceptions
  * from constraints, triggers and foreign keys. Caller is responsible to handle
  * possible exceptions.
  */

  /**
  * Checks if usim_spc_child has already data.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data
    RETURN NUMBER
  ;

  /**
  * Checks if usim_spc_child has data for parent or child.
  * @param p_usim_id_spc The parent id to check data for.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if usim_spc_child has data for given parent and child.
  * @param p_usim_id_spc The parent id to check data for.
  * @param p_usim_id_spc_child The child id to check data for.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data( p_usim_id_spc       IN usim_space.usim_id_spc%TYPE
                   , p_usim_id_spc_child IN usim_space.usim_id_spc%TYPE
                   )
    RETURN NUMBER
  ;

  /**
  * Checks if usim_spc_child has data for the given parent id.
  * @param p_usim_id_spc The parent id to check data for.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_parent(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if usim_spc_child has data for the given child id.
  * @param p_usim_id_spc The child id to check data for.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_child(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if a given parent has the same universe as the child.
  * @param p_usim_id_spc The parent id to check data for.
  * @return Returns 1 if universe is equal for child and parent, otherwise 0.
  */
  FUNCTION has_child_same_universe(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if a given child has the same universe as the parent.
  * @param p_usim_id_spc The child id to check data for.
  * @return Returns 1 if universe is equal for child and parent, otherwise 0.
  */
  FUNCTION has_parent_same_universe(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if a given space node has a child in the next dimension.
  * @param p_usim_id_spc The space id to check data for.
  * @return Returns 1 if the node has at least one child in the next dimension, otherwise 0.
  */
  FUNCTION has_child_next_dim(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if a given space node has a child in the current dimension.
  * @param p_usim_id_spc The space id to check data for.
  * @return Returns 1 if the node has a child in the current dimension, otherwise 0.
  */
  FUNCTION has_child_same_dim(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if a given space node has a parent in the current dimension.
  * @param p_usim_id_spc The space id to check data for.
  * @return Returns 1 if the node has a parent in the current dimension, otherwise 0.
  */
  FUNCTION has_parent_same_dim(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if a given space nodes have a relation. Type of relation is not considered, means not caring about
  * whether one is child or parent.
  * @param p_usim_id_spc The first space id to check data for.
  * @param p_usim_id_spc_rel The second space id to check data for.
  * @return Returns 1 if the nodes are related, otherwise 0.
  */
  FUNCTION has_relation( p_usim_id_spc      IN usim_space.usim_id_spc%TYPE
                       , p_usim_id_spc_rel  IN usim_space.usim_id_spc%TYPE
                       )
    RETURN NUMBER
  ;

  /**
  * Retrieves the amount of childs a given space id has in the universe the parent is in.
  * @param p_usim_id_spc The space id to get the amount of childs.
  * @return Returns the amount of childs found for the given space id.
  */
  FUNCTION child_count(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Retrieves the amount of parents a given space id has in the universe the child is in.
  * @param p_usim_id_spc The space id to get the amount of parents.
  * @return Returns the amount of childs found for the given space id.
  */
  FUNCTION parent_count(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /***
  * Retrieve the child in the same dimension. Expected a from space node, which should always
  * have only one child in the same dimension with the same sign.
  * @param p_usim_id_spc The space id to get the child for.
  * @return Returns the child space id or NULL if wrong space node used.
  */
  FUNCTION get_child_same_dimension(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_space.usim_id_spc%TYPE
  ;

  /***
  * Retrieve the child in the next dimension. Expects a space node, which should always
  * have only one from child in the next dimension with given sign.
  * @param p_usim_id_spc The space id to get the child for.
  * @return Returns the child space id or NULL if wrong space node used.
  */
  FUNCTION get_child_next_dimension(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_space.usim_id_spc%TYPE
  ;

  /***
  * Retrieve the parent in the same dimension. Expected a to space node, which should always
  * have only one parent in the same dimension with the same sign.
  * @param p_usim_id_spc The space id to get the parent for.
  * @return Returns the parent space id or NULL if wrong space node used.
  */
  FUNCTION get_parent_same_dimension(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_space.usim_id_spc%TYPE
  ;

  /**
  * Get child and parent details for a given space node id.
  * @param p_usim_id_spc The space id to get the details for.
  * @return Returns 1 if data could be fetched or 0 on errors.
  */
  FUNCTION get_chi_details( p_usim_id_spc  IN  usim_space.usim_id_spc%TYPE
                          , p_parent_count OUT NUMBER
                          , p_child_count  OUT NUMBER
                          )
    RETURN NUMBER
  ;

  /**
  * Inserts a parent-child relation between nodes, if active nodes exist and are not equal. If relation
  * exists, 1 is returned.
  * @param p_usim_id_spc The parent id to insert.
  * @param p_usim_id_spc_child The child id to insert.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns 1 if insert was successful or 0 if constraints are not fulfilled.
  */
  FUNCTION insert_chi( p_usim_id_spc        IN usim_space.usim_id_spc%TYPE
                     , p_usim_id_spc_child  IN usim_space.usim_id_spc%TYPE
                     , p_do_commit          IN BOOLEAN                     DEFAULT TRUE
                     )
    RETURN NUMBER
  ;

END usim_chi;
/