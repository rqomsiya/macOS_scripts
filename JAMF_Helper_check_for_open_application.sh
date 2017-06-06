#!/bin/sh

####################################################################################################
#
# DEFINE VARIABLES & READ IN PARAMETERS
#
####################################################################################################
#
# A HARDCODED VALUE FOR "processName," "jamfPolicyType" and "eventorIDName" CAN BE SET BELOW.
#
# A list of accepted process name values can be verified in Activity Monitor.
#
# Delete the double quotes and replace with the desired process name and/or event name, e.g. 
# processName=Safari.app or eventorIDName=runSafariPolicy. For jamfPolicyType, pass "-id" or "-event."
# 
# If this script is to be deployed via policy using the JSS leave the next line as is.
#
####################################################################################################

processName="Microsoft Outlook"
jamfPolicyType="id"
eventorIDName=""

####################################################################################################
#
# SCRIPT CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 4 AND, IF SO, ASSIGN TO "processName"

if [[ "$4" != "" ]] && [[ "$processName" == "" ]]
then
	processName=$4
fi

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 5 AND, IF SO, ASSIGN TO "jamfPolicyType"

if [[ "$5" != "" ]] && [[ "$jamfPolicyType" == "" ]]
then
	jamfPolicyType=$5
fi

# CHECK TO SEE IF A VALUE WAS PASSED IN PARAMETER 6 AND, IF SO, ASSIGN TO "eventorIDName"

if [[ "$6" != "" ]] && [[ "$eventorIDName" == "" ]]
then
	eventorIDName=$6
fi

####################################################################################################
#
# JAMF HELPER CONTENTS - DO NOT MODIFY BELOW THIS LINE
#
####################################################################################################

icon="/Library/User Pictures/CG_icon.png"

jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
windowType="hud"
description="Please close the $processName application and retry."
button1="OK"
title="Warning: Application Running"
alignDescription="left" 
defaultButton="1"
cancelButton="1"
timeout="30"

####################################################################################################
#
# CHECK TO SEE IF THE SPECIFIED PROCESS IS RUNNING, THEN ECHO STATEMENT DEPENDING ON CONDITION
#
####################################################################################################

processRunning=$(ps axc | grep "${processName}$")
jamf="/usr/local/bin/jamf"

if [[ $processRunning != "" ]]
then
	 echo "$processName is running. Prompt user to close the application and re-run policy from Self Service."
	 #JAMF Helper
	 userChoice=$("$jamfHelper" \
-windowType "$windowType" \
-lockHUD \
-title "$title" \
-timeout "$timeout" \
-defaultButton "$defaultButton" \
-cancelButton "$cancelButton" \
-icon "$icon" \
-description "$description" \
-alignDescription "$alignDescription" \
-button1 "$button1")
else
	 echo "$processName is NOT running. Search for $jamfPolicyType triggered by $eventorIDName and install $processName."
	 $jamf policy $jamfPolicyType $eventorIDName
fi
