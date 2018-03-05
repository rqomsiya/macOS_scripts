#!/bin/sh

# Get the account username
LocalUser=`/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }'`

# Unload the LaunchAgent
launchctl unload /Library/LaunchAgents/com.trusourcelabs.NoMAD.plist

# Give it 5 seconds to unload the LaunchAgent
sleep 5

echo "LaunchAgent unloaded."

# Remove the prefs file, the LaunchAgent and the application
defaults delete com.trusourcelabs.NoMAD.plist
rm -f /Users/$LocalUser/Library/Preferences/com.trusourcelabs.NoMAD.plist
rm -f /Library/LaunchAgents/com.trusourcelabs.NoMAD.plist
rm -rf /Applications/NoMAD.app

echo "Components removed."

# Give it 5 seconds before killing NoMAD
sleep 5

# quit NoMAD
killall NoMAD

echo "NoMAD killed."

exit 0
