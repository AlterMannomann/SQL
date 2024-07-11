# Debian 12.5
Using ISO debian-12.5.0-amd64-netinst.iso. Will be probably included in the repository.
Using VBox virtual system. Getting guest additions to work is sometimes painful.

With vbox disable shared folders, copy&paste and drag&drop. Choose manual install. For basics 20GB drive is enough. Data folders
will be added as shared folders later. Used 8196 MB memory and 2 processors, 20 GB disc preallocated. Bridged network works best
for me. No serial devices.

Configured users (root, usim, postgres) with default password usim. User usim added to sudo group and configured
sudoers with NOPASSWD:ALL for sudo group.

Install basics for vbox

    // modify sudoers with root
    // adjust: %sudo	ALL=(ALL:ALL) NOPASSWD:ALL
    // expecting user usim created on install otherwise create user usim pw usim
    usermod -a -G sudo usim
    apt install -y build-essential dkms linux-headers-$(uname -r)
    // mount guest addition and run in directory
    ./VBoxLinuxAdditions.run --nox11
    // shutdown system and enable drag&drop / copy&paste

This application is for ease of access not for security purposes. Usually you wouldn't do this.

Installed pgadmin library (you may need to install curl):

    sudo echo "deb [arch=amd64 signed-by=/usr/share/keyrings/pgadmin4.gpg] https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" | sudo tee /etc/apt/sources.list.d/pgadmin4.list
    curl -fsSL https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo gpg --dearmor -o /usr/share/keyrings/pgadmin4.gpg

Installed postgressql (15.6 (Debian 15.6-0+deb12u1)), documentation and pgadmin4 8.8 with debian gui.
# PostGres 15.6 basic setup

    // check install
    sudo systemctl is-enabled postgresql
    sudo systemctl status postgresql
    // set postgres db user password
    sudo -u postgres psql
    ALTER USER postgres WITH PASSWORD 'usim';
    quit

Assign group to usim

    sudo usermod -a -G postgres usim

Install pgadmin web interface

    sudo /usr/pgadmin4/bin/setup-web.sh

Adjust groups for usim, postgres and www-data (pgAdmin) to be able to access shared folders.

    sudo usermod -a -G vboxsf postgres
    sudo usermod -a -G vboxsf usim
    sudo usermod -a -G vboxsf www-data

Now link shared folders to this folders after shutdown. Mount points /usim_data and /usim_src. And execute

    sudo -u postgres psql -f /usim_src/SETUP/PostGresSetup.psql

After this user usim should be automatically connected to database usim with db role usim.

Had to edit /usr/pgadmin4/web/config.py as config_system.py didn't work, to get share available in pgAdmin web.

    SHARED_STORAGE = [{'name': 'Usim Share', 'path': '/usim_src', 'restricted_access': False}]

# Updating
Usually the recommendation is: **If your system is running, do not update**

This involves as well virtual managers, linux and database distributions.

USIM has no need for security, so no need for security updates. Anyway updates may highly possible break your running installation and cause you a lot of work to get everything running again. And then you have to verify that everything still works as expected. If you have a lot of time and passion go on. Otherwise stick to the old rule:

## Never touch a running system

# Setup the USim model
As all experiments failed with SET search_path and \setenv I used the connect option to set the schema to ensure that objects are created in the correct schema. Avoided special users, user postgres is good enough for this simulation.

    sudo -u postgres psql "options=--search_path=usim_test" -f /usim_src/SETUP/UsimSetupTest.psql
    sudo -u postgres psql "options=--search_path=usim" -f /usim_src/SETUP/UsimSetup.psql