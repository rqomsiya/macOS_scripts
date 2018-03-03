#!/bin/bash

# Get a list from all profiles installed on the computer and remove every one of them

for identifier in $(profiles -C | awk "/attribute/" | awk '{print $4}')
do profiles -r -p $identifier
done

sleep 5

for identifier in $(profiles -C | awk "/attribute/" | awk '{print $4}')
do profiles -R -p $identifier
done
