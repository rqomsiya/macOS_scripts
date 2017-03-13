#!/bin/sh

su "$3" -c  '/usr/bin/defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true'
su "$3" -c  '/usr/bin/defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true'
su "$3" -c  '/usr/bin/defaults write com.apple.finder ShowMountedServersOnDesktop -bool true'
su "$3" -c  '/usr/bin/defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true'

/usr/bin/killall Finder

exit 0