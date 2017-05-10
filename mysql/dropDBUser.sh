#!/bin/bash
#########################
#  Drop database user
#########################
#
# Usage: ./dropDBUser.sh <username> <hostname/ip> 
#        ./dropDBUser.sh <username> //Interactive feeding user informaton
#        ./dropDBUser.sh  //Interactive feeding user informaton
#

if [ $# = 2 ]; then
    username="${1}"
    hostname="${2}"
else
    if [ $# = 1 ]; then
	username="${1}"
    else
        printf "Please input username: "
        read username
    fi
    printf "please input hostname [localhost]: "
    read hostname
    if [ "${hostname}X" = "X" ]; then
	hostname="localhost"
    fi
    echo
fi
sqlstmt="drop user '${username}'@'${hostname}';"
mysql --defaults-extra-file='~/.my.ini' --execute="${sqlstmt}"
if [ $? = 0 ]; then
    echo "Drop user ${username} success"
else
    echo "ERROR: Cannot drop user. [ ${sqlstmt} ]"
fi
