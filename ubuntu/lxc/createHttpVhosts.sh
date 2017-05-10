#!/bin/bash
for i in {1..120}
do
	echo $'<VirtualHost *:80>'
	if [ $i -lt 10 ]; then
		echo $'\t'ServerName student00${i}.cisdd.org
		echo $'\t'ServerAdmin root@cisdd.org
		echo $'\t'ErrorLog '${APACHE_LOG_DIR}'/error.log
		echo $'\t'CustomLog '${APACHE_LOG_DIR}'/access.log combined
		echo $'\t'ProxyPass "/" "http://10.0.3.10${i}/"
		echo $'\t'ProxyPassReverse "/" "http://10.0.3.10${i}/"
	elif [ 9 -lt  $i -a  $i -lt 100 ]; then
		echo $'\t'ServerName student0${i}.cisdd.org
		echo $'\t'ServerAdmin root@cisdd.org
		echo $'\t'ErrorLog '${APACHE_LOG_DIR}'/error.log
		echo $'\t'CustomLog '${APACHE_LOG_DIR}'/access.log combined
		echo $'\t'ProxyPass "/" "http://10.0.3.1${i}/"
		echo $'\t'ProxyPassReverse "/" "http://10.0.3.1${i}/"
	else
		echo $'\t'ServerName student${i}.cisdd.org
		echo $'\t'ServerAdmin root@cisdd.org
		echo $'\t'ErrorLog '${APACHE_LOG_DIR}'/error.log
		echo $'\t'CustomLog '${APACHE_LOG_DIR}'/access.log combined
		echo $'\t'ProxyPass "/" "http://10.0.3.$((${i}+100))/"
		echo $'\t'ProxyPassReverse "/" "http://10.0.3.$((${i}+100))/"
	fi	
	echo $'</VirtualHost>'
done
for i in {241..244}
do
	echo $'<VirtualHost *:80>'
		echo $'\t'ServerName tutor0$((${i}-240)).cisdd.org
		echo $'\t'ServerAdmin root@cisdd.org
		echo $'\t'ErrorLog '${APACHE_LOG_DIR}'/error.log
		echo $'\t'CustomLog '${APACHE_LOG_DIR}'/access.log combined
		echo $'\t'ProxyPass "/" "http://10.0.3.${i}/"
		echo $'\t'ProxyPassReverse "/" "http://10.0.3.${i}/"
	echo $'</VirtualHost>'
done
