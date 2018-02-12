#!/bin/bash
# Logoff function only works on macOS 10.10.5 and 10.12.6 (still need to test 10.11.5 and 10.11.6)
# Get the logged in user's name
loggedInUser=$( ls -l /dev/console | awk '{print $3}' )
# Get the UID of the logged in user
loggedInUID=$(id -u "$loggedInUser")

install=$(/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "CG IT Security Updates" -heading "Security updates pending installation" -alignHeading center -description "Please SAVE all work and quit from all applications. You will be logged off, updates will be installed and your Mac will restart." -alignDescription center -icon /private/tmp/cg_logo.png -button1 "Install" -button2 "Cancel" -defaultButton 1 -cancelButton 2)

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
