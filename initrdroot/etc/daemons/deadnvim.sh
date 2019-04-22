#!/bin/sh

while [ 1 ]
do
	if ps -C nvim > /dev/null ; then
		sleep 1
	else
		poweroff -f
	fi
done
