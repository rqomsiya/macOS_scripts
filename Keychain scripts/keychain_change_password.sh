#!/bin/bash

# Program		: keychain_change_password_asst.sh
# Purpose		: Keychain walkthrough/logs off to update keychain
# Owner			: Capital Group Companies
# Author		: Rany Qomsiya (RYQ)
# Note			: This software is provided "AS IS" basis.
# Revisions		: 2016-01-03: Rev1.0a
# Updated (Last): 2016-01-25: Rev1.1a

MINPASSWORDAGE=5
MAXPASSWORDAGE=90
# Making DAYSWARNING the same as MAXPASSWORDAGE will make it so it will prompt the user regardless of age
# This is specifically for running through Self Service
# Non-interactive/background process should be set to 10 or something
DAYSWARNING=$MAXPASSWORDAGE
USER=`stat -f%Su /dev/console`
PROXYADDRLONG="..."
PROXYADDRSHORT="..."
PROXYPORT=8080
#DOMAIN=`dsconfigad -show | grep -m 1 Domain | awk '{ print $5 }'`
MAILSERVER="..."

################################################################################

if [ "$USER" == "admin" ] || [ "$USER" == "administrator" ] || [ "$USER" == "root" ]; then
	# local admin users, don't go any further
	echo "Local admin account, exiting..." >&2
	exit 0
fi

if [ `dsconfigad -show | grep Namespace | awk '{ print $4 }'` != "domain" ]; then
	# Mac is not bound to the domain, so accounts will only be local. Don't go any further
	# Technically, this condition should never be met
	echo "Not bound to domain, exiting..." >&2
	exit 0
fi

if [ ! -d "/Users/$USER" ]; then
	# Home path does not exist. Not a mobile account? Don't go any further
	echo "No home directory exists, exiting..." >&2
	exit 0
fi

if [[ -z `id "$USER" | grep Domain` ]]; then
	echo "Local user account, exiting..." >&2
	exit 0
fi

# Retrieves SMBPasswordLastSet from AD
#SMBDATE=`dscl localhost read "/Search/Users/$USER" SMBPasswordLastSet | grep -m 1 SMBPasswordLastSet | awk '{ print $2 }'`

# TODO: Add some logic here for userAccountControl to determine if password can be changed, doesn't expire, etc

SEARCHPATH=`dscl localhost -read /Search CSPSearchPath | grep -m 1 "Active" | sed 's/^ *//'`

SMBDATE=`dscl "$SEARCHPATH" -read "/Users/$USER" SMBPasswordLastSet 2>&1`
if [[ $SMBDATE == *rror* ]]; then
	# Error of some sort. Spit it out to stderr and exit
	# ie: user not found, could not connect, etc
	echo "User: $USER\nSMBPasswordLastSet: $SMBDATE" >&2
	exit 1
elif [[ $SMBDATE == *such* ]]; then
	# "No such key: SMBPasswordLastSet"
	# Something funky
	echo "Error: $SMBDATE" >&2
	exit 1 
fi

SMBDATE=`echo $SMBDATE | grep -m 1 SMBPasswordLastSet | awk '{ print $2 }'`
SMBDATE=`echo $SMBDATE / 10000000 - 11644473600 | bc`

DATENOW=`date +%s`

DAYSPASSED=`echo "($DATENOW - $SMBDATE) / 86400" | bc`
DAYSREMAIN=`echo $MAXPASSWORDAGE - $DAYSPASSED | bc`

##if [ $DAYSREMAIN -gt $DAYSWARNING ]; then
##    # Password expiry hasn't triggered a warning - do nothing
##    exit 0
if [ $DAYSPASSED -le $MINPASSWORDAGE ]; then
	# Password has already been changed recently, can't change again yet
	osascript -e 'tell application "System Events" to display alert "You have already changed your password '$DAYSPASSED' days ago, you cannot change it again so soon." as warning'
	echo "User: $USER\nSMBPasswordLastSet: $SMBDATE (DAYSREMAIN: $DAYSREMAIN)" >&2
	exit 1
elif [ $DAYSREMAIN -lt -1 ]; then
	# Something weird happened, probably returned a value like -15427
	osascript -e 'tell application "System Events" to display alert "Something weird happened. Please try again, and if the issue persists, contact IT Helpdesk" as warning'
	echo "Error\nUser: $USER\nSMBPasswordLastSet: $SMBDATE (DAYSREMAIN: $DAYSREMAIN)" >&2
	exit 1
fi

