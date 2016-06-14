#!/bin/bash

#change host name
HOST_NAME=`hostname`
hostname ${1}
sed -i "s/${HOSTNAME}/${1}/g" /etc/hostname
sed -i "s/${HOSTNAME}/${1}/g" /etc/hosts
#sed -i "s/\.qc\.cuny\.edu/\.qc\.cuny\.edu ${1}\.quic\.nyc/g" /etc/hosts
/etc/init.d/hostname.sh start
