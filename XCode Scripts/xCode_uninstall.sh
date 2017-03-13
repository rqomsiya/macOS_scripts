#!/bin/bash

# Program		: xcode_uninstall.sh
# Purpose		: Uninstalls XCode and CLI tools
# Owner			: Capital Group Companies
# Author		: Rany Qomsiya (RYQ)
# Note			: This software is provided "AS IS" basis.
# Revisions		: 2016-01-03: Rev1.0a
# Updated (Last): 2016-01-25: Rev1.1a

# Remove existing copy of Xcode.app from /Applications

if [[ -e "/Applications/Xcode.app" ]]; then
	rm -rf "/Applications/Xcode.app"
fi

exit 0