Prerequisites:
- Need Packages.app application
- Need MS Full installer from http://macadmins.software 

STEPS:
1) Open up Packages.app
2) Create RAW package
3) Copy MS Installer Choices XML in Payloads
4) Copy post-install script to package


# See below line for Post Install Script (Copy lines between -- marks)
--------------------
#!/bin/bash

# Determine working directory
install_dir=`dirname $0`

#Office Installers
OfficeMain="Microsoft_Office_2016_16.11.18031100_Installer.pkg"
Office_Choices="Office2016_Choice.xml"
VolumeSerializer="Microsoft_Office_2016_VL_Serializer_2.0.pkg"

#Install Office 2016
/usr/sbin/installer -dumplog -verbose -pkg $install_dir/"$OfficeMain" -applyChoiceChangesXML $install_dir/"$Office_Choices" -target "$3" -target "$3" -allowUntrusted
-----------------------

Choices XML (Excludes AutoUpdate, OneNote and Volume licnese keys -which will be deployed as separate package in JAMF policy)
# See below line for choices.xml file (Copy Between lines)
-------
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<array>
	<dict>
		<key>attributeSetting</key>
		<integer>1</integer>
		<key>choiceAttribute</key>
		<string>selected</string>
		<key>choiceIdentifier</key>
		<string>com.microsoft.word</string>
	</dict>
	<dict>
		<key>attributeSetting</key>
		<integer>1</integer>
		<key>choiceAttribute</key>
		<string>selected</string>
		<key>choiceIdentifier</key>
		<string>com.microsoft.excel</string>
	</dict>
	<dict>
		<key>attributeSetting</key>
		<integer>1</integer>
		<key>choiceAttribute</key>
		<string>selected</string>
		<key>choiceIdentifier</key>
		<string>com.microsoft.powerpoint</string>
	</dict>
	<dict>
		<key>attributeSetting</key>
		<integer>0</integer>
		<key>choiceAttribute</key>
		<string>selected</string>
		<key>choiceIdentifier</key>
		<string>com.microsoft.onenote.mac</string>
	</dict>
	<dict>
		<key>attributeSetting</key>
		<integer>1</integer>
		<key>choiceAttribute</key>
		<string>selected</string>
		<key>choiceIdentifier</key>
		<string>com.microsoft.outlook</string>
	</dict>
	<dict>
		<key>attributeSetting</key>
		<integer>0</integer>
		<key>choiceAttribute</key>
		<string>selected</string>
		<key>choiceIdentifier</key>
		<string>com.microsoft.autoupdate</string>
	</dict>
	<dict>
		<key>attributeSetting</key>
		<integer>0</integer>
		<key>choiceAttribute</key>
		<string>selected</string>
		<key>choiceIdentifier</key>
		<string>com.microsoft.licensing</string>
	</dict>
	<dict>
		<key>attributeSetting</key>
		<integer>1</integer>
		<key>choiceAttribute</key>
		<string>selected</string>
		<key>choiceIdentifier</key>
		<string>com.microsoft.office.fonts</string>
	</dict>
	<dict>
		<key>attributeSetting</key>
		<integer>1</integer>
		<key>choiceAttribute</key>
		<string>selected</string>
		<key>choiceIdentifier</key>
		<string>com.microsoft.office.frameworks</string>
	</dict>
	<dict>
		<key>attributeSetting</key>
		<integer>1</integer>
		<key>choiceAttribute</key>
		<string>selected</string>
		<key>choiceIdentifier</key>
		<string>com.microsoft.office.proofing</string>
	</dict>
</array>
</plist>
-------------
