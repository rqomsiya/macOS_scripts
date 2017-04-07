#!/bin/bash

theuser=$(/usr/bin/who | awk '/console/{ print $1 }')
/usr/bin/osascript > /dev/null << EOT

	tell application "Finder" 
		if not (disk "my documents" exists) then
			mount volume "smb://capgroup.com/mydocs/${theuser}/my documents/"
		end if
	end tell


EOT

echo $theuser My Documents server volume mounted on desktop.
killall cfprefsd
defaults write com.apple.finder ShowMountedServersOnDesktop true
