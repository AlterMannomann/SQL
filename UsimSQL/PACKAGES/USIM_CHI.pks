CREATE OR REPLACE PACKAGE usim_chi
IS
  /**A package for actions on table usim_spc_child.*/

  /**
  * Checks if usim_spc_child has already data.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data
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
  * Checks if a given parent has a free dimension to use for a child and given child type.
  * @param p_usim_id_spc The parent id to check data for.
  * @return Returns 1 if parent has a free dimension to use for a child, otherwise 0.
  */
  FUNCTION has_free_child_dimension(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if a given parent has a free position to use for a child and given child type.
  * @param p_usim_id_spc The parent id to check data for.
  * @return Returns 1 if parent has a free position to use for a child, otherwise 0.
  */
  FUNCTION has_free_child_position(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if a given space node is in an escape situation, where no dimension or position is available. Overflow on dimension
  * and position causes also an escape situation.
  * @param p_usim_id_spc The space id to check data for.
  * @return Returns 1 if the node is in an escape situation, otherwise 0.
  */
  FUNCTION has_escape_situation(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if a given space node is in an extend situation, where new dimension or position could be added without harming the universe limits.
  * @param p_usim_id_spc The space id to check data for.
  * @return Returns 1 if the node is in an extend situation, otherwise 0.
  */
  FUNCTION has_extend_situation(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
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
  * Checks if a given space node has a child in the given dimension.
  * @param p_usim_id_spc The space id to check data for.
  * @param p_usim_id_rmd The dimension id to check data for.
  * @return Returns 1 if the node has a child in the given dimension, otherwise 0.
  */
  FUNCTION has_child_at_dim( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                           , p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE
                           )
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
  * Gets the overflow rating for a given space id.
  * @param p_usim_id_spc The child id to check data for.
  * @return Returns 0 if universe has overflow in position and dimension, 1 if no overflow at all, 2 if overflow in position and 3 if overflow in dimension.
  */
  FUNCTION overflow_rating(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Retrieves the amount of childs a given parent space id has.
  * @param p_usim_id_spc The space id to get the amount of childs.
  * @return Returns the amount of childs found for the given parent space id.
  */
  FUNCTION child_count(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Retrieves the highest dimension a connected child has.
  * @param p_usim_id_spc The space id to get the max dimension.
  * @return Returns the maximum n dimension found for the given parent space id and associated childs or dimension of the given parent.
  */
  FUNCTION max_child_dimension(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN usim_dimension.usim_n_dimension%TYPE
  ;

  /**
  * Classifies a space parent node in means of options for connects to new space nodes. Considers only existing dimensions
  * and position. Does not consider situations of escape and extend.</br>
  * Classifications:</br>
  * -2 node not allowed, e.g. from type parent with ancestor in dimension 1 and position != 0.</br>
  * -1 node data model corrupt, e.g. id is NULL or amount of childs not in sync with model.</br>
  * 0 node is fully connected, no further childs or connects are possible.</br>
  * 1 node is ready to get connected, further childs or connects are possible to dimensions and positions.</br>
  * 2 node is ready to get connected, further childs or connects are possible only to dimensions.</br>
  * 3 node is ready to get connected, further childs or connects are possible only to positions.</br>
  * @param p_usim_id_spc The parent space id to classify.
  * @return Returns the classification of the parent space node.
  */
  FUNCTION classify_parent(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
    RETURN NUMBER
  ;

  /**
  * Classifies a space node in means of options to escape the universe or extend the existing universe dimensions and
  * positions within the limits, so new connections are possible.</br>
  * Classifications:</br>
  * -2 node not allowed, e.g. from type parent with ancestor in dimension 1 and position != 0.</br>
  * -1 node data model corrupt, e.g. id is NULL or amount of childs not in sync with model.</br>
  * 0 node can only escape to another universe.</br>
  * 1 node can extend dimensions and positions to escape.</br>
  * 2 node can only extend dimensions to escape.</br>
  * 3 node can only extend positions to escape.</br>
  * @param p_usim_id_spc The space id to classify.
  * @return Returns the classification of the space node for escapes.
  */
  FUNCTION classify_escape(p_usim_id_spc IN usim_space.usim_id_spc%TYPE)
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
  * Retrieve the child in the given dimension. Sign is derived from dimension axis.
  * @param p_usim_id_spc The space id to get the child for.
  * @param p_usim_id_rmd The universe/dimension relation id to get the child for.
  * @return Returns the child space id or NULL if wrong space node used.
  */
  FUNCTION get_child_at_dimension( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                                 , p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE
                                 )
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
  * Inserts a parent-child relation between nodes, if active nodes exist and are not equal. If relation
  * exists, given parent is returned.
  * @param p_usim_id_spc The parent id to insert.
  * @param p_usim_id_spc_child The child id to insert.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns inserted parent id or NULL if constraints are not fulfilled.
  */
  FUNCTION insert_chi( p_usim_id_spc        IN usim_space.usim_id_spc%TYPE
                     , p_usim_id_spc_child  IN usim_space.usim_id_spc%TYPE
                     , p_do_commit          IN BOOLEAN                     DEFAULT TRUE
                     )
    RETURN usim_space.usim_id_spc%TYPE
  ;

END usim_chi;
/