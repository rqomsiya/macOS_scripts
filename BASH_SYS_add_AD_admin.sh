#!/bin/bash

# Adds user as administration by:"" based on AD Group. No offline Admin access.

CURRENTGROUPS=`dsconfigad -show | grep "Allowed admin groups" | awk 'BEGIN {FS = "="};{print $2}' | sed 's/ //'`
NEWGROUP="cguser\\$4"

dsconfigad -groups "$CURRENTGROUPS,$NEWGROUP"
VALIDATEGROUPS=`dsconfigad -show | grep "Allowed admin groups" | awk 'BEGIN {FS = "="};{print $2}' | sed 's/ //'`

if [ "$VALIDATEGROUPS" == "$CURRENTGROUPS,$NEWGROUP" ]
	then
		echo "$LOGHEADER $SCRIPTNAME result: Admin Groups configured successfully." >> /var/log/yourfile.log
		exit 0
	else
		echo "$LOGHEADER $SCRIPTNAME result: Unable to set admin groups." >> /var/log/yourfile.log
		exit 1
fi