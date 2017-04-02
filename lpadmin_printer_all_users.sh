#!/bin/bash

# Allow staff to add printers and manage print queue without administrative rights
/usr/sbin/dseditgroup -o edit -a everyone -t group lpadmin

# Determines local, logged in user
loggedInUser=$(stat -f%Su /dev/console)

# Determines if local, logged in user is a member of "lpadmin."
var1=$(dseditgroup -o checkmember -m $loggedInUser -n . lpadmin)

# Will write out a message specifying if the current user is and if the current user is a member of the lpadmin group on the local node.
echo "$loggedInUser is currently logged in and $var1."

exit 0
