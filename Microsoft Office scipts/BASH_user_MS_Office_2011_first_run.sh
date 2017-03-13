#!/bin/bash

# Loginhook to get rid of Office First run.
# This version is for Office 2011
# Updated 101102 by Marcus Jaensson

##### NOTES ABOUT FILE PERMISSIONS ######
# Setting rights to 777 as chown does not seem to work as expected in a loginhook
# It seems that Office sets the correct owner on the files when launching an Office-app
# Really no secrets in these files anyway...



# Install this: 
# 1. Copy this to /Library/Scripts/loginhook.sh
# 2. Set owner to root and chmod 755
# 3. sudo defaults write com.apple.loginwindow LoginHook /Library/Scripts/loginhook.sh

LOGF="/tmp/loginhook.log"

OFFICEPREF="/Users/$3/Library/Preferences/com.microsoft.office.plist"
OFFICEDOMAIN="/Users/$3/Library/Preferences/com.microsoft.office"

AUPREF="/Users/$3/Library/Preferences/com.microsoft.autoupdate2.plist"
AUDOMAIN="/Users/$3/Library/Preferences/com.microsoft.autoupdate2"

ERPREF="/Users/$3/Library/Preferences/com.microsoft.error_reporting.plist"
ERDOMAIN="/Users/$3/Library/Preferences/com.microsoft.error_reporting"


echo "##### Beginning Log #####" >> $LOGF
echo `date "+%y%m%d %H.%M"` >> $LOGF
echo "User: $3" >> $LOGF


# Create files and values com.microsoft.office.plist
if [ -f "$OFFICEPREF" ]
then
echo "com.microsoft.office.plist exists." >> $LOGF
echo "Checking if 14\\FirstRun\\SetupComplete has value 1" >> $LOGF
SETUPSTATUS=$(defaults read "$OFFICEDOMAIN" "14\\FirstRun\\SetupComplete")
if [ $SETUPSTATUS = 1 ]
then
echo "SetupComplete is set to 1. Nothing to do" >> $LOGF
else
echo "Setting SetupComplete to 1" >> $LOGF
defaults write "$OFFICEDOMAIN" "14\\FirstRun\\SetupComplete" -int 1
chmod -f 777 "$OFFICEPREF"
fi
else
echo "com.microsoft.office.plist does not exist. Creating it and setting SetupComplete to 1" >> $LOGF
defaults write "$OFFICEDOMAIN" "14\\FirstRun\\SetupComplete" -int 1
chmod -f 777 "$OFFICEPREF"
fi

# Create fields and values com.microsoft.autoupdate2.plist
if [ -f "$AUPREF" ]
then
echo "com.microsoft.autoupdate2.plist exists." >> $LOGF
echo "Checking if HowToCheck has value Manual" >> $LOGF
HOWTOCHECK=$(defaults read "$AUDOMAIN" "HowToCheck")
LASTUPDATE=$(defaults read "$AUDOMAIN" "LastUpdate")
if [ $HOWTOCHECK = "Manual" ]
then
echo "HowToCheck is set to Manual. Nothing to do" >> $LOGF
else
echo "Setting HowToCheck to Manual" >> $LOGF
defaults write "$AUDOMAIN" "HowToCheck" -string "Manual"
chmod -f 777 "$AUPREF"
fi
if [ -z "$LASTUPDATE" ]
then
echo "LastUpdate is empty, populating"
defaults write "$AUDOMAIN" "LastUpdate" -date "2001-01-01T00:00:00Z"
else
echo "LastUpdate exists"
fi
else
echo "com.microsoft.autoupdate2.plist does not exist. Creating it and setting HowToCheck and LastUpdate to Manual" >> $LOGF
defaults write "$AUDOMAIN" "HowToCheck" -string "Manual"
defaults write "$AUDOMAIN" "LastUpdate" -date "2001-01-01T00:00:00Z"
chmod -f 777 "$AUPREF"
fi

# Create fields and values com.microsoft.error_reporting.plist
if [ -f "$ERPREF" ]
then
echo "com.microsoft.error_reporting.plist exists." >> $LOGF
echo "Checking if SQMReportsEnabled has value False" >> $LOGF
SQMREPORTS=$(defaults read "$ERDOMAIN" "SQMReportsEnabled")
SHIPASSERT=$(defaults read "$ERDOMAIN" "ShipAssertEnabled")
if [ $SQMREPORTS = "0" ]
then
echo "SQMReportsEnabled is set to False. Nothing to do" >> $LOGF
else
echo "Setting SQMReportsEnabled to False" >> $LOGF
defaults write "$ERDOMAIN" "SQMReportsEnabled" -bool False
chmod -f 777 "$ERPREF"
fi
if [ $SHIPASSERT = "0" ]
then
echo "ShipAssertEnabled is set to False. Nothing to do" >> $LOGF
else
echo "Setting ShipAssertEnabled to False" >> $LOGF
defaults write "$ERDOMAIN" "ShipAssertEnabled" -bool False
chmod -f 777 "$ERPREF"
fi
else
echo "com.microsoft.error_reporting.plist does not exist. Creating it and setting SQMReportsEnabled and ShipAssertEnabled to False" >> $LOGF
defaults write "$ERDOMAIN" "SQMReportsEnabled" -bool False
defaults write "$ERDOMAIN" "ShipAssertEnabled" -bool False
chmod -f 777 "$ERPREF"
fi


# Set name
REALNAME=$(dscl . -read /Users/$3 RealName | grep -v RealName | sed 's/^[ ]*//')
echo "RealName is $REALNAME" >> $LOGF
REALNAMESTATUS=$(defaults read "$OFFICEDOMAIN" "14\\UserInfo\\UserName")
echo "RealName Status is $REALNAMESTATUS" >> $LOGF
if [ -z "$REALNAMESTATUS" ]
then
echo "Setting realname" >> $LOGF
defaults write "$OFFICEDOMAIN" "14\\UserInfo\\UserName" -string "$REALNAME"
chmod -f 777 "$OFFICEPREF"
else
echo "REALNAME is already set" >> $LOGF
fi

echo -e "---------- Ending Log ----------\n" >> $LOGF

exit 0