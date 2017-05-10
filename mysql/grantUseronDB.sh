#!/bin/bash
##############################################
#  Grant privileges database user on a database
##############################################
#
# Usage: ./grantUseronDB.sh <username> <hostname/ip> <database>
#

if [ $# = 3 ]; then
    username="${1}"
    hostname="${2}"
    database="${3}"
else
    echo "Usage: ./grantUseronDB.sh <username> <hostname/ip> <database>"
    exit 1
fi
sqlstmt="GRANT ALL PRIVILEGES ON ${database}.* TO '${username}'@'${hostname}';FLUSH PRIVILEGES;"
mysql --defaults-extra-file='~/.my.ini' --execute="${sqlstmt}"
if [ $? = 0 ]; then
    echo "Grant privileges to user success"
else
    echo "ERROR:Cannot grant privileges to user. [ ${sqlstmt} ]"
fi
