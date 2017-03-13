#!/bin/sh

loaded=`launchctl list |grep com.jamfsoftware.jamf.agentd |awk {'print ($2)'}`

if [[ $loaded == "-" ]]
then 
echo "YES"
else 
echo "NO"
echo $loaded
fi