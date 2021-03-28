#!/bin/bash
#########################
#  Create database user
#  User role is readWrite
#########################
#
# Usage: ./createDBUser.sh <database> <username> <password>
#        ./createDBUser.sh  //Interactive feeding user informaton
#
source ./base.sh
checkPass

usage() {
  echo "Usage: ./createDBUser.sh <database> <username> <password>"
  echo "       ./createDBUser.sh  //Interactive feeding user informaton"
  exit 0
}

if [ $# == 3 ]; then
    mydb="${1}"
    username="${2}"
    password="${3}"
    role="readWrite"
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
        printf "Please input role name [readWrite]: "
        read role
        if [ "${role}X" == "X" ]; then
           role="readWrite" 
        fi
        while true; do
            printf "Please input user name: "
            read username
            if [ "${username}X" != "X" ]; then
                break;
            fi
        done
        while true; do
          while true; do   
              printf "please input password: "
              read -s password
              echo
              if [ "${password}X" != "X" ]; then
                  break;
              fi
          done
          printf "please input the password again: "
          read -s repassword
          echo
          if [ "${password}" = "${repassword}" ]; then
              break;
          else
              echo "Passwords didn't match!!!"
          fi
      done
    fi
fi
echo Show users in db: ${mydb}
mongo --quiet --eval "var mydb=\"${mydb}\"; var secret=\"${PASS_FILE}\"; var rolename=\"${role}\"; var username=\"${username}\"; var pwd=\"${password}\"" ./createUser.js
