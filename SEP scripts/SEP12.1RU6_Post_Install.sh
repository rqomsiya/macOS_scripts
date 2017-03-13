#!/bin/bash

cd /Users/Shared/
sleep 1
hdiutil mount /Users/Shared/SEP12RU6.dmg
sleep 1
cd /Volumes/Symantec\ Endpoint\ Protection/Additional\ Resources/SEP.mpkg 
sleep 1
sudo installer -pkg SEP.mpkg -target /
sleep 2
diskutil unmountDisk force /Volumes/Symantec\ Endpoint\ Protection 

rm /Users/Shared/SEP12RU6.dmg

exit 0