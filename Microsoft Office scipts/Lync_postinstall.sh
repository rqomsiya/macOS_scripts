#!/bin/bash
  
# Determine OS version
osvers=$(sw_vers -productVersion | awk -F. '{print $2}')

# Get currently loggedin user information
user=$( ls -l /dev/console | awk '{print $3}' )
  
# Determine working directory
install_dir=`dirname $0`
  
# Install Microsoft Lync 14.3.3 using the specified installer packages in the working directory
/usr/sbin/installer -dumplog -verbose -pkg $install_dir/"App_Microsoft_Lync_14.3.3_Update.pkg" -target "$3"

