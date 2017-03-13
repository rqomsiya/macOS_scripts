#!/bin/bash

networksetup -listallnetworkservices | while read service;
do
	 networksetup -getinfo "$service" | grep 'Ethernet Address' > /dev/null
	 if [ $? -eq 0 ]
	 then
	echo "Violated"
	 fi
done