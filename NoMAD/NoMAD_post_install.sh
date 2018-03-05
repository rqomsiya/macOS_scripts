#!/bin/sh

# Loads the Launch Agent for logged in user.
# Get current user and OS information.
sleep 10
CURRENT_USER=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
USER_ID=$(id -u "$CURRENT_USER")
OS_MAJOR=$(/usr/bin/sw_vers -productVersion | awk -F . '{print $1}')
OS_MINOR=$(/usr/bin/sw_vers -productVersion | awk -F . '{print $2}')

# Launching NoMAD using launchctl.
echo "Launching NoMAD..."
if [[ "$OS_MAJOR" -eq 10 && "$OS_MINOR" -le 9 ]]; then
    LOGINWINDOW_PID=$(pgrep -x -u "$USER_ID" loginwindow)
    /bin/launchctl bsexec "$LOGINWINDOW_PID" /bin/launchctl load /Library/LaunchAgents/com.trusourcelabs.NoMAD.plist
elif [[ "$OS_MAJOR" -eq 10 && "$OS_MINOR" -gt 9 ]]; then
    /bin/launchctl asuser "$USER_ID" /bin/launchctl load /Library/LaunchAgents/com.trusourcelabs.NoMAD.plist
else
    echo "[ERROR] macOS $OS_MAJOR.$OS_MINOR is not supported."
    exit 1004
fi

sudo jamf recon
