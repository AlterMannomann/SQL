# This script is intended to be called by unix user USIM, with all
# required SUDO rights.
# set -x
cd /usim_src
usim_log=/usim_src/SETUP/LOG/PostGreSetup.log
echo Current dir: "$(pwd)" > $usim_log
echo User: "$(whoami)" >> $usim_log
sudo su -c "psql -f /usim_src/SETUP/PostGresSetup.psql 2>&1 | tee -a $usim_log" postgres
