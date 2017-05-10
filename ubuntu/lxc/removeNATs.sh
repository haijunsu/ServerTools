#!/bin/bash
for i in {1..120}
do
	if [ $i -lt 10 ]; then
		iptables -t nat -D PREROUTING -p tcp -i eth0 --dport 210${i} -j DNAT --to-destination 10.0.3.10${i}:22
	elif [ 9 -lt  $i -a  $i -lt 100 ]; then
		iptables -t nat -D PREROUTING -p tcp -i eth0 --dport 21${i} -j DNAT --to-destination 10.0.3.1${i}:22
	else
		iptables -t nat -D PREROUTING -p tcp -i eth0 --dport 2$((${i}+100)) -j DNAT --to-destination 10.0.3.$((${i}+100)):22
	fi	
done
for i in {241..244}
do
        iptables -t nat -D PREROUTING -p tcp -i eth0 --dport 2${i} -j DNAT --to-destination 10.0.3.${i}:22
done
iptables-save
iptables -t nat -L --line-numbers
