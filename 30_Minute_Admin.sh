#!/bin/sh
# RYQ(Rany Qomsiya)
# This script will add the current user to the admin group
# It also creates a LaunchDaemon and script to remove that user in 24 hours

# Where the launchdaemon and script will be stored
launchDaemon="/Library/LaunchDaemons/com.ehemmete.removeadmin.plist"
removeScript="/Library/Scripts/removeAdmin.sh"

# Who is the current user
userToAdd=$(ls -l /dev/console | cut -d " " -f 4)

# Add that user to the admin group
dseditgroup -o edit -a "$userToAdd" -t user admin

# Find the date in 4 hours
month=$(perl -e 'use POSIX qw(strftime);$d = strftime "%m", localtime(time()+14400);print $d;')
day=$(perl -e 'use POSIX qw(strftime);$d = strftime "%e", localtime(time()+14400);print $d;')
hour=$(perl -e 'use POSIX qw(strftime);$d = strftime "%H", localtime(time()+14400);print $d;')
minute=$(perl -e 'use POSIX qw(strftime);$d = strftime "%M", localtime(time()+14400);print $d;')

# writes the launchdaemon file 
# the start calendar interval specifies the 24 hour wait
# if the computer is off or asleep, this will run once it is powered back up after the 
# start date/time
echo '<?xml version="1.0" encoding="UTF-8"?>' > $launchDaemon
echo '<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> $launchDaemon
echo '<plist version="1.0">' >> $launchDaemon
echo '<dict>' >> $launchDaemon
echo '       <key>Label</key>' >> $launchDaemon
echo '        <string>com.ehemmete.removeadmin</string>' >> $launchDaemon
echo '        <key>LaunchOnlyOnce</key>' >> $launchDaemon
echo '        <true/>' >> $launchDaemon
echo '        <key>RunAtLoad</key>' >> $launchDaemon
echo '        <false/>' >> $launchDaemon
echo '        <key>StartCalendarInterval</key>' >> $launchDaemon
echo '        <dict>' >> $launchDaemon
echo '        	<key>Month</key>' >> $launchDaemon
echo "        	<integer>$month</integer>" >> $launchDaemon
echo '        	<key>Day</key>' >> $launchDaemon
echo "        	<integer>$day</integer>" >> $launchDaemon
echo '        	<key>Hour</key>' >> $launchDaemon
echo "        	<integer>$hour</integer>" >> $launchDaemon
echo '        	<key>Minute</key>' >> $launchDaemon
echo "        	<integer>$minute</integer>" >> $launchDaemon
echo '        </dict>' >> $launchDaemon
echo '        <key>ProgramArguments</key>' >> $launchDaemon
echo '        <array>' >> $launchDaemon
echo "                <string>$removeScript</string>" >> $launchDaemon
echo '        </array>' >> $launchDaemon
echo '</dict>' >> $launchDaemon
echo '</plist>' >> $launchDaemon

# make the script directory if necessary
mkdir -p /Library/Scripts

# create the script to remove the user from the admin group
# the script also removes the launchdaemon and itself
echo "#!/bin/sh" > $removeScript
echo "# This script will remove a temporary admin" >> $removeScript
echo "dseditgroup -o edit -d $userToAdd -t user admin" >> $removeScript
echo "launchctl unload $launchDaemon" >> $removeScript
echo "rm $launchDaemon" >> $removeScript
echo "rm $removeScript" >> $removeScript

# make it executable
chmod +x "$removeScript"

# Load the daemon
launchctl load "$launchDaemon"



