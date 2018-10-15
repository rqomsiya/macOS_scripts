#!/bin/sh
# This script is intended to be used with JAMF Self Service. It will enable SecureToken for the currently logged in user account
# and either add it to the list of to FileVault enabled users or enable FileVault using a Personal Recovery Key.

# Your policy must include script parameters for a SecureToken enabled administrator username and password. For more information
# on using script parameters, please see https://www.jamf.com/jamf-nation/articles/146/script-parameters.

adminUser="$4"
adminPassword="$5"
userName1="$3"
userName2="$6"

# Uses AppleScript to prompt the currently logged in user for their account password.
userPassword1=$(/usr/bin/osascript <<EOT
tell application "System Events"
activate
display dialog "Please enter your login password:" default answer "" buttons {"Continue"} default button 1 with hidden answer
if button returned of result is "Continue" then
set pwd to text returned of result
return pwd
end if
end tell
EOT)
# Enables SecureToken for the currently logged in user account.
enableSecureToken() {
    sudo sysadminctl -adminUser $adminUser -adminPassword $adminPassword -secureTokenOn $userName -password $userPassword1
}
# Creates a PLIST containing the necessary administrator and user credentials.
createPlist() {
    echo '<?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
    <key>Username</key>
    <string>'$adminUser'</string>
    <key>Password</key>
    <string>'$adminPassword'</string>
    <key>AdditionalUsers</key>
    <array>
        <dict>
            <key>Username</key>
            <string>'$userName1'</string>
            <key>Password</key>
            <string>'$userPassword1'</string>
        </dict>
    </array>
    </dict>
    </plist>' > /private/tmp/userToAdd.plist
}
# Adds the currently logged in user to the list of FileVault enabled users.
addUser() {
    sudo fdesetup add -i < /private/tmp/userToAdd.plist
}
# Enables FileVault using a Personal Recovery Key.
enableFileVault() {
    sudo fdesetup enable -inputplist < /private/tmp/userToAdd.plist
}
# SecureToken enabled users are automatically added to the list of Filevault enabled users when FileVault first is enabled.
# Removes the specified user(s) from the list of FileVault enabled users.
removeUser() {
    sudo fdesetup remove -user $adminUser
    sudo fdesetup remove -user $userName2
}
# Update the preboot role volume's subject directory.
updatePreboot() {
    diskutil apfs updatePreboot /
}
# Deletes the PLIST containing the administrator and user credentials.
cleanUp() {
    rm /private/tmp/userToAdd.plist
}
#
enableSecureToken
createPlist
if [ "$(sudo fdesetup status | head -1)" == "FileVault is On." ]; then
    addUser
else
    enableFileVault
    removeUser
fi
updatePreboot
cleanUp
