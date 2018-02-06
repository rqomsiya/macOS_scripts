#!/bin/bash

lastBootTime=$(sysctl kern.boottime | awk -F'[ |,]' '{print $5}')   ## Raw unix time in seconds of last boot up
currentTime=$(date +"%s")                                           ## Current time in unix seconds
upTimeRaw=$((currentTime-lastBootTime))                             ## Calculation of difference between boot and current time ( total time up in seconds )
upTimeMin=$((upTimeRaw/60))                                         ## Calculation of uptime in minutes total ( uptime in seconds div by 60 )
upTimeHours=$((upTimeMin/60))                                       ## Calculation of uptime in hours total ( uptime in minutes div by 60 )
upTimeDays=$((upTimeHours/24))                                      ## Calculation of uptime in whole days total ( uptime in hours  div by 24 )
minusMinutes=$((((upTimeDays*24))*60))                              ## Total minutes up in whole days ( [uptime in whole days x 24] x 60 minutes )
remainingMin=$((upTimeMin-minusMinutes))                            ## Calculation of remaining minutes to subtract
remainingHrs=$((remainingMin/60))                                   ## Calculation of remaining hours to subtract
minusHours=$((upTimeHours-remainingHrs))

## Figure out minutes value for uptime display
total1=$((upTimeDays*24*60))
total2=$((remainingHrs*60))
minusMinutes2=$((total1+total2))
remainingMinFin=$((upTimeMin-minusMinutes2))

UptimeThreshold1alt=$((UptimeThreshold1-1))
UptimeThreshold2alt=$((UptimeThreshold2-1))

if [ "$upTimeDays" == "1" ]; then
	daysText="Day"
else
	daysText="Days"
fi

if [ "$remainingHrs" == "1" ]; then
	hrsText="Hour"
else
	hrsText="Hours"
fi

if [ "$remainingMinFin" == "1" ]; then
	minsText="Minute"
else
	minsText="Minutes"
fi

echo "<result>$upTimeDays $daysText, $remainingHrs $hrsText, $remainingMinFin $minsText</result>"
