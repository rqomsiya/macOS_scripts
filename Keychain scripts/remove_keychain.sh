#!/bin/sh

#  keychain_removal.sh
#  
#
#   jkim on 2/24/14.
#

CD="/Library/Application Support/JAMF/bin/CocoaDialog.app/Contents/MacOS/CocoaDialog"
loggedInUser=$(ls -l /dev/console|cut -d' ' -f4)

rm -f "/users/$loggedInUser/Library/Keychains/login.keychain"

if [ "$loggedInUser" != 'root' ]; then # Check if at the login window, if it is, the following code is skipped
#### CocoaDialog message box asking for the user to select restart
rv=`"$CD" msgbox --title "Restart Please" \
--text "To complete the Keychain Fix, a restart is required." \
--informative-text "It is important that you select Restart, but you may select Later to restart at a more convenient time." \
--no-newline --button1 "Restart" --button2 "Later" --float`
#### If the user selects restart, an apple script runs to run the Apple restart command. Gives the user a minute to cancel restart.
if [ "$rv" == "1" ]; then
echo "User selected Restart"
osascript -e 'tell application "loginwindow" to «event aevtrrst»'
elif [ "$rv" == "2" ]; then
echo "User selected Later"
exit
fi
else
echo "No User logged in. CocoaDialog not necessary"
fi