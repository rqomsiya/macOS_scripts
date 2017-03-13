#!/bin/sh

# This script removes all local admins except for CGADMIN

# For any user listed in the /Users folder except Shared and cgadmin, remove from the admin group
for user in `find /Users -maxdepth 1 -type d ! -name Shared -a ! -name cgadmin -mindepth 1 |cut -d/ -f3`
	do
		/usr/sbin/dseditgroup -o edit -d $user -t user admin
		echo Removed $user from admin group
	done
	
exit 0