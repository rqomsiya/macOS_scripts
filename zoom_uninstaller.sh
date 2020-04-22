#!/usr/bin/env bash

######################
### make it pretty ###
######################

if [ "$TERM" == "dumb" ]; then
    COL_RESET=""
    COL_GREEN=""
    COL_YELLOW=""
    COL_RED=""
    BOLD=""
    NORMAL=""
else
    ESC_SEQ="\x1b["
    COL_RESET=$ESC_SEQ"39;49;00m"
    COL_GREEN=$ESC_SEQ"32;01m"
    COL_YELLOW=$ESC_SEQ"33;01m"
    COL_RED=$ESC_SEQ"31;01m"
    BOLD=$(tput bold)
    NORMAL=$(tput sgr0)
fi

###############
### helpers ###
###############

function not_found() {
    echo -e "${COL_GREEN}[not found]${COL_RESET} " #$1
}

function deleted() {
    echo -e "${COL_YELLOW}[deleted]${COL_RESET} " #$1
}

function terminated() {
    echo -e "${COL_RED}[terminated]${COL_RESET} " #$1
}

loggedInUser=$(stat -f "%Su" /dev/console)

###################
### remove zoom ###
###################

# prompt the user for their password if required

echo ""
echo -e "${BOLD}Please Note:${NORMAL} This script will prompt for your password if you are not already running as sudo."

sudo -v

# kill the Zoom process if it's running

echo ""
echo -e "${BOLD}Checking to see if the Zoom process is running...${NORMAL}"

if pgrep -i zoom >/dev/null; then

    sudo kill "$(pgrep -i zoom)"
    printf "Zoom process "
    terminated

else

    printf "Zoom process "
    not_found

fi

# remove the Zoom application

echo ""
echo -e "${BOLD}Removing the Zoom Application...${NORMAL}"

declare -a ZOOM_APPLICATION=(
    "/Applications/zoom.us.app"
    "/Users/$loggedInUser/Applications/zoom.us.app"
)

for ENTRY in "${ZOOM_APPLICATION[@]}"; do
    if [ -f "${ENTRY}" ] || [ -d "${ENTRY}" ]; then
        sudo rm -rf "${ENTRY}"
        printf "%s " "${ENTRY}"
        deleted
    else
        printf "%s " "${ENTRY}"
        not_found
    fi
done

# unload the Zoom Audio Device and remove the kext file

echo ""
echo -e "${BOLD}Removing the Zoom Audio Device...${NORMAL}"

if [ -f "/System/Library/Extensions/ZoomAudioDevice.kext" ] || [ -d "/System/Library/Extensions/ZoomAudioDevice.kext" ]; then

    sudo kextunload -b zoom.us.ZoomAudioDevice
    sudo rm -rf "/System/Library/Extensions/ZoomAudioDevice.kext"
    printf "/System/Library/Extensions/ZoomAudioDevice.kext file "
    deleted

else

    printf "/System/Library/Extensions/ZoomAudioDevice.kext file "
    not_found

fi

declare -a ZOOM_AUDIO_DEVICE=(
    "/Library/Audio/Plug-Ins/HAL/ZoomAudioDevice.driver"
)

for ENTRY in "${ZOOM_AUDIO_DEVICE[@]}"; do
    if [ -f "${ENTRY}" ] || [ -d "${ENTRY}" ]; then
        sudo rm -rf "${ENTRY}"
        printf "%s " "${ENTRY}"
        deleted
    else
        printf "%s " "${ENTRY}"
        not_found
    fi
done

# remove the Zoom Plugin

echo ""
echo -e "${BOLD}Removing Zoom Plugins...${NORMAL}"

declare -a ZOOM_PLUGIN=(
    "/Library/Internet Plug-Ins/ZoomUsPlugIn.plugin"
    "/Users/$loggedInUser/Library/Internet Plug-Ins/ZoomUsPlugIn.plugin"
)

for ENTRY in "${ZOOM_PLUGIN[@]}"; do
    if [ -f "${ENTRY}" ] || [ -d "${ENTRY}" ]; then
        sudo rm -rf "${ENTRY}"
        printf "%s " "${ENTRY}"
        deleted
    else
        printf "%s " "${ENTRY}"
        not_found
    fi
done

# remove Zoom defaults

echo ""
echo -e "${BOLD}Removing Zoom defaults preferences...${NORMAL}"

if ! sudo defaults read us.zoom.xos 2>&1 | grep -Eq "Domain us.zoom.xos does not exist"; then

    sudo defaults delete us.zoom.xos
    printf "sudo defaults read us.zoom.xos "
    deleted

else

    printf "sudo defaults read us.zoom.xos "
    not_found

fi

echo ""
echo -e "${BOLD}Removing pkgutil history...${NORMAL}"

if pkgutil --pkgs | grep -Eq "us.zoom.pkg.videmeeting"; then

    sudo pkgutil --forget us.zoom.pkg.videmeeting &> /dev/null
    printf "pkgutil history for us.zoom.pkg.videmeeting "
    deleted

else

    printf "pkgutil history for us.zoom.pkg.videmeeting "
    not_found

fi

# remove extra Zoom cruft

echo ""
echo -e "${BOLD}Removing extra cruft that Zoom leaves behind...${NORMAL}"

declare -a ZOOM_CRUFT=(
    "/Users/$loggedInUser/.zoomus"
    "/Users/$loggedInUser/Library/Application Support/zoom.us"
    "/Library/Caches/us.zoom.xos"
    "/Users/$loggedInUser/Library/Caches/us.zoom.xos"
    "/Library/Logs/zoom.us"
    "/Users/$loggedInUser/Library/Logs/zoom.us"
    "/Library/Logs/zoominstall.log"
    "/Users/$loggedInUser/Library/Logs/zoominstall.log"
    "/Library/Preferences/ZoomChat.plist"
    "/Users/$loggedInUser/Library/Preferences/ZoomChat.plist"
    "/Library/Preferences/us.zoom.xos.plist"
    "/Users/$loggedInUser/Library/Preferences/us.zoom.xos.plist"
    "/Users/$loggedInUser/Library/Saved Application State/us.zoom.xos.savedState"
    "/Users/$loggedInUser/Library/Cookies/us.zoom.xos.binarycookies"
    "/Users/$loggedInUser/Library/Preferences/us.zoom.xos.Hotkey.plist"
    "/Users/$loggedInUser/Library/Preferences/us.zoom.airhost.plist"
    "/Users/$loggedInUser/Library/Mobile Documents/iCloud~us~zoom~videomeetings"
    "/Users/$loggedInUser/Library/Application Support/CloudDocs/session/containers/iCloud.us.zoom.videomeetings.plist"
    "/Users/$loggedInUser/Library/Application Support/CloudDocs/session/containers/iCloud.us.zoom.videomeetings"
)

for ENTRY in "${ZOOM_CRUFT[@]}"; do
    if [ -f "${ENTRY}" ] || [ -d "${ENTRY}" ]; then
        sudo rm -rf "${ENTRY}"
        printf "%s " "${ENTRY}"
        deleted
    else
        printf "%s " "${ENTRY}"
        not_found
    fi
done
