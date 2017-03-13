#!/bin/bash

cd /Users/Shared/
sleep 1
hdiutil mount /Users/Shared/Tanium_OSXCPZ.iso
sleep 1
cd /Volumes/Tanium_OSX
sleep 1
sudo installer -pkg TaniumClient-6.0.314.1442.pkg -target /
sleep 2
sudo launchctl unload /Library/LaunchDaemons/com.tanium.taniumclient.plist
sleep 1
sudo launchctl load /Library/LaunchDaemons/com.tanium.taniumclient.plist

diskutil unmountDisk force /Volumes/Tanium_OSX

rm /Users/Shared/Tanium_OSXCPZ.iso

exit 0