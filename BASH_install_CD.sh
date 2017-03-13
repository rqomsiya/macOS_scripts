#!/bin/sh
    # Remove temp pipe file if exists
    rm -f /tmp/cdupdatepipe
    
    # Create temp pipe file
    mkfifo /tmp/cdupdatepipe
    
    sleep 0.2
    
    # Start cocoaDialog prompt
    /usr/local/bin/cocoaDialog.app/Contents/MacOS/cocoaDialog progressbar --indeterminate --title "Updates Are Being Installed, A Restart Will Follow" --height "128" --width "500" --icon "installer" --icon-height "96" --icon-width "96" --float < /tmp/cdupdatepipe &
    
    # Echo out to pipe to be relayed to cocoaDialog window
    exec 3<> /tmp/cdupdatepipe
    
    # Install all jamf cached updates, echoing out to cocoaDialog prompt
    sudo jamf installAllCached 2>&1 | while read line; do
         echo "10 $line" >&3
    done
    
    # Restart countdown
    restartTimeout=5
    while [ $restartTimeout -ge 1 ]
    do
       echo "20 Restarting In $restartTimeout..."  >&3 
    sleep 1
       restartTimeout=$[$restartTimeout-1]
    done
    # Remove dummy receipt
    sudo rm -rf /.jssUpdates-Cached
    # Restart
    sudo jamf reboot -immediately
    
    exit 0