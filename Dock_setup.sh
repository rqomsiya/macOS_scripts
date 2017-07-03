#!/bin/bash

loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

# Check for the presence of a file created by this script to determine if the Dock has already been configured and if so, exit
if [ -e /Users/$loggedInUser/Library/Preferences/uk.ac.uel.docksetup.plist ]; then
	echo "Dock already set up for user $loggedInUser, exiting..."
	exit 0
else
	echo "Dock has not been set up for user $loggedInUser, setting up now..."
	su - "$loggedInUser" -c '/usr/local/bin/dockutil --remove all --no-restart'
	sleep 1
        su "$loggedInUser" -c '/usr/local/bin/dockutil --add  "/Applications/Launchpad.app" --no-restart'
	su "$loggedInUser" -c '/usr/local/bin/dockutil --add  "/Applications/Lock Screen.app" --no-restart'
	su "$loggedInUser" -c '/usr/local/bin/dockutil --add  "/Applications/Self Service.app" --no-restart'
	su "$loggedInUser" -c '/usr/local/bin/dockutil --add  "/Applications/Google Chrome.app" --no-restart'
	su "$loggedInUser" -c '/usr/local/bin/dockutil --add  "/Applications/Safari.app" --no-restart'
	su "$loggedInUser" -c '/usr/local/bin/dockutil --add  "/Applications/Adobe After Effects CC 2017/Adobe After Effects CC 2017.app" --no-restart'
	su "$loggedInUser" -c '/usr/local/bin/dockutil --add  "/Applications/Adobe Illustrator CC 2017/Adobe Illustrator.app" --no-restart'
	su "$loggedInUser" -c '/usr/local/bin/dockutil --add  "/Applications/Adobe InDesign CC 2017/Adobe InDesign CC 2017.app" --no-restart'
	su "$loggedInUser" -c '/usr/local/bin/dockutil --add  "/Applications/Adobe Photoshop CC 2017/Adobe Photoshop CC 2017.app" --no-restart'
	su "$loggedInUser" -c '/usr/local/bin/dockutil --add  "/Applications/Adobe Premiere Pro CC 2017/Adobe Premiere Pro CC 2017.app" --no-restart'
	su "$loggedInUser" -c '/usr/local/bin/dockutil --add  "/Applications/Microsoft Word.app" --no-restart'
	su "$loggedInUser" -c '/usr/local/bin/dockutil --add  "/Applications/Microsoft PowerPoint.app" --no-restart'
	su "$loggedInUser" -c '/usr/local/bin/dockutil --add  "/Applications/Microsoft Excel.app" --no-restart'
	su "$loggedInUser" -c '/usr/local/bin/dockutil --add  "/Applications/Skype for Business.app" --no-restart'
	su "$loggedInUser" -c '/usr/local/bin/dockutil --add  "/Applications/BBEdit.app" --no-restart'
	su "$loggedInUser" -c '/usr/local/bin/dockutil --add  "/Applications/VLC.app" --no-restart'
	su "$loggedInUser" -c '/usr/local/bin/dockutil --add  "~/Downloads"'
	# Create an empty file to signify that the Dock has been set up
	touch /Users/$loggedInUser/Library/Preferences/uk.ac.uel.docksetup.plist
	exit 0
fi

exit 0