# Prompt user if they want to change their password
a=$(osascript -e 'tell application "System Events" to activate' -e 'tell application "System Events" to set question to display dialog "Your password is due to expire in '$DAYSREMAIN' days. Do you want to change it now?" buttons {"Yes", "No"} default button 2 with icon caution' -e 'button returned of question')
if [ "$a" == "No" ]; then
	# User doesn't want to change password yet
	exit 0
fi

# Get current password from user, for authentication purposes
while true; do
	CURPASSWORD="$(osascript -e 'tell application "System Events" to display dialog "Please enter your CURRENT password:" with hidden answer default answer ""' -e 'text returned of result' 2>/dev/null)"
	if [ $? -ne 0 ]; then
		# Pressed cancel
		exit 0
	elif [ -z "$CURPASSWORD" ]; then
		# Left blank
		osascript -e 'tell application "System Events" to display alert "Password can not be left blank." as warning'
	else break
	fi
done

# Prompt for new password, including some validation checks to reduce server errors
while true; do
	NEWPASSWORD="$(osascript -e 'Tell application "System Events" to display dialog "Please enter your NEW password.\n\nRemember that your password must:\n\t• be at least 8 characters long\n\t• contain at least one capital letter\n\t• contain at least one digit or symbol\n\t• not contain your name\n\t• be different from your previous 24 passwords\n\t• not be within 5 days of the last password change" with hidden answer default answer ""' -e 'text returned of result' 2>/dev/null)"
	if [ $? -ne 0 ]; then
		# Pressed cancel
		exit 0
	elif [ -z "$NEWPASSWORD" ]; then
		# Left blank
		osascript -e 'Tell application "System Events" to display alert "Password can not be left blank." as warning'
	elif [ ${#NEWPASSWORD} -lt 8 ]; then
		osascript -e 'Tell application "System Events" to display alert "New password is not long enough." as warning'
	elif [[ ! "$NEWPASSWORD" =~ [A-Z] ]]; then
		osascript -e 'Tell application "System Events" to display alert "New password does not contain any capital letters." as warning'
	elif [[ ! "$NEWPASSWORD" =~ [!-@] ]]; then
		osascript -e 'Tell application "System Events" to display alert "New password does not contain any numbers or symbols." as warning'
	else break
	fi
done

# Get the user to type the password again to confirm
while true; do
	CONFIRMPASSWORD="$(osascript -e 'tell application "System Events" to display dialog "Please CONFIRM your new password." with hidden answer default answer ""' -e 'text returned of result' 2>/dev/null)"
	if [ $? -ne 0 ]; then
		# Pressed cancel
		exit 0
	elif [ -z "$CONFIRMPASSWORD" ]; then
		# Left blank
		osascript -e 'tell application "System Events" to display alert "Password can not be left blank." as warning'
		# Left blank
		osascript -e 'tell application "System Events" to display alert "Password can not be left blank." as warning'
	elif [ "$CONFIRMPASSWORD" != "$NEWPASSWORD" ]; then
		osascript -e 'tell application "System Events" to display alert "Passwords do not match." as warning'
	else break
	fi
done

result=$(dscl "$SEARCHPATH" passwd "/Users/$USER" "$CURPASSWORD" "$NEWPASSWORD")
result=`echo $result | awk '{ print $4 }'`
#result=""
#eDSAuthFailed
#eDSAuthMethodNotSupported
#eDSAuthPasswordQualityCheckFailed
if [ "$result" == "eDSAuthPasswordQualityCheckFailed" ]; then
	osascript -e 'Tell application "System Events" to display alert "(eDSAuthPasswordQualityCheckFailed):\nNew password has failed complexity requirements. It is most likely that your password had already been changed in the past 5 days, or is the same as one of your previous 24 passwords." as warning'
	exit 1
elif [ "$result" == "eDSAuthMethodNotSupported" ] || [ "$result" == "eDSAuthFailed" ]; then
	osascript -e 'Tell application "System Events" to display alert "('$result'):\nFailed validation. It is most likely that you entered your current password incorrectly, or you are not logged in with your account." as warning'
	exit 1
elif [ "$result" != "" ]; then
	osascript -e 'Tell application "System Events" to display alert "('$result'):\nUnhandled error. Please contact IT Helpdesk." as warning'
	exit 1
fi

# System keychain should almost always default to "/Library/Keychains/System.keychain"
# but you never know...
USERKEYCHAIN=`security default-keychain | xargs`
SYSKEYCHAIN=`security default-keychain -d system | xargs`

# Tell system to log off
osascript -e 'tell app "System Events" to log out'
