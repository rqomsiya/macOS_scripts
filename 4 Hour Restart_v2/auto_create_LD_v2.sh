#!/bin/sh

# RYQ(Rany Qomsiya)
# Capital Group Companies
# This script will restart the machine after 4 hours if /Library/JAMF/Application Support/JAMF/Watiing Room/ has cached pacakges
# It also creates a LaunchDaemon and script to remove script and LD in 4 hours

# Where the launchdaemon and script will be stored
launchDaemon="/Library/LaunchDaemons/com.cg.restarter.plist"
removeScript="/Library/Scripts/4_hour_restart.sh"
cocoadaemon="/Library/LaunchDaemons/com.cg.cocoadaemon.plist"

# Find the date in 4 hours
month=$(perl -e 'use POSIX qw(strftime);$d = strftime "%m", localtime(time()+14400);print $d;')
day=$(perl -e 'use POSIX qw(strftime);$d = strftime "%e", localtime(time()+14400);print $d;')
hour=$(perl -e 'use POSIX qw(strftime);$d = strftime "%H", localtime(time()+14400);print $d;')
minute=$(perl -e 'use POSIX qw(strftime);$d = strftime "%M", localtime(time()+14400);print $d;')

# writes the launchdaemon file 
# the start calendar interval specifies the 4 hour wait
# if the computer is off or asleep, this will run once it is powered back up after the 
# start date/time
echo '<?xml version="1.0" encoding="UTF-8"?>' > $launchDaemon
echo '<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> $launchDaemon
echo '<plist version="1.0">' >> $launchDaemon
echo '<dict>' >> $launchDaemon
echo '       <key>Label</key>' >> $launchDaemon
echo '        <string>com.cg.restarter.plist</string>' >> $launchDaemon
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

# Create Second LaunchDaemon to run Cocoa Dialog Script
echo '<?xml version="1.0" encoding="UTF-8"?>' >> $cocoadaemon
echo '<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">' >> $cocoadaemon
echo '<plist version="1.0">' >> $cocoadaemon
echo '<dict>' >> $cocoadaemon
echo '       <key>Label</key>' >> $cocoadaemon
echo '        <string>com.cg.cocoadaemon.plist</string>' >> $cocoadaemon
echo '        <key>ProgramArguments</key>' >> $cocoadaemon
echo '        <array>' >> $cocoadaemon
echo '        	<string>/Library/Scripts/CD_4_hour_restart_timer.sh</string>' >> $cocoadaemon
echo '        </array>' >> $cocoadaemon
echo '        <key>RunAtLoad</key>' >> $cocoadaemon
echo '        <true/>' >> $cocoadaemon
echo '</dict>' >> $cocoadaemon
echo '</plist>' >> $cocoadaemon

# create the script to shutdown machine after 4 hours
# the script also removes the launchdaemon and itself
echo "#!/bin/sh" > $removeScript
echo "# This script will restart computer after 4 hour timer has been reached" >> $removeScript
echo "launchctl unload /Library/LaunchDaemons/com.cg.restarter.plist 2>/dev/null" >> $removeScript
echo "launchctl unload /Library/LaunchDaemons/com.cg.cocoadaemon.plist 2>/dev/null" >> $removeScript
echo "sleep 5" >> $removeScript
echo "rm /Library/LaunchDaemons/com.cg.restarter.plist 2>/dev/null" >> $removeScript
echo "rm /Library/LaunchDaemons/com.cg.cocoadaemon.plist 2>/dev/null" >> $removeScript
echo "sleep 5" >> $removeScript
echo "shutdown -r now" >> $removeScript


# make it executable
chmod +x "$removeScript"

# Load the daemon
launchctl load "$launchDaemon"

# Load CocoaDaemon
launchctl load "$cocoadaemon"

# Unload Waiting Room WatchPath LD to avoid it re-running if more packages are pushed within the 4 hour window
launchctl unload /Library/LaunchDaemons/com.cg.createtimerld.plist

sleep 10

exit 0