#!/bin/bash

## define time servers
timeserver1="snx1ntp2.capgroup.com"
timeserver2="time.apple.com"

systemsetup -setusingnetworktime off
mv /private/etc/ntp.conf /private/etc/ntp.conf.orig
echo "server $timeserver1" > /private/etc/ntp.conf
echo "server $timeserver2" >> /private/etc/ntp.conf
systemsetup -setusingnetworktime on