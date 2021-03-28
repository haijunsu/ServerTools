#!/bin/bash
source ./base.sh
checkPass

mydb=$1
if [ "${mydb}X" == "X" ]; then
  mydb="admin"
fi
echo Show users in db: ${mydb}
mongo --quiet --eval "var mydb=\"${mydb}\"; var secret=\"${PASS_FILE}\";" ./getUsers.js
