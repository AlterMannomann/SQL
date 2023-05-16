-- insert start value
SET SERVEROUTPUT ON SIZE UNLIMITED
BEGIN
  -- initialize
  usim_ctrl.runPlanckCycle(1, 1, 1);
  DBMS_OUTPUT.PUT_LINE('First planck cycle complete ...');
END;
/
