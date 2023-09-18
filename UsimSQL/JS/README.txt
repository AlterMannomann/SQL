Setting up the visualisation:
- create a local web server that points to this directory as root directory
- grant access to the groups, roles or users, that run the web server or Oracle
-- on Windows those groups are for IIS:  IIS_IUSRS (read is sufficient)
   on Oracle XE: ORA_OraDB21Home1_SVCACCTS (r/w/e) (at least on my machine)
   for Oracle check the groups and roles on the basic Oracle directory to find a match, currently the group worked for me and I don't
   care too much at the moment. ORA_OPER and necessary grants would be a better match if security is important.