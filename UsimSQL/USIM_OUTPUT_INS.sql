-- insert start value
SET SERVEROUTPUT ON SIZE UNLIMITED
BEGIN
  -- initialize
  usim_ctrl.runonedirection(0, 1, 1, 1);
  -- run
  usim_ctrl.runonedirection(0);
  DBMS_OUTPUT.PUT_LINE('First run direction childs complete ...');
END;
/
