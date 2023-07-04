CREATE OR REPLACE PACKAGE usim_maths
IS
  /** A package for all mathematical calculations in this multiverse which will not use any database access.
  * The universes itself don't care about units, their units are always based on 1, like the planck units. Units like seconds do only
  * make sense for an observer inside a universe, but not from the universe perspective.
  * There is a difference between, so called "outside planck units" and "inside planck units". Inside, every planck unit equals 1, outside
  * it is defined by the start parameters of an universe.
  */

  /**
  * Calculates the planck speed c, which is an instantaneous velocity v by given planck length(minimal displacement) and planck time(minimal time frame). Using:</br>
  * v = delta x / delta t</br>
  " In this special case delta x equals the given outside planck length and delta t equals the outside planck time.
  * @param p_planck_length The outside planck definition for minimal displacement in a specific universe.
  * @param p_planck_time The outside planck definition for minimal time frames in a specific universe.
  * @return The planck speed for given time and displacement or 1 (default) if any of the parameters equals NULL/0.
  */
  FUNCTION init_planck_speed( p_planck_length IN NUMBER
                            , p_planck_time   IN NUMBER
                            )
    RETURN NUMBER
  ;

  /**
  * Calculates the planck time by given planck length(minimal displacement) and planck speed(minimal speed). Using:</br>
  * t = delta x / delta v</br>
  " In this special case delta x equals the given outside planck length and delta v equals the outside planck speed.
  * @param p_planck_length The outside planck definition for minimal displacement in a specific universe.
  * @param p_planck_speed The outside planck definition for minimal speed in a specific universe.
  * @return The planck time for given speed and displacement or 1 (default) if any of the parameters equals NULL/0.
  */
  FUNCTION init_planck_time( p_planck_length  IN NUMBER
                           , p_planck_speed   IN NUMBER
                           )
    RETURN NUMBER
  ;

  /**
  * Calculates the planck length by given planck speed(minimal speed) and planck time(minimal time frame). Using:</br>
  * x = delta t x delta v</br>
  " In this special case delta t equals the outside planck time and delta v equals the outside planck speed.
  * @param p_planck_speed The outside planck definition for minimal speed in a specific universe.
  * @param p_planck_time The outside planck definition for minimal time frames in a specific universe.
  * @return The planck length for given speed and time or 1 (default) if any of the parameters equals NULL/0.
  */
  FUNCTION init_planck_length( p_planck_speed IN NUMBER
                             , p_planck_time  IN NUMBER
                             )
    RETURN NUMBER
  ;

  /**
  * Applies a universe specific outside planck definition like speed, length or time. Using:</br>
  * value x factor
  * @param p_value The value to apply a planck factor. NULL values are interpreted as 0.
  * @param p_planck_factor The outside planck attribute definition like speed, time and length to be used as a factor. NULL values are interpreted as 0.
  * @return The value multiplied by the given factor.
  */
  FUNCTION apply_planck( p_value         IN NUMBER
                       , p_planck_factor IN NUMBER
                       )
    RETURN NUMBER
  ;

END usim_maths;
/