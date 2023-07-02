CREATE OR REPLACE PACKAGE usim_dim IS
  /**A package for actions on table usim_dimension.*/

  /**
  * Checks if usim_dimension has already data.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data
    RETURN NUMBER
  ;

  /**
  * Checks if usim_dimension has already data for a given dimension.
  * @param p_usim_id_mlv The id of the universe of the dimension.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data(p_usim_id_mlv IN usim_dimension.usim_id_mlv%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if usim_dimension has reached overflow state for a given universe.
  * @return Returns 1 if base data exist and overflow is reached, otherwise 0.
  */
  FUNCTION overflow_reached(p_usim_id_mlv IN usim_dimension.usim_id_mlv%TYPE)
    RETURN NUMBER
  ;

  /**
  * Gets the maximum dimension for a given universe.
  * @param p_usim_id_mlv The id of the universe to get the maximum current dimension.
  * @return Returns max usim_n_dimension for given universe or -1 if the given universe has no dimensions.
  */
  FUNCTION get_max_dimension(p_usim_id_mlv IN usim_dimension.usim_id_mlv%TYPE)
    RETURN usim_dimension.usim_n_dimension%TYPE
  ;

  /**
  * Checks if given dimension id exists.
  * @param p_usim_id_dim The id of the dimension.
  * @return Returns 1 if id exists, otherwise 0.
  */
  FUNCTION dimension_exists(p_usim_id_dim IN usim_dimension.usim_id_dim%TYPE)
    RETURN NUMBER
  ;

  /**
  * Gets the dimension for a given dimension id.
  * @param p_usim_id_dim The id of the dimension.
  * @return Returns usim_n_dimension for given dimension id or -1 if dimension id does not exist.
  */
  FUNCTION get_dimension(p_usim_id_dim IN usim_dimension.usim_id_dim%TYPE)
    RETURN usim_dimension.usim_n_dimension%TYPE
  ;

  /**
  * Inserts a new dimension (max +1) for a given universe until the maximum allowed dimension is reached.
  * Won't do anything, if maximum allowed dimension is exceeded or universe does not exist.
  * @param p_usim_id_mlv The id of the universe to get the maximum current dimension.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns the new dimension id or NULL.
  */
  FUNCTION insert_next_dimension( p_usim_id_mlv IN usim_dimension.usim_id_mlv%TYPE
                                , p_do_commit   IN BOOLEAN                          DEFAULT TRUE
                                )
    RETURN usim_dimension.usim_id_dim%TYPE
  ;

END;
/
