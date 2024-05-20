-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
CREATE OR REPLACE PACKAGE &USIM_SCHEMA..usim_rmd
IS
  /**A low level package for actions on table usim_rel_mlv_dim and its associated
  * views. Views can be seen as interfaces and dependency. No other package dependencies
  * apart from USIM_STATIC. ATTENTION Package may throw exceptions
  * from constraints, triggers and foreign keys. Caller is responsible to handle
  * possible exceptions.
  */

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
  * Checks if usim_rel_mlv_dim has already data for a dimension axis and universe.
  * @param p_usim_id_mlv The universe id of the relation.
  * @param p_usim_id_dim The dimension id of the relation.
  * @param p_usim_sign The sign of the dimension axis.
  * @param p_usim_n1_sign The sign (1, -1) of the ancestor dimension axis at n = 1, if n > 0 otherwise NULL.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data( p_usim_id_mlv  IN usim_multiverse.usim_id_mlv%TYPE
                   , p_usim_id_dim  IN usim_dimension.usim_id_dim%TYPE
                   , p_usim_sign    IN usim_rel_mlv_dim.usim_sign%TYPE
                   , p_usim_n1_sign IN usim_rel_mlv_dim.usim_n1_sign%TYPE
                   )
    RETURN NUMBER
  ;

  /**
  * Checks if usim_rel_mlv_dim has already data for a dimension axis and universe.
  * @param p_usim_id_mlv The universe id of the relation.
  * @param p_usim_n_dimension The dimension of the relation.
  * @param p_usim_sign The sign of the dimension axis.
  * @param p_usim_n1_sign The sign (1, -1) of the ancestor dimension axis at n = 1, if n > 0 otherwise NULL.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data( p_usim_id_mlv      IN usim_multiverse.usim_id_mlv%TYPE
                   , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                   , p_usim_sign        IN usim_rel_mlv_dim.usim_sign%TYPE
                   , p_usim_n1_sign     IN usim_rel_mlv_dim.usim_n1_sign%TYPE
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
  * Retrieve the dimension for a given universe/dimension relation.
  * @param p_usim_id_rmd The universe/dimension id.
  * @return The related dimension for the given id or NULL if id does not exist.
  */
  FUNCTION get_dimension(p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE)
    RETURN usim_dimension.usim_n_dimension%TYPE
  ;

  /**
  * Retrieve the dimension sign for a given universe/dimension relation.
  * @param p_usim_id_rmd The universe/dimension id.
  * @return The related dimension sign for the given id or NULL if id does not exist.
  */
  FUNCTION get_dim_sign(p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE)
    RETURN usim_rel_mlv_dim.usim_sign%TYPE
  ;

  /**
  * Retrieve the dimension sign of the n=1 ancestor for a given universe/dimension relation.
  * @param p_usim_id_rmd The universe/dimension id.
  * @return The related dimension sign of the n=1 ancestor for the given id or 0 if id does not exist (NULL is a valid return value).
  */
  FUNCTION get_dim_n1_sign(p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE)
    RETURN usim_rel_mlv_dim.usim_n1_sign%TYPE
  ;

  /**
  * Retrieve the universe id for a given universe/dimension relation.
  * @param p_usim_id_rmd The universe/dimension id.
  * @return The related universe id for the given id or NULL if id does not exist.
  */
  FUNCTION get_id_mlv(p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE)
    RETURN usim_multiverse.usim_id_mlv%TYPE
  ;

  /**
  * Retrieve the dimension id for a given universe/dimension relation.
  * @param p_usim_id_rmd The universe/dimension id.
  * @return The related dimension id for the given id or NULL if id does not exist.
  */
  FUNCTION get_id_dim(p_usim_id_rmd IN usim_rel_mlv_dim.usim_id_rmd%TYPE)
    RETURN usim_dimension.usim_id_dim%TYPE
  ;

  /**
  * Retrieve details a given universe/dimension relation without the universe id.
  * @param p_usim_id_rmd The universe/dimension id.
  * @param p_usim_id_dim Return the related dimension id.
  * @param p_usim_sign Return the related dimension sign.
  * @param p_usim_n1_sign Return the related n=1 dimension ancestor sign.
  * @return Return 1 if data could be fetched otherwise 0.
  */
  FUNCTION get_rmd_details( p_usim_id_rmd  IN  usim_rel_mlv_dim.usim_id_rmd%TYPE
                          , p_usim_id_dim  OUT usim_dimension.usim_id_dim%TYPE
                          , p_usim_sign    OUT usim_rel_mlv_dim.usim_sign%TYPE
                          , p_usim_n1_sign OUT usim_rel_mlv_dim.usim_n1_sign%TYPE
                          )
    RETURN NUMBER
  ;

  /**
  * Retrieve details a given universe/dimension relation without the universe id.
  * @param p_usim_id_rmd The universe/dimension id.
  * @param p_usim_n_dimension Return the related dimension.
  * @param p_usim_sign Return the related dimension sign.
  * @param p_usim_n1_sign Return the related n=1 dimension ancestor sign.
  * @return Return 1 if data could be fetched otherwise 0.
  */
  FUNCTION get_rmd_details( p_usim_id_rmd       IN  usim_rel_mlv_dim.usim_id_rmd%TYPE
                          , p_usim_n_dimension  OUT usim_dimension.usim_n_dimension%TYPE
                          , p_usim_sign         OUT usim_rel_mlv_dim.usim_sign%TYPE
                          , p_usim_n1_sign      OUT usim_rel_mlv_dim.usim_n1_sign%TYPE
                          )
    RETURN NUMBER
  ;

  /**
  * Retrieve details a given universe/dimension relation.
  * @param p_usim_id_rmd The universe/dimension id.
  * @param p_usim_id_mlv Return the related universe id.
  * @param p_usim_id_dim Return the related dimension id.
  * @param p_usim_sign Return the related dimension sign.
  * @param p_usim_n1_sign Return the related n=1 dimension ancestor sign.
  * @return The related dimension id for the given id or NULL if id does not exist.
  */
  FUNCTION get_rmd_details( p_usim_id_rmd  IN  usim_rel_mlv_dim.usim_id_rmd%TYPE
                          , p_usim_id_mlv  OUT usim_multiverse.usim_id_mlv%TYPE
                          , p_usim_id_dim  OUT usim_dimension.usim_id_dim%TYPE
                          , p_usim_sign    OUT usim_rel_mlv_dim.usim_sign%TYPE
                          , p_usim_n1_sign OUT usim_rel_mlv_dim.usim_n1_sign%TYPE
                          )
    RETURN NUMBER
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
  * @param p_usim_n1_sign The sign (1, -1) of the ancestor dimension axis at n = 1, if n > 0 otherwise NULL.
  * @return Returns usim_id_rmd for given parameters or NULL if relation does not exists.
  */
  FUNCTION get_id_rmd( p_usim_id_mlv  IN usim_multiverse.usim_id_mlv%TYPE
                     , p_usim_id_dim  IN usim_dimension.usim_id_dim%TYPE
                     , p_usim_sign    IN usim_rel_mlv_dim.usim_sign%TYPE   DEFAULT 1
                     , p_usim_n1_sign IN usim_rel_mlv_dim.usim_n1_sign%TYPE
                     )
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
  ;

  /**
  * Gets the relation id for a universe id and a dimension.
  * @param p_usim_id_mlv The universe id of the relation.
  * @param p_usim_n_dimension The dimension of the relation.
  * @param p_usim_sign The sign of the dimension axis.
  * @param p_usim_n1_sign The sign (1, -1) of the ancestor dimension axis at n = 1, if n > 0 otherwise NULL.
  * @return Returns usim_id_rmd for given parameters or NULL if relation does not exists.
  */
  FUNCTION get_id_rmd( p_usim_id_mlv      IN usim_multiverse.usim_id_mlv%TYPE
                     , p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                     , p_usim_sign        IN usim_rel_mlv_dim.usim_sign%TYPE      DEFAULT 1
                     , p_usim_n1_sign     IN usim_rel_mlv_dim.usim_n1_sign%TYPE
                     )
    RETURN usim_rel_mlv_dim.usim_id_rmd%TYPE
  ;

  /**
  * Inserts a new relation for a universe and dimension id describing one side of the dimension axis if n > 0.
  * @param p_usim_id_mlv The universe id of the relation.
  * @param p_usim_id_dim The dimension id of the relation.
  * @param p_usim_sign The sign of the dimension axis.
  * @param p_usim_n1_sign The sign (1, -1) of the ancestor dimension axis at n = 1, if n > 0 otherwise NULL.
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
  * Inserts a new relation for a universe id and a dimension describing one side of the dimension axis if n > 0.
  * @param p_usim_id_mlv The universe id of the relation.
  * @param p_usim_n_dimension The dimension of the relation.
  * @param p_usim_sign The sign of the dimension axis.
  * @param p_usim_n1_sign The sign (1, -1) of the ancestor dimension axis at n = 1, if n > 0 otherwise NULL.
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
