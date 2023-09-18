CREATE OR REPLACE PACKAGE usim_process
IS
  /**A package for processing space nodes. Depends on all available packages including USIM_CREATOR.*/

  /**
  * Retrieves the dimensional gravitational constant for a given space node and its dimension.
  * A wrapper for usim_maths.calc_dim_G.
  * @param p_usim_id_spc The space node to get G for. Mandatory.
  * @param p_node_G The dimensional gravitational constant for the space node as OUT parameter.
  * @return Returns 1 if G could be calculated, 0 if an overflow happened or -1 on not supported errors or missing space id.
  */
  FUNCTION get_dim_G( p_usim_id_spc IN  usim_space.usim_id_spc%TYPE
                    , p_node_G      OUT NUMBER
                    )
    RETURN NUMBER
  ;

  /**
  * Retrieves the outer radius for a given space node. Radius r is the distance from one node to another node.
  * @param p_usim_id_spc The space node to get G for. Mandatory.
  * @param p_outer_planck_r The outer planck radius, the distance between space nodes, as OUT parameter.
  * @return Returns 1 if radius could be calculated, 0 if an overflow happened or -1 on not supported errors or missing space id.
  */
  FUNCTION get_outer_planck_r( p_usim_id_spc    IN  usim_space.usim_id_spc%TYPE
                             , p_outer_planck_r OUT NUMBER
                             )
    RETURN NUMBER
  ;

  /**
  * Retrieves the energy as acceleration to add to the target node.
  * A wrapper for usim_maths.calc_planck_a2.
  * @param p_energy The energy of the source space node that accelerates its energy to the position of the target space node.
  * @param p_radius The outer distance between neighbor space nodes.
  * @param p_G The dimensional gravitational constant G for the source space node and its dimension.
  * @param p_target_energy The energy to add to the target energy as OUT parameter.
  * @return Returns 1 if target energy could be calculated, 0 on overflow or -1 on not supported errors or missing space id.
  */
  FUNCTION get_acceleration( p_energy         IN  NUMBER
                           , p_radius         IN  NUMBER
                           , p_G              IN  NUMBER
                           , p_target_energy  OUT NUMBER
                           )
    RETURN NUMBER
  ;

  /**
  * Provides a process start node in the queue. The space node must be a base universe with dimension 0 and
  * position 0. The process direction is childs.
  * @param p_usim_id_spc The base universe space node to start processing. Mandatory.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Return 1 if all was successfully processed otherwise 0.
  */
  FUNCTION place_start_node( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                           , p_do_commit   IN BOOLEAN                     DEFAULT TRUE
                           )
    RETURN NUMBER
  ;

  /**
  * Checks border situation for a given space node and flips, depending on the border rule,
  * the process spin to the correct direction.
  * @param p_usim_id_spc The space node to check. Mandatory.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Return 1 if all was successfully processed otherwise 0.
  */
  FUNCTION check_border( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                       , p_do_commit   IN BOOLEAN                     DEFAULT TRUE
                       )
    RETURN NUMBER
  ;

  /**
  * Processes a given space node by sending out energy either to child or parent nodes. Handles
  * border situation for process direction.
  * Will update table USIM_SPC_PROCESS. Using package USIM_MATHS for calculations.
  * @param p_usim_id_spc The space node to process. Mandatory.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Return 1 if all was successfully processed otherwise 0.
  */
  FUNCTION process_node( p_usim_id_spc IN usim_space.usim_id_spc%TYPE
                       , p_do_commit   IN BOOLEAN                     DEFAULT TRUE
                       )
    RETURN NUMBER
  ;

  /**
  * Processes currently open outputs, sums up the target nodes and updates targets energy. Starts
  * then processing target nodes as source nodes. Handles overflows and necessary actions like dimension creation.
  * Overflow can result in infinity or in NUMERIC OVERFLOW!!!!
  * Updates the planck time. Will write result to table USIM_SPC_PROCESS. Using package USIM_MATHS for calculations.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Return 1 if all was successfully processed otherwise 0.
  */
  FUNCTION process_queue(p_do_commit IN BOOLEAN DEFAULT TRUE)
    RETURN NUMBER
  ;

END usim_process;
/
