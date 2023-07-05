DECLARE
  l_usim_id_dim   usim_dimension.usim_id_dim%TYPE;
  l_usim_id_pos   usim_position.usim_id_pos%TYPE;
  l_usim_id_mlv   usim_multiverse.usim_id_mlv%TYPE;
  l_usim_id_rmd   usim_rel_mlv_dim.usim_id_rmd%TYPE;
BEGIN
  usim_base.init_basedata;
  -- base universe
  l_usim_id_mlv := usim_mlv.insert_universe;
  -- base position
  l_usim_id_pos := usim_pos.insert_next_position(1); -- 0, positive sign
  -- base dimension 0
  l_usim_id_dim := usim_dim.insert_next_dimension;
  -- base relation
  l_usim_id_rmd := usim_rmd.insert_rmd(l_usim_id_mlv, l_usim_id_dim);
  -- next dimension 1
  l_usim_id_dim := usim_dim.insert_next_dimension;
  l_usim_id_rmd := usim_rmd.insert_rmd(l_usim_id_mlv, l_usim_id_dim);
  l_usim_id_pos := usim_pos.insert_next_position(1); -- 1, positive sign
  l_usim_id_pos := usim_pos.insert_next_position(-1); -- -1, negative sign
END;
/