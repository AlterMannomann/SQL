CREATE OR REPLACE PACKAGE usim_rmd
IS
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
  * Checks if usim_rel_mlv_dim has already data for a dimension axis and universe.
  * @param p_usim_id_mlv The universe id of the relation.
  * @param p_usim_id_dim The dimension id of the relation.
  * @param p_usim_sign The sign of the dimension axis.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data( p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE
                   , p_usim_id_dim IN usim_dimension.usim_id_dim%TYPE
                   , p_usim_sign   IN usim_rel_mlv_dim.usim_sign%TYPE
                   )
    RETURN NUMBER
  ;

  /**
  * Retrieves the maximum dimension for a given universe.
  * @return Returns usim_n_dimension or -1 if no dimension for this universe exist.
  */
  FUNCTION get_max_dimension(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
    RETURN usim_dimension.usim_n_dimension%TYPE
  ;

  /**
  * Checks if usim_rel_mlv_dim has reached overflow state (all dimensions filled up to usim_base.get_max_dimension).
  * @return Returns 1 if base data / relation universe/dimensions exist and overflow is reached, otherwise 0.
  */
  FUNCTION overflow_reached(p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE)
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
  * Checks if a dimension axis for a given universe exists.
  * @param p_usim_id_mlv The universe id of the relation.
  * @param p_usim_n_dimension The dimension of the relation.
  * @param p_usim_sign The sign of the dimension axis.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION dimension_exists( p_usim_id_mlv      IN usim_multiverse.usim_id_mlv%TYPE
                           , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                           , p_usim_sign        IN usim_rel_mlv_dim.usim_sign%TYPE
                           )
    RETURN NUMBER
  ;

  /**
  * Retrieve the dimension for a given universe/dimension relation.
  * @param p_usim_id_rmd The universe/dimension id.
  * @return The related dimension for the given id or NULL if id does not exist.
  */
  FUNCTION get_dimension(p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE)
    RETURN usim_dimension.usim_n_dimension%TYPE
  ;

  /**
  * Retrieve the rule for ulimate or any border of the associated dimension.
  * @param p_usim_id_rmd The universe/dimension id.
  * @return Returns 1, rule for ultimate border or 0, rule for any border if given universe exists, otherwise -1.
  */
  FUNCTION get_ultimate_border(p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE)
    RETURN usim_multiverse.usim_ultimate_border%TYPE
  ;

  /**
  * Gets the relation id for a universe and dimension id.
  * @param p_usim_id_mlv The universe id of the relation.
  * @param p_usim_id_dim The dimension id of the relation.
  * @param p_usim_sign The sign of the dimension axis.
  * @return Returns usim_id_rmd for given parameters or NULL if relation does not exists.
  */
  FUNCTION get_id_rmd( p_usim_id_mlv IN usim_multiverse.usim_id_mlv%TYPE
                     , p_usim_id_dim IN usim_dimension.usim_id_dim%TYPE
                     , p_usim_sign   IN usim_rel_mlv_dim.usim_sign%TYPE   DEFAULT 1
                     )
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
  ;

  /**
  * Gets the relation id for a universe id and a dimension.
  * @param p_usim_id_mlv The universe id of the relation.
  * @param p_usim_n_dimension The dimension of the relation.
  * @param p_usim_sign The sign of the dimension axis.
  * @return Returns usim_id_rmd for given parameters or NULL if relation does not exists.
  */
  FUNCTION get_id_rmd( p_usim_id_mlv      IN usim_multiverse.usim_id_mlv%TYPE
                     , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                     , p_usim_sign        IN usim_rel_mlv_dim.usim_sign%TYPE      DEFAULT 1
                     )
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
  ;

  /**
  * Inserts a new relation for a universe and dimension id.
  * @param p_usim_id_mlv The universe id of the relation.
  * @param p_usim_id_dim The dimension id of the relation.
  * @param p_usim_sign The sign of the dimension axis.
  * @param p_usim_n1_sign The sign (1, -1) of the ancestor dimension axis at n = 1, if n > 1 otherwise NULL.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns the new/existing usim_id_rmd or NULL if universe/dimension does not exists / overflow reached.
  */
  FUNCTION insert_rmd( p_usim_id_mlv  IN usim_multiverse.usim_id_mlv%TYPE
                     , p_usim_id_dim  IN usim_dimension.usim_id_dim%TYPE
                     , p_usim_sign    IN usim_rel_mlv_dim.usim_sign%TYPE
                     , p_usim_n1_sign IN usim_rel_mlv_dim.usim_n1_sign%TYPE
                     , p_do_commit    IN BOOLEAN                           DEFAULT TRUE
                     )
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
  ;

  /**
  * Inserts a new relation for a universe id and a dimension if it not exists.
  * @param p_usim_id_mlv The universe id of the relation.
  * @param p_usim_n_dimension The dimension of the relation.
  * @param p_usim_sign The sign of the dimension axis.
  * @param p_usim_n1_sign The sign (1, -1) of the ancestor dimension axis at n = 1, if n > 1 otherwise NULL.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns the new/existing usim_id_rmd or NULL if universe/dimension does not exists / overflow reached.
  */
  FUNCTION insert_rmd( p_usim_id_mlv      IN usim_multiverse.usim_id_mlv%TYPE
                     , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                     , p_usim_sign        IN usim_rel_mlv_dim.usim_sign%TYPE
                     , p_usim_n1_sign     IN usim_rel_mlv_dim.usim_n1_sign%TYPE
                     , p_do_commit        IN BOOLEAN                              DEFAULT TRUE
                     )
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
  ;

END usim_rmd;
/
