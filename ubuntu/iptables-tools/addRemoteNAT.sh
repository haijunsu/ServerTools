#!/bin/bash
# usage:
#   addRemoteDANT.sh <ethernet name> <port> <destination server ip> <port> [local ip]
if [ -z "$5" ]
then
  LOCAL_IP=`ip -h -br address |grep ${1} |cut -d/ -f1|awk '{print $3}'`
else
  LOCAL_IP=$5
fi
echo ${LOCAL_IP}

iptables -t nat -A PREROUTING -p tcp -i ${1} --dport ${2} -j DNAT --to-destination ${3}:${4}
iptables -t nat -A POSTROUTING -p tcp -d ${3} --dport ${4} -j SNAT --to-source ${LOCAL_IP}
#iptables-save
#netfilter-persistent save
