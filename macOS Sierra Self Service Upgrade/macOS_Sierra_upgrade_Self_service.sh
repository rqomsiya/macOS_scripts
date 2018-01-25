#!/bin/bash

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# Owner: RYQ (Capital Group Companies)
# Edited: 1/25/2018
# Tested on 10.10.5 / 10.11.5 / 10.11.6 Clients to upgrade to 10.12.6
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# USER VARIABLES
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

##Enter 0 for Full Screen, 1 for Utility window (screenshots available on GitHub)
userDialog=0

#Specify path to OS installer. Use Parameter 4 in the JSS, or specify here
#Example: /Applications/Install macOS High Sierra.app
OSInstaller="$4"

##Version of OS. Use Parameter 5 in the JSS, or specify here.
#Example: 10.12.5
version="$5"

#Trigger used for download. Use Parameter 6 in the JSS, or specify here.
#This should match a custom trigger for a policy that contains an installer
#Example: download-sierra-install
download_trigger="$6"

#Management Account Username and Password variables
#Required for authenticated reboot, management account must be FV2 enabled
#If left blank, authenticated reboot will not happen
mgmtUser="$7"
mgmtPass="$8"

#Title of OS
#Example: macOS High Sierra
macOSname=`echo "$OSInstaller" |sed 's/^\/Applications\/Install \(.*\)\.app$/\1/'`

##Title to be used for userDialog (only applies to Utility Window)
title="$macOSname Upgrade"

##Heading to be used for userDialog
heading="Please wait as we prepare your computer for $macOSname..."

##Title to be used for userDialog
description="
This process will take approximately 5-10 minutes.
Once completed your computer will reboot and begin the upgrade."

#Description to be used prior to downloading the OS installer
dldescription="We need to download $macOSname to your computer, this will \
take several minutes."

##Icon to be used for userDialog
##Default is macOS Installer logo which is included in the staged installer package
icon="$OSInstaller/Contents/Resources/InstallAssistant.icns"

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# SYSTEM CHECKS
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

##Check if device is on battery or ac power
pwrAdapter=$( /usr/bin/pmset -g ps )
if [[ ${pwrAdapter} == *"AC Power"* ]]; then
    pwrStatus="OK"
    /bin/echo "Power Check: OK - AC Power Detected"
else
    pwrStatus="ERROR"
    /bin/echo "Power Check: ERROR - No AC Power Detected"
fi

##Check if free space > 15GB
osMinor=$( /usr/bin/sw_vers -productVersion | awk -F. {'print $2'} )
if [[ $osMinor -ge 12 ]]; then
    freeSpace=$( /usr/sbin/diskutil info / | grep "Available Space" | awk '{print $6}' | cut -c 2- )
else
    freeSpace=$( /usr/sbin/diskutil info / | grep "Free Space" | awk '{print $6}' | cut -c 2- )
fi

if [[ ${freeSpace%.*} -ge 15000000000 ]]; then
    spaceStatus="OK"
    /bin/echo "Disk Check: OK - ${freeSpace%.*} Bytes Free Space Detected"
else
    spaceStatus="ERROR"
    /bin/echo "Disk Check: ERROR - ${freeSpace%.*} Bytes Free Space Detected"
fi

##Check for existing OS installer
if [ -e "$OSInstaller" ]; then
  /bin/echo "$OSInstaller found, checking version."
  OSVersion=`/usr/libexec/PlistBuddy -c 'Print :"System Image Info":version' "$OSInstaller/Contents/SharedSupport/InstallInfo.plist"`
  /bin/echo "OSVersion is $OSVersion"
  if [ $OSVersion = $version ]; then
    downloadOS="No"
  else
    downloadOS="Yes"
    ##Delete old version.
    /bin/echo "Installer found, but old. Deleting..."
    /bin/rm -rf "$OSInstaller"
  fi
else
  downloadOS="Yes"
fi

##Download OS installer if needed
if [ $downloadOS = "Yes" ]; then
  /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper \
      -windowType utility -title "$title"  -alignHeading center -alignDescription left -description "$dldescription" \
      -button1 Ok -defaultButton 1 -icon "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/SidebarDownloadsFolder.icns" -iconSize 100
  ##Run policy to cache installer
  /usr/local/jamf/bin/jamf policy -event $download_trigger
