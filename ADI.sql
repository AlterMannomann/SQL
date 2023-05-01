CREATE OR REPLACE FUNCTION test_cond( par1 IN NUMBER 
                                    , par2 IN VARCHAR2
                                    , par3 IN VARCHAR2
                                    , par4 IN VARCHAR2
                                    , par5 IN DATE
                                    )
  RETURN NUMBER                                  
IS 

BEGIN
    IF 1 = 2 THEN RETURN -1;
    ELSIF par1 = 1 AND par2 = '2' AND par3 = '3' AND par4 = '4' AND par5 BETWEEN TO_DATE('01.01.2022', 'DD.MM.YYYY') AND TO_DATE('01.01.2022', 'DD.MM.YYYY') THEN RETURN 1;
    ELSIF par1 = 1 AND par2 = '2' AND par3 = '3' AND par5 BETWEEN TO_DATE('01.01.2022', 'DD.MM.YYYY') AND TO_DATE('01.01.2022', 'DD.MM.YYYY') THEN RETURN 2;
    ELSE RETURN 3;
    END IF;
END;
/                                    

SELECT test_cond(1, '2', '3', '4', TO_DATE('01.01.2022', 'DD.MM.YYYY')) FROM dual;