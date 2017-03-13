#!/bin/sh

# Check Available Free Space

availableSpace=`/usr/sbin/diskutil info / | grep "Volume Free Space:" | awk '{print $4}'`
echo $availableSpace

exit 0