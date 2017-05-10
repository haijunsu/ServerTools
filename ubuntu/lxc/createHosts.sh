#!/bin/bash
for i in {1..120}
do
	if [ $i -lt 10 ]; then
		echo "00"$i
		lxc-copy -n u1 -N "student00"$i
	elif [ 9 -lt  $i -a  $i -lt 100 ]; then
		echo "0"$i
		lxc-copy -n u1 -N "student0"$i
	else
		echo $i
		lxc-copy -n u1 -N "student"$i
	fi	
done
