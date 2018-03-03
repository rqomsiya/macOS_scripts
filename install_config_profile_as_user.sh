#!/bin/bash

# Install user configuration profile
# Change *****.mobileconfig name to speific configuration name

# Wait until the Dock process has actually launched. This should solve any issues where this script runs and it hasn't.

until [[ $(pgrep Dock) ]]; do
    wait
done

dockPID=$(pgrep Dock)

until [[ $(ps -p $dockPID -oetime= | tr '-' ':' | awk -F: '{ total=0; m=1; } { for (i=0; i < NF; i++) {total += $(NF-i)*m; m *= i >= 2 ? 24 : 60 }} {print total}') -ge 1 ]]; do
    sleep 1
done

sleep 2

# Find current logged in user name (as we're running in root context)

loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

# Where's my profile file?
profile=$( find /Users/$loggedInUser/Desktop -maxdepth 1 -type f -iname "*.mobileconfig" )

# Install!
sudo -u $loggedInUser -i "profiles -I -F ${profile} -v"

exit 0
