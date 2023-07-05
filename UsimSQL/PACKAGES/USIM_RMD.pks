CREATE OR REPLACE PACKAGE usim_rmd IS
  /**A package for actions on table usim_rel_mlv_dim.*/

  /**
  * Checks if usim_rel_mlv_dim has already data.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data
    RETURN NUMBER
  ;

  /**
  * Checks if usim_rel_mlv_dim has already data for a given relation id.
  * @param p_usim_id_rmd The relation id of universe/dimension.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data(p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if usim_rel_mlv_dim has already data for dimension and universe.
  * @param p_usim_id_mlv The universe id of the relation.
  * @param p_usim_id_dim The dimension id of the relation.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data( p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE
                   , p_usim_id_dim IN usim_dimension.usim_id_dim%TYPE
                   )
    RETURN NUMBER
  ;

  /**
  * Checks if a dimension for a given universe exists.
  * @param p_usim_id_mlv The universe id of the relation.
  * @param p_usim_n_dimension The dimension of the relation.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION dimension_exists( p_usim_id_mlv      IN usim_multiverse.usim_id_mlv%TYPE
                           , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                           )
    RETURN NUMBER
  ;

  /**
  * Gets the relation id for a universe and dimension id.
  * @param p_usim_id_mlv The universe id of the relation.
  * @param p_usim_id_dim The dimension id of the relation.
  * @return Returns usim_id_rmd for given parameters or NULL if relation does not exists.
  */
  FUNCTION get_id_rmd( p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE
                     , p_usim_id_dim IN usim_dimension.usim_id_dim%TYPE
                     )
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
  ;

  /**
  * Gets the relation id for a universe id and a dimension.
  * @param p_usim_id_mlv The universe id of the relation.
  * @param p_usim_n_dimension The dimension of the relation.
  * @return Returns usim_id_rmd for given parameters or NULL if relation does not exists.
  */
  FUNCTION get_id_rmd( p_usim_id_mlv      IN usim_multiverse.usim_id_mlv%TYPE
                     , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                     )
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
  ;

  /**
  * Inserts a new relation for a universe and dimension id.
  * @param p_usim_id_mlv The universe id of the relation.
  * @param p_usim_id_dim The dimension id of the relation.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns the new/existing usim_id_rmd or NULL if universe/dimension does not exists.
  */
  FUNCTION insert_rmd( p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE
                     , p_usim_id_dim IN usim_dimension.usim_id_dim%TYPE
                     , p_do_commit   IN BOOLEAN                           DEFAULT TRUE
                     )
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
  ;

  /**
  * Inserts a new relation for a universe id and a dimension.
  * @param p_usim_id_mlv The universe id of the relation.
  * @param p_usim_n_dimension The dimension of the relation.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns the new/existing usim_id_rmd or NULL if universe/dimension does not exists.
  */
  FUNCTION insert_rmd( p_usim_id_mlv      IN usim_multiverse.usim_id_mlv%TYPE
                     , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                     , p_do_commit        IN BOOLEAN                              DEFAULT TRUE
                     )
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
  ;

END usim_rmd;
/
