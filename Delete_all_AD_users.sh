#!/bin/bash
################################################################################
# DeleteADUsers.sh
#
# Requires Mac OS X 10.10 or newer
# If run as root, deletes all AD accounts
# If user is logged in, asks to verify login ID and will not delete that account
################################################################################

adusers=$(dscl . list /Users UniqueID | awk '$2 > 1000 {print $1}')
currentuser=$(stat -f "%Su" /dev/console)
response="2" # Presume confirmation failure

if [[ "$currentuser" != "root" ]]; then
    # If we're not root, ask user to verify their login ID
    response=$(/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "Verify login ID" -heading "Verify login ID" -description "Please verify that $currentuser is your login ID" -button1 "That's Me" -button2 "Not Me")
    if [ "$response" != "0" ]; then
       echo "Did not get confirmation from user, no accounts will be deleted"
    fi
else
    echo "Running as root, so all AD accounts will be deleted"
    response="0" # Always set confirmation response when root
fi

if [ "$response" == "0" ]; then
    echo "Deleting AD user accounts..."

    for user in $adusers ; do
        if [ "$user" != "$currentuser" ]; then
            /usr/sbin/sysadminctl -deleteUser "$user"
            echo "$user deleted"
        fi
    done
fi
