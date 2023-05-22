-- insert start value
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  l_frequency     usim_point.usim_frequency%TYPE;
  l_wavelength    usim_point.usim_wavelength%TYPE;
  l_amplitude     usim_point.usim_amplitude%TYPE;
BEGIN
  -- init planck time
  DBMS_OUTPUT.PUT_LINE('Planck time before cycle: ' || usim_utility.next_planck_time);
  -- initialize
  SELECT usim_angular_frequency
       , usim_wavelength
       , usim_amplitude
    INTO l_frequency
       , l_wavelength
       , l_amplitude
    FROM usim_dim_attributes_v
   WHERE usim_n_dimension = 0
  ;
  usim_ctrl.run_planck_cycle(1, l_amplitude, l_wavelength, l_frequency);
  DBMS_OUTPUT.PUT_LINE('First planck cycle complete ...');
  DBMS_OUTPUT.PUT_LINE('Planck time after cycle: ' || usim_utility.current_planck_time);
END;
/
