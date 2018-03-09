#!/bin/bash
# Configure Adobe Flash to *not* update
#
# Modified by Chris Jackson, 3-Mar-2016
# Original by Dan K. Snelson, 7-Nov-2014
#
# Inspired by Lance Berrier
# https://jamfnation.jamfsoftware.com/viewProfile.html?userID=12774

directory="/Library/Application Support/Macromedia/"
file="/Library/Application Support/Macromedia/mms.cfg"

if [ -f "$file" ] ; then

	# Flash Player is installed, has been launched and mms.cfg exists
	# let's configure it to not update

	grep -q -r "AutoUpdateDisable" "$file" && sed -i '' 's/AutoUpdateDisable=0|AutoUpdateDisable=1/AutoUpdateDisable=1/g' "$file" || echo 'AutoUpdateDisable=1' >> "$file"
	grep -q -r "SilentAutoUpdateEnable" "$file" && sed -i '' 's/SilentAutoUpdateEnable=0|SilentAutoUpdateEnable=1/SilentAutoUpdateEnable=0/g' "$file" || echo "SilentAutoUpdateEnable=0" >> "$file"
	grep -q -r "DisableAnalytics" "$file" && sed -i '' 's/DisableAnalytics=0|DisableAnalytics=1/DisableAnalytics=1/g' "$file" || echo "DisableAnalytics=1" >> "$file"

	RESULT="Configured"

else

	# mms.cfg doesn't exsist

	mkdir "${directory}"

	echo "AutoUpdateDisable=1" >> "$file"
	echo "SilentAutoUpdateEnable=0" >> "$file"

	RESULT="Created and configured"

fi

echo "<result>$RESULT</result>"
