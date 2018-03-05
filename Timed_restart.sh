#!/bin/bash

initRestart() {
# Create restart script
echo > /tmp/restartscript.sh '#!/bin/bash
timerSeconds=14400
cdPath="/Applications/Utilities/cocoaDialog.app/Contents/MacOS/CocoaDialog"
cdTitle="CG IT - Restart Required: This Mac will restart in 4 hours"
rm -f /tmp/hpipe
mkfifo /tmp/hpipe
sleep 0.2
$cdPath progressbar --title "$cdTitle" --text "Your Mac will restart in 4 hours..." \
--posX "left" --posY "top" --width 300 --float \
--icon-file "/tmp/cg_icon.png" \
--icon-height 48 --icon-width 48 --height 90 < /tmp/hpipe &
exec 3<> /tmp/hpipe
echo "100" >&3
sleep 1.5
startTime=`date +%s`
stopTime=$((startTime+timerSeconds))
secsLeft=$timerSeconds
progLeft="100"
barTick=$((timerSeconds/progLeft))
while [[ "$secsLeft" -gt 0 ]]; do
    sleep 1
    currTime=`date +%s`
    progLeft=$((secsLeft*100/timerSeconds))
    secsLeft=$((stopTime-currTime))
    minRem=$((secsLeft/60))
    secRem=$((secsLeft%60))
    echo "$progLeft $minRem minute(s) $secRem seconds until restart." >&3
done
shutdown -r now'

# Create and load a LaunchDaemon to fork a restart
echo "<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.company.restart</string>
    <key>UserName</key>
    <string>root</string>
    <key>ProgramArguments</key>
    <array>
        <string>sh</string>
        <string>/tmp/restartscript.sh</string>
        <string>$rebootSeconds</string>
        <string>$cocoaDialogPath</string>
        <string>$restartTitle</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>" > /tmp/restart.plist
launchctl load /tmp/restart.plist
}

initRestart
