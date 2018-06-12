#!/bin/bash

#change host name
HOST_NAME=`hostname`
# hostname ${1}
hostnamectl set-hostname ${1}
sed -i "s/${HOSTNAME}/${1}/g" /etc/hostname
sed -i "s/${HOSTNAME}/${1}/g" /etc/hosts
sed -i "s/${HOSTNAME}/${1}/g" /etc/postfix/main.cf
/etc/init.d/hostname.sh start
