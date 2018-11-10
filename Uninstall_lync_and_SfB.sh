#!/bin/sh
# script to remove items listed on https://support.microsoft.com/en-us/kb/2691870 "How to perform a clean uninstall of Lync for Mac 2011"
# 10/25/2016-added lines based on script Dave Fisher posted on Slack
# 10/25/2016-Lucas Vance from jamf support helped with cut commands for userEmail
# tested in an AD environment

# Pull current logged in user into 'user' variable.
user=`ls -l /dev/console | cut -d " " -f 4`

# #2 Kill Lync & SfB
killall "Microsoft Lync"
killall "Skype for Business"

# #3 Delete the Lync & SfB applications
rm -rf /Applications/Microsoft\ Lync.app
rm -rf /Applications/Skype\ For\ Business.app

# #4 Delete caches, cookies, OC_KeyContainer, preferences, receipts & logs (if present) 
rm -rf /Users/$user/Library/Application\ Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.microsoft.lync.sfl
rm -rf /Users/$user/Library/Cookies/com.microsoft.Lync.binarycookies
rm -rf /Users/$user/Library/Caches/com.microsoft.Lync
rm -rf /Users/$user/Library/Group\ Containers/UBF8T346G9.Office/Lync
rm -rf /Users/$user/Library/Logs/Microsoft-Lync*
rm -rf /Users/$user/Library/Preferences/ByHost/MicrosoftLync*
rm -rf /Users/$user/Library/Preferences/com.microsoft.Lync.plist
rm -rf /Users/$user/Library/Receipts/Lync.Client.Plugin.plist
rm -rf /Users/$user/Library/Keychains/OC_KeyContainer*

rm -rf /Users/$user/Library/Preferences/com.microsoft.SkypeForBusinessTAP.plist
rm -rf /Users/$user/Library/Logs/com.microsoft.SkypeForBusinessTAP
rm -rf /Users/$user/Library/Application\ Support/Skype\ for\ Business
rm -rf /Users/$user/Library/Application\ Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.microsoft.skypeforbusinesstap.sfl
rm -rf /Users/$user/Library/Application\ Support/com.microsoft.SkypeForBusinessTAP
rm -rf /Users/$user/Library/Cookies/com.microsoft.SkypeForBusinessTAP.binarycookies

# #5 Delete Lync & Skype User Data (but keep Lync Conversation History)
rm -rf /Users/$user/Documents/Microsoft\ User\ Data/Microsoft\ Lync\ Data 
rm -rf /Users/$user/Documents/Microsoft\ User\ Data/Microsoft/Communicator

# #6 remove this file from the Keychains folder and therefore, the Keychain
rm /Users/$user/Library/Keychains/OC_KeyContainer*

