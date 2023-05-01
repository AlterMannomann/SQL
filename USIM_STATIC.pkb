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

  FUNCTION get_child_name
    RETURN VARCHAR2
    DETERMINISTIC
    PARALLEL_ENABLE
  IS
  BEGIN
    RETURN usim_static.usim_child_name;
  END get_child_name
  ;
END usim_static;
/