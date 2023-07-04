CREATE OR REPLACE PACKAGE usim_dim
IS
  /**A package for actions on table usim_dimension.*/

  /**
  * Checks if usim_dimension has already data.
  * @return Returns 1 if dimensions are available, otherwise 0.
  */
  FUNCTION has_data
    RETURN NUMBER
  ;

  /**
  * Checks if given dimension id exists.
  * @param p_usim_id_dim The id of the dimension.
  * @return Returns 1 if id exists, otherwise 0.
  */
  FUNCTION has_data(p_usim_id_dim IN usim_dimension.usim_id_dim%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if usim_dimension has reached overflow state (all dimensions filled up to usim_base.get_max_dimension).
  * @return Returns 1 if base data / dimensions exist and overflow is reached, otherwise 0.
  */
  FUNCTION overflow_reached
    RETURN NUMBER
  ;

  /**
  * Gets the maximum dimension available.
  * @return Returns max usim_n_dimension or -1 if no dimension exists.
  */
  FUNCTION get_max_dimension
    RETURN usim_dimension.usim_n_dimension%TYPE
  ;

  /**
  * Checks if given dimension exists.
  * @param p_usim_n_dimension The dimension to verify.
  * @return Returns 1 if id exists, otherwise 0.
  */
  FUNCTION dimension_exists(p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE)
    RETURN NUMBER
  ;

  /**
  * Gets the dimension id for a given dimension.
  * @param p_usim_n_dimension The dimension to get the dimension id for.
  * @return Returns related usim_id_dim or NULL if it does not exist.
  */
  FUNCTION get_id_dim(p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE)
    RETURN usim_dimension.usim_id_dim%TYPE
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
  * Inserts a new dimension (max +1) until the maximum allowed dimension is reached.
  * Won't do anything, if maximum allowed dimension is exceeded.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns the new dimension id or NULL.
  */
  FUNCTION insert_next_dimension(p_do_commit IN BOOLEAN DEFAULT TRUE)
    RETURN usim_dimension.usim_id_dim%TYPE
  ;

END usim_dim;
/