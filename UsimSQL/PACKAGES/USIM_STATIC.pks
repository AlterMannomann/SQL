CREATE OR REPLACE PACKAGE usim_static IS
  /** A Package containing static values and SQL functions for retrieving this values to be used with the application.
  *
  * Package constants:
  * <b>usim_max_childs</b> - a constant value for the allowed amount of child nodes in a binary tree point structure.
  * <b>usim_max_seeds</b> - a constant value for the maximum seeds a universe can have, means the maximum of points with dimension and position without a parent.
  * <b>usim_seed_name</b> - a constant name for the basic point structure of the universe. Add an index if more than one seed is used.
  * <b>usim_mirror_name</b> - a constant name for the basic point mirror structure of the universe. Add an index if more than one seed is used.
  * <b>usim_child_add</b> - a constant name addendum for childs (point structure trees) of seed or mirror. Always add an index to this name to keep it unique.
  * <b>usim_max_dimensions</b> - a constant for n-sphere dimensions supported by the simulation.
  * <b>usim_planck_timer</b> - a constant for the sequence name responsible for planck time ticks.
  * <b>usim_not_available</b> - a constant name for filled char fields which are not Null, but have no usable content.
  * <b>usim_max_number</b> - a constant for the positive number overflow value.
  * <b>usim_status_success</b> - a constant for debug success.
  * <b>usim_status_error</b> - a constant for debug error.
  * <b>usim_status_warning</b> - a constant for debug warning.
  * <b>PI</b> - a constant for PI definition with Oracle precision.
  * <b>PI_DOUBLE</b> - a constant for 2 * PI definition with Oracle precision.
  * <b>PI_QUARTER</b> - a constant for PI / 4 definition with Oracle precision.
  */
  usim_max_childs         CONSTANT INTEGER      := 2;
  usim_max_seeds          CONSTANT INTEGER      := 1;
  usim_seed_name          CONSTANT VARCHAR2(12) := 'UniverseSeed';
  usim_mirror_name        CONSTANT VARCHAR2(10) := 'MirrorSeed';
  usim_child_add          CONSTANT VARCHAR2(5)  := 'Child';
  usim_max_dimensions     CONSTANT INTEGER      := 3;
  usim_planck_timer       CONSTANT VARCHAR2(20) := 'USIM_PLANCK_TIME_SEQ';
  usim_not_available      CONSTANT VARCHAR2(3)  := 'N/A';
  usim_max_number         CONSTANT NUMBER       := 99999999999999999999999999999999999999;
  usim_status_success     CONSTANT NUMBER       := 1;
  usim_status_error       CONSTANT NUMBER       := -1;
  usim_status_warning     CONSTANT NUMBER       := 0;
  PI                      CONSTANT NUMBER       := ACOS(-1);
  PI_DOUBLE               CONSTANT NUMBER       := ACOS(-1) * 2;
  PI_QUARTER              CONSTANT NUMBER       := ACOS(-1) / 4;

  /**
  * Get the maximum of childs a point with dimension and position can have.
  * @return USIM_STATIC.USIM_MAX_CHILDS
  */
  FUNCTION get_max_childs
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
  * Get the static name for the seed point structure of the universe.
  * @return USIM_STATIC.USIM_SEED_NAME
  */
  FUNCTION get_seed_name
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Get the static name for the seed mirror point structure of the universe.
  * @return USIM_STATIC.USIM_MIRROR_NAME
  */
  FUNCTION get_mirror_name
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Get the static base name for for childs (point structure trees) of a seed. Always add an index to this name to keep it unique.
  * @return USIM_STATIC.USIM_CHILD_ADD
  */
  FUNCTION get_child_add
    RETURN VARCHAR2
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
  * Get the static value for the maximum of n-sphere dimensions supported.
  * @return USIM_STATIC.USIM_MAX_DIMENSIONS
  */
  FUNCTION get_max_dimensions
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Get the static name of the planck timer sequence.
  * @return USIM_STATIC.USIM_PLANCK_TIMER
  */
  FUNCTION get_planck_timer
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
  * Check a number against overflow. If the highest number supported is reached, overflow is indicated.
  * Only for use in PL/SQL. Won't work with SQL statements.
  * @return TRUE if number is highest/lowest number possible, otherwise FALSE.
  */
  FUNCTION is_overflow_reached(p_check_number NUMBER)
    RETURN BOOLEAN
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

END usim_static;
/