CREATE OR REPLACE PACKAGE BODY usim_maths
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


END usim_maths;
/