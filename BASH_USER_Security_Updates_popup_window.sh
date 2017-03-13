#!/bin/bash

# Get the logged in user's name
loggedInUser=$( ls -l /dev/console | awk '{print $3}' )
# Get the PID of the logged in user
loggedInPID=$( ps -axj | awk "/^$loggedInUser/ && /Dock.app/ {print \$2;exit}" )

install=$(/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "CG-Security Updates" -heading "Please EXIT and SAVE all applications before logging off!" -alignHeading center -description "You will be logged off and pending updates will be installed." -icon /Library/CG/CG_icon.png -button1 "Install" -button2 "Cancel" -defaultButton 1 -cancelButton 2)

# If the user clicks install
if [ "$install" == "0" ]; then
	echo "Installing"
# Then force log off user
	/bin/launchctl bsexec "${loggedInPID}" sudo -iu "${loggedInUser}" "/usr/bin/osascript -e 'tell application \"System Events\" to keystroke \"q\" using {command down, option down, shift down}'"
	exit 0

# if the user clicks cancel
elif [ "$install" == "2" ]; then
	 echo "User canceled installation ";   
     exit 1
fi
