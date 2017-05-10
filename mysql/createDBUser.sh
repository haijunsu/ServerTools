#!/bin/bash
#########################
#  Create database user
#########################
#
# Usage: ./createDBUser.sh <username> <hostname/ip> <password>
#        ./createDBUser.sh <username> //Interactive feeding user informaton
#        ./createDBUser.sh  //Interactive feeding user informaton
#

if [ $# = 3 ]; then
    username="${1}"
    hostname="${2}"
    password="${3}"
else
    if [ $# = 1 ]; then
	username="${1}"
    else
        while true; do
            printf "Please input username: "
            read username
            if [ "${username}X" != "X" ]; then
                break;
            fi
        done
    fi

    printf "please input hostname [localhost]: "
    read hostname

    if [ "${hostname}X" = "X" ]; then
	hostname="localhost"
    fi
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
sqlstmt="create user '${username}'@'${hostname}'; set password for '${username}'@'${hostname}'=password('${password}');"
mysql --defaults-extra-file='~/.my.ini' --execute="${sqlstmt}"
if [ $? = 0 ]; then
    echo "Create user ${username} success"
else
    echo "ERROR: Cannot create user. [ ${sqlstmt} ]"
fi
