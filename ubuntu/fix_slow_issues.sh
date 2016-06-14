#!/bin/bash

# disable DNS to speedup login
SSH_MODIFIED=`grep "UseDNS no" /etc/ssh/sshd_config | wc -l`  
if [ ${SSH_MODIFIED} -ne 1 ]; then
	echo "Fixing SSH ..."
	echo "UseDNS no" >> /etc/ssh/sshd_config
	service ssh restart
else
	echo "SSH has been fixed. Skipped!"
fi

# shutdown reboot hung problem
echo "Fixing hung task timout ..."
echo 0 > /proc/sys/kernel/hung_task_timeout_secs
echo "Done!"
