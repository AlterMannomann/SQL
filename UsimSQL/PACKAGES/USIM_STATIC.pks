-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
CREATE OR REPLACE PACKAGE &USIM_SCHEMA..usim_static
IS
  /** A Package containing static values and SQL functions for retrieving this values to be used with the application. Changing values
  * in this package may break the application.
  *
  * Package constants:
  * <b>usim_max_childs_per_dimension</b> - a constant value for the allowed amount of child nodes within a given dimension. Application relies on this value.
  * <b>usim_max_seeds</b> - a constant value for the maximum seeds a universe can have, means the maximum of points with dimension and position without a parent. Application relies on this value.
  * <b>usim_planck_time_seq_name</b> - a constant for the sequence name responsible for planck time ticks.
  * <b>usim_planck_aeon_seq_name</b> - a constant for the sequence name responsible for planck aeons.
  * <b>usim_not_available</b> - a constant name for filled char fields which are not Null, but have no usable content.
  * <b>usim_side_from</b> - a constant name for the from side of a volume in space.
  * <b>usim_side_to</b> - a constant name for the to side of a volume in space.
  * <b>usim_side_both</b> - a constant name for basic space universe nodes in dimension 0, position 0 and sign 0 which are parents to base and mirror at the same time.
  * <b>usim_status_success</b> - a constant for debug success.
  * <b>usim_status_error</b> - a constant for debug error.
  * <b>usim_status_warning</b> - a constant for debug warning.
  * <b>usim_multiverse_status_active</b> - a constant for the active status of a multiverse.
  * <b>usim_multiverse_status_inactive</b> - a constant for the inactive status of a multiverse (all energy equals NULL).
  * <b>usim_multiverse_status_dead</b> - a constant for the dead status of a multiverse (all energy equals 0).
  * <b>usim_multiverse_status_crashed</b> - a constant for the crashed status of a multiverse (energy not equilibrated between universe and mirror).
  * <b>PI</b> - a constant for PI definition with Oracle precision.
  * <b>PI_DOUBLE</b> - a constant for 2 * PI definition with Oracle precision.
  * <b>PI_QUARTER</b> - a constant for PI / 4 definition with Oracle precision.
  */
  usim_max_childs_per_dimension   CONSTANT INTEGER      := 1;
  usim_max_seeds                  CONSTANT INTEGER      := 1;
  usim_planck_time_seq_name       CONSTANT CHAR(20)     := 'USIM_PLANCK_TIME_SEQ';
  usim_planck_aeon_seq_name       CONSTANT CHAR(20)     := 'USIM_PLANCK_AEON_SEQ';
  usim_not_available              CONSTANT CHAR(3)      := 'N/A';
  usim_side_from                  CONSTANT CHAR(1)      := 'F';
  usim_side_to                    CONSTANT CHAR(1)      := 'T';
  usim_side_both                  CONSTANT CHAR(1)      := 'B';
  usim_status_success             CONSTANT NUMBER       := 1;
  usim_status_error               CONSTANT NUMBER       := -1;
  usim_status_warning             CONSTANT NUMBER       := 0;
  usim_multiverse_status_active   CONSTANT NUMBER       := 1;
  usim_multiverse_status_inactive CONSTANT NUMBER       := 0;
  usim_multiverse_status_dead     CONSTANT NUMBER       := -1;
  usim_multiverse_status_crashed  CONSTANT NUMBER       := -2;
  PI                              CONSTANT NUMBER       := ACOS(-1);
  PI_DOUBLE                       CONSTANT NUMBER       := ACOS(-1) * 2;
  PI_QUARTER                      CONSTANT NUMBER       := ACOS(-1) / 4;

  /**
  * Types
  */
  SUBTYPE usim_id IS CHAR(55);
  TYPE usim_ids_type IS TABLE OF usim_id INDEX BY PLS_INTEGER;

  /**
  * Get the maximum of childs a node within a dimension can have.
  * @return USIM_STATIC.USIM_MAX_CHILDS_PER_DIMENSION
  */
  FUNCTION get_max_childs_per_dimension
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Get the maximum of seeds a universe can have.
  * @return USIM_STATIC.USIM_MAX_SEEDS
  */
  FUNCTION get_max_seeds
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Get the static PI value.
  * @return USIM_STATIC.PI
  */
  FUNCTION get_pi
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Get the static PI_DOUBLE (2 * PI) value.
  * @return USIM_STATIC.PI_DOUBLE
  */
  FUNCTION get_pi_double
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Get the static PI_QUARTER (PI / 4) value.
  * @return USIM_STATIC.PI_QUARTER
  */
  FUNCTION get_pi_quarter
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Get the static name of the planck time sequence.
  * @return USIM_STATIC.USIM_PLANCK_TIME_SEQ_NAME
  */
  FUNCTION get_planck_time_seq_name
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Get the static name of the planck time sequence.
  * @return USIM_STATIC.USIM_PLANCK_AEON_SEQ_NAME
  */
  FUNCTION get_planck_aeon_seq_name
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Get the static name for not available.
  * @return USIM_STATIC.USIM_NOT_AVAILABLE
  */
  FUNCTION get_not_available
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Get the static name for volume side from.
  * @return USIM_STATIC.USIM_SIDE_FROM
  */
  FUNCTION get_side_from
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Get the static name for volume side to.
  * @return USIM_STATIC.USIM_SIDE_TO
  */
  FUNCTION get_side_to
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Get the static name for volume side both.
  * @return USIM_STATIC.USIM_SIDE_BOTH
  */
  FUNCTION get_side_both
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Get the identifier number for success of debug operations.
  * @return USIM_STATIC.USIM_STATUS_SUCCESS
  */
  FUNCTION get_debug_success
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Get the identifier number for error of debug operations.
  * @return USIM_STATIC.USIM_STATUS_ERROR
  */
  FUNCTION get_debug_error
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Get the identifier number for warning of debug operations.
  * @return USIM_STATIC.USIM_STATUS_WARNING
  */
  FUNCTION get_debug_warning
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Get the active status of a multiverse.
  * @return USIM_STATIC.USIM_MULTIVERSE_STATUS_ACTIVE
  */
  FUNCTION get_multiverse_active
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Get the inactive status of a multiverse.
  * @return USIM_STATIC.USIM_MULTIVERSE_STATUS_INACTIVE
  */
  FUNCTION get_multiverse_inactive
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Get the dead status of a multiverse.
  * @return USIM_STATIC.USIM_MULTIVERSE_STATUS_DEAD
  */
  FUNCTION get_multiverse_dead
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Get the crashed status of a multiverse.
  * @return USIM_STATIC.USIM_MULTIVERSE_STATUS_CRASHED
  */
  FUNCTION get_multiverse_crashed
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Get a text representation of the status of a multiverse.
  * @return ACTIVE, INACTIVE, DEAD, CRASHED or UNKOWN status of universe by number identifier.
  */
  FUNCTION get_multiverse_status(p_status IN NUMBER)
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Get the identifier text for status of debug operations.
  * @param p_status - the debug status to get the text for.
  * @return SUCCESS, WARNING or ERROR
  */
  FUNCTION get_debug_status(p_status IN NUMBER)
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Get a text representation of a boolean value. Only for use in PL/SQL. Won't work with SQL statements.
  * @param p_boolean - the boolean expression or variable.
  * @return "TRUE" or "FALSE"
  */
  FUNCTION get_bool_str(p_boolean IN BOOLEAN)
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Returns a VARCHAR2 of length 55 using current timestamp
  * and the number from a cycling sequence to build a generic
  * primary key which does not cause number overflows or end of
  * available sequence numbers.
  * @param p_sequence_number - the cycling sequence number to add to the key.
  * @return New primary key in format TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3') || LPAD([sequence], 38, '0').
  */
  FUNCTION get_big_pk(p_sequence_number IN NUMBER)
    RETURN VARCHAR2
  ;

  /**
  * Returns the date value of a big primary key.
  * @param p_primary_key - the primary key to get the date from.
  * @return Normal DATE including seconds of the given primary key.
  */
  FUNCTION get_big_pk_date(p_primary_key IN VARCHAR2)
    RETURN DATE
  ;

  /**
  * Returns the number value of a big primary key.
  * @param p_primary_key - the primary key to get the number value from.
  * @return Number value of the given primary key.
  */
  FUNCTION get_big_pk_number(p_primary_key IN VARCHAR2)
    RETURN NUMBER
  ;

  /**
  * Returns the next number based on given number and sign.
  * Adds 1 for sign +1 and subtract 1 for sign -1.
  * @param p_number The number to get the next number for.
  * @param p_sign The sign for the number to use. Only used if number is 0, otherwise sign is retrieved from given number. Sign 0 is interpreted positive.
  * @return The next number based on (given) sign of the number.
  */
  FUNCTION get_next_number( p_number IN NUMBER
                          , p_sign   IN NUMBER DEFAULT 1
                          )
    RETURN NUMBER
  ;

  /**
  * Calculates the nodes defining a volume by dimension.
  * Uses 2<sup>dimension</sup>.
  * @param p_dimension The dimension to calculate the amount of nodes. Must be >= 0, values < 0 are interpreted as 0.
  * @return The amount of nodes that define a volume for a given dimension.
  */
  FUNCTION nodes_per_dimension(p_dimension IN NUMBER)
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Calculates the nodes missing for a given dimension, supposing that former dimensions and nodes already exist.
  * Uses nodes_per_dimension(dimension) - nodes_per_dimension(dimension - 1) with special case dimension 0 and 1.
  * @param p_dimension The dimension to calculate the amount of missing nodes. Must be >= 0, values < 0 are interpreted as 0.
  * @return The amount of missing nodes for a volume and a given dimension.
  */
  FUNCTION missing_nodes_per_dimension(p_dimension IN NUMBER)
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Checks if a given side is an allowed side.
  * @param p_side The side symbol to check.
  * @return Returns 1 if side symbol equals usim_side_from, usim_side_to or usim_side_both, otherwise 0.
  */
  FUNCTION is_allowed_side(p_side IN VARCHAR2)
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Checks if a given side is an allowed from or to side.
  * @param p_side The side symbol to check.
  * @return Returns 1 if side symbol equals usim_side_from or usim_side_to, otherwise 0.
  */
  FUNCTION is_allowed_fromto_side(p_side IN VARCHAR2)
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

END usim_static;
/