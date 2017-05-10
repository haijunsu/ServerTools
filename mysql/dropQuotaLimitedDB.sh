#!/bin/bash
#########################
#  Drop database 
#########################
#
# Usage: 
#        ./dropQuotaLimitedDB.sh <DB name> //Interactive feeding database size information
#        ./dropQuotaLimitedDB.sh  //Interactive feeding database informaton
#

source "../mylibs/commons.sh"
checkroot
trap 'error ${LINENO} "Drop quota limited database failed"' ERR
DEBUG=on #enable/disable debug

if [ $# = 1 ]; then
    dbname="${1}"
else
    while true; do
        printf "Please input database name: "
        read dbname
        if [ "${dbname}X" != "X" ]; then
            break;
        fi
    done
fi

debug "dbname=${dbname}"
cd /var/lib/mysql
# drop all tables first
TABLES=$(mysql ${dbname} -e 'show tables' | awk '{ print $1}' | grep -v '^Tables' )
 
for t in $TABLES
do
	msg "Deleting $t table from ${dbname} database..."
	mysql ${dbname} -e "drop table $t"
done
debug "All tables have been dropped."
rm ${dbname}
mkdir ${dbname}
chown mysql:mysql ${dbname}
mysql -e "drop database ${dbname}"
debug "drop database from mysql server seccessfully."
zfs destroy mysqldata/${dbname}
debug "destroy mysqldata/${dbname} successfully."
rm -rf /mysqldata/${dbname}
msg "Done"

