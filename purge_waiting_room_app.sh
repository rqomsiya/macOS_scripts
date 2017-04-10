#!/bin/bash

# declare variables and helpers
LogIt="/usr/bin/logger -t purgeWaitingRoom.bash "
STATUSCODE=0

# check for argument in first available argument slot under the JSS.
# Right now only operating with the assumption that there will only be one argument passed
if [ ! -z $4 ]
then
	pkgBaseName="$4"
	$LogIt Request to delete cached package $pkgBaseName
	echo "Packages to be deleted: $pkgBaseName"
else
	echo "No package name provided. Exiting with failure."
	$LogIt No package base name provided. Exiting.
	exit 1
fi

# find the cached packages in the Waiting Room, and use a while loop (hopefully white-space safe) to delete the package
echo "Finding previously-cached packages named $pkgBaseName"
find /Library/Application\ Support/JAMF/Waiting\ Room -name "$pkgBaseName*" -print0 | while read -d $'\0' pkg
do
	echo -n "Found $pkg ..."
	$LogIt Attempting to delete $pkg
	find /Library/Application\ Support/JAMF/Waiting\ Room -name $(basename "$pkg") -delete
	[[ $? = 0 ]] && echo "  Package deleted"; $LogIt SUCCESS - $pkg deleted || echo -e "\n###FAILED to delete package $pkg"; STATUSCODE=2
done

if [ $STATUSCODE != 0 ]
then
	echo "Unable to delete old package - code $STATUSCODE"
	$LogIt Unable to delete packages starting with name $pkgToDelete, error $STATUSCODE
else
	echo "Package purge successful"
fi

exit $STATUSCODE
