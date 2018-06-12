#!/bin/bash

######################
# Backup mysql databases (structure and contents)
#
# usage: backupMysqDB <store path> <db_name> [exclude tables]
# 
##################
backupMysqlDB() {
    if [ $# -eq 0 ]; then
	echo "No arguments supplied"
	return -2
    fi
    STORE_PATH=$1
    DB_NAME=$2
    IGNORED_TABLES_STRING=''
    if [ ! -z "$3" ]; then
        arr=(${3//,/ })
	for TABLE in "${arr[@]}"
	do :
	   IGNORED_TABLES_STRING+=" --ignore-table=${DB_NAME}.${TABLE}"
	done        
    fi 
    echo "BACKUP ${DB_NAME} ..."
    if [ ! -d ${STORE_PATH} ]; then
	mkdir -p ${STORE_PATH}
    fi
    # echo "${IGNORED_TABLES_STRING}"
    mysqldump --single-transaction --no-data ${DB_NAME} > "${STORE_PATH}${DB_NAME}_structure.sql"
    mysqldump --skip-lock-tables ${IGNORED_TABLES_STRING} ${DB_NAME} | gzip -9 >"${STORE_PATH}${DB_NAME}_data.sql.gz"
    if [ $? -eq 0 ]; then
    	echo "BACKUP ${DB_NAME} success"
	return 0
    else
	echo "BACKUP ${DB_NAME} failed"
	return -1
    fi
}

TODAY="$(date +%Y-%m-%d)"
MONTH_DAY="$(date +%d)"
SERVER_NAME=`hostname`
BACKUPPATH="/backup/daily/$TODAY/"
BACKUP_BIG_DB="FALSE"
BACKUP_CONTAINERS="FALSE"
if [ "10" = "${MONTH_DAY}" ]; then
    BACKUPPATH="/backup/archive/$TODAY/"
    BACKUP_BIG_DB="TRUE"
    BACKUP_CONTAINERS="TRUE"
fi
mkdir -p ${BACKUPPATH}
# Touch the folder to be curtime
# touch -t "$(date +%Y%m%d%H%M)" "/backup/daily/$TODAY/"
touch -t "$(date +%Y%m%d%H%M)" ${BACKUPPATH}

FILEPREFIX="${BACKUPPATH}${TODAY}.$HOSTNAME."
cd /
# Backup files
if [ -d "/storage/wwwroot" ]; then
	tar -czf "${FILEPREFIX}wwwroot.tar.gz" storage/wwwroot
fi
if [ -d "/storage/ssl" ]; then
	tar -czf "${FILEPREFIX}ssl.tar.gz" storage/ssl
fi
tar -czf "${FILEPREFIX}config.tar.gz" etc
tar -czf "${FILEPREFIX}userdata.tar.gz" home root

# Backup database
DB_LIST="/backup/db_server"
if [ -e ${DB_LIST} ]; then
	FILENAME="$TODAY.$HOSTNAME."

	#USER="backupuser"
	#USER="root"
	#PASS="KislfdKksfl23i"
	#HOST="localhost"

	#dbnames=`echo "show databases"|mysql -u${USER} -p${PASS} -h${HOST}|grep '^dev\|^prod'`
	dbnames=`echo "show databases"|mysql |grep '^dev\|^prod'`

	for qx in ${dbnames}; do
        	#mysqldump -v -u${USER} -p${PASS} -h${HOST} --databases  --skip-lock-tables $qx | gzip -9 >"${FILEPREFIX}${qx}.sql.gz"
        	#mysqldump -v --databases  --skip-lock-tables $qx | gzip -9 >"${FILEPREFIX}${qx}.sql.gz"
        	backupMysqlDB ${BACKUPPATH} ${qx}
	done
        # backup system database
	backupMysqlDB ${BACKUPPATH} mysql
	backupMysqlDB ${BACKUPPATH} phpmyadmin
	# mysqldump -v --databases  --skip-lock-tables mysql | gzip -9 >"${FILEPREFIX}mysql.sql.gz"
	# mysqldump -v --databases  --skip-lock-tables phpmyadmin | gzip -9 >"${FILEPREFIX}phpmyadmin.sql.gz"

	#backup big databases
	if [ "TRUE" = "${BACKUP_BIG_DB}" ]; then
		dbnames=`echo "show databases"|mysql |grep '^nobak_prod'`
		for qx in ${dbnames}; do
        		# mysqldump -v --databases  --skip-lock-tables $qx | gzip -9 >"${FILEPREFIX}${qx}.sql.gz"
        		backupMysqlDB ${BACKUPPATH} ${qx}
		done
		dbnames=`echo "show databases"|mysql |grep '^bpl'`
		for qx in ${dbnames}; do
        		#mysqldump -v --databases  --skip-lock-tables $qx | gzip -9 >"${FILEPREFIX}${qx}.sql.gz"
        		backupMysqlDB ${BACKUPPATH} ${qx}
		done
	else
		# AAE
		EXCLUDE_TABLES="MeterReadingLog,WeatherHistoricalData"
		backupMysqlDB ${BACKUPPATH} nobak_prod_sec_aae ${EXCLUDE_TABLES}
		# BPL
		EXCLUDE_TABLES="data_item"
		backupMysqlDB ${BACKUPPATH} bpl_performance_lab ${EXCLUDE_TABLES}
	fi
fi

# backup docker database
DB_CONTAINER_LIST="/backup/db_containers"
if [ -e ${DB_CONTAINER_LIST} ]; then
	container_names=$(</backup/db_containers)
	for name in ${container_names}; do
		docker exec ${name}  sh -c 'exec mysqldump --all-databases -uroot -p"$MYSQL_ROOT_PASSWORD"' |gzip -9 > "${FILEPREFIX}docker.${name}.sql.gz"	
	done
fi

# backup lxd containers
LXD_CONTAINER_LIST="/backup/lxd_containers"
if [ -e ${LXD_CONTAINER_LIST} ]; then
	container_names=$(</backup/lxd_containers)
	for name in ${container_names}; do
		if [ "${BACKUP_CONTAINERS}" = "TRUE" ]; then
		    echo ${name}
		    lxc snapshot ${name} ${TODAY} 
                    lxc publish "${name}/${TODAY}" --alias "${name}-${TODAY}"
                    lxc image export "${name}-${TODAY}" "${FILEPREFIX}lxd.${name}-tarball-image"
                    lxc image delete "${name}-${TODAY}"
		else
			cd /var/lib/lxd/containers/${name}/rootfs
			tar -czf "${FILEPREFIX}lxd.${name}.config.tar.gz" etc
			tar -czf "${FILEPREFIX}lxd.${name}.userdata.tar.gz" home root
			if [ -d "/var/lib/lxd/containers/${name}/rootfs/storage/wwwroot" ]; then
				tar -czf "${FILEPREFIX}lxd.${name}.wwwroot.tar.gz" storage/wwwroot
			fi
			if [ -d "/var/lib/lxd/containers/${name}/rootfs/storage/github" ]; then
				tar -czf "${FILEPREFIX}lxd.${name}.github.tar.gz" storage/github
			fi
                fi
	done
fi

# backup MongoDB

MongoDB_LIST="/backup/mongodbs"
if [ -e ${MongoDB_LIST} ]; then
	dbs=$(</backup/mongodbs)
	for db in ${dbs}; do
		mongodump -u cisdd -p Ilovemyjob@cep2 --authenticationDatabase admin -d ${db} --gzip --archive=${FILEPREFIX}MongoDB-${db}.gz
	done
fi

# remove old backups
find /backup/daily/* -maxdepth 0 -mtime +30 | xargs rm -rf

