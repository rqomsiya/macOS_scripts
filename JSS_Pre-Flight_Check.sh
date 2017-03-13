#!/bin/bash
​
#This script is meant to be used in Casper. It will check for a process running in the background.
#If the process is running, nothing happens.
#If the process is not running, another policy is triggered via a custom trigger
​
#Notes:
# $4 is a JSS variable and will be used to determine the custom trigger to run another policy
# $5-10 are JSS variables and will contain the name of the process we are checking.
# $11 is a JSS variable and should include the amount of free space required for the app in GB (e.g. 2)
​
process1="$5"
process2="$6"
process3="$7"
process4="$8"
process5="$9"
process6="${10}"
​
#Variables to determine disk space needed for policy
needed_free_space="${11}"
available_free_space=$(df -g / | tail -1 | awk '{print $4}')
​
if [[ "$needed_free_space" != "None" ]] || [[ -n "$needed_free_space" ]]; then
	if [[ "$available_free_space" -lt "$needed_free_space" ]]; then
		/bin/echo "Insufficient free space. $available_free_space gigabytes found as free space on boot drive, but $needed_free_space gigabytes is needed. Not proceeding with install."
		exit 1
	fi
fi
​
if [[ "$available_free_space" -ge "$needed_free_space" ]]; then
	/bin/echo "$available_free_space gigabytes of free space on boot drive. Proceeding with install."
​
	processrunning1=$( ps axc | grep "${process1}$" )
	processrunning2=$( ps axc | grep "${process2}$" )
	processrunning3=$( ps axc | grep "${process3}$" )
	processrunning4=$( ps axc | grep "${process4}$" )
	processrunning5=$( ps axc | grep "${process5}$" )
	processrunning6=$( ps axc | grep "${process6}$" )
​
	if [ "$processrunning1" != "" ]; then
		/bin/echo "$process1 is running. Cannot continue with installation."
		exit 1
	elif [ "$processrunning2" != "" ]; then
			/bin/echo "$process2 is running. Cannot continue with installation."
			exit 2
	elif [ "$processrunning3" != "" ]; then
				/bin/echo "$process3 is running. Cannot continue with installation."
				exit 3
	elif [ "$processrunning4" != "" ]; then
					/bin/echo "$process4 is running. Cannot continue with installation."
					exit 4
	elif [ "$processrunning5" != "" ]; then
						/bin/echo "$process5 is running. Cannot continue with installation."
						exit 5
	elif [ "$processrunning6" != "" ]; then
							/bin/echo "$process6 is running. Cannot continue with installation."
							exit 6
	else
		/bin/echo "Application processes are not running. Installation will continue."
		jamf policy -trigger "$4"
	fi
fi