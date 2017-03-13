 #!/bin/bash
 
 # give user choice between 2-hour timer and immediate restart
RESPONSE=`sudo -u $(ls -l /dev/console | awk '{print $3}') "$cdPath" msgbox --title "CG Security Update" --text "Software Updates Pending" \ 
			--informative-text "A RESTART is required by one or more installations. You may either restart now by clicking the Restart Now button below, or your machine will restart automatically in 4 hours. A Restart Timer will be provided and you may restart manually at any time before it completes." --icon-file "${msgIcon}" --button1 "2-Hour Timer" --button2 "Restart Now!" --width 450 --height 184 --posY top &`
            #user chose 4-hour timer
            if [ "$RESPONSE" == "1" ]; then
                echo "Initiating 2-hour restart timer and exiting."
                jamf policy -trigger restarttimer &
                exit 0
            #user chose immediate restart
            elif [ "$RESPONSE" == "2" ]; then
                echo "Restarting now."
                jamf policy -trigger authrestart &  
                exit 0
            fi