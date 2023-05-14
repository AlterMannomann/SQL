SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  l_usim_id_seed    usim_poi_structure.usim_id_psc%TYPE;
  l_usim_id_mirror  usim_poi_structure.usim_id_psc%TYPE;
BEGIN
  SELECT usim_id_psc INTO l_usim_id_seed FROM usim_poi_structure WHERE usim_point_name = usim_static.usim_seed_name;
  SELECT usim_id_psc INTO l_usim_id_mirror FROM usim_poi_structure WHERE usim_point_name = 'Mirror Seed';
  usim_ctrl.fillPointStructure(l_usim_id_seed, 1, 2, NULL);
  usim_ctrl.fillPointStructure(l_usim_id_mirror, -1, -2, 1);
  DBMS_OUTPUT.PUT_LINE('Universe and mirror created, 2 planck length distance');
END;
/
