#!/bin/bash

#Delete all custom CUSTOMPHRASE additions every time this is run
awk '!/#CUSTOMPHRASE/' /etc/hosts > /tmp/hosts && cp -f /tmp/hosts /etc/hosts
sleep 1 

#Add current CUSTOMPHRASE custom additions to /etc/hosts
echo "#CUSTOMPHRASE Location File Server Header" >> /etc/hosts
echo "192.168.0.1    myserver.example.com #CUSTOMPHRASE" >> /etc/hosts
echo "192.168.0.2    herserver.example.com #CUSTOMPHRASE" >> /etc/hosts
echo "#CUSTOMPHRASE Other Server Header" >> /etc/hosts
echo "10.0.0.3    hisserver.example.com #CUSTOMPHRASE" >> /etc/hosts
echo "10.0.0.4    ourserver.example.com #CUSTOMPHRASE" >> /etc/hosts