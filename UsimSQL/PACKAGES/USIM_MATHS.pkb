-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
CREATE OR REPLACE PACKAGE BODY &USIM_SCHEMA..usim_maths
IS
  -- see header for documentation
  FUNCTION init_planck_speed( p_planck_length IN NUMBER
                            , p_planck_time   IN NUMBER
                            )
    RETURN NUMBER
  IS
  BEGIN
    IF    NVL(p_planck_length, 0) = 0
       OR NVL(p_planck_time, 0)   = 0
    THEN
      -- fallback default value
      RETURN 1;
    ELSE
      RETURN (p_planck_length / p_planck_time);
    END IF;
  END init_planck_speed
  ;

  FUNCTION init_planck_time( p_planck_length  IN NUMBER
                           , p_planck_speed   IN NUMBER
                           )
    RETURN NUMBER
  IS
  BEGIN
    IF    NVL(p_planck_length, 0) = 0
       OR NVL(p_planck_speed, 0)  = 0
    THEN
      -- fallback default value
      RETURN 1;
    ELSE
      RETURN (p_planck_length / p_planck_speed);
    END IF;
  END init_planck_time
  ;

  FUNCTION init_planck_length( p_planck_speed IN NUMBER
                             , p_planck_time  IN NUMBER
                             )
    RETURN NUMBER
  IS
  BEGIN
    IF    NVL(p_planck_time, 0)   = 0
       OR NVL(p_planck_speed, 0)  = 0
    THEN
      -- fallback default value
      RETURN 1;
    ELSE
      RETURN (p_planck_speed * p_planck_time);
    END IF;
  END init_planck_length
  ;

  FUNCTION apply_planck( p_value         IN NUMBER
                       , p_planck_factor IN NUMBER
                       )
    RETURN NUMBER
  IS
  BEGIN
    RETURN (NVL(p_value, 0) * NVL(p_planck_factor, 0));
  END apply_planck
  ;

  FUNCTION calc_dim_G(p_dimension IN NUMBER)
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    l_result := 1 / usim_static.nodes_per_dimension(NVL(ABS(FLOOR(p_dimension)), 0));
    RETURN l_result;
  END calc_dim_G
  ;

  FUNCTION calc_planck_a2( p_m1 IN NUMBER
                         , p_r  IN NUMBER
                         , p_G  IN NUMBER
                         )
    RETURN NUMBER
  IS
    l_result NUMBER;
  BEGIN
    l_result := NVL(p_G, 1) * (NVL(p_m1, 0) / POWER(NVL(p_r, 1), 2));
    RETURN l_result;
  END calc_planck_a2
  ;

END usim_maths;
/