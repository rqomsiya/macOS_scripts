#!/bin/bash

clientIPV4=$(/opt/cisco/anyconnect/bin/vpn stats | grep "Client Address (IPv4):" | awk '{print $4}')

if [[ "$clientIPV4" != "" ]]; then
	echo "<result>$clientIPV4</result>"
else
	echo "<result>NON-VPN</result>"
fi
