-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
CREATE OR REPLACE PACKAGE &USIM_SCHEMA..usim_apex
IS
  /**This package is used as an interface to the APEX application
  * providing specialized functions and procedures for use in APEX.
  */

  --== package variable definition ==--
  -- default schema fixed, change if needed
  PROD_SCHEMA CONSTANT CHAR(4) := 'USIM';
  -- test schema fixed, change if needed
  TEST_SCHEMA CONSTANT CHAR(9) := 'USIM_TEST';

  /**
  * Determines the environment by current user.
  * If USIM_TEST_SCHEMA, then the system is considered as test.
  * @return 0 No test system, 1 is test system, -1 no USIM system
  */
  FUNCTION is_test_env
    RETURN NUMBER
    DETERMINISTIC
    PARALLEL_ENABLE
  ;

  /**
  * Checks if all objects are valid and all packages installed. Due
  * to dependencies in packages it can be assumed that the system is
  * installed correctly when all packages exist and are valid. Checks
  * also if the SYS granted procedures and jobs are present.
  * @return 1 System is installed
  *         2 Test system is installed
  *         0 No system is installed
  *       -10 Invalid objects found in system, objects complete
  *       -11 Invalid and missing objects found in system
  *       -12 Missing objects found in system, objects valid
  *       -20 Invalid objects found in test system, objects complete
  *       -21 Invalid and missing objects found in test system
  *       -22 Missing objects found in test system, objects valid
  *       -99 No USIM system
  */
  FUNCTION is_installed
    RETURN NUMBER
  ;

  /**
  * Returns a displayable text representation of is_installed return value.
  * @return Text describing the installation state.
  */
  FUNCTION is_installed_text
    RETURN VARCHAR2
  ;



END usim_apex;
/