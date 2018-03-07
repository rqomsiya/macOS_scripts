#!/bin/bash
# Written by RYQ (Capital Group Companies)
# Created 2/28/18
# Edited 3/2/18

# Variables
loggedInUser=`/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }'`
loggedInUserHome=`dscl . -read /Users/$loggedInUser NFSHomeDirectory | awk '{print $NF}'`
tld="*.capgroup.com,cgweb,cgweb2,teams,communities,projects,atm,*.okta.com,mysite,cgwebsocial,mysite"
authentication="negotiate,basic,digest,ntlm"
currentUser=$(stat -f %Su "/dev/console")

# Check to see if user is logged in as this is a requirement for the script to run. Script writes to logged in users Chrome pref file
if [[ "$currentUser" == "root" ]]; then
	echo "No user is logged in. Exiting script."
	exit 0
fi
# Check to see if Google Chrome is running (below script will quit Chrome so we want to make sure its not running)
if pgrep -x "Google Chrome"; then
	echo "Google Chrome is running. Exiting Script."
	exit 0
fi
		
# Start Google Chrome customizations
/bin/echo "*** Enable single sign-on in Google Chrome for $loggedInUser ***"
/bin/echo "Quit all Chrome-related processes"
/usr/bin/pkill -l -U ${loggedInUser} Chrome

if [ -f "/Users/$loggedInUser/Library/Preferences/com.google.Chrome.plist" ]; then

	# backup current file
	/bin/cp "/Users/$loggedInUser/Library/Preferences/com.google.Chrome.plist" "/Users/$loggedInUser/Library/Preferences/com.google.Chrome.plist.backup"
	/bin/echo "Preference archived as: /Users/$loggedInUser/Library/Preferences/com.google.Chrome.plist.backup"

	/usr/bin/defaults write /Users/$loggedInUser/Library/Preferences/com.google.Chrome.plist AuthNegotiateDelegateWhitelist $tld
	/bin/echo "AuthNegotiateDelegateWhitelist set to $tld for $loggedInUser"
	/usr/bin/defaults write /Users/$loggedInUser/Library/Preferences/com.google.Chrome.plist AuthServerWhitelist $tld
	/bin/echo "AuthServerWhitelist set to $tld for $loggedInUser"
	/usr/bin/defaults write /Users/$loggedInUser/Library/Preferences/com.google.Chrome.plist AuthSchemes $authentication
	/bin/echo "AuthSchemes set to $authentication for $loggedInUser"
	/usr/sbin/chown $loggedInUser /Users/$loggedInUser/Library/Preferences/com.google.Chrome.plist

	# Respawn cfprefsd to load new preferences
	/usr/bin/killall cfprefsd

else

	/bin/echo "Google preference not found for $loggedInUser"

fi

exit 0
