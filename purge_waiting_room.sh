#!/bin/sh

# Sometimes the cached packages stored in the JAMF Waiting Room folder are old or should be removed.
# This script will delete the entire folder.  The Waiting Room folder will reappear if a package or script is set to be cached to the computer.

if [ -e /Library/Application\ Support/JAMF/Waiting\ Room/ ]
    then
        echo "Removing cached packages"
        rm -rf /Library/Application\ Support/JAMF/Waiting\ Room/
    else
        echo "The waiting room folder wasn't there.  No cached files to delete."
fi
