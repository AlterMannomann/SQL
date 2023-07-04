CREATE OR REPLACE PACKAGE BODY usim_static
IS
  -- decription see header
  FUNCTION get_max_childs_per_dimension
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  IS
  BEGIN
    RETURN usim_static.usim_max_childs_per_dimension;
  END get_max_childs_per_dimension
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

  FUNCTION get_planck_time_seq_name
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  IS
  BEGIN
    RETURN usim_static.usim_planck_time_seq_name;
  END get_planck_time_seq_name
  ;

  FUNCTION get_planck_aeon_seq_name
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  IS
  BEGIN
    RETURN usim_static.usim_planck_aeon_seq_name;
  END get_planck_aeon_seq_name
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

  FUNCTION get_multiverse_active
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  IS
  BEGIN
    RETURN usim_static.usim_multiverse_status_active;
  END get_multiverse_active
  ;

  FUNCTION get_multiverse_inactive
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  IS
  BEGIN
    RETURN usim_static.usim_multiverse_status_inactive;
  END get_multiverse_inactive
  ;

  FUNCTION get_multiverse_dead
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  IS
  BEGIN
    RETURN usim_static.usim_multiverse_status_dead;
  END get_multiverse_dead
  ;

  FUNCTION get_multiverse_crashed
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  IS
  BEGIN
    RETURN usim_static.usim_multiverse_status_crashed;
  END get_multiverse_crashed
  ;

  FUNCTION get_multiverse_status(p_status IN NUMBER)
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  IS
  BEGIN
    RETURN CASE
             WHEN p_status = usim_multiverse_status_active
             THEN 'ACTIVE'
             WHEN p_status = usim_multiverse_status_inactive
             THEN 'INACTIVE'
             WHEN p_status = usim_multiverse_status_dead
             THEN 'DEAD'
             WHEN p_status = usim_multiverse_status_crashed
             THEN 'CRASHED'
             ELSE 'UNKNOWN'
          END
    ;
  END get_multiverse_status
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

  FUNCTION get_big_pk_number(p_primary_key IN VARCHAR2)
    RETURN NUMBER
  IS
  BEGIN
    RETURN TO_NUMBER(SUBSTR(p_primary_key, 18));
  END get_big_pk_number
  ;

END usim_static;
/