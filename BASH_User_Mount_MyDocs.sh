#!/bin/bash

# Program		: BASH_User_Mount_MyDocs.sh
# Purpose		: Mounts user MyDocs
# Called By		: n/a
# Owner			: Capital Group Companies
# Author		: Rany Qomsiya (RYQ)
# Note			: This software is provided "AS IS" basis. 

username="$3"
    if [ -z "$username" ]; then		# Checks if the variable is empty (user running script from Self Service)
        username="$USER"
    fi
    echo "User: $username"
protocol="$4"	# This is the protocol to connect with (afp | smb)
    echo "Protocol: $4"
serverName="$5"	# This is the address of the server, e.g. my.fileserver.com
    echo "Server: $5"
shareName="$6"	# This is the name of the share to mount
    echo "Sharename: $6"
group="$7"		# This is the name of the group the user needs to be a member of to mount the share
    echo "Group: $7"

# Check that the user is in the necessary group
	groupCheck=`dseditgroup -o checkmember -m $username "$group" | grep -c "yes"`
		if [ "${groupCheck}" -ne 1 ]; then
		exit 1
		fi
		
# Mount the drive
	mount_script=`/usr/bin/osascript > /dev/null << EOT
	tell application "Finder" 
	activate
	mount volume "$protocol://${serverName}/${shareName}"
	end tell
EOT`

exit 0