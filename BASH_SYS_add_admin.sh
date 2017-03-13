#!/bin/sh

# Program		: BASH_SYS_add_ADuser_localAdmin.sh
# Purpose		: Grants local admin access based on user AD membership
# Called By		: n/a
# Owner			: Capital Group Companies
# Author		: Rany Qomsiya (RYQ)
# Note			: This software is provided "AS IS" basis. 

# Setting Variables: Currently logged in user.
loggedInUser=$( ls -l /dev/console | awk '{print $3}' )

# Setting Variables: AD Group name that is compared against logged in users memebrship. Change AD group after ADAdminGroupName="AD_Group_Name_Here"
ADAdminGroupName="ADMIN_JSS_WIN_PRD"

# Checks all AD groups curently logged in user is a member of
ADGroups=$( dscl "/Active Directory/CGUSER/All Domains" read /Users/$loggedInUser dsAttrTypeNative:memberOf )

# If user is 
if [[ "$ADGroups" =~ "$ADAdminGroupName" ]]; then
	echo "User $loggedInUser is member of group $ADAdminGroupName. Granting Local Admin Privileges"
	/usr/sbin/dseditgroup -o edit -a $loggedInUser -t user admin
else
	echo "User $loggedInUser is not a member of group $AdminGroupName. Leaving as standard user"
fi

exit 0