#!/bin/sh

/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -users cgadmin -privs -all -restart -agent –menu

exit 0