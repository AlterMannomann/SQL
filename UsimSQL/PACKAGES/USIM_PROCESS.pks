CREATE OR REPLACE PACKAGE usim_process
IS
  /**A package for processing space nodes. Depends on all available packages including USIM_CREATOR.*/

  /**
  * Provides a process start node in the queue. The start node is always the base universe seed at position 0 and dimension 0
  * without any parent. The process direction is childs. Should be called only once. Will do nothing if processing nodes already
  * exist or no base universe seed is found.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Return 1 if all was successfully processed otherwise 0.
  */
  FUNCTION place_start_node(p_do_commit IN BOOLEAN DEFAULT TRUE)
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
