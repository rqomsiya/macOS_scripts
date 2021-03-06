#!/bin/bash
# Logoff function only works on macOS 10.10.5-10.12.6
# Get the logged in user's name
loggedInUser=$( ls -l /dev/console | awk '{print $3}' )
# Get the PID of the logged in user
loggedInPID=$(id -u "$loggedInUser")
# Get the UID of the logged in user
loggedInUID=$(id -u "$loggedInUser")
## Get a count of processes that match ScreenSaverEngine
ScreenSaverCheck=$(ps axc | grep "ScreenSaverEngine" | awk 'END {print NR}')

if [[ "$loggedInPID" != 0 ]] && [[ "$ScreenSaverCheck" == 0 ]]; then
     ## Someone is logged in and the screen saver isn't running. Continue
     install=$(/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "CG IT Security Updates" -heading "Security updates pending installation" -alignHeading center -description "Please SAVE all work and quit from all applications. You will be logged off, updates will be installed and your Mac will restart." -alignDescription center -icon /private/tmp/cg_logo.png -button1 "Install" -button2 "Cancel" -defaultButton 1 -cancelButton 2)
else
     ## Either the screen saver is running, or no-one is logged in, so exit
     exit 0
fi

# If the user clicks install
if [ "$install" == "0" ]; then
	echo "Installing"
# Then force log off user
/bin/launchctl asuser $loggedInUID /usr/bin/osascript -e 'tell application "loginwindow" to «event aevtrlgo»'

# if the user clicks cancel
elif [ "$install" == "2" ]; then
	 echo "User canceled installation ";   
     exit 1
fi
