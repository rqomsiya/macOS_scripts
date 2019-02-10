#!/bin/bash

## Token required to uninstall

token=

## Uninstall command
sudo /Library/Application\ Support/bcua/Uninstall\ Blue\ Coat\ Unified\ Agent.app/Contents/MacOS/uninstall-helper –ut $token

exit 0
