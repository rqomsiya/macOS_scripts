#!/bin/bash


# Apply the dockutil settings to current logging in user $3

sleep 10

sudo -u $3 /usr/local/bin/dockutil --remove all "/Users/$3"
sudo -u $3 /usr/local/bin/dockutil --add '/Applications/Launchpad.app' "/Users/$3"
sudo -u $3 /usr/local/bin/dockutil --add '/Applications/Safari.app' "/Users/$3"
sudo -u $3 /usr/local/bin/dockutil --add '/Applications/Google Chrome.app' "/Users/$3"
sudo -u $3 /usr/local/bin/dockutil --add '/Applications/Microsoft Office 2011/Microsoft Word.app' "/Users/$3"
sudo -u $3 /usr/local/bin/dockutil --add '/Applications/Microsoft Office 2011/Microsoft Excel.app' "/Users/$3"
sudo -u $3 /usr/local/bin/dockutil --add '/Applications/Microsoft Office 2011/Microsoft PowerPoint.app' "/Users/$3"
sudo -u $3 /usr/local/bin/dockutil --add '/Applications/Microsoft Office 2011/Microsoft Outlook.app' "/Users/$3"
sudo -u $3 /usr/local/bin/dockutil --add '/Applications' --view grid --display folder --sort name "/Users/$3"
sudo -u $3 /usr/local/bin/dockutil --add '/Applications/Utilities/Self Service.app' "/Users/$3"
sudo -u $3 /usr/local/bin/dockutil --add '/Applications/Microsoft Lync.app' "/Users/$3"
sudo -u $3 /usr/local/bin/dockutil --add '~/Documents' --view grid --display folder --sort name "/Users/$3"