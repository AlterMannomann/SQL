DECLARE
  l_usim_id_dim   usim_dimension.usim_id_dim%TYPE;
  l_usim_id_pos   usim_position.usim_id_pos%TYPE;
  l_usim_id_mlv   usim_multiverse.usim_id_mlv%TYPE;
--  l_usim_id_rmdp  usim_rel_mlv_dim_pos.usim_id_rmdp%TYPE;
BEGIN
  usim_base.init_basedata;
  -- base universe
  l_usim_id_mlv := usim_mlv.insert_universe;
  -- base position
  l_usim_id_pos := usim_pos.insert_next_position(1); -- 0
  -- base dimension 0
  l_usim_id_dim := usim_dim.insert_next_dimension;
  -- base relation
  -- next dimension 1
  l_usim_id_dim := usim_dim.insert_next_dimension;
  l_usim_id_pos := usim_pos.insert_next_position(1); -- 1
  l_usim_id_pos := usim_pos.insert_next_position(-1); -- -1
END;
/