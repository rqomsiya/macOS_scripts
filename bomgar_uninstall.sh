#!/bin/bash
/Users/Shared/bomgar*/Bomgar\ Support\ Client.app/Contents/MacOS/sdcust -uninstall silent

pkill -f bomgar
sleep 1

launchctl unload /Library/LaunchAgents/com.bomgar.bomgar-scc*

/bin/rm -rf /Library/LaunchDaemons/com.bomgar.bomgar-ps-*
/bin/rm -rf /Library/LaunchDaemons/.com.bomgar.bomgar-ps-*
/bin/rm -rf /Library/LaunchAgents/com.bomgar.bomgar-scc*
/bin/rm -rf /Users/Shared/bomgar-scc-*

exit 0
