#!/bin/bash

# Pre-installation script for NoMAD
# Author : richard at richard - purves dot com

# The idea here is to clean up if an existing installation is present before installing the version in the pkg.

# Where is everything?
install_dir=$( /usr/bin/dirname $0 )

# Logging stuff starts here
LOGFOLDER="/private/var/log"
LOGFILE="${LOGFOLDER}/NoMAD-Preinstall.log"

if [ ! -d "$LOGFOLDER" ];
then
	/bin/mkdir "$LOGFOLDER"
fi

if [ ! -f "$LOGFILE" ];
then
	/usr/bin/touch ${LOGFILE}
fi

function logme()
{
# Check to see if function has been called correctly
	if [ -z "$1" ]; then
		/bin/echo "$(date '+%F %T') - logme function call error: no text passed to function! Please recheck code!"
		/bin/echo "$(date '+%F %T') - logme function call error: no text passed to function! Please recheck code!" >> ${LOGFILE}		
		exit 1
	fi

# Log the passed details
	/bin/echo "$(date '+%F %T') - $1"
	/bin/echo "$(date '+%F %T') - $1" >> ${LOGFILE}
}

# Start the preinstallation process.
logme "NoMAD Pre-Installation Script"

# Find if there's a console user or not. Blank return if not.
consoleuser=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')

logme "Detected console user: $consoleuser"
if [ -n "$consoleuser" ]; then
	# User present. We must be cautious.

	# Find if there's a launch agent present
	logme "Checking for LaunchAgent presence."
	laloc=$(/usr/bin/find /Library/LaunchAgents -maxdepth 1 -type f -iname "*nomad*.plist")
	if [ ! -z "$laloc" ];
	then
		# Kill the launch agent. No mercy.
		logme "Unloading NoMAD LaunchAgent at: $laloc"
		/usr/bin/sudo -iu "$consoleuser" launchctl unload "$laloc"
	else
		logme "NoMAD LaunchAgent not found. Proceeding."
	fi

	# Check to see if NoMAD is actually running
	# If NoMAD is running, kill NoMAD!
	logme "Checking for NoMAD PID."
	pid=$( /usr/bin/pgrep NoMAD )
	if [ ! -z "$pid" ];
	then
		logme "Killing NoMAD application running on PID: $pid"
		/bin/kill -9 $pid
	else
		logme "NoMAD application not running."
	fi
fi

# Check for the NoMAD app and delete if present
logme "Checking for NoMAD in /Applications"
apploc=$(/usr/bin/find /Applications -maxdepth 1 -type d -iname "*nomad*.app")

if [ -d "$apploc" ];
then
	logme "NoMAD found. Deleting."
	/bin/rm -rf "$apploc"
else
	logme "NoMAD not found."
fi

logme "Installation completed"
