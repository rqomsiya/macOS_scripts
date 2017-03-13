#!/bin/bash

if [ ! -d /System/Library/LaunchDaemonsDisabled ];then
	mkdir -p /System/Library/LaunchDaemonsDisabled
fi
if [ ! -d /System/Library/LaunchAgentsDisabled ];then
	mkdir -p /System/Library/LaunchAgentsDisabled
fi

defaults write /Library/Preferences/com.apple.Bluetooth.plist ControllerPowerState -int 0
	
## determine if bluetooth is enabled, and if so disable it
enabled=$(ps -ax | grep blued | grep -v grep)
if [ "$enabled" != "" ];then
	pkill blued
fi

disable_launchctl ()
{
	if [ -f /System/Library/LaunchDaemons/"$1" ];then
		launchctlName=$(echo "$1" | sed -e 's/.plist//g')
		daemonCheck=$(launchctl list | grep "$launchctlName")
		if [ "$daemonCheck" != "" ];then
			launchctl unload -w /System/Library/LaunchDaemons/"$1"
		fi
		mv /System/Library/LaunchDaemons/"$1" /System/Library/LaunchDaemonsDisabled/
	else
		if [ -f /System/Library/LaunchAgents/"$1" ];then
			launchctlName=$(echo "$1" | sed -e 's/.plist//g')
			agentCheck=$(launchctl list | grep "$launchctlName")
			if [ "$agentCheck" != "" ];then
				launchctl unload -w /System/Library/LaunchAgents/"$1"
			fi
			mv /System/Library/LaunchAgents/"$1" /System/Library/LaunchAgentsDisabled/
		fi
	fi	
}

disable_launchctl com.apple.IOBluetoothUSBDFU.plist
disable_launchctl com.apple.blued.plist
disable_launchctl com.apple.bluetoothaudiod.plist
disable_launchctl com.apple.bluetoothUIServer.plist

extensions="/System/Library/Extensions"
mkdir -p /System/Library/DisabledExt

# Driver
sudo mv $extensions/AppleBluetoothMultitouch.kext /System/Library/DisabledExt/
sudo mv $extensions/IOBluetoothFamily.kext /System/Library/DisabledExt/
sudo mv $extensions/IOBluetoothHIDDriver.kext /System/Library/DisabledExt/

# Bluetooth Mouns & Keyboard
sudo mv $extensions/AppleHIDKeyboard.kext/Contents/PlugIns/AppleBluetoothHIDKeyboard.kext /System/Library/DisabledExt/
sudo mv $extensions/AppleHIDMouse.kext/Contents/PlugIns/AppleBluetoothHIDMouse.kext /System/Library/DisabledExt/

touch /System/Library/Extensions
