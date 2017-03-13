#!/bin/bash

# Sets Outlook 2011 as default mail and calendar application

osascript 2> /dev/null <<-EOF

tell application "Microsoft Outlook"
	set system default everything application to yes
end tell
tell application "Microsoft Outlook" to quit
end
EOF
