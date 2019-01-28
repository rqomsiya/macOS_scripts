#!/bin/bash

#####################################################################################################
#
# ABOUT THIS PROGRAM
#
# NAME
#   MindManagerSettings.sh -- Set License and accept EULA
#
#
####################################################################################################
#
# HISTORY
#
#   Version: 1.0
#   - Philipp Reinheimer, 14.04.18
#
####################################################################################################


#---Variables---#
currentuser=$(/bin/ls -la /dev/console | /usr/bin/cut -d ' ' -f 4)

#---LicenseKey and Settings---#
su -l $currentuser -c "defaults -currentHost write com.mindjet.mindmanager.11 LicenseKey 'APxxxx-xxxx-xxxx-xxxx'"
su -l $currentuser -c "defaults -currentHost write com.mindjet.mindmanager.11 ShowEULA -int 0"
su -l $currentuser -c "defaults -currentHost write com.mindjet.mindmanager.11 Edition -int 0"

su -l $currentuser -c "defaults write /Users/$currentuser/Library/Preferences/com.mindjet.mindmanager.11 DeviceAutoUpdateDisabled -bool false"
su -l $currentuser -c "defaults write /Users/$currentuser/Library/Preferences/com.mindjet.mindmanager.11 FirstLaunch -bool false"
su -l $currentuser -c "defaults write /Users/$currentuser/Library/Preferences/com.mindjet.mindmanager.11 StartupDialogPolicy -int 3"
su -l $currentuser -c "defaults write /Users/$currentuser/Library/Preferences/com.mindjet.mindmanager.11 NewDocumentOnStart -int 1"

echo $currentuser

exit 0
