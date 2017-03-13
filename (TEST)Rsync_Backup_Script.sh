#!/bin/bash

user=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

# Create mount point
mkdir /Volumes/Macintosh\ HD/Users/$user/Backup
# Mount the share
mount -t smbfs cifs://capgroup.com/mydocs/$user/my%20documents /Volumes/Macintosh\ HD/Users/$user/Backup
# sleep 10 seconds
sleep 10
# Sync User Documents folder to My Docs
rsync -uhzrlv "/Users/$user/Documents/Jobs/" /Users/ryq/Backup

exit 0