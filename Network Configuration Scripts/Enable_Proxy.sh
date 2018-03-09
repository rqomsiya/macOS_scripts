#!/bin/sh

# HARDCODED VALUES ARE SET HERE
autoProxyURL="http://cgproxy.cguser.capgroup.com/prod.pac"

# CHECK TO SEE IF A VALUE WAS PASSED FOR $4, AND IF SO, ASSIGN IT
if [ "$4" != "" ] && [ "$autoProxyURL" == "" ]; then
autoProxyURL=$4
fi

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
for i in $(networksetup -listallnetworkservices | tail +2 ); do
	networksetup -setproxyautodiscovery "$i" off
	done

# Echo that we're done
echo "PAC proxy configured for all interfaces. AutoProxy Discovery Disabled on all interfaces."
