#!/bin/bash
if [[ -f "/Library/LaunchDaemons/com.tanium.taniumclient.plist" ]]; then 
    isTaniumInstalled="T"
else
    isTaniumInstalled="F"
fi
printf "<result>%s</result>" "%s"
