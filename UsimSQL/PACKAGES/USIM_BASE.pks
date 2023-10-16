CREATE OR REPLACE PACKAGE usim_base
IS
  /** A package for getting/setting values of USIM_BASEDATA table.
  */

  /**
  * Checks if usim_basedata has already data.
  * @return Returns 1 if base data are available, otherwise 0.
  */
  FUNCTION has_basedata
    RETURN NUMBER
  ;

  /**
  * Initializes the base data with the attributes that have to be set on insert if no base data
  * exist, otherwise do nothing. As this procedure mimics the constraints, adjusting the constraints needs package adjustment.
  * @param p_max_dimension The maximum dimensions possible for this multiverse.
  * @param p_usim_abs_max_number The absolute maximum number available for this multiverse.
  * @param p_usim_overflow_node_seed Defines the overflow behaviour, default 0 means standard overflow behaviour. If set to 1, all new nodes are created with the universe seed at coordinate 0 as the parent.
  */
  PROCEDURE init_basedata( p_max_dimension            IN NUMBER DEFAULT 42
                         , p_usim_abs_max_number      IN NUMBER DEFAULT 99999999999999999999999999999999999999
                         , p_usim_overflow_node_seed  IN NUMBER DEFAULT 0
                         )
  ;

  /**
  * Retrieves the current maximum dimension.
  * @return The current value from column usim_max_dimension or NULL if not initialized.
  */
  FUNCTION get_max_dimension
    RETURN NUMBER
  ;

  /**
  * Retrieves the current absolute maximum number allowed.
  * @return The current value from column usim_abs_max_number or NULL if not initialized.
  */
  FUNCTION get_abs_max_number
    RETURN NUMBER
  ;

  /**
  * Retrieves the current minimum number allowed.
  * @return The current value from column usim_abs_max_number * -1 or NULL if not initialized.
  */
  FUNCTION get_min_number
    RETURN NUMBER
  ;

  /**
  * Retrieves the current positive number for underflow situation (too close to zero).
  * @return The current positive underflow value derived from usim_abs_max_number or NULL if not initialized.
  */
  FUNCTION get_max_underflow
    RETURN NUMBER
  ;

  /**
  * Retrieves the current negative number for underflow situation (too close to zero).
  * @return The current negative underflow value derived from usim_abs_max_number or NULL if not initialized.
  */
  FUNCTION get_min_underflow
    RETURN NUMBER
  ;

  /**
  * Checks if given number if it has an overflow or underflow situation based on the maximum absolute number defined in base.
  * Infinity is always an overflow situation.
  * @param p_check_number The number to verify.
  * @return Returns 1 if overflow, 0 if not or NULL if base data not initialized.
  */
  FUNCTION num_has_overflow(p_check_number IN NUMBER)
    RETURN NUMBER
  ;

  /**
  * Retrieves the current setting for overflow behavior.
  * @return The current value from column usim_overflow_node_seed or NULL if not initialized.
  */
  FUNCTION get_overflow_node_seed
    RETURN NUMBER
  ;

  /**
  * CHecks if the defined planck time sequence exists.
  * @return TRUE if the sequence exists, otherwise FALSE.
  */
  FUNCTION planck_time_seq_exists
    RETURN BOOLEAN
  ;

  /**
  * Retrieves the current planck time tick.
  * @return The current value from column usim_planck_time_seq_curr or NULL if not initialized.
  */
  FUNCTION get_planck_time_current
    RETURN NUMBER
  ;

  /**
  * Retrieves the last planck time tick.
  * @return The current value from column usim_planck_time_seq_last or NULL if not initialized.
  */
  FUNCTION get_planck_time_last
    RETURN NUMBER
  ;

  /**
  * Retrieves the next planck time tick. Will update current and last planck time as well as planck
  * aeon if planck time sequence will cycle. If planck aeon is not set, it will be initialized.
  * @return The next planck time tick number or NULL if not initialized/sequence does not exist.
  */
  FUNCTION get_planck_time_next
    RETURN NUMBER
  ;

  /**
  * CHecks if the defined planck aeon sequence exists.
  * @return TRUE if the sequence exists, otherwise FALSE.
  */
  FUNCTION planck_aeon_seq_exists
    RETURN BOOLEAN
  ;

  /**
  * Retrieves the current planck aeon sequence big id.
  * @return The current value from column usim_planck_aeon_seq_curr or usim_static.usim_not_available if not initialized.
  */
  FUNCTION get_planck_aeon_seq_current
    RETURN VARCHAR2
  ;

  /**
  * Retrieves the last planck aeon sequence big id before current.
  * @return The current value from column usim_planck_aeon_seq_last or usim_static.usim_not_available if not initialized.
  */
  FUNCTION get_planck_aeon_seq_last
    RETURN VARCHAR2
  ;

  /**
  * Retrieves the next planck aeon sequence big id. Will update current and last planck aeon sequence.
  * @return The next planck aeon sequence as a big id or NULL if not initialized/sequence does not exist.
  */
  FUNCTION get_planck_aeon_seq_next
    RETURN VARCHAR2
  ;

END usim_base;
/