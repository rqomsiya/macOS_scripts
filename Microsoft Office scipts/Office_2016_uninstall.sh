#!/bin/bash

#Get Currently Loggedin User
declare -x loggedinuser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
echo "Current user is " $loggedinuser

declare -x current_date=$(date +'%Y%m%d_%H%M%S')

#Kill Office processes
killall "Microsoft Excel"
killall "Microsoft Word"
killall "Microsoft OneNote"
killall "Microsoft Powerpoint"
killall "Microsoft Outlook"
killall "Microsoft Database Daemon"
killall "Microsoft AU Daemon"


#Function to remove directory only if found
removeDirectory () {
for i in "${@}"; do
	if [[ -d "$1" ]]; then
		/bin/rm -rf "$1"
		/bin/echo "Removed directory ""$i"
	fi
done
}

#Function to remove file only if found
removeFile () {
for i in "${@}"; do
	if [[ -e $1 ]]; then
		/bin/rm -f "$1"
		/bin/echo "Removed file ""$i"
	fi
done
}

#Function to backup Office/Outlook preferences/profiles only if found
backup () {
for i in "${@}"; do
	if [[ -d $1 ]]; then
		sudo -u "$loggedinuser" /bin/mv "$1" /Users/$loggedinuser/Documents/Office_2016_Backup_"$current_date"/Office/
		/bin/echo "Backed up ""$i"" to /Users/$loggedinuser/Documents/Office_2016_Backup_$current_date/Office/"
	fi
done
}

#Removing Office 2016 apps
removeDirectory "/Applications/Microsoft Excel.app"
removeDirectory "/Applications/Microsoft OneNote.app"
removeDirectory "/Applications/Microsoft Outlook.app"
removeDirectory "/Applications/Microsoft PowerPoint.app"
removeDirectory "/Applications/Microsoft Word.app"

#Remove Offie 2016 volume licensing
removeFile "/Library/LaunchDaemons/com.microsoft.office.licensingV2.helper.plist"
removeFile "/Library/PrivilegedHelperTools/com.microsoft.office.licensingV2.helper"
removeFile "/Library/Preferences/com.microsoft.office.licensingV2.plist"

rm -rf /Library/LaunchDaemons/com.microsoft.office.licensingV2.helper.plist
rm -rf /Library/PrivilegedHelperTools/com.microsoft.office.licensingV2.helper
rm -rf /Library/Preferences/com.microsoft.office.licensingV2.plist

#Remove Office 2016 user preferences
removeDirectory "/User/$loggedinuser/Library/Containers/com.microsoft.errorreporting"
removeDirectory "/User/$loggedinuser/Library/Containers/com.microsoft.netlib.shipassertprocess"
removeDirectory "/User/$loggedinuser/Library/Containers/com.microsoft.Office365ServiceV2"
removeDirectory "/User/$loggedinuser/Library/Containers/com.microsoft.Outlook"
removeDirectory "/User/$loggedinuser/Library/Containers/com.microsoft.Powerpoint"
removeDirectory "/User/$loggedinuser/Library/Containers/com.microsoft.RMS-XPCService"
removeDirectory "/User/$loggedinuser/Library/Containers/com.microsoft.Word"
removeDirectory "/User/$loggedinuser/Library/Containers/com.microsoft.onenote.mac"

#Backup Outlook for Mac 2016
if [ ! -d /Users/$loggedinuser/Documents/Office_2016_Backup_"$current_date"/Office ]; then
	sudo -u "$loggedinuser" /bin/mkdir -p /Users/$loggedinuser/Documents/Office_2016_Backup_"$current_date"/Office/
	echo Creating /Users/$loggedinuser/Documents/Office_2016_Backup_"$current_date"/Office/
fi

backup "/Users/$loggedinuser/Library/Group Containers/UBF8T346G9.Office/"
backup "/Users/$loggedinuser/Library/Group Containers/UBF8T346G9.MS"
backup "/Users/$loggedinuser/Library/Group Containers/UBF8T346G9.OfficeOsfWebHost"


OFFICERECEIPTS=$(pkgutil --pkgs=com.microsoft.office.*)

for ARECEIPT in $OFFICERECEIPTS
do
	pkgutil --forget $ARECEIPT
done

exit 0
