-- point
INSERT INTO usim_point_insert_v
    ( usim_energy
    , usim_amplitude
    , usim_wavelength
    , usim_dimension
    , usim_coordinate
    )
    VALUES
    ( 0
    , 0
    , 0
    , 0
    , 0
    )
;
CLEAR COLUMNS
COLUMN PDP_ID NEW_VAL PDP_ID
SELECT MAX(usim_id_pdp) AS PDP_ID
  FROM usim_poi_dim_position
;
INSERT INTO usim_point_insert_v
    ( usim_energy
    , usim_amplitude
    , usim_wavelength
    , usim_dimension
    , usim_coordinate
    , usim_id_parent
    )
    VALUES
    ( 0
    , 0
    , 0
    , 1
    , 1
    , &PDP_ID
    )
;
COLUMN PDP_CHILD1 NEW_VAL PDP_CHILD1
SELECT MAX(usim_id_pdp) AS PDP_CHILD1
  FROM usim_poi_dim_position
;
INSERT INTO usim_point_insert_v
    ( usim_energy
    , usim_amplitude
    , usim_wavelength
    , usim_dimension
    , usim_coordinate
    , usim_id_parent
    )
    VALUES
    ( 0
    , 0
    , 0
    , 1
    , -1
    , &PDP_ID
    )
;
COLUMN PDP_CHILD2 NEW_VAL PDP_CHILD2
SELECT MAX(usim_id_pdp) AS PDP_CHILD2
  FROM usim_poi_dim_position
;
INSERT INTO usim_point_insert_v
    ( usim_energy
    , usim_amplitude
    , usim_wavelength
    , usim_dimension
    , usim_coordinate
    , usim_id_parent
    )
    VALUES
    ( 0
    , 0
    , 0
    , 2
    , 1
    , &PDP_CHILD1
    )
;
COLUMN PDP_CHILD11 NEW_VAL PDP_CHILD11
SELECT MAX(usim_id_pdp) AS PDP_CHILD11
  FROM usim_poi_dim_position
;
INSERT INTO usim_point_insert_v
    ( usim_energy
    , usim_amplitude
    , usim_wavelength
    , usim_dimension
    , usim_coordinate
    , usim_id_parent
    )
    VALUES
    ( 0
    , 0
    , 0
    , 2
    , -1
    , &PDP_CHILD1
    )
;
COLUMN PDP_CHILD12 NEW_VAL PDP_CHILD12
SELECT MAX(usim_id_pdp) AS PDP_CHILD12
  FROM usim_poi_dim_position
;
INSERT INTO usim_point_insert_v
    ( usim_energy
    , usim_amplitude
    , usim_wavelength
    , usim_dimension
    , usim_coordinate
    , usim_id_parent
    )
    VALUES
    ( 0
    , 0
    , 0
    , 2
    , 1
    , &PDP_CHILD2
    )
;
COLUMN PDP_CHILD21 NEW_VAL PDP_CHILD21
SELECT MAX(usim_id_pdp) AS PDP_CHILD21
  FROM usim_poi_dim_position
;
INSERT INTO usim_point_insert_v
    ( usim_energy
    , usim_amplitude
    , usim_wavelength
    , usim_dimension
    , usim_coordinate
    , usim_id_parent
    )
    VALUES
    ( 0
    , 0
    , 0
    , 2
    , -1
    , &PDP_CHILD2
    )
;
COLUMN PDP_CHILD22 NEW_VAL PDP_CHILD22
SELECT MAX(usim_id_pdp) AS PDP_CHILD22
  FROM usim_poi_dim_position
;
INSERT INTO usim_point_insert_v
    ( usim_energy
    , usim_amplitude
    , usim_wavelength
    , usim_dimension
    , usim_coordinate
    , usim_id_parent
    )
    VALUES
    ( 0
    , 0
    , 0
    , 3
    , 1
    , &PDP_CHILD11
    )
;
INSERT INTO usim_point_insert_v
    ( usim_energy
    , usim_amplitude
    , usim_wavelength
    , usim_dimension
    , usim_coordinate
    , usim_id_parent
    )
    VALUES
    ( 0
    , 0
    , 0
    , 3
    , -1
    , &PDP_CHILD11
    )
;
INSERT INTO usim_point_insert_v
    ( usim_energy
    , usim_amplitude
    , usim_wavelength
    , usim_dimension
    , usim_coordinate
    , usim_id_parent
    )
    VALUES
    ( 0
    , 0
    , 0
    , 3
    , 1
    , &PDP_CHILD12
    )
;
INSERT INTO usim_point_insert_v
    ( usim_energy
    , usim_amplitude
    , usim_wavelength
    , usim_dimension
    , usim_coordinate
    , usim_id_parent
    )
    VALUES
    ( 0
    , 0
    , 0
    , 3
    , -1
    , &PDP_CHILD12
    )
;

INSERT INTO usim_point_insert_v
    ( usim_energy
    , usim_amplitude
    , usim_wavelength
    , usim_dimension
    , usim_coordinate
    , usim_id_parent
    )
    VALUES
    ( 0
    , 0
    , 0
    , 3
    , 1
    , &PDP_CHILD21
    )
;
INSERT INTO usim_point_insert_v
    ( usim_energy
    , usim_amplitude
    , usim_wavelength
    , usim_dimension
    , usim_coordinate
    , usim_id_parent
    )
    VALUES
    ( 0
    , 0
    , 0
    , 3
    , -1
    , &PDP_CHILD21
    )
;
INSERT INTO usim_point_insert_v
    ( usim_energy
    , usim_amplitude
    , usim_wavelength
    , usim_dimension
    , usim_coordinate
    , usim_id_parent
    )
    VALUES
    ( 0
    , 0
    , 0
    , 3
    , 1
    , &PDP_CHILD22
    )
;
INSERT INTO usim_point_insert_v
    ( usim_energy
    , usim_amplitude
    , usim_wavelength
    , usim_dimension
    , usim_coordinate
    , usim_id_parent
    )
    VALUES
    ( 0
    , 0
    , 0
    , 3
    , -1
    , &PDP_CHILD22
    )
;
COMMIT;