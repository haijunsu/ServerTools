It is a problem to save iptables settings with different Ubuntu version. In order to make sure ip forwarding works well, you need to create a script in /etc/network/if-up.d/<script name>. For example, the script name is tiqc.
sudo vi /etc/network/if-up.d/tiqc

#!/bin/bash
FLAG="/tmp/tiqc_ipforwording"
if [ -f ${FLAG} ]; then
  echo "Already set iptables rules. Skip it."
  exit 0
fi
SCRIPTS_FOLDER="/home/navysu/projects/ServerTools/ubuntu/iptables-tools"
if [ -f ${SCRIPTS_FOLDER}/addLocalNAT.sh ]; then
  # add iptables rule here

  # mailman port forwarding
  ${SCRIPTS_FOLDER}/addLocalNAT.sh ens3 80 10.0.5.11 80

  # mailserver port forwarding
  ${SCRIPTS_FOLDER}/addLocalNAT.sh ens3 25 10.0.5.10 25

fi

#if [ -f ${SCRIPTS_FOLDER}/addRemoteNAT.sh ]; then
  # add iptables rule here

#fi
touch ${FLAG}
exit 0
