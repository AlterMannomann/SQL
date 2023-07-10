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
BEGIN
  usim_base.init_basedata;
  -- base universe
  l_usim_id_mlv := usim_mlv.insert_universe;
  -- base dimension 0
  l_usim_id_dim := usim_dim.insert_next_dimension;
  -- base position
  l_usim_id_pos := usim_pos.insert_next_position(1); -- 0, neutral sign
  l_usim_id_pos1 := usim_pos.insert_next_position(1); -- 0, 1
  l_usim_id_pos2 := usim_pos.insert_next_position(1); -- 1, 1
  l_usim_id_pos3 := usim_pos.insert_next_position(-1); -- 0, -1
  l_usim_id_pos4 := usim_pos.insert_next_position(-1); -- -1, -1
  INSERT INTO usim_volume
    ( usim_id_mlv
    , usim_id_pos_base_from
    , usim_id_pos_base_to
    , usim_id_pos_mirror_from
    , usim_id_pos_mirror_to
    )
    VALUES
    ( l_usim_id_mlv
    , l_usim_id_pos1
    , l_usim_id_pos2
    , l_usim_id_pos3
    , l_usim_id_pos4
    )
    RETURNING usim_id_vol INTO l_usim_id_vol
  ;
  COMMIT;
  l_usim_id_nod := usim_nod.insert_node;
/*
  -- base rmd relation
  l_usim_id_rmd := usim_rmd.insert_rmd(l_usim_id_mlv, l_usim_id_dim);
  -- base rrpn relation
  l_usim_id_rrpn := usim_rrpn.insert_rrpn(l_usim_id_rmd, l_usim_id_pos, l_usim_id_nod);
  -- next dimension 1
  l_usim_id_dim := usim_dim.insert_next_dimension;
  l_usim_id_rmd := usim_rmd.insert_rmd(l_usim_id_mlv, l_usim_id_dim);
  l_usim_id_pos := usim_pos.insert_next_position(1); -- 1, positive sign
  l_usim_id_nod := usim_nod.insert_node;
  l_usim_id_rrpn := usim_rrpn.insert_rrpn(l_usim_id_rmd, l_usim_id_pos, l_usim_id_nod);
  l_usim_id_pos := usim_pos.insert_next_position(-1); -- -1, negative sign
  l_usim_id_nod := usim_nod.insert_node;
  l_usim_id_rrpn := usim_rrpn.insert_rrpn(l_usim_id_rmd, l_usim_id_pos, l_usim_id_nod);
*/
END;
/