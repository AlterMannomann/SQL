CREATE OR REPLACE PACKAGE BODY usim_creator
IS
  -- see header for documentation
  FUNCTION create_new_universe( p_usim_energy_start_value IN usim_multiverse.usim_energy_start_value%TYPE DEFAULT 1
                              , p_usim_planck_time_unit   IN usim_multiverse.usim_planck_time_unit%TYPE   DEFAULT 1
                              , p_usim_planck_length_unit IN usim_multiverse.usim_planck_length_unit%TYPE DEFAULT 1
                              , p_usim_planck_speed_unit  IN usim_multiverse.usim_planck_speed_unit%TYPE  DEFAULT 1
                              , p_usim_planck_stable      IN usim_multiverse.usim_planck_stable%TYPE      DEFAULT 1
                              , p_usim_base_sign          IN usim_multiverse.usim_base_sign%TYPE          DEFAULT 1
                              , p_usim_id_vol_parent      IN usim_volume.usim_id_vol%TYPE                 DEFAULT NULL
                              , p_do_commit               IN BOOLEAN                                      DEFAULT TRUE
                              )
    RETURN usim_multiverse.usim_id_mlv%TYPE
  IS
    l_usim_id_mlv     usim_multiverse.usim_id_mlv%TYPE;
    l_usim_id_pos     usim_position.usim_id_pos%TYPE;
    l_usim_id_nod     usim_node.usim_id_nod%TYPE;
    l_usim_id_dim     usim_dimension.usim_id_dim%TYPE;
    l_usim_id_rmd     usim_rel_mlv_dim.usim_id_rmd%TYPE;
    l_usim_id_rrpn    usim_rel_rmd_pos_nod.usim_id_rrpn%TYPE;
    l_usim_id_vol     usim_volume.usim_id_vol%TYPE;
  BEGIN
    IF usim_base.has_basedata = 1
    THEN
      l_usim_id_mlv := usim_mlv.insert_universe( p_usim_energy_start_value
                                               , p_usim_planck_time_unit
                                               , p_usim_planck_length_unit
                                               , p_usim_planck_speed_unit
                                               , p_usim_planck_stable
                                               , p_usim_base_sign
                                               , p_do_commit
                                               );
      IF usim_dim.dimension_exists(0) = 1
      THEN
        l_usim_id_dim := usim_dim.get_id_dim(0);
      ELSE
        l_usim_id_dim := usim_dim.insert_next_dimension(p_do_commit);
      END IF;
      IF usim_pos.coordinate_exists(0, 0) = 1
      THEN
        l_usim_id_pos := usim_pos.get_id_pos(0, 0);
      ELSE
        l_usim_id_pos := usim_pos.insert_next_position(0, p_do_commit);
      END IF;
      l_usim_id_nod   := usim_nod.insert_node(p_do_commit);
      l_usim_id_rmd   := usim_rmd.insert_rmd(l_usim_id_mlv, l_usim_id_dim, p_do_commit);
      l_usim_id_rrpn  := usim_rrpn.insert_rrpn(l_usim_id_rmd, l_usim_id_pos, l_usim_id_nod, p_do_commit);
      -- check volume parent condition
      IF p_usim_id_vol_parent IS NOT NULL
      THEN
        l_usim_id_vol := usim_rvm.insert_relation(p_usim_id_vol_parent, l_usim_id_mlv);
      END IF;
      RETURN l_usim_id_mlv;
    ELSE
      RETURN NULL;
    END IF;
  END create_new_universe
  ;

  FUNCTION create_next_volume( p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE
                             , p_do_commit   IN BOOLEAN                           DEFAULT TRUE
                             )
    RETURN usim_volume.usim_id_vol%TYPE
  IS
    l_usim_id_vol       usim_volume.usim_id_vol%TYPE;
    l_usim_id_dim       usim_dimension.usim_id_dim%TYPE;
    l_usim_id_rmd       usim_rel_mlv_dim.usim_id_rmd%TYPE;
    l_usim_id_pos_bfrom usim_position.usim_id_pos%TYPE;
    l_usim_id_pos_bto   usim_position.usim_id_pos%TYPE;
    l_usim_id_pos_mfrom usim_position.usim_id_pos%TYPE;
    l_usim_id_pos_mto   usim_position.usim_id_pos%TYPE;
    l_usim_id_nod       usim_node.usim_id_nod%TYPE;
    l_usim_base_sign    usim_multiverse.usim_base_sign%TYPE;
    l_usim_coord_bfrom  usim_position.usim_coordinate%TYPE;
    l_usim_coord_bto    usim_position.usim_coordinate%TYPE;
    l_usim_coord_mfrom  usim_position.usim_coordinate%TYPE;
    l_usim_coord_mto    usim_position.usim_coordinate%TYPE;
    l_usim_id_rrpn      usim_rel_rmd_pos_nod.usim_id_rrpn%TYPE;

    CURSOR cur_dimension_walk(cp_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    IS
      SELECT usim_n_dimension
           , usim_id_rmd
        FROM usim_rmd_v
       WHERE usim_id_mlv      = cp_usim_id_mlv
         AND usim_n_dimension > 0
       ORDER BY usim_n_dimension
    ;
  BEGIN
    IF      usim_mlv.has_data(p_usim_id_mlv)          = 1
       AND  usim_vol.overflow_reached(p_usim_id_mlv)  = 0
    THEN
      -- check dimension n = 1
      IF usim_rmd.dimension_exists(p_usim_id_mlv, 1) = 0
      THEN
        IF usim_dim.dimension_exists(1) = 0
        THEN
          l_usim_id_dim := usim_dim.insert_next_dimension(p_do_commit);
        ELSE
          l_usim_id_dim := usim_dim.get_id_dim(1);
        END IF;
        l_usim_id_rmd   := usim_rmd.insert_rmd(p_usim_id_mlv, l_usim_id_dim, p_do_commit);
      END IF;
      l_usim_coord_bfrom  := usim_vol.get_next_base_from(p_usim_id_mlv);
      l_usim_coord_bto    := usim_static.get_next_number(l_usim_coord_bfrom, usim_mlv.get_base_sign(p_usim_id_mlv));
      l_usim_coord_mfrom  := usim_vol.get_next_mirror_from(p_usim_id_mlv);
      l_usim_coord_mto    := usim_static.get_next_number(l_usim_coord_mfrom, usim_mlv.get_mirror_sign(p_usim_id_mlv));
      l_usim_id_pos_bfrom := usim_pos.insert_next_position(l_usim_coord_bfrom, usim_mlv.get_base_sign(p_usim_id_mlv), p_do_commit);
      l_usim_id_pos_bto   := usim_pos.insert_next_position(l_usim_coord_bto, usim_mlv.get_base_sign(p_usim_id_mlv), p_do_commit);
      l_usim_id_pos_mfrom := usim_pos.insert_next_position(l_usim_coord_mfrom, usim_mlv.get_mirror_sign(p_usim_id_mlv), p_do_commit);
      l_usim_id_pos_mto   := usim_pos.insert_next_position(l_usim_coord_mto, usim_mlv.get_mirror_sign(p_usim_id_mlv), p_do_commit);
      l_usim_id_vol       := usim_vol.insert_vol(p_usim_id_mlv, l_usim_id_pos_bfrom, l_usim_id_pos_bto, l_usim_id_pos_mfrom, l_usim_id_pos_mto, p_do_commit);
      FOR rec IN cur_dimension_walk(p_usim_id_mlv)
      LOOP
        IF usim_rrpn.has_data(rec.usim_id_rmd, l_usim_id_pos_bfrom) = 0
        THEN
          l_usim_id_nod  := usim_nod.insert_node;
          l_usim_id_rrpn := usim_rrpn.insert_rrpn(rec.usim_id_rmd, l_usim_id_pos_bfrom, l_usim_id_nod, p_do_commit);
        END IF;
        IF usim_rrpn.has_data(rec.usim_id_rmd, l_usim_id_pos_bto) = 0
        THEN
          l_usim_id_nod  := usim_nod.insert_node;
          l_usim_id_rrpn := usim_rrpn.insert_rrpn(rec.usim_id_rmd, l_usim_id_pos_bto, l_usim_id_nod, p_do_commit);
        END IF;
        IF usim_rrpn.has_data(rec.usim_id_rmd, l_usim_id_pos_mfrom) = 0
        THEN
          l_usim_id_nod  := usim_nod.insert_node;
          l_usim_id_rrpn := usim_rrpn.insert_rrpn(rec.usim_id_rmd, l_usim_id_pos_mfrom, l_usim_id_nod, p_do_commit);
        END IF;
        IF usim_rrpn.has_data(rec.usim_id_rmd, l_usim_id_pos_mto) = 0
        THEN
          l_usim_id_nod  := usim_nod.insert_node;
          l_usim_id_rrpn := usim_rrpn.insert_rrpn(rec.usim_id_rmd, l_usim_id_pos_mto, l_usim_id_nod, p_do_commit);
        END IF;
      END LOOP;
      RETURN l_usim_id_vol;
    ELSE
      RETURN NULL;
    END IF;
  END create_next_volume
  ;

  FUNCTION create_next_dimension(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
  IS
    l_next_dim        usim_dimension.usim_n_dimension%TYPE;
    l_usim_id_dim     usim_dimension.usim_id_dim%TYPE;
    l_usim_id_rmd     usim_rel_mlv_dim.usim_id_rmd%TYPE;
    l_usim_id_rrpn    usim_rel_rmd_pos_nod.usim_id_rrpn%TYPE;
    l_usim_id_nod     usim_node.usim_id_nod%TYPE;

    CURSOR cur_positions(cp_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    IS
      SELECT usim_id_pos
        FROM usim_vol_join_v
       WHERE usim_id_mlv = cp_usim_id_mlv
       GROUP BY usim_id_pos
    ;
  BEGIN
    IF usim_rmd.overflow_reached(p_usim_id_mlv)  = 0
    THEN
      l_next_dim := usim_rmd.get_max_dimension(p_usim_id_mlv) + 1;
      -- check if dimension exists
      IF usim_dim.dimension_exists(l_next_dim) = 0
      THEN
        l_usim_id_dim := usim_dim.insert_next_dimension;
      ELSE
        l_usim_id_dim := usim_dim.get_id_dim(l_next_dim);
      END IF;
      l_usim_id_rmd := usim_rmd.insert_rmd(p_usim_id_mlv, l_usim_id_dim);
      -- if volumes for the universe exist, distribute every volume to the new dimension
      FOR rec IN cur_positions(p_usim_id_mlv)
      LOOP
        l_usim_id_nod  := usim_nod.insert_node;
        l_usim_id_rrpn := usim_rrpn.insert_rrpn(l_usim_id_rmd, rec.usim_id_pos, l_usim_id_nod);
      END LOOP;
      RETURN l_usim_id_rmd;
    ELSE
      RETURN NULL;
    END IF;
  END create_next_dimension
  ;


END usim_creator;
