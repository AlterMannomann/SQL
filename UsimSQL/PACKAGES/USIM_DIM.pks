-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
CREATE OR REPLACE PACKAGE &USIM_SCHEMA..usim_dim
IS
  /**A low level package for actions on table usim_dimension and its associated
  * views. Views can be seen as interfaces and dependency. No other package dependencies
  * apart from USIM_STATIC. ATTENTION Package may throw exceptions
  * from constraints, triggers and foreign keys. Caller is responsible to handle
  * possible exceptions.
  */

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
  * Checks if given dimension exists.
  * @param p_usim_n_dimension The dimension to verify.
  * @return Returns 1 if id exists, otherwise 0.
  */
  FUNCTION has_data(p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE)
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
  * Inserts a dimension into usim_dimension.
  * @param p_usim_n_dimension The dimension to insert. Always absolute value is used, no negative dimensions possible.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns the new/existing dimension id or NULL on errors.
  */
  FUNCTION insert_dimension( p_usim_n_dimension IN usim_dimension.usim_n_dimension%TYPE
                           , p_do_commit        IN BOOLEAN                              DEFAULT TRUE
                           )
    RETURN usim_dimension.usim_id_dim%TYPE
  ;

  /**
  * Creates all dimensions including given max dimension. Can be used to initialize the available
  * dimensions in a multiverse.
  * @param p_max_dimension The maximum dimensions to insert. Always absolute value is used, no negative dimensions possible.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns 1 one success 0 on errors.
  */
  FUNCTION init_dimensions( p_max_dimension IN usim_dimension.usim_n_dimension%TYPE
                          , p_do_commit     IN BOOLEAN                              DEFAULT TRUE
                          )
    RETURN NUMBER
  ;

END usim_dim;
/