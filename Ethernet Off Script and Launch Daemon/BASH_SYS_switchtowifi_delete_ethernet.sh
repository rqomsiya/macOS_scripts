#!/bin/bash

# Switch network location to "Wi-Fi" and delete network location "Ethernet"

networksetup -switchtolocation "Wi-Fi"
sleep 15
networksetup -deletelocation "Ethernet"

exit 0