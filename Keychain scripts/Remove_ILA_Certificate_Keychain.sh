#!/bin/sh
#
##################################################################
# This script will traverse all keychains. It will delete the wifi
# certificate labeled "ml" (seen in line 13 and line 26).
##################################################################

# Pull list of users with UDID over 500
over500=`dscl . list /Users UniqueID | awk '$2 > 500 { print $1 }'`

# Remove from System.keychain if it exists.
echo "Remove ILA Wi-Fi Certificate from System.keychain if it exists..."
/usr/bin/security delete-certificate -c "ml" /Library/Keychains/System.keychain 2>/dev/null
echo "Remove ILA Wi-Fi Certificate from System.keychain if it exists..."

# Loop through and remove from users keychains if it exists, and pipe errors to /dev/null.
echo "Now loop through all users with UID over 500..."
for u in $over500
do
	# Pull list of keychains
	KEYCHAIN=`su $u -c 'security list-keychains | tr -d "\"" | tr -d "  " | grep -v "/Library/Keychains/System.keychain"' 2>/dev/null`

	for k in $KEYCHAIN
	do
		echo "Removing ILA Wi-Fi Certificate from keychain $k for user $u if it exists..."
		/usr/bin/security delete-certificate -c "ml" $k 2>/dev/null
		echo "Removed ILA Wi-Fi Certificate from keychain $k for user $u if it existed..."
	done
done

exit 0