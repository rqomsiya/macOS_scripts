#!/bin/bash

LYNC_PID=$(ps ax | grep "/Applications/Microsoft Lync.app/Contents/MacOS/Microsoft Lync" | grep -v grep | awk '{ print $1 }')
kill -9 ${LYNC_PID} 2>/dev/null

USER_LIST=`dscl . list /Users UniqueID | awk '$2 > 500 { print $1 }'`
for USER in ${USER_LIST};
do
rm -rf "/Users/$USER/Library/Preferences/com.microsoft.Lync.plist" 2>/dev/null
rm -rf "/Users/$USER/Library/Preferences/ByHost"/MicrosoftLyncRegistrationDB.*.plist 2>/dev/null
rm -rf "/Users/$USER/Library/Logs"/Microsoft-Lync*.log* 2>/dev/null
rm -rf "/Users/$USER/Documents/Microsoft User Data/Microsoft Lync Data" 2>/dev/null
rm -rf "/Users/$USER/Documents/Microsoft User Data/Microsoft Lync History" 2>/dev/null
rm -rf "/Users/$USER/Library/Keychains/"OC* 2>/dev/null
done

rm -R "/Applications/Microsoft Lync.app" 2>/dev/null
rm -R "/Library/Internet Plug-Ins/MeetingJoinPlugin.plugin" 2>/dev/null

exit 0
