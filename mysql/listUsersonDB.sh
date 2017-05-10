#!/bin/bash
##############################################
# list all database  users 
##############################################
#
# Usage: ./listUsersonDB.sh [database_name]
#

sqlstmt="select user, host, db as 'database name' from db"
if [ $# = 1 ]; then
    sqlstmt="${sqlstmt} where db like '%${1}%';"
else 
    sqlstmt="${sqlstmt};"
fi
mysql --defaults-extra-file='~/.my.ini' --execute="${sqlstmt}" mysql
if [ $? != 0 ]; then
    echo "ERROR:Cannot list users on database. [ ${sqlstmt} ]"
fi
