#!/bin/bash
# JamfHelper Screen Lock

# Set Varibles
lastreboot=`uptime | awk '{print "Your last reboot was: " $3 " " $4 }' |
sed -e 's/.$//g'`
heading="$4" 

# This shows up above the image in a bigger bolder font than the description field
description="$lastreboot ago. $5"

# This shows up below the image in a smaller lighter font than the heading field

# Default description if none is passed through the variable
if [ "$4" == "" ]; then
heading="Installing Updates"
fi

if [ "$5" == "" ]; then
description="$lastreboot ago. Please do not close your laptop or unplug
anything until this screen disappears."
fi

# Script contents
/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType fs -icon "/Library/CG/logo.png" -heading "$heading" -description "$description" &

exit 0