#!/bin/sh

# Get the logged in users username
loggedInUser=`/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }'`

# Get UID of logged in user
UserID=$(dscl . read /Users/$loggedInUser UniqueID | awk '$2 > 1000 {print $2}')

# Run recon, submitting the users username which as of 8.61+ can then perform an LDAP lookup
if [[ ${UserID} -ge 1000 ]]; then
	echo "Running recon for $loggedInUser $(date)..."
	
sleep 15

   /usr/local/bin/jamf recon -endUsername $loggedInUser
else
	echo "No network users found. Exiting."
fi
exit 0