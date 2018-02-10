#!/bin/bash

## Create network location "Automatic" and delete all other network locations
networksetup -createlocation Automatic populate 2> /dev/null
sleep 5
networksetup -switchtolocation Automatic 2> /dev/null
sleep 2
networksetup -deletelocation "Wi-Fi" 2> /dev/null
sleep 2
networksetup -deletelocation "Ethernet" 2> /dev/null
sleep 2
networksetup -deletelocation "Display Ethernet" 2> /dev/null
sleep 5

## Set proxy locations
# HARDCODED VALUES ARE SET HERE
autoProxyURL="http://cgproxy/prod.pac"

# CHECK TO SEE IF A VALUE WAS PASSED FOR $4, AND IF SO, ASSIGN IT
if [ "$4" != "" ] && [ "$autoProxyURL" == "" ]; then
autoProxyURL=$4
fi

# Detects all network hardware & creates services for all installed network hardware
/usr/sbin/networksetup -detectnewhardware

IFS=$'\n'

	#Loops through the list of network services
	for i in $(networksetup -listallnetworkservices | tail +2 );
	do
	
		# Get a list of all services
		autoProxyURLLocal=`/usr/sbin/networksetup -getautoproxyurl "$i" | head -1 | cut -c 6-`
		
		# Echo's the name of any matching services & the autoproxyURL's set
		echo "$i Proxy set to $autoProxyURLLocal"
	
		# If the value returned of $autoProxyURLLocal does not match the value of $autoProxyURL for the interface $i, change it.
		if [[ $autoProxyURLLocal != $autoProxyURL ]]; then
			/usr/sbin/networksetup -setautoproxyurl $i $autoProxyURL
			echo "Set auto proxy for $i to $autoProxyURL"
		fi
		
		# Enable auto proxy once set
		/usr/sbin/networksetup -setautoproxystate "$i" on
		echo "Turned on auto proxy for $i" 
	
	done

unset IFS

sleep 5

IFS=$'\n'

for i in $(networksetup -listallnetworkservices); do
	networksetup -setproxyautodiscovery "$i" off
	networksetup -setsearchdomains "$i" capgroup.com cguser.capgroup.com
	networksetup -setproxybypassdomains "$i" "*.local, 169.254/16, cguser.capgroup.com, capgroup.com"
	done

unset IFS

# Disables Bluetooth Pan and Thunderbolt Bridge

/usr/sbin/networksetup -setnetworkserviceenabled "Bluetooth PAN" off
/usr/sbin/networksetup -setnetworkserviceenabled "Thunderbolt Bridge" off

# Echo that we're done
echo "PAC proxy configured for all interfaces. AutoProxy Discovery Disabled on all interfaces."

exit 0
