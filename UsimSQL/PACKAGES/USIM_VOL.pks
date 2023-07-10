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


END usim_vol;