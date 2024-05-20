# to be used on the database server for running scripts with APEX
# parameter 1: directory of usim scripts to switch to
# parameter 2: script name to call
# parameter 3: db user name
# if running on a system with other, important, databases find a better solution.
# change to given directory
export ORAENV_ASK=NO
export ORACLE_SID=FREE
. oraenv
cd $1
pwd
whoami
echo ${ORACLE_HOME}/bin/sqlplus / AS SYSDBA @USIM_RUN.sql "${3}" "${2}"
${ORACLE_HOME}/bin/sqlplus / AS SYSDBA @USIM_RUN.sql "${3}" "${2}"