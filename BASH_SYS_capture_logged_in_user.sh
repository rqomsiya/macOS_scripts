#!/bin/bash

username=$(defaults read /Library/Preferences/com.apple.loginwindow.plist lastUserName)
## username=$(/usr/bin/last -1 -t console | awk '{print $1}')
sleep 1
jamf recon -endUsername "$username"

exit 0