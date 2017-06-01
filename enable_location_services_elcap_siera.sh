#!/bin/bash

## Unload locationd
/bin/launchctl unload /System/Library/LaunchDaemons/com.apple.locationd.plist

## Get the version of Mac OS
OS_Version=$(sw_vers -productVersion)

if [[ $OS_Version == 10.11* ]] ; then
    ## Write enabled value to plist (El Cap)
    uuid=$(/usr/sbin/system_profiler SPHardwareDataType | grep "Hardware UUID" | cut -c22-57)
    /usr/bin/defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd."$uuid" LocationServicesEnabled -int 1
    /usr/bin/defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd.notbackedup."$uuid" LocationServicesEnabled -int 1
elif [[ $OS_Version == 10.12* ]]  ; then
    ## Write enabled value to locationd plist (Sierra)
    defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd LocationServicesEnabled -int 1
fi ## If OS is not 10.11 or 10.12, do nothing

## Fix Permissions for the locationd folder
/usr/sbin/chown -R _locationd:_locationd /var/db/locationd

## Reload locationd
/bin/launchctl load /System/Library/LaunchDaemons/com.apple.locationd.plist

exit 0
