# This script is intended to be called by unix user USIM.
# set -x
cd /usim_src
usim_log=/usim_src/SETUP/LOG/UsimTesting.log
echo Current dir: "$(pwd)" > $usim_log
echo User: "$(whoami)" >> $usim_log
psql "options=--search_path=usim_test,public" -f /usim_src/SETUP/UsimTestExtension.psql 2>&1 | tee -a $usim_log
# match regex can be used to split the tests or call special test setups, e.g. --match '^test_000|^setup_000'
# default is that functions begin with test, setup, teardown, startup or shutdown
pg_prove --dbname usim --schema usim_test --runtests -v 2>&1 | tee -a $usim_log
# prepare usim_test to contain some data
psql "options=--search_path=usim_test" -f /usim_src/SETUP/UsimTestPrepare.psql 2>&1 | tee -a $usim_log
