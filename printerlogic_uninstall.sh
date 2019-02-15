#!/bin/bash
FILE=/opt/PrinterInstallerClient/bin/uninstall.sh 

if [ -f $FILE ]; then
	echo "The file '$FILE' exists. Uninstall in progress"
	/opt/PrinterInstallerClient/bin/uninstall.sh 
else
	echo "The file '$FILE' in not found."
fi
exit 0
