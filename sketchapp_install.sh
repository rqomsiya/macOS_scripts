#!/bin/bash

function ConfigureSkecth () {

    echo "`date` Adding preferences for all users"
    defaults write /Library/Preferences/com.bohemiancoding.sketch3.plist SUEnableAutomaticChecks -bool NO
    defaults write /Library/Preferences/com.bohemiancoding.sketch3.plist SUAutomaticallyUpdate -bool NO
    defaults write /Library/Preferences/com.bohemiancoding.sketch3.plist SUHasLaunchedBefore -bool YES
    defaults write /Library/Preferences/com.bohemiancoding.sketch3.plist hasShown23Welcome -bool YES
    echo "`date` All preferences are now added"
    echo "`date` Installation is now complete"
    echo "`date` ========== Installation Ended =========="

}


function SerializeSketch () {

    # add serial number for current and all future users
    CurrentUsers=`sudo -u $(ls -l /dev/console | awk {'print $3'}) ls /Users/  | tr '\n' ' '`
    LicenseKey="SK3-XXX-XXXX-XXXX-XXXX-XXXX"
    echo "`date` Adding license key for current users"
    if [[ -e /Library/Application\ Support/com.bohemiancoding.sketch3 ]]; then
        rm -rf /Library/Application\ Support/com.bohemiancoding.sketch3
        mkdir -p /Library/Application\ Support/com.bohemiancoding.sketch3
        touch /Library/Application\ Support/com.bohemiancoding.sketch3/.deployment
        echo "$LicenseKey" > /Library/Application\ Support/com.bohemiancoding.sketch3/.deployment
    else    
        mkdir -p /Library/Application\ Support/com.bohemiancoding.sketch3
        touch /Library/Application\ Support/com.bohemiancoding.sketch3/.deployment
        echo "$LicenseKey" > /Library/Application\ Support/com.bohemiancoding.sketch3/.deployment
    fi
    echo "`date` All license keys are now added"
    echo "`date` Starting Configuration"
    ConfigureSkecth

}


function InstallSketch () {

    # download and install the latest version
    until [[ -d '/Applications/Sketch.app' ]]; do
        if [[ -e /tmp/sketch.zip ]]; then
            rm -rf /tmp/sketch.zip
        fi
        if [[ -d /tmp/__MACOSX ]]; then
            rm -rf /tmp/__MACOSX/
        fi
        if [[ -d /tmp/Sketch.app ]]; then
            rm -rf /tmp/Sketch.app
        fi
        echo "`date` Downloading Sketch"
        curl -L -o /tmp/sketch.zip "https://download.sketchapp.com/sketch-41.2.zip" >/dev/null 2>&1
        echo "`date` Download complete"
        cd /tmp/
        echo "`date` Unzipping archive"
        unzip sketch.zip  >/dev/null 2>&1
        echo "`date` Archive unizpped"
        echo "`date` Moving Sketch.app to the Applications directory"
        mv Sketch.app /Applications
        echo "`date` Editing permissions"
        chown -R root:wheel /Applications/Sketch.app
        chmod -R 755 /Applications/Sketch.app
        cd ~
        echo "`date` Removing temporary files"
        rm -rf /tmp/sketch.zip && rm -rf /tmp/__MACOSX && rm -rf /tmp/Sketch.app
    done
    echo "`date` App Installed"
    echo "`date` Starting Serialization"
    SerializeSketch

}


function RemoveSketch () {

    # Remove and all related files if sketch if installed
    echo "`date` Removing Sketch.app"
    if [[ -d '/Applications/Sketch.app' ]]; then
        until [[ ! -d '/Applications/Sketch.app' ]]; do
            rm -rf /Applications/Sketch.app
        done
        echo "`date` Sketch.app was removed"
        echo "`date` Removing related files"
        for dir in Users private System; do
            find /$dir -name "*bohemiancoding*" -exec rm -rf {} \; >/dev/null 2>&1
        done
        echo "`date` All related files were removed"
        echo "`date` Begining installation of sketch3"
        InstallSketch
    fi

}

function DetectSketch () {

    # Check to see whether Sketch is installed or not, if yes, remove it, then install latest, if no, then install latest.
    pgrep Sketch >/dev/null
    if [[ $? = 0 ]]; then
        pkill Sketch
    fi
    echo "`date` ========== Installation Started =========="
    echo "`date` Detecting if Sketch is installed or not"
    if [[ -d '/Applications/Sketch.app' ]]; then
        echo "`date` Sketch was detected, will remove"
        RemoveSketch
    else
        echo "`date` Sketch was not detected, will install"
        InstallSketch
    fi

}

function LogSketch () {

    # Setup log files if logs do not exists, create it, otherwise start logging
    LogFile="/Library/Logs/sketch3_install.log"
    if [[ ! -e $LogFile ]]; then
        touch $LogFile && exec >> $LogFile
        echo "`date` ========== Log File Created =========="
    else
        exec >> $LogFile
    fi

}

LogSketch
DetectSketch

exit 0
