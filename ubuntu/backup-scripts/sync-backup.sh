#!/bin/bash
# rsync backup data to NAS
echo ${1} ${2}
if [ -e ${2} ]; then
	echo `date`
	rsync -rtD --delete-after /${1}/ ${2}
	echo `date`
fi

