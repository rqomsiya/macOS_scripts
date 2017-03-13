#!/bin/bash

##################
#Script information
##################
#Script: dockutil_Office_2016_Icons
#Purpose: Replaces existing Office 2011 icons with Office 2016 icons for all users



#########
#Variables
#########

SCRIPTNAME="dockutil_Office_2016_Icons"
dockutil="/Library/Application Support/yourfolder/Utilities/dockutil_2.0.2.py"
OUTLOOK2016="/Applications/Microsoft Outlook.app"
WORD2016="/Applications/Microsoft Word.app"
EXCEL2016="/Applications/Microsoft Excel.app"
POWERPOINT2016="/Applications/Microsoft PowerPoint.app"
ONENOTE2016="/Applications/Microsoft OneNote.app"
REMOTEDESKTOP="/Applications/Microsoft Remote Desktop.app"

#########
#SCRIPT
#########

#Remove 2011 icons for all users
"$dockutil" --remove 'Microsoft Outlook' --allhomes --no-restart
"$dockutil" --remove 'Microsoft OneNote' --allhomes --no-restart
"$dockutil" --remove 'Microsoft Word' --allhomes --no-restart
"$dockutil" --remove 'Microsoft Excel' --allhomes --no-restart
"$dockutil" --remove 'Microsoft PowerPoint' --allhomes --no-restart
"$dockutil" --remove 'Microsoft Remote Desktop Connection' --allhomes --no-restart
"$dockutil" --remove 'Microsoft Remote Desktop' --allhomes

sleep 2

#Add 2016 icons for all users
"$dockutil" --add "$REMOTEDESKTOP" --position beginning --allhomes --no-restart
"$dockutil" --add "$ONENOTE2016" --position beginning --allhomes --no-restart
"$dockutil" --add "$POWERPOINT2016" --position beginning --allhomes --no-restart
"$dockutil" --add "$EXCEL2016" --position beginning --allhomes --no-restart
"$dockutil" --add "$WORD2016" --position beginning --allhomes --no-restart
"$dockutil" --add "$OUTLOOK2016" --position beginning --allhomes


#Repeat for User Template - Remove 2011

"$dockutil" --remove 'Microsoft Outlook' --no-restart "/System/Library/User Template/English.lproj/Library/Preferences/com.apple.dock.plist"
"$dockutil" --remove 'Microsoft OneNote' --no-restart "/System/Library/User Template/English.lproj/Library/Preferences/com.apple.dock.plist"
"$dockutil" --remove 'Microsoft Word' --no-restart "/System/Library/User Template/English.lproj/Library/Preferences/com.apple.dock.plist"
"$dockutil" --remove 'Microsoft Excel' --no-restart "/System/Library/User Template/English.lproj/Library/Preferences/com.apple.dock.plist"
"$dockutil" --remove 'Microsoft PowerPoint' --no-restart "/System/Library/User Template/English.lproj/Library/Preferences/com.apple.dock.plist"
"$dockutil" --remove 'Microsoft Remote Desktop Connection' --no-restart "/System/Library/User Template/English.lproj/Library/Preferences/com.apple.dock.plist"
"$dockutil" --remove 'Microsoft Remote Desktop' --no-restart "/System/Library/User Template/English.lproj/Library/Preferences/com.apple.dock.plist"

#Repeat for User Template - Add 2016


"$dockutil" --add "$REMOTEDESKTOP" --position beginning --no-restart "/System/Library/User Template/English.lproj/Library/Preferences/com.apple.dock.plist"
"$dockutil" --add "$ONENOTE2016" --position beginning --no-restart "/System/Library/User Template/English.lproj/Library/Preferences/com.apple.dock.plist"
"$dockutil" --add "$POWERPOINT2016" --position beginning --no-restart "/System/Library/User Template/English.lproj/Library/Preferences/com.apple.dock.plist"
"$dockutil" --add "$EXCEL2016" --position beginning --no-restart "/System/Library/User Template/English.lproj/Library/Preferences/com.apple.dock.plist"
"$dockutil" --add "$WORD2016" --position beginning --no-restart "/System/Library/User Template/English.lproj/Library/Preferences/com.apple.dock.plist"
"$dockutil" --add "$OUTLOOK2016" --position beginning --no-restart "/System/Library/User Template/English.lproj/Library/Preferences/com.apple.dock.plist"

exit 0