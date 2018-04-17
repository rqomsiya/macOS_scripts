#!/bin/bash

echo "Stopping application"
osascript -e 'tell application "PrinterInstallerClient" to quit' || true

echo "Removing services"
launchctl unload /Library/LaunchDaemons/com.printerlogic.client.plist || true
launchctl remove com.printerlogic.client || true
launchctl unload /Library/LaunchAgents/com.printerlogic.client.scheduled_refresh.plist || true
# Remove any scheduled_refresh tasks from older versions
launchctl remove com.printerlogic.client.scheduled_refresh || true
launchctl unload /Library/LaunchAgents/com.printerlogic.client.scheduled_refresh.*.plist || true
killall -9 PrinterInstallerClientService || true
killall -9 PrinterInstallerClientInterface || true
rm -f /Library/LaunchDaemons/com.printerlogic.client* || true
rm -f /Library/LaunchAgents/com.printerlogic.client* || true

echo "Unregistering apps"
pkgutil --packages | grep printerlogic | xargs -n 1 pkgutil --forget 2> /dev/null || true
rm -rf /Applications/PrinterInstallerClient.app || true

echo "Removing web browser plugin"
rm -f /Library/Internet\ Plug-Ins/npPrinterInstallerClientPlugin.plugin || true

echo "Deleting files"
rm -rf /opt/PrinterInstallerClient/tmp || true
rm -f /Applications/Printer\ Installer\ Client.app || true
rm -rf /opt/PrinterInstallerClient || true

echo "Uninstallation complete"
