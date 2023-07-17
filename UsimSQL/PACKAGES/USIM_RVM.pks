CREATE OR REPLACE PACKAGE usim_rvm
IS
  /**A package for actions on table usim_rel_vol_mlv.*/

  /**
  * Checks if usim_rel_vol_mlv has already data.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data
    RETURN NUMBER
  ;

  /**
  * Checks if usim_rel_vol_mlv has data for the given volume id.
  * @param p_usim_id_vol The volume id to check data for.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data(p_usim_id_vol IN usim_volume.usim_id_vol%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if usim_rel_vol_mlv has data for the given universe id.
  * @param p_usim_id_mlv The universe id to check data for.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data_mlv(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN NUMBER
  ;

  /**
  * Inserts a parent-child relation between volume and universe, if base data, volume and universe exist
  * and volume related universe has reached overflow state for volume and universe/dimension relation.
  * @param p_usim_id_vol The volume id to insert. Not allowed if volume has already a relation.
  * @param p_usim_id_mlv The universe id to insert. Not allowed if universe is a base universe or already has a relation.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns inserted usim_id_vol or NULL if constraints are not fulfilled.
  */
  FUNCTION insert_relation( p_usim_id_vol IN usim_volume.usim_id_vol%TYPE
                          , p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE
                          , p_do_commit   IN BOOLEAN                          DEFAULT TRUE
                          )
    RETURN usim_volume.usim_id_vol%TYPE
  ;
END usim_rvm;
/