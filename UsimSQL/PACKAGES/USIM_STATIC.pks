CREATE OR REPLACE PACKAGE usim_static IS
  /* USIM_STATIC
   * Package containing static values to be used with the application.
   */

  -- Package variables
  -- USIM_MAX_CHILDS      a constant value for child nodes in a binary tree.
  usim_max_childs         CONSTANT INTEGER := 2;
  -- USIM_MAX_SEEDS       a constant value for the maximum seeds a universe can have, means the maximum of
  --                      point with dimension and position without a parent
  usim_max_seeds          CONSTANT INTEGER := 1;
  -- USIM_SEED_NAME       a constant name for the basic point structure of the universe. Add an index if more than one seed is used.
  usim_seed_name          CONSTANT VARCHAR2(13) := 'UniverseSeed';
  -- USIM_MIRROR_NAME     a constant name for the basic point mirror structure of the universe. Add an index if more than one seed is used.
  usim_mirror_name        CONSTANT VARCHAR2(13) := 'MirrorSeed';
  -- USIM_CHILD_ADD       a constant name addendum for childs (point structure trees) of seed or mirror. Always add an index to this name to keep it unique.
  usim_child_add          CONSTANT VARCHAR2(13) := 'Child';
  -- USIM_MAX_DIMENSIONS  a constant for n-sphere dimensions supported by the simulation.
  usim_max_dimensions     CONSTANT INTEGER := 3;
  -- USIM_PLANCK_TIMER    a constant for the sequence name responsible for planck time ticks
  usim_planck_timer       CONSTANT VARCHAR2(20) := 'USIM_PLANCK_TIME_SEQ';
  -- USIM_NOT_AVAILABLE   a constant name for filled char fields which are not Null, but have no usable content.
  usim_not_available      CONSTANT VARCHAR2(3) := 'N/A';
  -- PI                   PI definition with Oracle precision
  PI                      CONSTANT NUMBER := ACOS(-1);
  -- PI2                  2 * PI definition with Oracle precision
  PI_DOUBLE               CONSTANT NUMBER := ACOS(-1) * 2;
  -- PI_QUARTER           PI / 4 definition with Oracle precision
  PI_QUARTER              CONSTANT NUMBER := ACOS(-1) / 4;

  -- Functions for SQL access of package variables
  /* USIM_STATIC.GET_MAX_CHILDS()
   * Get the maximum of childs a point with dimension and position can have.
   *
   * RETURNS: USIM_STATIC.USIM_MAX_CHILDS
   */
  FUNCTION get_max_childs
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  ;
  /* USIM_STATIC.GET_MAX_SEEDS()
   * Get the maximum of seeds a universe can have.
   *
   * RETURNS: USIM_STATIC.USIM_MAX_SEEDS
   */
  FUNCTION get_max_seeds
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  ;
  /* USIM_STATIC.GET_SEED_NAME()
   * Get the static name for the seed point structure of the universe.
   *
   * RETURNS: USIM_STATIC.USIM_SEED_NAME
   */
  FUNCTION get_seed_name
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  ;
  /* USIM_STATIC.GET_MIRROR_NAME()
   * Get the static name for the seed mirror point structure of the universe.
   *
   * RETURNS: USIM_STATIC.USIM_MIRROR_NAME
   */
  FUNCTION get_mirror_name
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  ;
  /* USIM_STATIC.GET_CHILD_ADD()
   * Get the static base name for for childs (point structure trees) of a seed. Always add an index to this name to keep it unique.
   *
   * RETURNS: USIM_STATIC.USIM_CHILD_ADD
   */
  FUNCTION get_child_add
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  ;
  /* USIM_STATIC.GET_PI()
   * Get the static PI value.
   *
   * RETURNS: USIM_STATIC.PI
   */
  FUNCTION get_pi
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  ;
  /* USIM_STATIC.GET_PI_DOUBLE()
   * Get the static PI_DOUBLE (2 * PI) value.
   *
   * RETURNS: USIM_STATIC.PI_DOUBLE
   */
  FUNCTION get_pi_double
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  ;
  /* USIM_STATIC.GET_PI_QUARTER()
   * Get the static PI_QUARTER (PI / 4) value.
   *
   * RETURNS: USIM_STATIC.PI_QUARTER
   */
  FUNCTION get_pi_quarter
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  ;
  /* USIM_STATIC.GET_MAX_DIMENSIONS()
   * Get the static USIM_MAX_DIMENSIONS value.
   *
   * RETURNS: USIM_STATIC.USIM_MAX_DIMENSIONS
   */
  FUNCTION get_max_dimensions
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /* USIM_STATIC.GET_PLANCK_TIMER()
   * Get the static USIM_PLANCK_TIMER value.
   *
   * RETURNS: USIM_STATIC.USIM_PLANCK_TIMER
   */
  FUNCTION get_planck_timer
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /* USIM_STATIC.GET_NOT_AVAILABLE()
   * Get the static USIM_NOT_AVAILABLE value.
   *
   * RETURNS: USIM_STATIC.USIM_NOT_AVAILABLE
   */
  FUNCTION get_not_available
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  -- function for building a big primary key
  /* USIM_STATIC.GET_BIG_PK
   * Returns a VARCHAR2 of length 55 using current timestamp
   * and the number from a cycling sequence to build a generic
   * primary key which does not cause number overflows or end of
   * available sequence numbers.
   *
   * PARAMETER
   * p_sequence_number  - the cycling sequence number to add to the key.
   *
   * RETURNS
   * New primary key in format TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3') || LPAD([sequence], 38, '0').
   */
  FUNCTION get_big_pk(p_sequence_number IN NUMBER)
    RETURN VARCHAR2
  ;
  /* USIM_STATIC.GET_BIG_PK_DATE
   * Returns the date value of a big primary key.
   *
   * PARAMETER
   * p_primary_key  - the primary key to get the date from.
   *
   * RETURNS
   * Normal DATE including seconds of the given primary key.
   */
  FUNCTION get_big_pk_date(p_primary_key IN VARCHAR2)
    RETURN DATE
  ;

END usim_static;
/