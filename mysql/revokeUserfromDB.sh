#!/bin/bash
##############################################
#  Revoke  privileges database user on a database
##############################################
#
# Usage: ./revokeUserfromDB.sh <username> <hostname/ip> <database>
#

if [ $# = 3 ]; then
    username="${1}"
    hostname="${2}"
    database="${3}"
else
    echo "Usage: ./revokeUserfromDB.sh <username> <hostname/ip> <database>"
    exit 1
fi
sqlstmt="REVOKE ALL PRIVILEGES ON ${database}.* FROM '${username}'@'${hostname}'; FLUSH PRIVILEGES;"
mysql --defaults-extra-file='~/.my.ini' --execute="${sqlstmt}"
if [ $? = 0 ]; then
    echo "Revoke privileges from user success"
else
    echo "ERROR:Cannot revoke privileges from user. [ ${sqlstmt} ]"
fi
