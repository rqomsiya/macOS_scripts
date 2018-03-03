#!/bin/bash
# Created by RYQ (Capital Group Companies)
# Script is used to delete all existing computer level profiles and install any .mobileconfig files located in /private/tmp/

# Get a list from all profiles installed on the computer and remove every one of them
for identifier in $(profiles -C | awk "/attribute/" | awk '{print $4}')
do profiles -r -p $identifier
done

sleep 5

for identifier in $(profiles -C | awk "/attribute/" | awk '{print $4}')
do profiles -R -p $identifier
done

sleep 2

# Install all config profiles in /private/tmp/ directory
config="/private/tmp/*.mobileconfig"
for i in $config
do /usr/bin/profiles -I -F "$i"
done

# Delete all .mobileconfig files in /private/tmp/ directory
rm -rf /private/tmp/*.mobileconfig
