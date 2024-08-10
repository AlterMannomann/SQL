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

Install pgTap for testing:

    sudo apt-get install pgtap

Installed/upgraded postgressql (15.8 (Debian 15.8-0+deb12u1)), documentation and pgadmin4 8.10 with debian gui and pgtap 1.2.
# PostGres 15 basic setup

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

    /usim_src/SH/dba_init_usim.sh

After this user usim and schema usim as well as usim_test are available. pgTap extension installed on database usim.

Had to edit /usr/pgadmin4/web/config.py as config_system.py didn't work, to get share available in pgAdmin web.

    SHARED_STORAGE = [{'name': 'Usim Share', 'path': '/usim_src', 'restricted_access': False}]

# Updating
Usually the recommendation is: **If your system is running, do not update**

This involves as well virtual managers, linux and database distributions.

USIM has no need for security, so no need for security updates. Anyway updates may highly possible break your running installation and cause you a lot of work to get everything running again. And then you have to verify that everything still works as expected. If you have a lot of time and passion go on. Otherwise stick to the old rule:

## Never touch a running system

# Setup the USim model
As all experiments failed with SET search_path and \setenv I used the connect option to set the schema to ensure that objects are created in the correct schema. Avoided special users, user usim is good enough for this simulation. To install schema usim and usim_test run:

    /usim_src/SH/init_usim_all.sh

If you want only to setup one schema use one of the following

    /usim_src/SH/init_usim.sh
    /usim_src/SH/init_usim_test.sh

## Manual testing with pgAdmin
For testing with pgAdmin, depending on the login used, you may want to use

    SET search_path TO usim_test;
    SET search_path TO usim;

## Functions and procedures
Did not found an elegant and working way to read out default values and cast them correctly. Of course you can use one of the following

    SELECT column_default FROM information_schema.columns WHERE table_name='mytable';
    SELECT pg_get_expr(d.adbin, d.adrelid) AS default_value
    FROM   pg_catalog.pg_attribute    a
    LEFT   JOIN pg_catalog.pg_attrdef d ON (a.attrelid, a.attnum) = (d.adrelid, d.adnum)
    WHERE  NOT a.attisdropped           -- no dropped (dead) columns
    AND    a.attnum   > 0               -- no system columns
    AND    a.attrelid = 'myschema.mytable'::regclass
    AND    a.attname  = 'mycolumn';

But as the text output has sometimes already a cast within the expression and I found until now no eval function, the types and
defaults are still hardcoded in the procedures or function. This means, any changes on table column defaults or types will need some extra round trip of adjusting the functions and procedures. For probably easier finding of impacted functions and procedures, the doc section contains a literal part with Dependency «table name», e.g.

    * @literal Dependency usim_basedata column types and defaults.

# Init the USim model
Be careful about using the default values. Those are meant for a very big simulation and need a properly configured PostGres instance with enough processors, memory and fast disc access. Space consumption will be measured in TB rather than GB.

    -- use bda_new_sim to create a new simulation, e.g.
    CALL bda_new_sim('My simulation', 42::smallint, 99999::numeric, 0.00001::numeric);

# Almost timeless design
Whenever possible the design is extend for being able to deal with faster systems. Therefore exists some special application managed sequences, which can also be temporary. Only reason for this is, to ensure that concurrent creations with the same timestamp are manageable in sense of uniqueness.

Limitations are avoided, whereever possible. Design should be still usable if integers get bigger or dates get higher as expected nowadays.