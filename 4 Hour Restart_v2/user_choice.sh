#!/bin/bash

sleep 60

loggedInUser=$(stat -f%Su /dev/console)
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
windowType="hud"
description="There is a critical security update avaialble for your macOS computer. To perform the update, select 'UPDATE' and your computer will resetart. Once complete, you will be returned to the login window. If you are unable to perform this update at the moment, please select 'Cancel' and you will be given a 4 hour window before your machine automatically restarts.

*Please save all working documents before selecting 'UPDATE.'

If you require assistance, please contact the Helpdesk at x55777."

button1="UPDATE"
button2="Cancel"
icon="/Library/User Pictures/CG_icon.png"
title="Critical: Apple Security Update Available"
alignDescription="left" 
alignHeading="center"
defaultButton="2"
timeout="7200"

# JAMF Helper window as it appears for targeted computers
userChoice=$("$jamfHelper" -windowType "$windowType" -lockHUD -title "$title" -timeout "$timeout" -defaultButton "$defaultButton" -icon "$icon" -description "$description" -alignDescription "$alignDescription" -alignHeading "$alignHeading" -button1 "$button1" -button2 "$button2")

# If user selects "UPDATE"
if [ "$userChoice" == "0" ]; then
	echo "User clicked UPDATE; now downloading and installing all available updates."
	# Install ALL available software and security updates
	shutdown -r now
# If user selects "Cancel"
elif [ "$userChoice" == "2" ]; then
	echo "User clicked Cancel or timeout was reached; now exiting."
	bash /Library/Scripts/auto_create_LD_v2.sh
	exit 0    
fi