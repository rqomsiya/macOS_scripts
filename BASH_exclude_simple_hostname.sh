#!/bin/bash

echo "list Setup:/Network/Service/[^/]+"|scutil| awk '{print $4}' | cut -c 24-59 |while read serviceid; do /usr/libexec/PlistBuddy -c "Add :NetworkServices:$serviceid:Proxies:ExcludeSimpleHostnames integer 1" /Library/Preferences/SystemConfiguration/preferences.plist ;/usr/libexec/PlistBuddy -c "Set :NetworkServices:$serviceid:Proxies:ExcludeSimpleHostnames 1" /Library/Preferences/SystemConfiguration/preferences.plist; done

