#!/bin/bash
#########################
#  Drop a database user
#########################
#
# Usage: ./dropDBUser.sh <database> <username>
#        ./dropDBUser.sh  //Interactive feeding user informaton
#

source ./base.sh
checkPass

usage() {
  echo "Usage: ./dropDBUser.sh <database> <username> <password>"
  echo "       ./dropDBUser.sh  //Interactive feeding user informaton"
  exit 0
}

if [ $# == 2 ]; then
    mydb="${1}"
    username="${2}"
else
    if [ $# != 0 ]; then
      usage
    else
        while true; do
            printf "Please input database name: "
            read mydb
            if [ "${mydb}X" != "X" ]; then
                break;
            fi
        done
        while true; do
            printf "Please input user name: "
            read username
            if [ "${username}X" != "X" ]; then
                break;
            fi
        done
    fi
fi
prompt="Are you sure to delete user \"${username}\" from db \"${mydb}\"?[y/N][N]: "
read -r -p "${prompt}" response
response=${response,,}    # tolower
if [[ "$response" =~ ^(yes|y)$ ]]; then
  mongo --quiet --eval "var mydb=\"${mydb}\"; var secret=\"${PASS_FILE}\"; var username=\"${username}\"" ./dropUser.js
	echo Deleted.
else
  echo "Aborted! Nothing is changed."
fi
