#!/bin/bash
# usage:
#    iptables-add-SNAT.sh <Destination IP> <Destination port> <This server IP>
iptables -t nat -A POSTROUTING -p tcp -d ${1} --dport ${2} -j SNAT --to-source ${3}
#iptables-save
#netfilter-persistent save
