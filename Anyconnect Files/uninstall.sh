#!/bin/bash

## Uninstall Posture module
/opt/cisco/hostscan/bin/posture_uninstall.sh

## Uninstall VPN Client 
/opt/cisco/anyconnect/bin/anyconnect_uninstall.sh

## Uninstall VPN
/opt/cisco/anyconnect/bin/vpn_uninstall.sh

## Uninstall DART
/opt/cisco/anyconnect/bin/dart_uninstall.sh

## Cleanup any existing Cisco Anyconnect files and folders in /opt/ directory
## This also removes the anyconnect default .xml profile
rm -rf /opt/cisco/

exit 0
