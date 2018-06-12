#!/bin/bash
# rsync backup data to NAS
SYNC_BACKUP_DIR="/DATA-SYNC/TIQC-NAS/backup"
if [ -e ${SYNC_BACKUP_DIR} ]; then
	echo `date`
	rsync -rtD --delete-after /DATA-SYNC/backup-all/ ${SYNC_BACKUP_DIR}
	echo `date`
fi
SYNC_SHARED_DIR="/DATA-SYNC/TIQC-NAS/shared"
if [ -e ${SYNC_SHARED_DIR} ]; then
	echo `date`
	rsync -rtD --delete-after /DATA-SYNC/backup-shared-all/ ${SYNC_SHARED_DIR}
	echo `date`
fi

