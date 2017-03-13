#!/bin/bash

ScreenLock=$(profiles -Lv | awk '/attribute: name: CG_Symantec/,/attribute: profileUUID:/' | awk '/attribute: profileUUID:/ {print $NF}')
echo $ScreenLock
if [ -z "$ScreenLock" ]
then
echo "CP_ScrenLockTime_YOS profile not found."
else
echo "CP_ScrenLockTime_YOS profile found. Removing"
profiles -R -p "$ScreenLock"
fi
echo

sudo rm -rf /Library/CG/CG_Symantec_Interm_Cert.mobileconfig

exit 0