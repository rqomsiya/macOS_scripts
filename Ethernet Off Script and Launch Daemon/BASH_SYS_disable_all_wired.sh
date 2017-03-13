#!/bin/bash

# Program		: BASH_SYS_disable_all_wired.sh
# Purpose		: Disables ethernet access on Developer machines
# Called By		: com.company.ethernet.plist (LaunchDaemon)
# Owner			: Capital Group Companies
# Author		: Rany Qomsiya (RYQ)
# Note			: This software is provided "AS IS" basis. 

while read networkService; do
	if ! [[ ${networkService} =~ .*Wi-Fi.* ]]; then
		networksetup -setnetworkserviceenabled "${networkService}" off
	fi
done < <( networksetup -listnetworkserviceorder | awk '/^\([0-9]/{$1 ="";gsub("^ ","");print}' )

exit 0