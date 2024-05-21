# to be used on the database server for running scripts with APEX
# parameter 1: directory of usim scripts to switch to
# parameter 2: script name to call
# parameter 3: db user name
# if running on a system with other, important, databases find a better solution.
# change to given directory
# TAKE CARE on Windows systems, file has to be saved always with LF, not CRLF as it is called from Linux server
export ORAENV_ASK=NO
export ORACLE_SID=FREE
. oraenv
echo Parameter $1 $2 $3
echo Current dir: "$(pwd)"
echo cd to $1
cd $1
echo Current dir: "$(pwd)"
echo User: "$(whoami)"
echo EXECUTE: ${ORACLE_HOME}/bin/sqlplus / AS SYSDBA @USIM_RUN.sql "${3}" "${2}"
${ORACLE_HOME}/bin/sqlplus / AS SYSDBA @USIM_RUN.sql "${3}" "${2}"
