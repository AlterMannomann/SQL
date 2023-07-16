CREATE OR REPLACE PACKAGE usim_rrpn
IS
  /**A package for actions on table usim_rel_rmd_pos_nod.*/

  /**
  * Checks if usim_rel_rmd_pos_nod has already data.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data
    RETURN NUMBER
  ;

  /**
  * Checks if usim_rel_rmd_pos_nod has already data for a given relation id.
  * @param p_usim_id_rrpn The relation id of universe/dimension/position/node.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data(p_usim_id_rrpn IN usim_rel_rmd_pos_nod.usim_id_rrpn%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if usim_rel_rmd_pos_nod has already data for given relation ids.
  * @param p_usim_id_rmd The relation id of universe/dimension.
  * @param p_usim_id_pos The id of the position.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data( p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE
                   , p_usim_id_pos IN usim_position.usim_id_pos%TYPE
                   )
    RETURN NUMBER
  ;

  /**
  * Checks if usim_rel_rmd_pos_nod has already data for given relation ids.
  * @param p_usim_id_rmd The relation id of universe/dimension.
  * @param p_usim_id_pos The id of the position.
  * @param p_usim_id_nod The id of the node.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data( p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE
                   , p_usim_id_pos IN usim_position.usim_id_pos%TYPE
                   , p_usim_id_nod IN usim_node.usim_id_nod%TYPE
                   )
    RETURN NUMBER
  ;

  /**
  * Retrieves a relation id for a given ids if it exists in the relation universe/dimension/position/node.
  * @param p_usim_id_rmd The universe/dimension relation id.
  * @param p_usim_id_pos The position id.
  * @param p_usim_id_nod The node id.
  * @return Returns usim_id_rrpn if it exists, otherwise NULL.
  */
  FUNCTION get_id_rrpn( p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE
                      , p_usim_id_pos IN usim_position.usim_id_pos%TYPE
                      , p_usim_id_nod IN usim_node.usim_id_nod%TYPE
                      )
    RETURN usim_rel_rmd_pos_nod.usim_id_rrpn%TYPE
  ;

  /**
  * Inserts a new relation for the given ids in the relation universe/dimension/position/node if it does not exist yet.
  * @param p_usim_id_rmd The universe/dimension relation id.
  * @param p_usim_id_pos The position id.
  * @param p_usim_id_nod The node id.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns the new/existing usim_id_rrpn id or NULL if given ids do not exist.
  */
  FUNCTION insert_rrpn( p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE
                      , p_usim_id_pos IN usim_position.usim_id_pos%TYPE
                      , p_usim_id_nod IN usim_node.usim_id_nod%TYPE
                      , p_do_commit   IN BOOLEAN                            DEFAULT TRUE
                      )
    RETURN usim_rel_rmd_pos_nod.usim_id_rrpn%TYPE
  ;

END usim_rrpn;
/