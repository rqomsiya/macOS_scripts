#!/bin/bash

# Determine working directory
install_dir=`dirname $0`

#Office Installers
Tanium="TaniumClient-7.2.314.3608.pkg"

#Install Tanium client
/usr/sbin/installer -dumplog -verbose -pkg $install_dir/"$Tanium" -target "$3" -allowUntrusted

sleep 10

/Library/Tanium/TaniumClient/TaniumClient config set ServerNameList tants1.capgroup.com,148.107.22.53,148.107.28.53

#Load the launchD
sudo launchctl load /Library/LaunchDaemons/com.tanium.taniumclient.plist

exit 0
