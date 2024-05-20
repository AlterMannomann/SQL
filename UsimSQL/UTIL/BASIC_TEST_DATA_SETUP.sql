DECLARE
  -- n1p: n1=1, n1n n=-1, 1p=1/dim 1 sign 1, 1n=-1/dim 1 sign -1
  l_id_mlv1         usim_multiverse.usim_id_mlv%TYPE;
  l_id_mlv2         usim_multiverse.usim_id_mlv%TYPE;
  l_id_rmd0         usim_rel_mlv_dim.usim_id_rmd%TYPE;
  l_id_rmd_n1p_1p   usim_rel_mlv_dim.usim_id_rmd%TYPE;
  l_id_rmd_n1n_1n   usim_rel_mlv_dim.usim_id_rmd%TYPE;
  l_id_rmd_n1p_2p   usim_rel_mlv_dim.usim_id_rmd%TYPE;
  l_id_rmd_n1p_2n   usim_rel_mlv_dim.usim_id_rmd%TYPE;
  l_id_rmd_n1n_2p   usim_rel_mlv_dim.usim_id_rmd%TYPE;
  l_id_rmd_n1n_2n   usim_rel_mlv_dim.usim_id_rmd%TYPE;
  l_id_rmd_n1p_3p   usim_rel_mlv_dim.usim_id_rmd%TYPE;
  l_id_rmd_n1p_3n   usim_rel_mlv_dim.usim_id_rmd%TYPE;
  l_id_rmd_n1n_3p   usim_rel_mlv_dim.usim_id_rmd%TYPE;
  l_id_rmd_n1n_3n   usim_rel_mlv_dim.usim_id_rmd%TYPE;
  l_id_pos0         usim_position.usim_id_pos%TYPE;
  l_id_pos1p        usim_position.usim_id_pos%TYPE;
  l_id_pos1n        usim_position.usim_id_pos%TYPE;
  l_id_pos2p        usim_position.usim_id_pos%TYPE;
  l_id_pos2n        usim_position.usim_id_pos%TYPE;
  l_id_spc0         usim_space.usim_id_spc%TYPE;
  -- dim 1 pos 0
  l_id_spc0_n1p_1p  usim_space.usim_id_spc%TYPE;
  l_id_spc0_n1n_1n  usim_space.usim_id_spc%TYPE;
  -- dim 1 pos 1
  l_id_spc1p_n1p_1p usim_space.usim_id_spc%TYPE;
  l_id_spc1n_n1n_1n usim_space.usim_id_spc%TYPE;
  -- dim 1 pos 2
  l_id_spc2p_n1p_1p usim_space.usim_id_spc%TYPE;
  l_id_spc2n_n1n_1n usim_space.usim_id_spc%TYPE;
  -- dim 2 pos 0
  l_id_spc0p_n1p_2p usim_space.usim_id_spc%TYPE;
  l_id_spc0n_n1p_2n usim_space.usim_id_spc%TYPE;
  l_id_spc0p_n1n_2p usim_space.usim_id_spc%TYPE;
  l_id_spc0n_n1n_2n usim_space.usim_id_spc%TYPE;
  -- dim 2 pos 1
  l_id_spc1p_n1p_2p usim_space.usim_id_spc%TYPE;
  l_id_spc1n_n1p_2n usim_space.usim_id_spc%TYPE;
  l_id_spc1p_n1n_2p usim_space.usim_id_spc%TYPE;
  l_id_spc1n_n1n_2n usim_space.usim_id_spc%TYPE;
  -- dim 2 pos 2
  l_id_spc2p_n1p_2p usim_space.usim_id_spc%TYPE;
  l_id_spc2n_n1p_2n usim_space.usim_id_spc%TYPE;
  l_id_spc2p_n1n_2p usim_space.usim_id_spc%TYPE;
  l_id_spc2n_n1n_2n usim_space.usim_id_spc%TYPE;
  -- inbetween nodes
  -- 1,1 in dim 1,2
  l_id_spc1p1p_n1p_1p2p usim_space.usim_id_spc%TYPE;
  -- -1,1 in dim -1,2
  l_id_spc1n1p_n1n_1n2p usim_space.usim_id_spc%TYPE;
  -- 1, -1
  l_id_spc1p1n_n1p_1p2n usim_space.usim_id_spc%TYPE;
  -- -1, -1
  l_id_spc1n1n_n1n_1n2n usim_space.usim_id_spc%TYPE;

  l_seq             NUMBER;
  l_return          NUMBER;
  l_usim_id_mlv     usim_multiverse.usim_id_mlv%TYPE;
  l_usim_id_spc     usim_space.usim_id_spc%TYPE;
  l_seq_aeon        usim_static.usim_id;
  l_parents         usim_static.usim_ids_type;
  l_universe_state  usim_multiverse.usim_universe_status%TYPE;
BEGIN
  usim_erl.purge_log;
  usim_debug.purge_log;
  usim_debug.set_debug_on;

