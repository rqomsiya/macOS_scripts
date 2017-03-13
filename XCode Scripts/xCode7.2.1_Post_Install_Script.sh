#!/bin/sh

# Program		: xcode7.2_post_install_script.sh
# Purpose		: Xcode 7.2 Post-install CLI tools/Development Mobile .pkg and adds users to Dev Group
# Owner			: Capital Group Companies
# Author		: Rany Qomsiya (RYQ)
# Note			: This software is provided "AS IS" basis.
# Revisions		: 2016-01-03: Rev1.0a
# Updated (Last): 2016-01-25: Rev1.1a

# DevToolsSecurity tool to change the authorization policies, such that a user who is a
# member of either the admin group or the _developer group does not need to enter an additional
# password to use the Apple-code-signed debugger or performance analysis tools.
/usr/sbin/DevToolsSecurity -enable

# Accept Xcode License
/Applications/Xcode.app/Contents/Developer/usr/bin/xcodebuild -license accept

# Install Additional Components
/usr/sbin/installer -pkg /Applications/Xcode.app/Contents/Resources/Packages/MobileDevice.pkg -target /

/usr/sbin/installer -pkg /Applications/Xcode.app/Contents/Resources/Packages/MobileDeviceDevelopment.pkg -target /

# Suppress post-run messages
sudo defaults write /Library/Preferences/com.apple.dt.Xcode DVTSkipMobileDeviceFrameworkVersionChecking -bool true

# Add all users on machine to Developer group
sleep 5
sudo DevToolsSecurity -enable
/usr/sbin/dseditgroup -o edit -a everyone -t group _developer