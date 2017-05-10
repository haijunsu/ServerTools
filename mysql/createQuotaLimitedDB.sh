#!/bin/bash
#########################
#  Create database user
#########################
#
# Usage: ./createQuotaLimitedDB.sh <DB name> <DB Size>
#        ./createQuotaLimitedDB.sh <DB name> //Interactive feeding database size information
#        ./createQuotaLimitedDB.sh  //Interactive feeding database informaton
#

source "../mylibs/commons.sh"
checkroot
trap 'error ${LINENO} "Create quota limited database failed"' ERR
DEBUG=on #enable/disable debug
if [ $# = 2 ]; then
    dbname="${1}"
    dbsize="${2}"
else
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

    printf "please input database size [1gb]: "
    read dbsize
    if [ "${dbsize}X" = "X" ]; then
	dbsize="1gb";
    fi
fi
debug "dbname=${dbname}, quota=${dbsize}"
cd /var/lib/mysql
zfs create -o mountpoint=/mysqldata/${dbname} -o quota=${dbsize} mysqldata/${dbname}
chown -R mysql:mysql /mysqldata/${dbname}
chmod -R 700 /mysqldata/${dbname}
mysql -e "create database ${dbname};"
mv ${dbname}/db.opt /mysqldata/${dbname}
mv ${dbname} /tmp
rm -rf /tmp/${dbname}
ln -s /mysqldata/${dbname} /var/lib/mysql
restorecon -R -v /mysqldata
msg echo "Done"

