#!/bin/bash
 
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
     echo "Not running as root or using sudo"
     exit
fi
 
launchctl unload /Library/LaunchDaemons/com.tanium.taniumclient.plist
launchctl remove com.tanium.taniumclient > /dev/null 2>&1
rm /Library/LaunchDaemons/com.tanium.taniumclient.plist
rm /Library/LaunchDaemons/com.tanium.trace.recorder.plist
rm -rf /Library/Tanium/
rm /var/db/receipts/com.tanium.taniumclient.TaniumClient.pkg.bom
rm /var/db/receipts/com.tanium.taniumclient.TaniumClient.pkg.plist 
