DECLARE
  l_usim_id_dim   usim_dimension.usim_id_dim%TYPE;
  l_usim_id_pos   usim_position.usim_id_pos%TYPE;
  l_usim_id_pos0  usim_position.usim_id_pos%TYPE;
  l_usim_id_pos0m usim_position.usim_id_pos%TYPE;
  l_usim_id_pos1  usim_position.usim_id_pos%TYPE;
  l_usim_id_pos1m usim_position.usim_id_pos%TYPE;
  l_usim_id_pos2  usim_position.usim_id_pos%TYPE;
  l_usim_id_pos2m usim_position.usim_id_pos%TYPE;
  l_usim_id_mlv   usim_multiverse.usim_id_mlv%TYPE;
  l_usim_id_rmd   usim_rel_mlv_dim.usim_id_rmd%TYPE;
  l_usim_id_rmd1  usim_rel_mlv_dim.usim_id_rmd%TYPE;
  l_usim_id_rmd2  usim_rel_mlv_dim.usim_id_rmd%TYPE;
  l_usim_id_nod   usim_node.usim_id_nod%TYPE;
  l_usim_id_spc   usim_space.usim_id_spc%TYPE;
  l_usim_id_spc0  usim_space.usim_id_spc%TYPE;
  l_usim_id_spc0m usim_space.usim_id_spc%TYPE;
  l_usim_id_spc1  usim_space.usim_id_spc%TYPE;
  l_usim_id_spc1m usim_space.usim_id_spc%TYPE;
  l_usim_id_spc2  usim_space.usim_id_spc%TYPE;
  l_usim_id_spc2m usim_space.usim_id_spc%TYPE;
  l_usim_id_spd1  usim_space.usim_id_spc%TYPE;
  l_usim_id_spd1m usim_space.usim_id_spc%TYPE;
  l_usim_id_spd2  usim_space.usim_id_spc%TYPE;
  l_usim_id_spd2m usim_space.usim_id_spc%TYPE;
  l_usim_id_mir   usim_space.usim_id_spc%TYPE;
  l_usim_id_chi   usim_space.usim_id_spc%TYPE;
  l_seq_aeon      CHAR(55);
  l_seq           NUMBER;
  l_result        NUMBER;
BEGIN
  usim_erl.purge_log;
  usim_base.init_basedata(3, 2);
  usim_erl.log_error('basic_test_data_setup', 'Init base data with max dimension 3 and max number 2.');

  -- init planck time
  l_seq_aeon := usim_base.get_planck_aeon_seq_next;
  usim_erl.log_error('basic_test_data_setup', 'Init planck aeon [' || l_seq_aeon || '].');
  l_seq := usim_base.get_planck_time_next;
  usim_erl.log_error('basic_test_data_setup', 'Init planck tick [' || l_seq || '].');
  -- base universe
  l_usim_id_spc := usim_creator.create_new_universe;
  l_result := usim_process.place_start_node(l_usim_id_spc);
  FOR i IN 1..20
  LOOP
    l_result := usim_process.process_queue;
  END LOOP;

