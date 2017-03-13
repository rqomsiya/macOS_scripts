#!/bin/bash

jHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"

## 72 hours = 3 days in hours. 
maxHours="72"    

timeNow=$(date +"%s")
upTimeSecs=$(sysctl kern.boottime | awk -F'[= |,]' '{print $6}')
upTimeHours=$(($((timeNow-upTimeSecs))/60/60))

echo "Uptime hours: $upTimeHours"

msg="Your Mac has now been running for at least $upTimeHours hours between reboots.

Please reboot your Mac as soon as its convenient to in order to maintain smooth operation of your system."

icon="/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/Toolbarinfo.icns"

if (( $upTimeHours >= $maxHours )); then
	echo "Mac has been up for more than $maxHours hours"

	"$jHelper" -windowType utility -description "$msg" -button1 OK -icon "$icon" -iconSize 90
	exit 0
else
	echo "Mac has been up for less than $maxHours hours. Exiting."
	exit 0
fi


## Dialog Message to Enduser
jamf reboot -minutes 20 -message "Your Mac will reboot in 20 minutes to maintain smooth working order. Please close any open work now to avoid data loss of unsaved documents." -background