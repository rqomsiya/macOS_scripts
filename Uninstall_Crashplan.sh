#!/bin/bash

filelookingfor="/Library/Application\ Support/CrashPlan/Uninstall.app/Contents/Resources/uninstall.sh"

if [ -f $filelookingfor ];
then
# found the file do something
sudo /Library/Application\ Support/CrashPlan/Uninstall.app/Contents/Resources/uninstall.sh 
else
# didn't find the file, do something
echo "file not found"
fi
