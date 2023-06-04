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

  FUNCTION is_overflow_reached(p_check_number NUMBER)
    RETURN BOOLEAN
    DETERMINISTIC
    PARALLEL_ENABLE
  IS
  BEGIN
    RETURN (ABS(p_check_number) = usim_static.usim_max_number);
  END is_overflow_reached
  ;

  FUNCTION get_debug_success
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
   IS
  BEGIN
    RETURN usim_static.usim_status_success;
  END get_debug_success
  ;

  FUNCTION get_debug_error
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  IS
  BEGIN
    RETURN usim_static.usim_status_error;
  END get_debug_error
  ;

  FUNCTION get_debug_warning
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  IS
  BEGIN
    RETURN usim_static.usim_status_warning;
  END get_debug_warning
  ;

  FUNCTION get_debug_status(p_status  IN NUMBER)
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  IS
  BEGIN
    RETURN CASE
             WHEN p_status = usim_status_success
             THEN 'SUCCESS'
             WHEN p_status = usim_status_error
             THEN 'ERROR'
             WHEN p_status = usim_status_warning
             THEN 'WARNING'
             ELSE 'UNKNOWN'
          END
    ;
  END get_debug_status
  ;

  FUNCTION get_bool_str(p_boolean IN BOOLEAN)
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  IS
  BEGIN
    IF p_boolean
    THEN
      RETURN 'TRUE';
    ELSE
      RETURN 'FALSE';
    END IF;
  END get_bool_str
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