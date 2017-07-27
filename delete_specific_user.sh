#!/bin/sh
# Script to delete specific user. Pass username in paramater $4 in the policy.
accountName=$4

if [ ! -z "$accountName" ] && [[ `/usr/bin/dscl . list /Users | grep "$accountName"` == "$accountName" ]]; then
    /usr/local/bin/jamf -deleteAccount -username "$accountName" -deleteHomeDirectory 2>/dev/null
fi

exit 0