else
  /bin/echo "$macOSname installer with $version was already present, continuing..."
fi

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# CREATE FIRST BOOT SCRIPT
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

/bin/mkdir /usr/local/jamfps

/bin/echo "#!/bin/bash
## First Run Script to remove the installer.
## Clean up files
/bin/rm -fdr "$OSInstaller"
/bin/sleep 2
## Update Device Inventory
/usr/local/jamf/bin/jamf recon
#Cleanup IAQuitInsteadOfReboot key
/usr/bin/defaults delete /Library/Preferences/.GlobalPreferences IAQuitInsteadOfReboot
## Remove LaunchDaemon
/bin/rm -f /Library/LaunchDaemons/com.jamfps.cleanupOSInstall.plist
## Remove Script
/bin/rm -fdr /usr/local/jamfps
exit 0" > /usr/local/jamfps/finishOSInstall.sh

/usr/sbin/chown root:admin /usr/local/jamfps/finishOSInstall.sh
/bin/chmod 755 /usr/local/jamfps/finishOSInstall.sh

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# LAUNCH DAEMON
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

cat << EOF > /Library/LaunchDaemons/com.jamfps.cleanupOSInstall.plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.jamfps.cleanupOSInstall</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>-c</string>
        <string>/usr/local/jamfps/finishOSInstall.sh</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

##Set the permission on the file just made.
/usr/sbin/chown root:wheel /Library/LaunchDaemons/com.jamfps.cleanupOSInstall.plist
/bin/chmod 644 /Library/LaunchDaemons/com.jamfps.cleanupOSInstall.plist

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
# APPLICATION
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #

#Set key to Quit instead of reboot. Reboot will be handled by JAMF policy. This key is deleted as part of first boot script.
/usr/bin/defaults write /Library/Preferences/.GlobalPreferences IAQuitInsteadOfReboot -bool YES

##Caffeinate
/usr/bin/caffeinate -dis &
caffeinatePID=$(echo $!)

if [[ ${pwrStatus} == "OK" ]] && [[ ${spaceStatus} == "OK" ]]; then
    ##Launch jamfHelper
    if [[ ${userDialog} == 0 ]]; then
        /bin/echo "Launching jamfHelper as FullScreen..."
        /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType fs -title "" -icon "$icon" -heading "$heading" -description "$description" &
        jamfHelperPID=$(echo $!)
    fi
    if [[ ${userDialog} == 1 ]]; then
        /bin/echo "Launching jamfHelper as Utility Window..."
        /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "$title" -icon "$icon" -heading "$heading" -description "$description" -iconSize 100 &
        jamfHelperPID=$(echo $!)
    fi
    
    #Check to make sure we've got credentials for authenticated reboot
    if [ "$mgmtUser" != "" ] && [ "$mgmtPass" != "" ]; then
      
      #Create a plist to read in to authrestart
      fvplist="<?xml version=\"1.0\" encoding=\"UTF-8\"?>
        <!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyLIst-1.0.dtd\">
        <plist version=\"1.0\">
        <dict>
        <key>Username</key>
        <string>$mgmtUser</string>
        <key>Password</key>
        <string>$mgmtPass</string>
        </dict>
        </plist>"

      #Write out the plist
      echo $fvplist > /tmp/fv.plist
    fi

    ##Begin Upgrade
    /bin/echo "Launching startosinstall..."
    "$OSInstaller/Contents/Resources/startosinstall" --applicationpath "$OSInstaller" --nointeraction --pidtosignal $jamfHelperPID &
    /bin/sleep 3
else
    ## Remove Script
    /bin/rm -f /usr/local/jamfps/finishOSInstall.sh
    /bin/rm -f /Library/LaunchDaemons/com.jamfps.cleanupOSInstall.plist

    /bin/echo "Launching jamfHelper Dialog (Requirements Not Met)..."
    /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -title "$title" -icon "$icon" -heading "Requirements Not Met" -description "We were unable to prepare your computer for $macOSname. Please ensure you are connected to power and that you have at least 15GB of Free Space.
    If you continue to experience this issue, please contact the IT Support Center." -iconSize 100 -button1 "OK" -defaultButton 1

fi

##Kill Caffeinate
kill ${caffeinatePID}

#Trigger an authenticated reboot
fdesetup authrestart -inputplist < /tmp/fv.plist

exit 0
