#!/bin/bash
# Removes 30 min (1800sec) LaunchDaemon and removes user from Admin Group


if [[ -f /var/uits/userToRemove ]]; then
	USERNAME=`cat /var/uits/userToRemove`
	echo "removing" $USERNAME "from admin group"
	/usr/sbin/dseditgroup -o edit -d $USERNAME -t user admin
	echo $USERNAME "has been removed from admin group"
	rm -f /var/uits/userToRemove
else
	defaults write /Library/LaunchDaemons/com.yourcompany.adminremove.plist disabled -bool true
	echo "going to unload"
	launchctl unload -w /Library/LaunchDaemons/com.yourcompany.adminremove.plist
	echo "Completed"
	rm -f /Library/LaunchDaemons/com.yourcompany.adminremove.plist
fi
exit 0