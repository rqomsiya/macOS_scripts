#!/bin/bash

##Ensure CD is installed in "/Applications/Utilities" folder
##Ensure that CG_icon.png is located in "/Library/Users Pictures" folder

CD="/Applications/Utilities/cocoaDialog.app/Contents/MacOS/cocoaDialog"

loggedInUser=$(ls -l /dev/console|cut -d' ' -f4)
if [ "$loggedInUser" != 'root' ]; then 
	
#### Check if at the login window, if it is, the following code is skipped
#### CocoaDialog message box asking for the user to select restart

rv=`$CD msgbox --title "Restart Please" \
--text "An important update has been installed and requires a restart" \
--icon-file "/Library/User Pictures/CG_icon.png" \
--informative-text "Please save your work and select a restart option below." \
--no-newline --button1 "Restart Now" --button2 "Restart in 5 Minutes" --button3 "Restart in 20 Minutes" --float`
#### If the user selects restart, an apple script runs to run the Apple restart command. Gives the user a minute to cancel restart.
 if [ "$rv" == "1" ]; then
	echo "User selected Restart"
	/sbin/shutdown -r now
 elif [ "$rv" == "2" ]; then
	echo "User selected 5 minutes"

timerSeconds="300"

rm -f /tmp/hpipe
mkfifo /tmp/hpipe
sleep 0.2

"$CD" progressbar --title "Please Restart Your Computer" --text "Preparing to reboot this Mac..." \
--posX "center" --posY "199" --width 600 --float \
--icon-file "/usr/local/assets/rh.png" \
--icon-height 48 --icon-width 48 --height 90 < /tmp/hpipe &

## Send progress through the named pipe
exec 3<> /tmp/hpipe

echo "100" >&3

sleep 1.5

startTime=`date +%s`
stopTime=$((startTime+timerSeconds))
secsLeft=$timerSeconds
progLeft="100"

while [[ "$secsLeft" -gt 0 ]]; do
		sleep 1
		currTime=`date +%s`
		progLeft=$((secsLeft*100/timerSeconds))
		secsLeft=$((stopTime-currTime))
		minRem=$((secsLeft/60))
		secRem=$((secsLeft%60))
		echo "$progLeft $minRem minute(s) $secRem seconds until your Mac reboots. Please save any work now." >&3
done

/sbin/shutdown -r now


	exit

	 elif [ "$rv" == "3" ]; then
	echo "User selected 20 minutes"

	timerSeconds="1200"

rm -f /tmp/hpipe
mkfifo /tmp/hpipe
sleep 0.2

"$CD" progressbar --title "Please Restart Your Computer" --text "Preparing to reboot this Mac..." \
--posX "center" --posY "199" --width 600 --float \
--icon-file "/usr/local/assets/rh.png" \
--icon-height 48 --icon-width 48 --height 90 < /tmp/hpipe &

## Send progress through the named pipe
exec 3<> /tmp/hpipe

echo "100" >&3

sleep 1.5

startTime=`date +%s`
stopTime=$((startTime+timerSeconds))
secsLeft=$timerSeconds
progLeft="100"

while [[ "$secsLeft" -gt 0 ]]; do
		sleep 1
		currTime=`date +%s`
		progLeft=$((secsLeft*100/timerSeconds))
		secsLeft=$((stopTime-currTime))
		minRem=$((secsLeft/60))
		secRem=$((secsLeft%60))
		echo "$progLeft $minRem minute(s) $secRem seconds until your Mac reboots. Please save any work now." >&3
done

/sbin/shutdown -r now

	exit
 fi
else
 echo "No User logged in. CocoaDialog not necessary"
fi