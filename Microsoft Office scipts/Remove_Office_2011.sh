#!/bin/bash

####################################################################################################
#
# Copyright (c) 2015, JAMF Software, LLC.  All rights reserved.
#
#       Redistribution and use in source and binary forms, with or without
#       modification, are permitted provided that the following conditions are met:
#               * Redistributions of source code must retain the above copyright
#                 notice, this list of conditions and the following disclaimer.
#               * Redistributions in binary form must reproduce the above copyright
#                 notice, this list of conditions and the following disclaimer in the
#                 documentation and/or other materials provided with the distribution.
#               * Neither the name of the JAMF Software, LLC nor the
#                 names of its contributors may be used to endorse or promote products
#                 derived from this software without specific prior written permission.
#
#       THIS SOFTWARE IS PROVIDED BY JAMF SOFTWARE, LLC "AS IS" AND ANY
#       EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#       WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#       DISCLAIMED. IN NO EVENT SHALL JAMF SOFTWARE, LLC BE LIABLE FOR ANY
#       DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#       (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#       LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#       ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#       (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#       SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
####################################################################################################

consoleuser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

echo "logged in user is" $consoleuser

pkill -f Microsoft

files=(
"/Users/$consoleuser/Library/Preferences/com.microsoft.Excel.plist"
"/Users/$consoleuser/Library/Preferences/com.microsoft.office.plist"
"/Users/$consoleuser/Library/Preferences/com.microsoft.office.setupassistant.plist"
"/Users/$consoleuser/Library/Preferences/com.microsoft.outlook.databasedaemon.plist"
"/Users/$consoleuser/Library/Preferences/com.microsoft.outlook.office_reminders.plist"
"/Users/$consoleuser/Library/Preferences/com.microsoft.Outlook.plist"
"/Users/$consoleuser/Library/Preferences/com.microsoft.PowerPoint.plist"
"/Users/$consoleuser/Library/Preferences/com.microsoft.Word.plist"
#
"/Users/$consoleuser/Library/Preferences/ByHost/com.microsoft*"
#
"/Library/LaunchDaemons/com.microsoft.office.licensing.helper.plist"
"/Library/Preferences/com.microsoft.office.licensing.plist"
"/Library/PrivilegedHelperTools/com.microsoft.office.licensing.helper"
)

folders=(
"/Applications/Microsoft Office 2011"
"/Library/Application Support/Microsoft"
"/Library/Fonts/Microsoft"
"/Users/$consoleuser/Documents/Microsoft User Data"
"/Library/Receipts/Office*"
)

search="*"

for i in "${files[@]}"
do
	if [[ "${i}" == *"$search"* ]] ; then
		echo "removing files like ${i}"
		rm "${i}"
	elif [ -a "${i}" ] ; then
		echo "removing file ${i}"
		rm "${i}"

	fi
done

for i in "${folders[@]}"
do
	echo "removing folder ${i}"
	rm -rf "${i}"
done