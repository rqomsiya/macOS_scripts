#!/bin/bash
if [[ -f "/Library/LaunchDaemons/com.tanium.taniumclient.plist" ]]; then 
	isTaniumInstalled="Installed"
else
	isTaniumInstalled="Not Installed"
fi

echo "<result>$isTaniumInstalled</result>"
