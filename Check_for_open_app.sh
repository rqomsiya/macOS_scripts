#!/bin/bash

# Pass Variables in JSS Policy Script Window
# Pass Trigger variable "5". Ensure you have a policy with the same trigger name

process="$4"

processrunning=$( ps axc | grep "${process}$" )
if [ "$processrunning" != "" ]; then
	echo "$process IS running, try again tomorrow."
else
	/bin/echo "$process IS NOT running, will try to update it now."
	/usr/sbin/jamf policy -trigger "$5"
fi