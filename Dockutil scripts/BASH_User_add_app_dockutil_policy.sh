#!/bin/sh
####################################################################################################
#
# Add apps to dock with in Variable #4. This utilizes DockUtil.
#
####################################################################################################

###
# Get the Username of the logged in user
###
loggedInUser=`/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }'`

echo "$loggedInUser..."

# HARDCODED VALUES ARE SET HERE

# Applications Path, specify full path as in: /Applications/Safari.app
appPath=""

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "appPath"
if [ "$4" != "" ] && [ "$appPath" == "" ];then
    appPath=$4
fi

##
# Error if variable appPath is empty
##
if [ "$appPath" == "" ]; then
	echo "Error:  No value was specified for the appPath variable..."
	exit 1
fi

###
# Add the App as given at $appPath
###

echo "Will add "$appPath"..."

sudo -u "$loggedInUser" /usr/local/bin/dockutil --add "$appPath" /Users/"$loggedInUser"

echo "Added "$appPath" to /Users/"$loggedInUser"..."