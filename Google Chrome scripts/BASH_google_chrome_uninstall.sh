#!/bin/bash

#Remove Google Chrome App from /Applications Folder
rm -rf /Applications/Google\ Chrome.app
#Remove System Library Google references
rm -rf /Library/Google/
# Get the name of the currently logged user
ConsoleUser=$(stat -f %Su "/dev/console")
rm -rf /Users/$ConsoleUser/Library/Caches/Google
rm -rf /Users/$ConsoleUser/Library/Google/

exit 0