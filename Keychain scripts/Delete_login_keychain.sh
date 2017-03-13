#!/bin/bash

user=$(ls -la /dev/console | cut -d " " -f 4)
rm -rf /Users/$user/Library/Keychains/*

exit 0