#!/bin/bash
# usage:
#   addLocalDANT.sh <ethernet name> <port> <destination server ip> <port>

usage() {
  echo "Usage:" 
  echo "    ${0} <ethernet name> <port> <destination server ip> <port> [multiport placeholder]"
  echo "        if multiport placeholder has value, the port should be <num>,<num>,..."
}

if [ $# -lt 4 -o $# -gt 5 ]; then
  usage
  exit 1
elif [ $# -eq 4 ]; then
  iptables -t nat -A PREROUTING -p tcp -i ${1} --dport ${2} -j DNAT --to-destination ${3}:${4}
else
  iptables -t nat -A PREROUTING -p tcp -i ${1} --match multiport --dports ${2} -j DNAT --to-destination ${3}:${4}
fi
exit 0
#iptables-save
#netfilter-persistent save
