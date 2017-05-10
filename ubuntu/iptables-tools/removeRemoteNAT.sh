#!/bin/bash
# usage:
#   addRemoteDANT.sh <ethernet name> <port> <destination server ip> <port>
LOCAL_IP=`ip -h -br address |grep ${1} |cut -d/ -f1|awk '{print $3}'`
#echo ${LOCAL_IP}
iptables -t nat -D PREROUTING -p tcp -i ${1} --dport ${2} -j DNAT --to-destination ${3}:${4}
iptables -t nat -D POSTROUTING -p tcp -d ${3} --dport ${4} -j SNAT --to-source ${LOCAL_IP}
#iptables-save
#netfilter-persistent save
