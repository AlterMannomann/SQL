-- a new file is always copied to the main directory. Before copying, the current file, if it exists,
-- is copied to the history directory with a unique name.
CREATE OR REPLACE DIRECTORY usim_dir AS '&USIM_DIRECTORY';
CREATE OR REPLACE DIRECTORY usim_hist_dir AS '&USIM_HISTORY';
-- script main directory for script runs
CREATE OR REPLACE DIRECTORY usim_script_dir AS '&USIM_SCRIPTS';
-- installation log files
CREATE OR REPLACE DIRECTORY usim_log_dir AS '&USIM_LOGS';
