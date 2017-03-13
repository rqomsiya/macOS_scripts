#!/bin/bash
timerSeconds="14400"
cdPath="/Library/Application Support/JAMF/bin/cocoaDialog.app/Contents/MacOS/cocoaDialog"
rm -f /tmp/hpipe
mkfifo /tmp/hpipe
sleep 0.2
"$cdPath" progressbar --title "Restart Required: Mac Security Updates" --text "Your machine will automatically restart in 4 hours..." \
--posX "center" --posY "199" --width 800 --float \
--icon-file "/Library/User Pictures/CG_icon.png" \
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
	echo "$progLeft $minRem minute(s) $secRem seconds until your machine restarts. You may also restart your computer manually to dismiss this message." >&3
done