/*
  l_return := usim_dbif.init_basedata(3, 10);
  usim_erl.log_error('basic_test_data_setup', 'Init base data with max dimension 3 and max number 10.');

  -- init planck time
  l_seq := usim_dbif.get_planck_time_next;
  usim_erl.log_error('basic_test_data_setup', 'Init planck tick [' || l_seq || '].');
  l_seq_aeon := usim_dbif.get_planck_aeon_seq_current;
  usim_erl.log_error('basic_test_data_setup', 'Current planck aeon [' || l_seq_aeon || '] after update tick.');
  -- base universe
  l_return    := usim_dbif.init_dimensions;
  l_return    := usim_dbif.init_positions;
  l_id_mlv1   := usim_dbif.create_universe;
  l_id_pos0   := usim_dbif.get_id_pos(0);
  l_id_pos1p  := usim_dbif.get_id_pos(1);
  l_id_pos1n  := usim_dbif.get_id_pos(-1);
  l_id_pos2p  := usim_dbif.get_id_pos(2);
  l_id_pos2n  := usim_dbif.get_id_pos(-2);
  -- dim axis 0
  l_return  := usim_dbif.create_dim_axis(l_id_mlv1, 0, NULL, l_id_rmd0, l_id_rmd_n1p_1p);
  l_id_spc0 := usim_dbif.create_space_node(l_id_rmd0, l_id_pos0, l_parents);
  -- dim axis 1 (+/-)
  l_return := usim_dbif.create_dim_axis(l_id_mlv1, 1, l_id_rmd0, l_id_rmd_n1p_1p, l_id_rmd_n1n_1n);
  l_parents(1) := l_id_spc0;
  -- +0,0,0
  l_id_spc0_n1p_1p  := usim_dbif.create_space_node(l_id_rmd_n1p_1p, l_id_pos0, l_parents);
  -- -0,0,0
  l_id_spc0_n1n_1n  := usim_dbif.create_space_node(l_id_rmd_n1n_1n, l_id_pos0, l_parents);

  -- from here on parents have to have the same dim n1 sign
  -- do positive axis n1p_n1
  l_parents(1) := l_id_spc0_n1p_1p;
  -- 1,0,0
  l_id_spc1p_n1p_1p := usim_dbif.create_space_node(l_id_rmd_n1p_1p, l_id_pos1p, l_parents);
  l_parents(1) := l_id_spc1p_n1p_1p;
  -- 2,0,0
  l_id_spc2p_n1p_1p := usim_dbif.create_space_node(l_id_rmd_n1p_1p, l_id_pos2p, l_parents);

  -- do negative axis n1n_n1
  l_parents(1) := l_id_spc0_n1n_1n;
  -- -1,0,0
  l_id_spc1n_n1n_1n := usim_dbif.create_space_node(l_id_rmd_n1n_1n, l_id_pos1n, l_parents);
  l_parents(1) := l_id_spc1n_n1n_1n;
  -- -2,0,0
  l_id_spc2n_n1n_1n := usim_dbif.create_space_node(l_id_rmd_n1n_1n, l_id_pos2n, l_parents);

  -- dim axis n1p_n2 (+/-)
  l_return := usim_dbif.create_dim_axis(l_id_mlv1, 2, l_id_rmd_n1p_1p, l_id_rmd_n1p_2p, l_id_rmd_n1p_2n);
  -- dim axis n1n_n2 (+/-)
  l_return := usim_dbif.create_dim_axis(l_id_mlv1, 2, l_id_rmd_n1n_1n, l_id_rmd_n1n_2p, l_id_rmd_n1n_2n);

  -- do axis n1p_n2p
  -- +0,+0,0 n1p_n2p
  l_parents(1) := l_id_spc0_n1p_1p;
  l_id_spc0p_n1p_2p := usim_dbif.create_space_node(l_id_rmd_n1p_2p, l_id_pos0, l_parents);
  -- +0,+1,0 n1p_n2p
  l_parents(1) := l_id_spc0p_n1p_2p;
  l_id_spc1p_n1p_2p := usim_dbif.create_space_node(l_id_rmd_n1p_2p, l_id_pos1p, l_parents);
  -- +0,+2,0 n1p_n2p
  l_parents(1) := l_id_spc1p_n1p_2p;
  l_id_spc2p_n1p_2p := usim_dbif.create_space_node(l_id_rmd_n1p_2p, l_id_pos2p, l_parents);

  -- do axis n1p_n2n
  -- +0,-0,0 n1p_n2n
  l_parents(1) := l_id_spc0_n1p_1p;
  l_id_spc0n_n1p_2n := usim_dbif.create_space_node(l_id_rmd_n1p_2n, l_id_pos0, l_parents);
  -- +0,-1,0 n1p_n2n
  l_parents(1) := l_id_spc0n_n1p_2n;
  l_id_spc1n_n1p_2n := usim_dbif.create_space_node(l_id_rmd_n1p_2n, l_id_pos1n, l_parents);
  -- +0,-2,0 n1p_n2n
  l_parents(1) := l_id_spc1n_n1p_2n;
  l_id_spc2n_n1p_2n := usim_dbif.create_space_node(l_id_rmd_n1p_2n, l_id_pos2n, l_parents);

  -- do axis n1n_n2p
  -- -0,+0,0 n1n_n2p
  l_parents(1) := l_id_spc0_n1n_1n;
  l_id_spc0p_n1n_2p := usim_dbif.create_space_node(l_id_rmd_n1n_2p, l_id_pos0, l_parents);
  -- -0,+1,0 n1n_n2p
  l_parents(1) := l_id_spc0p_n1n_2p;
  l_id_spc1p_n1n_2p := usim_dbif.create_space_node(l_id_rmd_n1n_2p, l_id_pos1p, l_parents);
  -- -0,+2,0 n1n_n2p
  l_parents(1) := l_id_spc1p_n1n_2p;
  l_id_spc2p_n1n_2p := usim_dbif.create_space_node(l_id_rmd_n1n_2p, l_id_pos2p, l_parents);

  -- do axis n1n_n2n
  -- -0,-0,0 n1n_n2n
  l_parents(1) := l_id_spc0_n1n_1n;
  l_id_spc0n_n1n_2n := usim_dbif.create_space_node(l_id_rmd_n1n_2n, l_id_pos0, l_parents);
  -- -0,-1,0 n1n_n2n
  l_parents(1) := l_id_spc0n_n1n_2n;
  l_id_spc1n_n1n_2n := usim_dbif.create_space_node(l_id_rmd_n1n_2n, l_id_pos1n, l_parents);
  -- -0,-2,0 n1n_n2n
  l_parents(1) := l_id_spc1n_n1n_2n;
  l_id_spc2n_n1n_2n := usim_dbif.create_space_node(l_id_rmd_n1n_2n, l_id_pos2n, l_parents);

  -- inbetween nodes two ways to construct, higher dimension with related value or lower dimension with related value
  -- 1,1,0 n1p
  l_parents(1) := l_id_spc1p_n1p_1p;
  l_parents(2) := l_id_spc1p_n1p_2p;
  l_id_spc1p1p_n1p_1p2p := usim_dbif.create_space_node(l_id_rmd_n1p_2p, l_id_pos1p, l_parents);
  -- 1,-1,0 n1p
  l_parents(1) := l_id_spc1p_n1p_1p;
  l_parents(2) := l_id_spc1n_n1p_2n;
  l_id_spc1p1n_n1p_1p2n := usim_dbif.create_space_node(l_id_rmd_n1p_2p, l_id_pos1p, l_parents);
  -- -1,1,0 n1n
  l_parents(1) := l_id_spc1n_n1n_1n;
  l_parents(2) := l_id_spc1n_n1n_2n;
  l_id_spc1n1p_n1n_1n2p := usim_dbif.create_space_node(l_id_rmd_n1n_2n, l_id_pos1n, l_parents);
  -- -1,-1,0 n1n
  l_parents(1) := l_id_spc1n_n1n_1n;
  l_parents(2) := l_id_spc1p_n1n_2p;
  l_id_spc1n1n_n1n_1n2n := usim_dbif.create_space_node(l_id_rmd_n1n_2n, l_id_pos1n, l_parents);

--  l_universe_state := usim_dbif.set_universe_state(l_id_mlv1, usim_static.usim_multiverse_status_active,);
*/
  -- test processing
  l_return := usim_process.place_start_node(3, 10);
  IF l_return = 1
  THEN
    usim_debug.debug_log('basic_test_data_setup', 'Init place start node with max dimension 3 and max number 10.');
    l_return := usim_process.run_samples(1000);
    IF l_return = 1
    THEN
      usim_debug.debug_log('basic_test_data_setup', 'Samples run exit without error.');
    ELSE
      usim_debug.debug_log('basic_test_data_setup', 'Error running samples.');
    END IF;
  ELSE
    usim_debug.debug_log('basic_test_data_setup', 'Failed to init place start node with max dimension 3 and max number 10.');
  END IF;

  -- get variables for this run
  l_usim_id_spc := usim_dbif.get_id_spc_base_universe;
  l_usim_id_mlv := usim_dbif.get_id_mlv(l_usim_id_spc);
  l_seq_aeon    := usim_dbif.get_planck_aeon_seq_current;
  l_seq         := usim_dbif.get_planck_time_current;
  -- provide json output, if website is running, may throw errors on file open
  l_return := usim_creator.create_space_log(l_seq_aeon, 1, l_seq);
EXCEPTION
  WHEN OTHERS THEN
    usim_debug.debug_log('basic_test_data_setup', 'Unexpected error SQLCODE [' || SQLCODE || '] message [' || SQLERRM || '].');
END;
/
-- list error and debug messages
SELECT usim_timestamp, SUBSTR(usim_err_object, 1, 50) AS usim_err_object, usim_err_info FROM usim_error_log ORDER BY usim_timestamp, usim_tick;
SELECT usim_timestamp, SUBSTR(usim_log_object, 1, 50) AS usim_log_object, usim_log_content FROM usim_debug_log ORDER BY usim_timestamp, ROWID;