/*
  l_usim_id_mlv   := usim_spc.get_id_mlv(l_usim_id_spc);
  -- first volume, dimension 1 is guaranteed
  usim_erl.log_error('basic_test_data_setup', 'Create first volume: usim_creator.create_volume(''' || l_usim_id_spc || ''');');
  l_usim_id_rmd1  := usim_rmd.get_id_rmd(l_usim_id_mlv, 1);
  l_usim_id_vol   := usim_creator.get_create_volume(l_usim_id_spc, l_usim_id_mlv, l_usim_id_rmd1);
  usim_erl.log_error('basic_test_data_setup', 'Created first volume id [' || l_usim_id_vol || '].');
  usim_erl.log_error('basic_test_data_setup', 'Create new dimension: usim_creator.create_next_dimension(''' || l_usim_id_spc || ''');');
  l_usim_id_rmd2  := usim_creator.get_create_next_dim(l_usim_id_spc, l_usim_id_mlv);
  usim_erl.log_error('basic_test_data_setup', 'Created new dimension rmd id [' || l_usim_id_rmd2 || '].');
  -- create next volume should extend to dimension 2
  l_usim_id_pos0  := usim_pos.get_id_pos(0, 1);
  l_usim_id_pos0m := usim_pos.get_id_pos(0, -1);
  l_usim_id_pos1  := usim_pos.get_id_pos(1, 1);
  l_usim_id_pos1m := usim_pos.get_id_pos(-1, -1);
  l_usim_id_pos2  := usim_pos.insert_next_position(1, TRUE); -- 2
  l_usim_id_pos2m := usim_pos.insert_next_position(-1, TRUE); -- -2
  l_usim_id_vol1  := usim_vol.insert_vol(l_usim_id_rmd1, l_usim_id_pos1, l_usim_id_pos2, l_usim_id_pos1m, l_usim_id_pos2m);
  l_usim_id_nod   := usim_nod.insert_node;
  l_usim_id_spc2  := usim_spc.insert_spc(l_usim_id_rmd1, l_usim_id_pos2, l_usim_id_nod, usim_static.usim_side_to, l_usim_id_vol1);
  l_usim_id_nod   := usim_nod.insert_node;
  l_usim_id_spc2m := usim_spc.insert_spc(l_usim_id_rmd1, l_usim_id_pos2m, l_usim_id_nod, usim_static.usim_side_to, l_usim_id_vol1);
  l_usim_id_mir   := usim_mir.insert_mir(l_usim_id_spc2, l_usim_id_spc2m);
  l_usim_id_spc0  := usim_spc.get_id_spc(l_usim_id_rmd1, l_usim_id_pos0, usim_static.usim_side_from, l_usim_id_vol);
  l_usim_id_spc0m := usim_spc.get_id_spc(l_usim_id_rmd1, l_usim_id_pos0m, usim_static.usim_side_from, l_usim_id_vol);
  l_usim_id_spc1  := usim_spc.get_id_spc(l_usim_id_rmd1, l_usim_id_pos1, usim_static.usim_side_to, l_usim_id_vol);
  l_usim_id_spc1m := usim_spc.get_id_spc(l_usim_id_rmd1, l_usim_id_pos1m, usim_static.usim_side_to, l_usim_id_vol);
  l_usim_id_chi   := usim_chi.insert_chi(l_usim_id_spc1, l_usim_id_spc2);
  l_usim_id_chi   := usim_chi.insert_chi(l_usim_id_spc1m, l_usim_id_spc2m);
  -- create space nodes in dimension 2
  l_usim_id_nod   := usim_nod.insert_node;
  l_usim_id_spd1  := usim_spc.insert_spc(l_usim_id_rmd2, l_usim_id_pos1, l_usim_id_nod, usim_static.usim_side_from, l_usim_id_vol);
  l_usim_id_nod   := usim_nod.insert_node;
  l_usim_id_spd1m := usim_spc.insert_spc(l_usim_id_rmd2, l_usim_id_pos1m, l_usim_id_nod, usim_static.usim_side_from, l_usim_id_vol);
  l_usim_id_mir   := usim_mir.insert_mir(l_usim_id_spd1, l_usim_id_spd1m);
  l_usim_id_chi   := usim_chi.insert_chi(l_usim_id_spc0, l_usim_id_spd1);
  l_usim_id_chi   := usim_chi.insert_chi(l_usim_id_spc0m, l_usim_id_spd1m);
  l_usim_id_nod   := usim_nod.insert_node;
  l_usim_id_spd2  := usim_spc.insert_spc(l_usim_id_rmd2, l_usim_id_pos1, l_usim_id_nod, usim_static.usim_side_to, l_usim_id_vol);
  l_usim_id_nod   := usim_nod.insert_node;
  l_usim_id_spd2m := usim_spc.insert_spc(l_usim_id_rmd2, l_usim_id_pos1m, l_usim_id_nod, usim_static.usim_side_to, l_usim_id_vol);
  l_usim_id_mir   := usim_mir.insert_mir(l_usim_id_spd2, l_usim_id_spd2m);
  l_usim_id_chi   := usim_chi.insert_chi(l_usim_id_spc1, l_usim_id_spd2);
  l_usim_id_chi   := usim_chi.insert_chi(l_usim_id_spc1m, l_usim_id_spd2m);
  l_usim_id_chi   := usim_chi.insert_chi(l_usim_id_spd1, l_usim_id_spd2);
  l_usim_id_chi   := usim_chi.insert_chi(l_usim_id_spd1m, l_usim_id_spd2m);
*/

  /*
  usim_erl.log_error('basic_test_data_setup', 'Get base to space id: usim_vol.get_id_base_to(''' || l_usim_id_vol || ''');');
  l_usim_id_spc1 := usim_spc.get_id_spc_base_to(l_usim_id_vol);
  usim_erl.log_error('basic_test_data_setup', 'Retrieved base to space id [' || l_usim_id_spc1 || '].');
  usim_erl.log_error('basic_test_data_setup', 'Create next volume: usim_creator.create_volume(''' || l_usim_id_spc1 || ''');');
  l_usim_id_vol := usim_creator.create_volume(l_usim_id_spc1);
  usim_erl.log_error('basic_test_data_setup', 'Created next volume id [' || l_usim_id_vol || '].');
  */
