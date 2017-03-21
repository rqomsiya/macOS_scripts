#!/bin/bash

plistbuddy="/usr/libexec/PlistBuddy"
USER=$(/bin/ls -l /dev/console | /usr/bin/awk '{print $3}')
launchServicesSecure="/Users/$USER/Library/Preferences/com.apple.LaunchServices/com.apple.launchservices.secure.plist"
PLIST_ENTRIES=$(/usr/bin/defaults read $launchServicesSecure | /usr/bin/grep LSHandlerPreferred | /usr/bin/wc -l | /usr/bin/sed 's/ //g')

if [ "$PLIST_ENTRIES" = "0" ]; then
    ONE="0"
    TWO="1"
    THREE="2"
    FOUR="3"
    FIVE="4"
    SIX="5"
else
    ONE=$(/bin/echo $(($PLIST_ENTRIES+1)))
    TWO=$(/bin/echo $(($PLIST_ENTRIES+2)))
    THREE=$(/bin/echo $(($PLIST_ENTRIES+3)))
    FOUR=$(/bin/echo $(($PLIST_ENTRIES+4)))
    FIVE=$(/bin/echo $(($PLIST_ENTRIES+5)))
    SIX=$(/bin/echo $(($PLIST_ENTRIES+6)))
fi

# Create the LSHandlers array
$plistbuddy -c "add:LSHandlers array" "${launchServicesSecure}"

# Set default for mailto links
$plistbuddy -c "add:LSHandlers:${ONE}:LSHandlerPreferredVersions dict" "${launchServicesSecure}"
$plistbuddy -c "add:LSHandlers:${ONE}:LSHandlerPreferredVersions:LSHandlerRoleAll string -" "${launchServicesSecure}"
$plistbuddy -c "add:LSHandlers:${ONE}:LSHandlerRoleAll string com.microsoft.outlook" "${launchServicesSecure}"
$plistbuddy -c "add:LSHandlers:${ONE}:LSHandlerURLScheme string mailto" "${launchServicesSecure}"

# Set Outlook 2016 as default for email
$plistbuddy -c "add:LSHandlers:${TWO}:LSHandlerContentType string com.apple.mail.email" "${launchServicesSecure}"
$plistbuddy -c "add:LSHandlers:${TWO}:LSHandlerPreferredVersions dict" "${launchServicesSecure}"
$plistbuddy -c "add:LSHandlers:${TWO}:LSHandlerPreferredVersions:LSHandlerRoleAll string -" "${launchServicesSecure}"
$plistbuddy -c "add:LSHandlers:${TWO}:LSHandlerRoleAll string com.microsoft.outlook" "${launchServicesSecure}"

# Set Outlook 2016 as default email from Outlook 2011
$plistbuddy -c "add:LSHandlers:${THREE}:LSHandlerContentType string com.microsoft.outlook14.email-message" "${launchServicesSecure}"
$plistbuddy -c "add:LSHandlers:${THREE}:LSHandlerPreferredVersions dict" "${launchServicesSecure}"
$plistbuddy -c "add:LSHandlers:${THREE}:LSHandlerPreferredVersions:LSHandlerRoleAll string -" "${launchServicesSecure}"
$USER $plistbuddy -c "add:LSHandlers:${THREE}:LSHandlerRoleAll string com.microsoft.outlook" "${launchServicesSecure}"

# Set Outlook 2016 as default for .ics files
$plistbuddy -c "add:LSHandlers:${FOUR}:LSHandlerContentType string com.apple.ical.ics" "${launchServicesSecure}"
$plistbuddy -c "add:LSHandlers:${FOUR}:LSHandlerPreferredVersions dict" "${launchServicesSecure}"
$plistbuddy -c "add:LSHandlers:${FOUR}:LSHandlerPreferredVersions:LSHandlerRoleAll string -" "${launchServicesSecure}"
$plistbuddy -c "add:LSHandlers:${FOUR}:LSHandlerRoleAll string com.microsoft.outlook" "${launchServicesSecure}"

# Set Outlook 2016 as default calendar from Outlook 2011
$plistbuddy -c "add:LSHandlers:${FIVE}:LSHandlerContentType string com.microsoft.outlook14.icalendar" "${launchServicesSecure}"
$plistbuddy -c "add:LSHandlers:${FIVE}:LSHandlerPreferredVersions dict" "${launchServicesSecure}"
$plistbuddy -c "add:LSHandlers:${FIVE}:LSHandlerPreferredVersions:LSHandlerRoleAll string -" "${launchServicesSecure}"
$plistbuddy -c "add:LSHandlers:${FIVE}:LSHandlerRoleAll string com.microsoft.outlook" "${launchServicesSecure}"

# Set Outlook 2016 as default for .vcard
$plistbuddy -c "add:LSHandlers:${SIX}:LSHandlerContentType string public.vcard" "${launchServicesSecure}"
$plistbuddy -c "add:LSHandlers:${SIX}:LSHandlerPreferredVersions dict" "${launchServicesSecure}"
$plistbuddy -c "add:LSHandlers:${SIX}:LSHandlerPreferredVersions:LSHandlerRoleAll string -" "${launchServicesSecure}"
$plistbuddy -c "add:LSHandlers:${SIX}:LSHandlerRoleAll string com.microsoft.outlook" "${launchServicesSecure}"

exit
