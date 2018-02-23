#!/bin/bash

# Get a list of all computer level profiles installed on the computer and remove every one of them

for identifier in $(profiles -C | awk "/attribute/" | awk '{print $4}')
do profiles -R -p $identifier
done
