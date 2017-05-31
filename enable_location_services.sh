#!/bin/bash

## Unload locationd
launchctl unload /System/Library/LaunchDaemons/com.apple.locationd.plist

## Write enabled value to locationd plist
defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd LocationServicesEnabled -int 1

## Fix Permissions for the locationd folder
chown -R _locationd:_locationd /var/db/locationd

## Reload locationd
launchctl load /System/Library/LaunchDaemons/com.apple.locationd.plist

exit 0
