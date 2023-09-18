CREATE OR REPLACE PACKAGE usim_maths
IS
  /** A package for all mathematical calculations in this multiverse which will not use any database access.
  * The universes itself don't care about units, their units are always based on 1, like the planck units. Units like seconds do only
  * make sense for an observer inside a universe, but not from the universe perspective.
  * There is a difference between, so called "outside planck units" and "inside planck units". Inside, every planck unit equals 1, outside
  * it is defined by the start parameters of an universe.
  * <b>Technical:</b> Oracle cuts numbers too large but still supported by PL/SQL. Calculations may raise number overflow/underflow. Using this
  * library should include to check numbers for "overflow" before to get reliable results. Exception handling is minimalistic, if something
  * fails, defaults are used. Exceptions itself are not checked or differentiated. Testing should proove that it works with numbers in range.
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

  /**
  * Calculate acceleration / hit energy for extending space based on source space node attributes.
  * Uses classical mechanics to calculate the acceleration that will hit a target space node from gravitational laws in a very reduced sense.
  * Uses a<sub>2</sub> = G * m<sub>1</sub> / r<sup>2</sup>. Only valid for extending space itself.
  * Extending space sees mass = energy as there exists no mass currently. Energy moving in internal planck steps r = 1 with c = 1 and t = 1.
  * As we have no mass yet and nodes can't move, acceleration transports the energy of one node to the next node. Acceleration is seen as the
  * energy that hits and reacts with another space nodes energy. Energy will travel until it reaches its defined borders and then travel back.
  * The reaction of a target space node is therefore not immediate. Once hit it will first emit the received energy as acceleration to the target
  * nodes within r = 1 until a border is reached. The same law is applied on the travel back, but now with the new energy levels of the target
  * nodes. If a node is not initialized yet (energy = NULL), it is treated as 1 leaving incoming acceleration and energy unchanged.
  * @param p_m1 The "mass" of the source space node represented by its energy value. NULL is interpreted as 0.
  * @param p_r The radius / distance between source and target space node. Internally always 1, but external values may differ. NULL is interpreted as 1.
  * @param p_G The gravitational constant used by the source space node to expand its energy. Use calc_dim_G with the dimension of the source space node to get the correct value. NULL is interpreted as 1.
  * @return The acceleration / hit energy for a target space node by source attributes. Overflow/underflow or any error has to be handled by caller.
  */
  FUNCTION calc_planck_a2( p_m1 IN NUMBER
                         , p_r  IN NUMBER
                         , p_G  IN NUMBER
                         )
    RETURN NUMBER
  ;

  /**
  * Calculates the gravitational constant G for a given dimension for extending space in planck units using G = 1 / 8PI as a base,
  * but considers the current dimension instead of static 8 for 3 dimension. This G is not static. It is only valid in the given dimension.
  * The number for the PI multiplier is derived from maximum binary tree nodes per dimension. Formula:</br>
  * dn = nodes per dimension n = 2<sup>n</sup></br>
  * G<sub>dim</sub> = 1 / (dn * PI)</br>
  * Only valid for extending space itself.
  * @param p_dimension The n dimension to calculate G<sub>dim</sub> for. NULL values are interpreted as 0. Uses the absolute of the number, ignores negative dimensions and cuts any floating point decimals.
  * @return The calculated G<sub>dim</sub> for the given dimension.
  */
  FUNCTION calc_dim_G(p_dimension IN NUMBER)
    RETURN NUMBER
  ;

END usim_maths;
/