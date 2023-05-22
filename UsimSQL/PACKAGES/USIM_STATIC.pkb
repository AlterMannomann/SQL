CREATE OR REPLACE PACKAGE BODY usim_static IS
  -- decription see header
  FUNCTION get_max_childs
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  IS
  BEGIN
    RETURN usim_static.usim_max_childs;
  END get_max_childs
  ;

  FUNCTION get_max_seeds
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  IS
  BEGIN
    RETURN usim_static.usim_max_seeds;
  END get_max_seeds
  ;

  FUNCTION get_seed_name
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  IS
  BEGIN
    RETURN usim_static.usim_seed_name;
  END get_seed_name
  ;

  FUNCTION get_mirror_name
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  IS
  BEGIN
    RETURN usim_static.usim_mirror_name;
  END get_mirror_name
  ;

  FUNCTION get_child_add
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  IS
  BEGIN
    RETURN usim_static.usim_child_add;
  END get_child_add
  ;

  FUNCTION get_pi
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  IS
  BEGIN
    RETURN usim_static.PI;
  END get_pi
  ;

  FUNCTION get_pi_double
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  IS
  BEGIN
    RETURN usim_static.PI_DOUBLE;
  END get_pi_double
  ;

  FUNCTION get_pi_quarter
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  IS
  BEGIN
    RETURN usim_static.PI_QUARTER;
  END get_pi_quarter
  ;

  FUNCTION get_max_dimensions
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  IS
  BEGIN
    RETURN usim_static.usim_max_dimensions;
  END get_max_dimensions
  ;

  FUNCTION get_planck_timer
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  IS
  BEGIN
    RETURN usim_static.usim_planck_timer;
  END get_planck_timer
  ;

  FUNCTION get_not_available
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  IS
  BEGIN
    RETURN usim_static.usim_not_available;
  END get_not_available
  ;

  FUNCTION get_big_pk(p_sequence_number IN NUMBER)
    RETURN VARCHAR2
  IS
  BEGIN
    RETURN TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3') || LPAD(TRIM(TO_CHAR(p_sequence_number)), 38, '0');
  END get_big_pk
  ;

  FUNCTION get_big_pk_date(p_primary_key IN VARCHAR2)
    RETURN DATE
  IS
  BEGIN
    RETURN TO_DATE(SUBSTR(p_primary_key, 1, 14), 'YYYYMMDDHH24MISS');
  END get_big_pk_date
  ;
END usim_static;
/