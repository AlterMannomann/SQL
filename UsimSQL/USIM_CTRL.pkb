CREATE OR REPLACE PACKAGE BODY usim_ctrl IS
  -- see header for documentation
  PROCEDURE fillPointStructure( p_usim_id_psc       IN usim_poi_structure.usim_id_psc%TYPE
                              , p_position_left     IN usim_position.usim_coordinate%TYPE
                              , p_position_right    IN usim_position.usim_coordinate%TYPE
                              , p_usim_id_parent    IN usim_poi_dim_position.usim_id_pdp%TYPE
                              )
  IS
    PRAGMA AUTONOMOUS_TRANSACTION;
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
          ( usim_dimension
          , usim_coordinate
          , usim_id_psc
          , usim_id_parent
          )
          VALUES
          ( l_start_dimension
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
          ( usim_dimension
          , usim_coordinate
          , usim_id_psc
          , usim_id_parent
          )
          VALUES
          ( l_start_dimension
          , p_position_left
          , p_usim_id_psc
          , p_usim_id_parent
          )
      ;
      INSERT INTO usim_point_insert_v
          ( usim_dimension
          , usim_coordinate
          , usim_id_psc
          , usim_id_parent
          )
          VALUES
          ( l_start_dimension
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
            ( usim_dimension
            , usim_coordinate
            , usim_id_psc
            , usim_id_parent
            )
            VALUES
            ( dim_rec.usim_dimension + 1
            , p_position_left
            , p_usim_id_psc
            , par_rec.parent
            )
        ;
        INSERT INTO usim_point_insert_v
            ( usim_dimension
            , usim_coordinate
            , usim_id_psc
            , usim_id_parent
            )
            VALUES
            ( dim_rec.usim_dimension + 1
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
  -- see header for documentation
  PROCEDURE processOutput(p_usim_id_outp IN usim_output.usim_id_outp%TYPE)
  IS
    l_usim_energy           NUMBER;
    l_usim_amplitude        NUMBER;
    l_usim_wavelength       NUMBER;
    l_usim_plancktime       INTEGER;

    -- cursors
    CURSOR cur_output(cp_usim_id_outp IN usim_output.usim_id_outp%TYPE)
    IS
      SELECT usim_id_source
           , usim_id_target
           , usim_energy
           , usim_amplitude
           , usim_wavelength
           , usim_energy_target
           , usim_energy_source
           , usim_amplitude_target
           , usim_amplitude_source
           , usim_wavelength_target
           , usim_wavelength_source
           , usim_energy_force
           , usim_distance
           , usim_direction
           , usim_id_parent_source
           , usim_id_poi_parent_target
           , usim_id_pdp_target
           , usim_id_pdp_source
        FROM usim_output_v
       WHERE usim_id_outp    = cp_usim_id_outp
             -- only records not processed
         AND usim_processed  = 0
    ;
    CURSOR cur_get_childs(cp_usim_id_parent IN usim_poi_dim_position.usim_id_pdp%TYPE)
    IS
      SELECT pdc.usim_id_pdc
           , pdc.usim_id_pdp
           , pdpv.usim_id_poi
        FROM usim_pdp_childs pdc
        LEFT OUTER JOIN usim_poi_dim_position_v pdpv
          ON pdc.usim_id_child = pdpv.usim_id_pdp
       WHERE pdc.usim_id_pdp = cp_usim_id_parent
       ORDER BY usim_id_psc
              , usim_id_child

    ;
  BEGIN
    -- we expect only one record as result set, using a for loop simply
    -- inits the record correct and does nothing if result set is empty
    -- without need for exception handling.
    l_usim_plancktime := usim_planck_time_seq.CURRVAL;
    FOR rec IN cur_output(p_usim_id_outp)
    LOOP
      -- react on input
      -- if overflow, do not change values
      IF    ABS(NVL(rec.usim_energy_target, 0) + rec.usim_energy_force)    = binary_double_infinity
         OR ABS(NVL(rec.usim_amplitude_target, 0) + rec.usim_amplitude)    = binary_double_infinity
         OR ABS(NVL(rec.usim_wavelength_target, 0) + rec.usim_wavelength)  = binary_double_infinity
      THEN
        l_usim_energy       := NVL(rec.usim_energy_target, 0);
        l_usim_amplitude    := NVL(rec.usim_amplitude_target, 0);
        l_usim_wavelength   := NVL(rec.usim_wavelength_target, 0);
        addOverflow(rec.usim_id_pdp_target, rec.usim_energy_force, rec.usim_amplitude, rec.usim_wavelength);
      ELSE
        -- variables will hold values that are distributed to child/parent depending on direction
        -- energy as mass, points won't move, only accumulate force, no G used, evenly distributed
        l_usim_energy       := NVL(rec.usim_energy_target, 0) + rec.usim_energy_force;
        -- amplitude and wavelength not handled yet, just add
        l_usim_amplitude    := (NVL(rec.usim_amplitude_target, 0) + rec.usim_amplitude);
        l_usim_wavelength   := (NVL(rec.usim_wavelength_target, 0) + rec.usim_wavelength);
      END IF;
      addPointHistory( rec.usim_id_target
                     , rec.usim_id_source
                     , l_usim_energy
                     , rec.usim_energy_source
                     , l_usim_amplitude
                     , rec.usim_amplitude_source
                     , l_usim_wavelength
                     , rec.usim_wavelength_source
                     , rec.usim_energy_force
                     , rec.usim_distance
                     , l_usim_plancktime
                     , rec.usim_direction
                     , rec.usim_id_pdp_target
                     , rec.usim_id_pdp_source
                     )
      ;
      -- update target
      UPDATE usim_point
         SET usim_energy      = l_usim_energy
           , usim_amplitude   = l_usim_amplitude
           , usim_wavelength  = l_usim_wavelength
       WHERE usim_id_poi = rec.usim_id_target
      ;
      -- direction depending actions
      IF rec.usim_direction >= 0
      THEN
        -- process childs
        FOR childrec IN cur_get_childs(rec.usim_id_pdp_target)
        LOOP
          INSERT INTO usim_output
            ( usim_id_source
            , usim_id_target
            , usim_plancktime
            , usim_direction
            , usim_energy
            , usim_amplitude
            , usim_wavelength
            )
            VALUES
            ( rec.usim_id_target
            , childrec.usim_id_poi
            , l_usim_plancktime
            , rec.usim_direction
            , l_usim_energy
            , l_usim_amplitude
            , l_usim_wavelength
            )
          ;
        END LOOP;
      ELSE
        -- process parents, if parent is not NULL
        IF     rec.usim_id_parent_source      IS NOT NULL
           AND rec.usim_id_poi_parent_target  IS NOT NULL
        THEN
          INSERT INTO usim_output
            ( usim_id_source
            , usim_id_target
            , usim_plancktime
            , usim_direction
            , usim_energy
            , usim_amplitude
            , usim_wavelength
            )
            SELECT rec.usim_id_target
                 , rec.usim_id_poi_parent_target
                 , l_usim_plancktime
                 , rec.usim_direction
                 , l_usim_energy
                 , l_usim_amplitude
                 , l_usim_wavelength
              FROM dual
                   -- make sure that a parent is only updated once by same child
             WHERE NOT EXISTS (SELECT 1
                                 FROM usim_output
                                WHERE usim_id_source  = rec.usim_id_target
                                  AND usim_id_target  = rec.usim_id_poi_parent_target
                                  AND usim_direction  = rec.usim_direction
                                  AND usim_plancktime = l_usim_plancktime
                              )
          ;
        END IF;
      END IF;
    END LOOP;
    -- update output
    UPDATE usim_output
       SET usim_processed = 1
     WHERE usim_id_outp = p_usim_id_outp
    ;
    COMMIT;
  END processOutput
  ;
  -- see header for documention
  PROCEDURE runOneDirection( p_usim_direction   IN usim_output.usim_direction%TYPE  DEFAULT 0
                           , p_usim_energy      IN usim_point.usim_energy%TYPE      DEFAULT NULL
                           , p_usim_amplitude   IN usim_point.usim_amplitude%TYPE   DEFAULT NULL
                           , p_usim_wavelength  IN usim_point.usim_wavelength%TYPE  DEFAULT NULL
                           )
  IS
    l_cnt_not_processed     NUMBER;
    l_chk_null_attributes   BOOLEAN;
    l_cnt_null_attributes   NUMBER;
    l_usim_direction        INTEGER;
    -- cursors
    CURSOR cur_cnt_not_processed(cp_usim_direction IN usim_output.usim_direction%TYPE)
    IS
      SELECT COUNT(*)
        FROM usim_output
       WHERE usim_processed = 0
         AND usim_direction = cp_usim_direction
    ;
    CURSOR cur_not_processed(cp_usim_direction IN usim_output.usim_direction%TYPE)
    IS
      SELECT usim_id_outp
             -- order is important, especially for reverse processing, wrong order, wrong result
        FROM usim_output_order_v
       WHERE usim_processed = 0
         AND usim_direction = cp_usim_direction
    ;
    CURSOR cur_chk_base_parent_null
    IS
      SELECT COUNT(*)
        FROM usim_poi_dim_position_v
       WHERE usim_id_parent IS NULL
         AND usim_dimension  = 0
         AND (   usim_energy      IS NULL
              OR usim_amplitude   IS NULL
              OR usim_wavelength  IS NULL
             )
    ;
    CURSOR cur_base_parent
    IS
      SELECT pdpv.usim_id_poi
           , pdpv.usim_energy
           , pdpv.usim_amplitude
           , pdpv.usim_wavelength
           , pdpv.usim_dimension
           , pdpv.usim_id_pdp
           , pdpvcl.usim_id_poi   AS usim_id_poi_child_left
           , pdpvcr.usim_id_poi   AS usim_id_poi_child_right
        FROM usim_poi_dim_position_v pdpv
        LEFT OUTER JOIN usim_poi_dim_position_v pdpvcl
          ON pdpv.usim_id_child_left = pdpvcl.usim_id_pdp
        LEFT OUTER JOIN usim_poi_dim_position_v pdpvcr
          ON pdpv.usim_id_child_right = pdpvcr.usim_id_pdp
       WHERE pdpv.usim_id_parent IS NULL
         AND pdpv.usim_dimension  = 0
    ;
    CURSOR cur_chk_base_childs_null
    IS
      SELECT COUNT(*)
        FROM usim_poi_dim_position_v
       WHERE usim_id_parent IS NOT NULL
         AND usim_dimension  = (SELECT MAX(usim_dimension) FROM usim_dimension)
         AND (   usim_energy      IS NULL
              OR usim_amplitude   IS NULL
              OR usim_wavelength  IS NULL
             )
    ;
    CURSOR cur_base_childs
    IS
      SELECT pdpv.usim_id_poi
           , pdpv.usim_energy
           , pdpv.usim_amplitude
           , pdpv.usim_wavelength
           , pdpv.usim_dimension
           , pdpv.usim_id_pdp
           , pdpvp.usim_id_poi            AS usim_id_poi_parent
        FROM usim_poi_dim_position_v pdpv
        LEFT OUTER JOIN usim_poi_dim_position_v pdpvp
          ON pdpv.usim_id_parent = pdpvp.usim_id_pdp
       WHERE pdpv.usim_dimension = (SELECT MAX(usim_dimension) FROM usim_dimension)
    ;

  BEGIN
    -- check if any parameter is NULL
    l_chk_null_attributes := (p_usim_energy IS NULL OR p_usim_amplitude IS NULL OR p_usim_wavelength IS NULL);
    -- guarantee correct direction
    l_usim_direction      := CASE WHEN p_usim_direction = 0 THEN p_usim_direction ELSE -1 END;
    OPEN cur_cnt_not_processed(p_usim_direction);
    FETCH cur_cnt_not_processed INTO l_cnt_not_processed;
    CLOSE cur_cnt_not_processed;

    IF l_cnt_not_processed = 0
    THEN
      IF l_usim_direction = 0
      THEN
        -- create base entries for child direction, check NULLs first
        OPEN cur_chk_base_parent_null;
        FETCH cur_chk_base_parent_null INTO l_cnt_null_attributes;
        CLOSE cur_chk_base_parent_null;
        IF     l_chk_null_attributes
           AND l_cnt_null_attributes > 0
        THEN
          RAISE_APPLICATION_ERROR( num => -20700
                                 , msg => 'NULL Attributes not allowed if some base attributes for direction are NULL and nothing to process.'
                                 )
          ;
        END IF;
        -- we expect one record, just for comfort
        FOR rec IN cur_base_parent
        LOOP
          IF l_cnt_null_attributes > 0
          THEN
            -- we should set the attributes on universe seed with given values, target = source
            INSERT INTO usim_output
              ( usim_id_source
              , usim_id_target
              , usim_plancktime
              , usim_direction
              , usim_energy
              , usim_amplitude
              , usim_wavelength
              )
              VALUES
              ( rec.usim_id_poi
              , rec.usim_id_poi
              , usim_planck_time_seq.CURRVAL
              , l_usim_direction
              , p_usim_energy
              , p_usim_amplitude
              , p_usim_wavelength
              )
            ;
          ELSE
            -- use current values from point for childs
            INSERT INTO usim_output
              ( usim_id_source
              , usim_id_target
              , usim_plancktime
              , usim_direction
              , usim_energy
              , usim_amplitude
              , usim_wavelength
              )
              VALUES
              ( rec.usim_id_poi
              , rec.usim_id_poi
              , usim_planck_time_seq.CURRVAL
              , l_usim_direction
              , rec.usim_energy
              , rec.usim_amplitude
              , rec.usim_wavelength
              )
            ;
          END IF;
        END LOOP;
      ELSE
        -- create base entries for parent direction, check NULLs first
        -- any value != 0 is interpreted as direction parent
        OPEN cur_chk_base_childs_null;
        FETCH cur_chk_base_childs_null INTO l_cnt_null_attributes;
        CLOSE cur_chk_base_childs_null;
        IF     l_chk_null_attributes
           AND l_cnt_null_attributes > 0
        THEN
          RAISE_APPLICATION_ERROR( num => -20700
                                 , msg => 'NULL Attributes not allowed if some base attributes for direction are NULL and nothing to process.'
                                 )
          ;
        END IF;
        -- here we expect more than one record
        FOR rec IN cur_base_childs
        LOOP
          IF l_cnt_null_attributes > 0
          THEN
            -- we should set values (not expected to happen currently), target = source
            INSERT INTO usim_output
              ( usim_id_source
              , usim_id_target
              , usim_plancktime
              , usim_direction
              , usim_energy
              , usim_amplitude
              , usim_wavelength
              )
              VALUES
              ( rec.usim_id_poi
              , rec.usim_id_poi
              , usim_planck_time_seq.CURRVAL
              , l_usim_direction
              , p_usim_energy
              , p_usim_amplitude
              , p_usim_wavelength
              )
            ;
          ELSE
            IF rec.usim_id_poi_parent IS NOT NULL
            THEN
              -- use current values from point for parent, if parent is not null
              INSERT INTO usim_output
                ( usim_id_source
                , usim_id_target
                , usim_plancktime
                , usim_direction
                , usim_energy
                , usim_amplitude
                , usim_wavelength
                )
                VALUES
                ( rec.usim_id_poi
                , rec.usim_id_poi_parent
                , usim_planck_time_seq.CURRVAL
                , l_usim_direction
                , rec.usim_energy
                , rec.usim_amplitude
                , rec.usim_wavelength
                )
              ;
            END IF;
          END IF;
        END LOOP;
      END IF;
      -- commit so far
      COMMIT;
    END IF;
    -- now start processing
    WHILE l_cnt_not_processed > 0
    LOOP
      FOR rec IN cur_not_processed(p_usim_direction)
      LOOP
        -- new records created will not be seen in this loop
        -- as they are processed as autonomous transaction
        usim_ctrl.processoutput(rec.usim_id_outp);
      END LOOP;
      -- check, if new entries have been created by the last run
      OPEN cur_cnt_not_processed(p_usim_direction);
      FETCH cur_cnt_not_processed INTO l_cnt_not_processed;
      CLOSE cur_cnt_not_processed;
    END LOOP;
  END runOneDirection
  ;
  -- see header for documentation
  PROCEDURE runPlanckCycle( p_usim_energy      IN usim_point.usim_energy%TYPE      DEFAULT NULL
                          , p_usim_amplitude   IN usim_point.usim_amplitude%TYPE   DEFAULT NULL
                          , p_usim_wavelength  IN usim_point.usim_wavelength%TYPE  DEFAULT NULL
                          )
  IS
    l_usim_plancktime NUMBER;
  BEGIN
    -- initialize parent to childs
    runOneDirection(0, p_usim_energy, p_usim_amplitude, p_usim_wavelength);
    -- process dependend nodes
    runOneDirection(0);
    -- now initialize the child nodes at end of tree to travel in direction parents
    runOneDirection(-1);
    -- process dependend nodes
    runOneDirection(-1);
    -- set the new planck time by calling the sequence
    SELECT usim_planck_time_seq.NEXTVAL INTO l_usim_plancktime FROM dual;
  END runPlanckCycle
  ;

  PROCEDURE addPointHistory( p_usim_id_poi              IN usim_poi_history.usim_id_poi%TYPE
                           , p_usim_id_poi_source       IN usim_poi_history.usim_id_poi_source%TYPE
                           , p_usim_energy              IN usim_poi_history.usim_energy%TYPE
                           , p_usim_energy_source       IN usim_poi_history.usim_energy_source%TYPE
                           , p_usim_amplitude           IN usim_poi_history.usim_amplitude%TYPE
                           , p_usim_amplitude_source    IN usim_poi_history.usim_amplitude_source%TYPE
                           , p_usim_wavelength          IN usim_poi_history.usim_wavelength%TYPE
                           , p_usim_wavelength_source   IN usim_poi_history.usim_wavelength_source%TYPE
                           , p_usim_energy_force        IN usim_poi_history.usim_energy_force%TYPE
                           , p_usim_distance            IN usim_poi_history.usim_distance%TYPE
                           , p_usim_planck_time         IN usim_poi_history.usim_planck_time%TYPE
                           , p_usim_update_direction    IN usim_poi_history.usim_update_direction%TYPE
                           , p_usim_id_pdp              IN usim_poi_history.usim_id_pdp%TYPE
                           , p_usim_id_pdp_source       IN usim_poi_history.usim_id_pdp_source%TYPE
                           )
  IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    INSERT INTO usim_poi_history
      ( usim_id_poi
      , usim_id_poi_source
      , usim_energy
      , usim_energy_source
      , usim_amplitude
      , usim_amplitude_source
      , usim_wavelength
      , usim_wavelength_source
      , usim_energy_force
      , usim_distance
      , usim_planck_time
      , usim_update_direction
      , usim_id_pdp
      , usim_id_pdp_source
      )
      VALUES
      ( p_usim_id_poi
      , p_usim_id_poi_source
      , p_usim_energy
      , p_usim_energy_source
      , p_usim_amplitude
      , p_usim_amplitude_source
      , p_usim_wavelength
      , p_usim_wavelength_source
      , p_usim_energy_force
      , p_usim_distance
      , p_usim_planck_time
      , p_usim_update_direction
      , p_usim_id_pdp
      , p_usim_id_pdp_source
      )
    ;
    COMMIT;
  END addPointHistory
  ;

  PROCEDURE addOverflow( p_usim_id_pdp      IN usim_overflow.usim_id_pdp%TYPE
                       , p_usim_energy      IN usim_overflow.usim_energy%TYPE
                       , p_usim_amplitude   IN usim_overflow.usim_amplitude%TYPE
                       , p_usim_wavelength  IN usim_overflow.usim_wavelength%TYPE
                       )
  IS
    PRAGMA AUTONOMOUS_TRANSACTION;
  BEGIN
    INSERT INTO usim_overflow
      ( usim_id_pdp
      , usim_energy
      , usim_amplitude
      , usim_wavelength
      )
      VALUES
      ( p_usim_id_pdp
      , p_usim_energy
      , p_usim_amplitude
      , p_usim_wavelength
      )
    ;
    COMMIT;
  END addOverflow
  ;

END usim_ctrl;
/