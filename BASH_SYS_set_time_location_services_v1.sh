#!/bin/bash

########################## SET SYSTEM TIME/ Enable Location ##################################################
#
# If the machine is 5 minutes out of the kdc the machine will not bind to the domain.
#
# This script does the folling to ensure the time is correct
#
# 1. Unload the launch daemon used for location services
#
# 2. Get the hardware UUID of the machine and put it in the location services db
#
# 3. Enable location services
#
# 4. Correct permissions on the database file used for location services
#
# 5. Set the time zone to update the time automatically
#
# 6. Set the network time to on
#
###############################################################################################

######################### ENVIRONMENT VARIABLES #######################

# Get the Hardware UUID from system profiler
uuid=$(/usr/sbin/system_profiler SPHardwareDataType | grep "Hardware UUID" | cut -c22-57)

####################### DO NOT MODIFY BELOW THIS LINE #################

# Unload the launch daemon
/bin/launchctl unload /System/Library/LaunchDaemons/com.apple.locationd.plist

# Write the UUID to the hidden plist file and initialise it
/usr/bin/defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd."$uuid" LocationServicesEnabled -int 1

# Enable Location Services
/usr/bin/defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd.notbackedup."$uuid" LocationServicesEnabled -int 1

# Make sure the permissions on the database file is correct
/usr/sbin/chown -R _locationd:_locationd /var/db/locationd
/bin/launchctl load /System/Library/LaunchDaemons/com.apple.locationd.plist

# Set time zone to update automatically
/usr/bin/defaults write /Library/Preferences/com.apple.timezone.auto Active -bool true

# Set network time to on
/usr/sbin/systemsetup -setusingnetworktime on > /dev/null 2>&1

exit 0