END;
/
SELECT usim_timestamp, SUBSTR(usim_err_object, 1, 50) AS usim_err_object, usim_err_info FROM usim_error_log ORDER BY usim_timestamp, usim_tick;
/* nice sort for view
SELECT *
  FROM usim_rrpn_v
 ORDER BY usim_id_mlv
        , usim_sign
        , usim_coordinate
        , usim_n_dimension
;
-- seems NOT ok
SELECT usim_chi.has_free_child_dimension(scv.usim_id_spc) AS free_dim
     , usim_chi.has_free_child_position(scv.usim_id_spc) AS free_pos
     , usim_chi.has_escape_situation(scv.usim_id_spc) AS has_escape_situation
     , usim_chi.has_extend_situation(scv.usim_id_spc) AS has_extend_situation
     , CASE usim_chi.classify_parent(scv.usim_id_spc)
         WHEN -2 THEN 'ERR'
         WHEN -1 THEN 'DM ERR'
         WHEN 0 THEN 'FULL'
         WHEN 1 THEN 'FREE DIM POS'
         WHEN 2 THEN 'FREE DIM'
         WHEN 3 THEN 'FREE POS'
         ELSE 'ERR'
       END AS classify_parent
     , CASE usim_chi.classify_escape(scv.usim_id_spc)
         WHEN -2 THEN 'ERR'
         WHEN -1 THEN 'DM ERR'
         WHEN 0 THEN 'NONE'
         WHEN 1 THEN 'DIM POS'
         WHEN 2 THEN 'DIM'
         WHEN 3 THEN 'POS'
         ELSE 'ERR'
       END AS classify_escape
     , usim_spc.overflow_mlv_dim(scv.usim_id_spc) AS overflow_dim
     , usim_spc.overflow_mlv_pos(scv.usim_id_spc) AS overflow_pos
     , usim_spo.get_xyz(scv.usim_id_spc) AS parent_xyz
     , usim_spo.get_xyz(scv.usim_id_spc_child) AS child_xyz
     , scv.parent_coordinate
     , scv.child_coordinate
     , scv.parent_dimension
     , scv.child_dimension
     , scv.parent_dim_sign
     , scv.child_dim_sign
     , scv.usim_id_spc
     , scv.usim_id_spc_child
  FROM usim_spc_chi_v scv
 ORDER BY scv.parent_dim_sign, scv.parent_dimension, scv.parent_coordinate, scv.child_dim_sign, scv.child_dimension, scv.child_coordinate
;
-- get all nodes by volume
  WITH vol AS
       (SELECT usim_id_rmd
             , usim_id_vol
             , usim_id_pos_base_from AS usim_id_pos_base
             , usim_id_pos_mirror_from AS usim_id_pos_mirror
             , usim_static.get_side_from AS usim_vol_side
          FROM usim_volume
         WHERE usim_id_vol = '2023080902035029500000000000000000000000000000000000024'
         UNION ALL
        SELECT usim_id_rmd
             , usim_id_vol
             , usim_id_pos_base_to AS usim_id_pos_base
             , usim_id_pos_mirror_to AS usim_id_pos_mirror
             , usim_static.get_side_to AS usim_vol_side
          FROM usim_volume
         WHERE usim_id_vol = '2023080902035029500000000000000000000000000000000000024'
       )
     , rmd AS
       (SELECT usim_id_rmd
          FROM usim_space
         WHERE usim_id_vol = '2023080902035029500000000000000000000000000000000000024'
         GROUP BY usim_id_rmd
       )
SELECT spcv.usim_id_spc
     , spcv.usim_id_pos
     , vol.usim_id_vol
     , CASE
         WHEN usim_vol.has_ancestor(vol.usim_id_vol) = 1
         THEN vol.usim_vol_side
         ELSE spcv.usim_vol_side
       END AS usim_vol_side
     , spcv.usim_vol_side AS org_vol_side
     , vol.usim_vol_side AS new_vol_side
     , spcv.usim_n_dimension
     , spcv.usim_coordinate
     , spcv.usim_sign
  FROM usim_spc_v spcv
 INNER JOIN vol
    ON spcv.usim_id_pos IN (vol.usim_id_pos_base, vol.usim_id_pos_mirror)
 INNER JOIN rmd
    ON spcv.usim_id_rmd = rmd.usim_id_rmd
 WHERE spcv.usim_id_vol IN (vol.usim_id_vol, CASE WHEN usim_vol.has_ancestor(vol.usim_id_vol) = 1 THEN usim_vol.get_ancestor(vol.usim_id_vol) ELSE NULL END)
;
-- testing
  WITH src AS
       (SELECT usim_id_spc AS p_usim_id_spc
          FROM usim_spc_v
         WHERE usim_coordinate = 0
           AND usim_sign = 1
           AND usim_n_dimension = 1
       )
SELECT usim_chi.get_child_next_dimension(p_usim_id_spc, 1) next_dim_child
     , usim_spc.get_sign(p_usim_id_spc) sign
     , usim_spc.has_attached_volume(p_usim_id_spc) vol
     , usim_chi.child_count(p_usim_id_spc) cnt
     , usim_chi.get_vol_rel_id(p_usim_id_spc) vol_id
     , usim_spc.is_universe_base(p_usim_id_spc) is_base
     , p_usim_id_spc
  FROM src
;
  WITH rmd AS
       (SELECT usim_id_rmd
             , usim_n_dimension
          FROM usim_spc_v
         GROUP BY usim_id_rmd
                , usim_n_dimension
       )
     , spcv AS
       (SELECT usim_id_spc
             , usim_n_dimension
             , usim_coordinate
             , CASE WHEN usim_sign = 0 THEN 1 ELSE usim_sign END AS usim_sign
          FROM usim_spc_v spcv
       )
SELECT spcv.usim_id_spc
     , spcv.usim_n_dimension AS from_dim
     , rmd.usim_n_dimension AS to_dim
     , spcv.usim_coordinate
     , usim_pos.get_coordinate(usim_chi.get_vol_pos_rel_id(usim_id_spc, rmd.usim_id_rmd, -1)) AS rel_coord
     , spcv.usim_sign
     , usim_spc.is_universe_base(spcv.usim_id_spc) AS is_base
     , usim_chi.get_vol_pos_rel_id(usim_id_spc, rmd.usim_id_rmd, -1) AS pos_id
  FROM spcv
 CROSS JOIN rmd
 WHERE spcv.usim_n_dimension > 0
   AND rmd.usim_n_dimension > 0
   AND rmd.usim_n_dimension >= spcv.usim_n_dimension
   AND spcv.usim_sign = -1
 ORDER BY spcv.usim_n_dimension, rmd.usim_n_dimension, spcv.usim_coordinate DESC
;
-- basic JSON
  WITH grp AS
       (SELECT usim_planck_aeon
             , usim_planck_time
          FROM usim_spc_process
         GROUP BY usim_planck_aeon
                , usim_planck_time
       )
     , details AS
       (SELECT usim_planck_aeon
             , usim_planck_time
             , JSON_OBJECT( 'from' VALUE
                         JSON_OBJECT( 'x' VALUE usim_spo.get_dim_coord(usim_id_spc_source, 1)
                                    , 'y' VALUE usim_spo.get_dim_coord(usim_id_spc_source, 2)
                                    , 'z' VALUE usim_spo.get_dim_coord(usim_id_spc_source, 3)
                                    , 'energy' VALUE usim_energy_source
                                    , 'dim' VALUE usim_spc.get_dimension(usim_id_spc_source)
                                    , 'dim_sign' VALUE usim_spc.get_dim_sign(usim_id_spc_source)
                                    , 'output' VALUE usim_energy_output
                                    )
                                  , 'to' VALUE
                         JSON_OBJECT( 'x' VALUE usim_spo.get_dim_coord(usim_id_spc_target, 1)
                                    , 'y' VALUE usim_spo.get_dim_coord(usim_id_spc_target, 2)
                                    , 'z' VALUE usim_spo.get_dim_coord(usim_id_spc_target, 3)
                                    , 'energy' VALUE NVL(usim_energy_target, 0)
                                    , 'dim' VALUE usim_spc.get_dimension(usim_id_spc_target)
                                    , 'dim_sign' VALUE usim_spc.get_dim_sign(usim_id_spc_target)
                                    )
                                  ) AS json_detail
          FROM usim_spc_process
       )
SELECT JSON_OBJECT( 'aeon' VALUE usim_planck_aeon
                  , 'tick' VALUE usim_planck_time
                  , 'processes' VALUE (SELECT JSON_OBJECTAGG('executed' VALUE json_detail)
                                         FROM details
                                        WHERE usim_planck_aeon = grp.usim_planck_aeon
                                          AND usim_planck_time = grp.usim_planck_time
                                      )
                  )
  FROM grp
;
-- besser
-- Tabelle USIM_SPR_JSON real_time_index, filename, json_content; für zeitbereiche/anzahl ticks/maximale rows wenn tick wechselt count um zu wissen ob
-- der tick noch platz hat
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  jo JSON_OBJECT_T;
  ja JSON_ARRAY_T;
BEGIN
  ja := new JSON_ARRAY_T;
  jo := new JSON_OBJECT_T;
  jo.put('bla','blubb');
  jo.put('sepp', 'depp');
  ja.append(jo);
  ja.append(jo);
  DBMS_OUTPUT.PUT_LINE(ja.to_String);
END;
/
-- create overview tabs
SELECT usim_timestamp, SUBSTR(usim_err_object, 1, 50) AS usim_err_object, usim_err_info FROM usim_error_log ORDER BY usim_timestamp, usim_tick;
SELECT * FROM usim_spc_v;
SELECT * FROM usim_spc_chi_v;
SELECT * FROM usim_spo_v;
SELECT * FROM usim_rmd_v;
SELECT * FROM usim_position;
SELECT * FROM usim_spo_xyz_v;

*/