#!/bin/bash
for i in {1..120}
do
	if [ $i -lt 10 ]; then
		echo student00$i,10.0.3.10$i
	elif [ 9 -lt  $i -a  $i -lt 100 ]; then
		echo student0$i,10.0.3.1$i
	else
		echo student$i,10.0.3.$(($i+100))
	fi	
done
