#!/bin/sh

# get current console user
currentUser=$( /usr/bin/stat -f "%Su" /dev/console )
echo "Currently logged in user: $currentUser."

# get current console user's home folder path
currentUserHome=$( /usr/bin/dscl . read "/Users/$currentUser" NFSHomeDirectory | /usr/bin/awk 'BEGIN {FS=": "} {print $2}' )
echo "Currently logged in user's home folder path: $currentUserHome."

# get NetBIOS domain of bound Mac
netBIOSDomain=$( /usr/bin/dscl "/Active Directory/" -read / SubNodes | /usr/bin/awk 'BEGIN {FS=": "} {print $2}' )

if [ "$netBIOSDomain" = "" ]; then
	echo "Unable to determine NetBIOS domain. Exiting."
	exit 1
else
	echo "NetBIOS Domain: $netBIOSDomain."
fi

userADInfo=$( /usr/bin/dscl "/Active Directory/$netBIOSDomain/All Domains/" -read "/Users/$currentUser" City co company EMailAddress PhoneNumber PostalCode RealName State Street )

meContact="$currentUserHome/Library/Group Containers/UBF8T346G9.Office/MeContact.plist"

userAddress=$( echo "$userADInfo" | grep -A 1 Street | /usr/bin/tail -1 | xargs )
/usr/bin/defaults write "$meContact" Address -string "$userAddress"
echo "Setting Address: $userAddress"

userCompany=$( echo "$userADInfo" | grep -A 1 company | /usr/bin/tail -1 | xargs )
/usr/bin/defaults write "$meContact" 'Business Company' -string  "$userCompany"
echo "Setting Company: $userCompany"

userCity=$( echo "$userADInfo" | grep -A 1 City | /usr/bin/tail -1 | xargs )
/usr/bin/defaults write "$meContact" City -string "$userCity"
echo "Setting City: $userCity"

userCountry=$( echo "$userADInfo" | grep -w 'co' -A 1 |/usr/bin/tail -1 | xargs )
/usr/bin/defaults write "$meContact" Country -string "$userCountry"
echo "Setting Country: $userCountry"

userEmail=$( echo "$userADInfo" | grep EMailAddress | /usr/bin/awk -F ": " '{print $2}' )
/usr/bin/defaults write "$meContact" Email -string "$userEmail"
echo "Setting Email: $userEmail"

userName=$( echo "$userADInfo" | grep -A 1 RealName | /usr/bin/tail -1 | xargs )
/usr/bin/defaults write "$meContact" Name -string "$userName"
echo "Setting Name: $userName"

userInitials=$( printf "%c" $userName )
/usr/bin/defaults write "$meContact" Name -string "$userInitials"
echo "Setting Initials: $userInitials"

userPhone=$( echo "$userADInfo" | grep -A 1 PhoneNumber | /usr/bin/tail -1 | xargs )
/usr/bin/defaults write "$meContact" Phone -string "$userPhone"
echo "Setting Phone: $userPhone"

userState=$( echo "$userADInfo" | grep -w 'State' | /usr/bin/awk -F ": " '{print $2}' )
/usr/bin/defaults write "$meContact" State -string "$userState"
echo "Setting State: $userState"

userZip=$( echo "$userADInfo" | grep PostalCode | /usr/bin/awk -F ": " '{print $2}' )
/usr/bin/defaults write "$meContact" Zip -string "$userZip"
echo "Setting Zip: $userZip"

exit 0
