DECLARE
  l_usim_id_dim   usim_dimension.usim_id_dim%TYPE;
  l_usim_id_pos   usim_position.usim_id_pos%TYPE;
  l_usim_id_pos1  usim_position.usim_id_pos%TYPE;
  l_usim_id_pos2  usim_position.usim_id_pos%TYPE;
  l_usim_id_pos3  usim_position.usim_id_pos%TYPE;
  l_usim_id_pos4  usim_position.usim_id_pos%TYPE;
  l_usim_id_mlv   usim_multiverse.usim_id_mlv%TYPE;
  l_usim_id_rmd   usim_rel_mlv_dim.usim_id_rmd%TYPE;
  l_usim_id_vol   usim_volume.usim_id_vol%TYPE;
  l_usim_id_nod   usim_node.usim_id_nod%TYPE;
  l_usim_id_rrpn  usim_rel_rmd_pos_nod.usim_id_rrpn%TYPE;
  l_seq_aeon      CHAR(55);
  l_seq           NUMBER;
BEGIN
  usim_base.init_basedata;
  -- init planck time
  l_seq_aeon := usim_base.get_planck_aeon_seq_next;
  l_seq := usim_base.get_planck_time_next;
  -- base universe
  l_usim_id_mlv := usim_creator.create_new_universe;
  l_usim_id_vol := usim_creator.create_next_volume(l_usim_id_mlv);
  l_usim_id_vol := usim_creator.create_next_volume(l_usim_id_mlv);
  l_usim_id_vol := usim_creator.create_next_volume(l_usim_id_mlv);
  l_usim_id_rmd := usim_creator.create_next_dimension(l_usim_id_mlv);
  l_usim_id_rmd := usim_creator.create_next_dimension(l_usim_id_mlv);
END;
/

/* nice sort for view
SELECT *
  FROM usim_rrpn_v
 ORDER BY usim_id_mlv
        , usim_sign
        , usim_coordinate
        , usim_n_dimension
;
*/