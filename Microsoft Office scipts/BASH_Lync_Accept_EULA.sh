#!/bin/bash

user=$( ls -l /dev/console | awk '{print $3}' )

su $user -c "defaults write ~/Library/Preferences/com.microsoft.Lync acceptedSLT143 -bool true"
su $user -c "defaults write ~/Library/Preferences/com.microsoft.Lync UserHasRunMessenger143 -bool true"