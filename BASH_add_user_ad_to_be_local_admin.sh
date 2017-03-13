#!/bin/bash

# This will check to see if user is an Admin via AD groups, & if is but is not in the local admins group then add.
# Then run once more. If user is in the local admin group or is not an AD defined admin then quit.
mainFunction() {

# Get members of the Mac's local admin group
adminGroupMembership=$(dscl . -read /Groups/admin | awk '/GroupMembership:/{for(i=2;i<=NF;i++){out=out" "$i}; print out}')

# Flush dsmemberutil's cache
dsmemberutil flushcache

# If user comes back as an admin, they could be an admin via AD Group or by being a member of the local admin group
if [[ $(dsmemberutil checkmembership -U "$loggedInUser" -G admin) == 'user is a member of the group' ]]; then
	# Check to see if the user is part of the local admin group
	if [[ $adminGroupMembership =~ "$loggedInUser" ]]; then
		# Update EA
		echo "<result>$loggedInUser: Local Admin</result>"
		# Exit script
		exit 0
	else
		# If the user is in a AD admin group, is a AD User & is not part of the local admins groups then;
		# Add user to local admin group
		sudo dseditgroup -o edit -n /Local/Default -a "$loggedInUser" -t user admin
		# Run this function again
		mainFunction
	fi
else
	# If the user is not in a AD admin group, is a AD User & is not part of the local admins groups then:
	echo "<result>$loggedInUser: Not In Admin Groups</result>"
	# Exit script
	exit 0
fi
}

# If nothing returned from the below then presume not bound to AD & exit
if [[ -z $(dsconfigad -show | awk '/Active Directory Domain/') ]]; then
	# Update EA
	echo "<result>Mac: Not Bound</result>"
	# Exit script
	exit 0
fi

# Get the username of the logged in user
loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

# If nothing returned from the above then no one is logged in
if [[ -z $loggedInUser ]]; then
	# Update EA
	echo "<result>Mac: Not Logged In</result>"
	# Exit script
	exit 0
fi

# Get the UniqueID of loggedInUser, exit if ID is less than 1000 as presuming it's then a local account
if [ $(dscl . -read /Users/"$loggedInUser" | awk '/UniqueID:/{ print $NF}') -lt 1000 ]; then
	# Update EA
	echo "<result>$loggedInUser: Local Account</result>"
	# Exit script
	exit 0
fi

# Check to see if the user is authenticated to the domain.. if the below comes back blank.. exit
if [[ -z $(dscl /Search read /Users/"$loggedInUser" AuthenticationAuthority | awk '/NetLogon;/{ print $1 }') ]]; then
	# If we're not currently connected to AD
	echo "<result>$loggedInUser: Not AD Authenticated</result>"
	exit 0
fi

# Run mainFunction
mainFunction