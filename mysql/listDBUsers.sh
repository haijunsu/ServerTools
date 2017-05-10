#!/bin/bash
##############################################
# list all database  users 
##############################################
#
# Usage: ./listDBUsers.sh [username]
#

sqlstmt="select user, host from user"
if [ $# = 1 ]; then
    sqlstmt="${sqlstmt} where user like '%${1}%';"
else 
    sqlstmt="${sqlstmt};"
fi
mysql --defaults-extra-file='~/.my.ini' --execute="${sqlstmt}" mysql
if [ $? != 0 ]; then
    echo "ERROR:Cannot list database users. [ ${sqlstmt} ]"
fi
