#!/bin/bash

# Tanium Uninstall Script

sudo launchctl unload /Library/LaunchDaemons/com.tanium.taniumclient.plist
sleep 1
sudo rm /Library/LaunchDaemons/com.tanium.taniumclient.plist
sleep 1
sudo rm -r /Library/Tanium

exit 0

