SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  l_usim_id_seed    usim_poi_structure.usim_id_psc%TYPE;
  l_usim_id_mirror  usim_poi_structure.usim_id_psc%TYPE;
  l_pos1            usim_position.usim_coordinate%TYPE;
  l_pos2            usim_position.usim_coordinate%TYPE;
  l_neg1            usim_position.usim_coordinate%TYPE;
  l_neg2            usim_position.usim_coordinate%TYPE;
  l_point           usim_poi_dim_position.usim_id_pdp%TYPE;
BEGIN
  SELECT usim_id_psc INTO l_usim_id_seed FROM usim_poi_structure WHERE usim_point_name = usim_static.usim_seed_name;
  SELECT usim_id_psc INTO l_usim_id_mirror FROM usim_poi_structure WHERE usim_point_name = usim_static.usim_mirror_name;
  SELECT usim_next_1st_position_positive
       , usim_next_2nd_position_positive
       , usim_next_1st_position_negative
       , usim_next_2nd_position_negative
    INTO l_pos1
       , l_pos2
       , l_neg1
       , l_neg2
    FROM usim_position_v
  ;
  usim_ctrl.fill_point_structure(l_usim_id_seed, l_pos1, l_pos2, NULL);
  SELECT usim_id_pdp
    INTO l_point
    FROM usim_poi_dim_position_v
   WHERE usim_id_parent IS NULL
  ;
  usim_ctrl.fill_point_structure(l_usim_id_mirror, l_neg1, l_neg2, l_point);
  DBMS_OUTPUT.PUT_LINE('Universe and mirror created');
END;
/
