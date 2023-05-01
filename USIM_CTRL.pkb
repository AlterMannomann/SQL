CREATE OR REPLACE PACKAGE BODY usim_ctrl IS
  -- see header for documentation
  PROCEDURE fillPointStructure( p_usim_id_psc       IN usim_poi_structure.usim_id_psc%TYPE
                              , p_position_left     IN usim_position.usim_coordinate%TYPE
                              , p_position_right    IN usim_position.usim_coordinate%TYPE
                              , p_usim_id_parent    IN usim_poi_dim_position.usim_id_pdp%TYPE
                              , p_usim_energy       IN usim_point.usim_energy%TYPE
                              , p_usim_amplitude    IN usim_point.usim_amplitude%TYPE
                              , p_usim_wavelength   IN usim_point.usim_wavelength%TYPE
                              )
  IS
    l_cnt_result          INTEGER;
    l_start_dimension     usim_dimension.usim_dimension%TYPE;
    l_parent_dimension    usim_dimension.usim_dimension%TYPE;

    -- cursors
    CURSOR cur_dim_walk(cp_start_dim IN usim_dimension.usim_dimension%TYPE)
    IS
      SELECT usim_id_dim
           , usim_dimension
        FROM usim_dimension
       WHERE usim_dimension >= cp_start_dim
         AND usim_dimension < (SELECT MAX(usim_dimension) FROM usim_dimension)
       ORDER BY usim_dimension
    ;
    CURSOR cur_dim_parents( cp_dimension    IN usim_dimension.usim_dimension%TYPE
                          , cp_usim_id_psc  IN usim_poi_structure.usim_id_psc%TYPE
                          )
    IS
      SELECT usim_id_pdp AS parent
        FROM usim_poi_dim_position_v
       WHERE usim_dimension = cp_dimension
         AND usim_id_psc    = cp_usim_id_psc
    ;
  BEGIN
    -- basic check, the rest is delegated to insert trigger
    SELECT COUNT(*) INTO l_cnt_result FROM usim_poi_dim_position WHERE usim_id_psc = p_usim_id_psc;
    IF l_cnt_result != 0
    THEN
      RAISE_APPLICATION_ERROR( num => -20500
                             , msg => 'Given point structure id (' || p_usim_id_psc || ') is not empty.'
                             )
      ;
    END IF;

    IF p_usim_id_parent IS NULL
    THEN
      l_start_dimension := 0;
      -- create base record, position 0, dimension 0
      INSERT INTO usim_point_insert_v
          ( usim_energy
          , usim_amplitude
          , usim_wavelength
          , usim_dimension
          , usim_coordinate
          , usim_id_psc
          , usim_id_parent
          )
          VALUES
          ( p_usim_energy
          , p_usim_amplitude
          , p_usim_wavelength
          , l_start_dimension
          , 0
          , p_usim_id_psc
          , p_usim_id_parent
          )
      ;
    ELSE
      -- get parent dimension
      SELECT COUNT(*) INTO l_cnt_result FROM usim_poi_dim_position WHERE usim_id_pdp = p_usim_id_parent;
      IF l_cnt_result = 0
      THEN
        RAISE_APPLICATION_ERROR( num => -20200
                               , msg => 'Given parent point ID (' || p_usim_id_parent || ') does not exist.'
                               )
        ;
      END IF;
      SELECT usim_dimension INTO l_parent_dimension FROM usim_poi_dim_position_v WHERE usim_id_pdp = p_usim_id_parent;
      l_start_dimension := l_parent_dimension + 1;
      -- create entries in new point structures to start dimension walk as the parent is within another point structure
      INSERT INTO usim_point_insert_v
          ( usim_energy
          , usim_amplitude
          , usim_wavelength
          , usim_dimension
          , usim_coordinate
          , usim_id_psc
          , usim_id_parent
          )
          VALUES
          ( p_usim_energy
          , p_usim_amplitude
          , p_usim_wavelength
          , l_start_dimension
          , p_position_left
          , p_usim_id_psc
          , p_usim_id_parent
          )
      ;
      INSERT INTO usim_point_insert_v
          ( usim_energy
          , usim_amplitude
          , usim_wavelength
          , usim_dimension
          , usim_coordinate
          , usim_id_psc
          , usim_id_parent
          )
          VALUES
          ( p_usim_energy
          , p_usim_amplitude
          , p_usim_wavelength
          , l_start_dimension
          , p_position_right
          , p_usim_id_psc
          , p_usim_id_parent
          )
      ;
    END IF;

    FOR dim_rec IN cur_dim_walk(l_start_dimension)
    LOOP
      -- for every parent we find
      FOR par_rec IN cur_dim_parents(dim_rec.usim_dimension, p_usim_id_psc)
      LOOP
        INSERT INTO usim_point_insert_v
            ( usim_energy
            , usim_amplitude
            , usim_wavelength
            , usim_dimension
            , usim_coordinate
            , usim_id_psc
            , usim_id_parent
            )
            VALUES
            ( p_usim_energy
            , p_usim_amplitude
            , p_usim_wavelength
            , dim_rec.usim_dimension + 1
            , p_position_left
            , p_usim_id_psc
            , par_rec.parent
            )
        ;
        INSERT INTO usim_point_insert_v
            ( usim_energy
            , usim_amplitude
            , usim_wavelength
            , usim_dimension
            , usim_coordinate
            , usim_id_psc
            , usim_id_parent
            )
            VALUES
            ( p_usim_energy
            , p_usim_amplitude
            , p_usim_wavelength
            , dim_rec.usim_dimension + 1
            , p_position_right
            , p_usim_id_psc
            , par_rec.parent
            )
        ;
      END LOOP;
    END LOOP;
    COMMIT;
  EXCEPTION
    WHEN OTHERS THEN
      ROLLBACK;
      RAISE;
  END fillPointStructure
  ;
END usim_ctrl;
/