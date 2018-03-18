#!/bin/bash

# Written by RYQ (Capital Group Companies)
# Created 3/16/2018
# Edited 3/17/2018

# Variables
process="Adobe Acrobat"
processrunning=$( pgrep Acrobat )
loggedInUser=$(stat -f%Su /dev/console)
jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
windowType="hud"
description="Your Mac requires a security update to Adobe Acrobat. This update will upgrade your Acrobat to the new DC version.

*Please save all working documents before selecting UPDATE.

If you require assistance, please contact the TSD by phone at x55777."

button1="UPDATE"
button2="Cancel"
icon="/tmp/adobe.png"
title="CG Security Update"
alignDescription="left" 
alignHeading="center"
defaultButton="2"
cancelButton="2"
timeout="7200"

# Script starts here...
userChoice=$("$jamfHelper" -windowType "$windowType" -lockHUD -title "$title" -timeout "$timeout" -defaultButton "$defaultButton" -cancelButton "$cancelButton" -icon "$icon" -description "$description" -alignDescription "$alignDescription" -alignHeading "$alignHeading" -button1 "$button1")

if [ "$userChoice" == "0" ]; then
    echo "User clicked UPDATE; now running Adobe Acrobat DC policy via JSS policy ID 1527."
fi	
# Runs checks to see if Acrobat is Running. NOTE: Edit jamf policy -id to whatever policy is applicable for Acrobat Pro
	if [ "$processrunning" != "" ]; then
	echo "$process found running"
	/bin/echo "Stopping process: $process"
	sudo kill -9 "${processrunning}"
	sudo jamf policy -id 1527
else
	sudo jamf policy -id 1527
fi
