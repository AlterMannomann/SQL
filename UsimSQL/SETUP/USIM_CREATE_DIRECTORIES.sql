-- a new file is always copied to the main directory. Before copying, the current file, if it exists, is copied to the history directory with a unique name.
ACCEPT USIM_DIRECTORY CHAR PROMPT 'Directory for json main space log file (a valid local directory like C:\Users\xxx\Documents\SQL\UsimSQL\JS):'
ACCEPT USIM_HISTORY CHAR PROMPT 'Directory for json history space log files (a valid local directory like C:\Users\xxx\Documents\SQL\UsimSQL\JS\SpaceLog):'
CREATE OR REPLACE DIRECTORY usim_dir AS '&USIM_DIRECTORY';
CREATE OR REPLACE DIRECTORY usim_hist_dir AS '&USIM_HISTORY';
