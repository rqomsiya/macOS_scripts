#!/bin/bash

theuser=$(/usr/bin/who | awk '/console/{ print $1 }')
/usr/bin/osascript > /dev/null << EOT

	tell application "Finder" 
	activate
	mount volume "smb://capgroup.com/mydocs/${theuser}/my documents/"
	end tell


EOT

echo $theuser
killall cfprefsd
defaults write com.apple.finder ShowMountedServersOnDesktop true
