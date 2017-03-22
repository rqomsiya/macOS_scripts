#!/bin/sh

# Script to check if the Tanium LaunchDaemon is installed and loaded
# If Tanium Launch Daemon is installed and loaded the result will be "Installed and loaded".
# If Tanium file is not present the result will be "Not Installed".
# If Tanium file is present but the LaunchDaemon is not loaded the result will be "Not loaded".



TaniumCheckLaunchDaemon="/Library/LaunchDaemons/com.tanium.taniumclient.plist"

if [[ -f "$TaniumCheckLaunchDaemon" ]]; then
	TaniumCheckLoaded=$(/bin/launchctl list | grep com.tanium.taniumclient)
		
		#if string is not empty
		if [ -n "${TaniumCheckLoaded}" ]; then
		result="Installed and loaded"
	else
	result="Not loaded"
	fi
else
	result="Not Installed"
fi

echo "<result>$result</result>"
