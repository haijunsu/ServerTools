#!/bin/bash
DNS_MODIFIED=`grep "149.4.68.218" /etc/network/interfaces | wc -l`  
if [ ${DNS_MODIFIED} -ne 1 ]; then
	echo "Adding DNS servers ..."
	echo dns-nameservers 149.4.68.218 149.4.68.227 149.4.100.201 149.4.100.202 8.8.8.8>> /etc/network/interfaces
	echo dns-search tiqc.nyc quic.nyc qc.cuny.edu>> /etc/network/interfaces
	service networking restart
	echo "Done!"
else
	echo "Nothing changed. Skipped!"
fi
