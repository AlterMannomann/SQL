# This script is intended to be called by unix user USIM
# set -x
cd /usim_src
usim_log=/usim_src/SETUP/LOG/UsimTesting.log
echo Current dir: "$(pwd)" > $usim_log
echo User: "$(whoami)" >> $usim_log
psql "options=--search_path=usim_test,public" -f /usim_src/SETUP/UsimTestExtension.psql 2>&1 | tee -a $usim_log