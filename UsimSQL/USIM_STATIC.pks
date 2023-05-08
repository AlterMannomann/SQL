CREATE OR REPLACE PACKAGE usim_static IS
  /* USIM_STATIC
   * Package containing static values to be used with the application.
   */

  -- Package variables
  -- USIM_MAX_CHILDS      a constant value for child nodes in a binary tree. Also used for child tree nodes.
  usim_max_childs         CONSTANT INTEGER := 2;
  -- USIM_MAX_SEEDS       a constant value for the maximum seeds a universe can have, means the maximum of
  --                      point with dimension and position without a parent
  usim_max_seeds          CONSTANT INTEGER := 1;
  -- USIM_SEED_NAME       a constant name for the basic point structure of the universe. Add an index if more than one seed is used.
  usim_seed_name          CONSTANT VARCHAR2(13) := 'UniverseSeed';
  -- USIM_CHILD_NAME      a constant name for childs (point structure trees) of a seed or one of its nodes. Always add an index to this name to keep it unique.
  usim_child_name         CONSTANT VARCHAR2(13) := 'SeedTreeChild';

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
  /* USIM_STATIC.GET_CHILD_NAME()
   * Get the static base name for for childs (point structure trees) of a seed. Always add an index to this name to keep it unique.
   *
   * RETURNS: USIM_STATIC.USIM_CHILD_NAME
   */
  FUNCTION get_child_name
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  ;
END usim_static;
/