#!/bin/bash
##############################################
# Show grants for user 
##############################################
#
# Usage: ./showGrantsforUser.sh <username> <hostname/ip>
#

if [ $# = 2 ]; then
    username="${1}"
    hostname="${2}"
else
    echo "Usage: ./showGrantsforUser.sh <username> <hostname/ip>"
    exit 1
fi
sqlstmt="show grants for '${username}'@'${hostname}';"
mysql --defaults-extra-file='~/.my.ini' --execute="${sqlstmt}"
if [ $? != 0 ]; then
    echo "ERROR:Cannot show grants user. [ ${sqlstmt} ]"
fi
