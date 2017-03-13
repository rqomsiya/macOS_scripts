#!/bin/sh
## postinstall

pathToScript=$0
pathToPackage=$1
targetLocation=$2
targetVolume=$3

# Install the software

installer -package "/private/tmp/AnyConnect/AnyConnect.pkg" -target / -applyChoiceChangesXML "/private/tmp/AnyConnect/choices.xml"

# Hide the opt folder

chflags hidden /opt

# Remove the files from /private/tmp

/bin/rm -rf "/private/tmp/AnyConnect"

exit 0		## Success
exit 1		## Failure