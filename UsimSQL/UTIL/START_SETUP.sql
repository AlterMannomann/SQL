DECLARE
  l_seq             NUMBER;
  l_return          NUMBER;
  l_usim_id_mlv     usim_multiverse.usim_id_mlv%TYPE;
  l_usim_id_spc     usim_space.usim_id_spc%TYPE;
  l_seq_aeon        usim_static.usim_id;
BEGIN
  usim_erl.purge_log;
  l_return := usim_process.place_start_node;
  IF l_return = 1
  THEN
    usim_erl.log_error('basic_setup', 'Init place start node with defaults for base data and universe.');
    l_return := usim_process.run_samples(23);
    IF l_return = 1
    THEN
      usim_erl.log_error('basic_setup', 'Samples run exit without error.');
    ELSE
      usim_erl.log_error('basic_setup', 'Error running samples.');
    END IF;
  ELSE
    usim_erl.log_error('basic_setup', 'Failed to init place start node with defaults for base data and universe.');
  END IF;

  -- get variables for this run
  l_usim_id_spc := usim_dbif.get_id_spc_base_universe;
  l_usim_id_mlv := usim_dbif.get_id_mlv(l_usim_id_spc);
  l_seq_aeon    := usim_dbif.get_planck_aeon_seq_current;
  l_seq         := usim_dbif.get_planck_time_current;
  -- provide json output, if website is running, may throw errors on file open
  l_return := usim_creator.create_json_struct(l_usim_id_mlv);
  l_return := usim_creator.create_space_log(l_seq_aeon, 1, l_seq);

END;
/
