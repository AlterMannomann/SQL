-- make object qualified and ensure that script can start standalone
COLUMN USIM_SCHEMA NEW_VAL USIM_SCHEMA
SELECT SYS_CONTEXT('USERENV', 'CURRENT_SCHEMA') AS USIM_SCHEMA FROM dual;
CREATE OR REPLACE PACKAGE &USIM_SCHEMA..usim_spr
IS
  /**A low level package for actions on table usim_spc_process and its associated
  * views. Views can be seen as interfaces and dependency. No other package dependencies
  * apart from USIM_BASE and USIM_SPC. ATTENTION Package may throw exceptions
  * from constraints, triggers and foreign keys. Caller is responsible to handle
  * possible exceptions.
  */

  /**
  * Checks if usim_spc_process has already data.
  * @return Returns 1 if data are available, otherwise 0.
  */
  FUNCTION has_data
    RETURN NUMBER
  ;

  /**
  * Checks if usim_spc_process has already data for a given process id.
  * @param p_usim_id_spr The process id to check.
  * @return Returns 1 if data are available for this id, otherwise 0.
  */
  FUNCTION has_data(p_usim_id_spr IN usim_spc_process.usim_id_spr%TYPE)
    RETURN NUMBER
  ;

  /**
  * Checks if usim_spc_process has unprocessed data.
  * @return Returns 1 if unprocessed data are available, otherwise 0.
  */
  FUNCTION has_unprocessed
    RETURN NUMBER
  ;

  /**
  * Checks if the current unprocessed queue is valid. All unprocessed records must have the current
  * planck aeon and time and if the table is not empty, there must be at least 2 process records.
  * Count of process records must be a multitude of 2. An empty table will also return 1.
  * @return Returns 1 if queue is ready to be processed, otherwise error code: 0 no unprocessed records, -1 planck aeon/time error, -2 record count wrong.
  */
  FUNCTION is_queue_valid
    RETURN NUMBER
  ;

  /**
  * Fetches the current planck aeon and time if the queue is valid. Will not operate on empty tables.
  * @param p_usim_planck_aeon The planck aeon for the current unprocessed records.
  * @param p_usim_planck_time The planck time for the current unprocessed records.
  * @return Returns 1 if planck data could be fetched, otherwise error code from USIM_SPR.IS_QUEUE_VALID: 0 no unprocessed records, -1 planck aeon/time error, -2 record count wrong.
  */
  FUNCTION get_unprocessed_planck( p_usim_planck_aeon OUT usim_spc_process.usim_planck_aeon%TYPE
                                 , p_usim_planck_time OUT usim_spc_process.usim_planck_time%TYPE
                                 )
    RETURN NUMBER
  ;

  /**
  * Inserts a new process record with status IS_PROCESSED = 0 and current real time, planck aeon
  * and planck tick.
  * @param p_usim_id_spc_source The space id of the process that emits energy. Must exist.
  * @param p_usim_id_spc_target The space id of the process that receives energy. Must exist.
  * @param p_usim_energy_source The energy of the source before processing. NULL not allowed.
  * @param p_usim_energy_target The energy of the target before processing.
  * @param p_usim_energy_output The energy output of the source before processing. NULL not allowed.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns the new unique process id or NULL on errors. May throw exceptions on number inserts causing overflows.
  */
  FUNCTION insert_spr( p_usim_id_spc_source IN usim_space.usim_id_spc%TYPE
                     , p_usim_id_spc_target IN usim_space.usim_id_spc%TYPE
                     , p_usim_energy_source IN usim_spc_process.usim_energy_source%TYPE
                     , p_usim_energy_target IN usim_spc_process.usim_energy_target%TYPE
                     , p_usim_energy_output IN usim_spc_process.usim_energy_output%TYPE
                     , p_do_commit          IN BOOLEAN                                  DEFAULT TRUE
                     )
    RETURN usim_spc_process.usim_id_spr%TYPE
  ;

  /**
  * Sets the given process step to processed.
  * @param p_usim_id_spr The process id of the process that should be set to processed. Must exist.
  * @param p_process_state The process state to set. 1=processed, 2=universe not active, not processed. Default is 1.
  * @param p_do_commit An boolean indicator if data should be committed or not (e.g. for trigger use).
  * @return Returns 1 if processed state could be set otherwise 0.
  */
  FUNCTION set_processed( p_usim_id_spr   IN usim_spc_process.usim_id_spr%TYPE
                        , p_process_state IN usim_spc_process.is_processed%TYPE DEFAULT 1
                        , p_do_commit     IN BOOLEAN                            DEFAULT TRUE
                        )
    RETURN NUMBER
  ;

END usim_spr;
/