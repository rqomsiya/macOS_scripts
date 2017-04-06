#!/bin/sh
userList=`dscl . list /Users UniqueID | awk '$2 > 1000 {print $1}'`
echo "Deleting account and home directory for the following users..."
for a in $userList ; do
find /Users -type d -maxdepth 1 -mindepth 1 -not -name "*.*" -mtime +90 | grep "$a";
if [[ $? == 0 ]]; then
dscl . delete /Users/"$a"; #delete the account
rm -r /Users/"$a"; #delete the home directory
fi
done
