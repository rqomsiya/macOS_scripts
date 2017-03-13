#!/bin/bash
# 
# Change *****.mobileconfig name to speific configuration name
# Installing

/usr/bin/profiles -I -F "/tmp/Energy Settings.mobileconfig"
/usr/bin/profiles -I -F "/tmp/Security Settings.mobileconfig"
/usr/bin/profiles -I -F "/tmp/Proxy Settings.mobileconfig"

exit 0