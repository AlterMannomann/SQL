CREATE OR REPLACE PACKAGE usim_nod
IS
  /**A low level package for actions on table usim_node and its associated
  * views. Views can be seen as interfaces and dependency. No other package dependencies
  * apart from USIM_STATIC. ATTENTION Package may throw exceptions
  * from constraints, triggers and foreign keys. Caller is responsible to handle
  * possible exceptions.
  */

  /**
  * Checks if usim_node has already data.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data
    RETURN NUMBER
  ;

  /**
  * Checks if usim_node has the given node id.
  * @param p_usim_id_nod The node id to verify.
  * @return Returns 1 if node id exists, otherwise 0.
  */
  FUNCTION has_data(p_usim_id_nod IN usim_node.usim_id_nod%TYPE)
    RETURN NUMBER
  ;

  /**
  * Retrieves the energy of a given node, which can be NULL. Use
  * has_data to verify, if a node id exists.
  * @param p_usim_id_nod The node id to get the energy for.
  * @return Returns usim_energy if node id exists, otherwise NULL. Using NUMBER not TYPE as calculations behave different if TYPE is used and max is reached.
  */
  FUNCTION get_energy(p_usim_id_nod IN usim_node.usim_id_nod%TYPE)
    RETURN NUMBER
  ;

  /**
  * Inserts a new node. Energy is set to NULL on insert and can only
  * be changed by update. As a node is a very simple structure, it may
  * be difficult to identify a specific node, if it is not assigned
  * to a universe, dimension, position, node structure after creating it.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns the new created node id with energy default NULL.
  */
  FUNCTION insert_node(p_do_commit  IN BOOLEAN  DEFAULT TRUE)
    RETURN usim_node.usim_id_nod%TYPE
  ;

  /**
  * Updates the energy of a given node.
  * @param p_usim_energy The the energy to set on the node.
  * @param p_usim_id_pos The node id to update the energy.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns current usim_energy after update or NULL if node does not exist.
  */
  FUNCTION update_energy( p_usim_energy  IN usim_node.usim_energy%TYPE
                        , p_usim_id_nod  IN usim_node.usim_id_nod%TYPE
                        , p_do_commit    IN BOOLEAN                    DEFAULT TRUE
                        )
    RETURN usim_node.usim_energy%TYPE
  ;

  /**
  * Updates the energy of a given node by adding the given energy value to the existing energy value.
  * @param p_usim_energy The the energy to add to the node. Using NUMBER not TYPE as calculations behave different if TYPE is used and max is reached.
  * @param p_usim_id_pos The node id to update the energy.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns current usim_energy after update.
  */
  FUNCTION add_energy( p_usim_energy  IN NUMBER
                     , p_usim_id_nod  IN usim_node.usim_id_nod%TYPE
                     , p_do_commit    IN BOOLEAN                    DEFAULT TRUE
                     )
    RETURN usim_node.usim_energy%TYPE
  ;

END usim_nod;