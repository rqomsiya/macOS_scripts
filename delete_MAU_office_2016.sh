#!/bin/sh

if
[ -d "/Library/Application Support/Microsoft/MAU2.0" ] 
then
rm -rf "/Library/Application Support/Microsoft/MAU2.0"
echo "Updater has been deleted."
else
echo "Updater not found, exiting."
fi
