CREATE OR REPLACE PACKAGE usim_vol
IS
  /**A package for actions on table usim_volume.*/

  /**
  * Checks if usim_volume has already data.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data
    RETURN NUMBER
  ;

  /**
  * Checks if usim_volume has already data for a given volume id.
  * @param p_usim_id_vol The volume id.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data(p_usim_id_vol IN usim_volume.usim_id_vol%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if usim_volume has already data for the given ids.
  * @param p_usim_id_mlv The universe id for this volume.
  * @param p_usim_id_pos_base_from The position id for base from.
  * @param p_usim_id_pos_base_to The position id for base to.
  * @param p_usim_id_pos_mirror_from The position id for mirror from.
  * @param p_usim_id_pos_mirror_to The position id for mirror to.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data( p_usim_id_mlv              IN usim_multiverse.usim_id_mlv%TYPE
                   , p_usim_id_pos_base_from    IN usim_position.usim_id_pos%TYPE
                   , p_usim_id_pos_base_to      IN usim_position.usim_id_pos%TYPE
                   , p_usim_id_pos_mirror_from  IN usim_position.usim_id_pos%TYPE
                   , p_usim_id_pos_mirror_to    IN usim_position.usim_id_pos%TYPE
                   )
    RETURN NUMBER
  ;

  /**
  * Checks if usim_volume has reached overflow state (all base and mirror positions filled up to usim_base.get_abs_max_number).
  * As we expect equally distributed number pairs only base to is checked for overflow.
  * @return Returns 1 if base data / universe exist and overflow is reached, otherwise 0.
  */
  FUNCTION overflow_reached(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN NUMBER
  ;

  /**
  * Retrieves volume id for the given ids.
  * @param p_usim_id_mlv The universe id for this volume.
  * @param p_usim_id_pos_base_from The position id for base from.
  * @param p_usim_id_pos_base_to The position id for base to.
  * @param p_usim_id_pos_mirror_from The position id for mirror from.
  * @param p_usim_id_pos_mirror_to The position id for mirror to.
  * @return Returns usim_id_vol or NULL, if it does not exist.
  */
  FUNCTION get_id_vol( p_usim_id_mlv              IN usim_multiverse.usim_id_mlv%TYPE
                     , p_usim_id_pos_base_from    IN usim_position.usim_id_pos%TYPE
                     , p_usim_id_pos_base_to      IN usim_position.usim_id_pos%TYPE
                     , p_usim_id_pos_mirror_from  IN usim_position.usim_id_pos%TYPE
                     , p_usim_id_pos_mirror_to    IN usim_position.usim_id_pos%TYPE
                     )
    RETURN usim_volume.usim_id_vol%TYPE
  ;

  /**
  * Retrieves universe id for a given volume id.
  * @param p_usim_id_vol The volume id.
  * @return Returns usim_id_mlv or NULL, if volume does not exist.
  */
  FUNCTION get_id_mlv(p_usim_id_vol IN usim_volume.usim_id_vol%TYPE)
    RETURN usim_multiverse.usim_id_mlv%TYPE
  ;

  /**
  * Retrieves the next base from position, a new volumen can start with. Volumes
  * are connected by the base to side, e.g volume 0, 1 is connected to volume 1, 2.
  * If given universe exists, sign is derived from universe and value with correct
  * sign (apart 0) is retrieved.
  * @param p_usim_id_mlv The universe id for this volume.
  * @return The coordinate value for next base from volume or NULL, if universe does not exist / overflow reached. The position for the coordinate is not necessarily created yet.
  */
  FUNCTION get_next_base_from(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
  ;


  /**
  * Retrieves the next mirror from position, a new volumen can start with. Volumes
  * are connected by the mirror to side, e.g volume 0, -1 is connected to volume -1, -2.
  * If given universe exists, sign is derived from universe and value with correct
  * sign (apart 0) is retrieved.
  * @param p_usim_id_mlv The universe id for this volume.
  * @return The coordinate value for next mirror from volume or NULL, if universe does not exist / overflow reached. The position for the coordinate is not necessarily created yet.
  */
  FUNCTION get_next_mirror_from(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN usim_position.usim_coordinate%TYPE
  ;

  /**
  * Inserts a new volume for the given ids if it does not exist and all
  * constraints are fulfilled. If the volume exists only returns the id.
  * Constraints:</b>
  * FROM < TO, ABS(TO) - ABS(FROM) = 1, base/mirror sign equals universe base/mirror sign.
  * @param p_usim_id_mlv The universe id for this volume.
  * @param p_usim_id_pos_base_from The position id for base from.
  * @param p_usim_id_pos_base_to The position id for base to.
  * @param p_usim_id_pos_mirror_from The position id for mirror from.
  * @param p_usim_id_pos_mirror_to The position id for mirror to.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns new/existing usim_id_vol or NULL, if constraints are not fulfilled.
  */
  FUNCTION insert_vol( p_usim_id_mlv              IN usim_multiverse.usim_id_mlv%TYPE
                     , p_usim_id_pos_base_from    IN usim_position.usim_id_pos%TYPE
                     , p_usim_id_pos_base_to      IN usim_position.usim_id_pos%TYPE
                     , p_usim_id_pos_mirror_from  IN usim_position.usim_id_pos%TYPE
                     , p_usim_id_pos_mirror_to    IN usim_position.usim_id_pos%TYPE
                     , p_do_commit                IN BOOLEAN                            DEFAULT TRUE
                     )
    RETURN usim_volume.usim_id_vol%TYPE
  ;

END usim_vol;
/