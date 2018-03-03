#!/bin/bash

# Get a list of all computer level profiles installed on the computer and remove every one of them. Note lower case -r and not -R (which is for user level profiles)

for identifier in $(profiles -C | awk "/attribute/" | awk '{print $4}')
do profiles -r -p $identifier
done
