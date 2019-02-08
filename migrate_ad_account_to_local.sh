#!/bin/bash
# Modified 2017-03-03
# Author: Marcus Siöström
# This script is a modified version of https://github.com/rtrouton/rtrouton_scripts/tree/master/rtrouton_scripts/migrate_ad_mobile_account_to_local_account
# This script will convert the currently signed in (GUI) user from a mobile account to a local account whithout user intervention

logfile="/Library/Managed Installs/Logs/DomAccToLocal.log"

RemoveAD(){

    # This function force-unbinds the Mac from the existing Active Directory domain
    # and updates the search path settings to remove references to Active Directory
    searchPath=`/usr/bin/dscl /Search -read . CSPSearchPath | grep Active\ Directory | sed 's/^ //'`

    # Force unbind from Active Directory
    /usr/sbin/dsconfigad -remove -force -u none -p none && echo "Unbound Mac successfully" >> "$logfile" || echo "AD unbinding failed via dsconfigad" >> "$logfile"

    # Deletes the Active Directory domain from the custom /Search
    # and /Search/Contacts paths
    /usr/bin/dscl /Search/Contacts -delete . CSPSearchPath "$searchPath" && echo "Removed searchpath 1" >> "$logfile"
    /usr/bin/dscl /Search -delete . CSPSearchPath "$searchPath" && echo "Removed searchpath 1" >> "$logfile"

    # Changes the /Search and /Search/Contacts path type from Custom to Automatic
    /usr/bin/dscl /Search -change . SearchPolicy dsAttrTypeStandard:CSPSearchPath dsAttrTypeStandard:NSPSearchPath && echo "Set searchpath 1 to automatic" >> "$logfile"
    /usr/bin/dscl /Search/Contacts -change . SearchPolicy dsAttrTypeStandard:CSPSearchPath dsAttrTypeStandard:NSPSearchPath && echo "Set searchpath 2 to automatic" >> "$logfile"
}


user=$(/usr/bin/defaults read /Library/Preferences/com.apple.loginwindow.plist lastUserName 2>/dev/null)
uid=$(/usr/bin/dscl . list /Users UniqueID | awk "/^${user}/" | awk '{print $2}' | sed 's/[^0-9]//g')
checkAD=$(/usr/bin/dscl localhost -list . | grep "Active Directory")



if [ $uid -ge 1000 ]
  then
    echo "UID greater than 999. Continuing" >> "$logfile"
    verifyuser=$(/usr/bin/dscl . list /Users UniqueID | awk "/${uid}$/" | awk '{print $1}')
    if [[ "$verifyuser" = "$user" ]]
      then
        echo "UID verification successfull. Checking if $user is a mobile AD account" >> "$logfile"
        accounttype=`/usr/bin/dscl . -read /Users/"$user" AuthenticationAuthority | head -2 | awk -F'/' '{print $2}' | tr -d '\n'`

    		if [[ "$accounttype" = "Active Directory" ]]
          then
            echo "$user has an AD account. Checking if it is mobile." >> "$logfile"
            mobileusercheck=$(/usr/bin/dscl . -read /Users/"$user" AuthenticationAuthority | head -2 | awk -F'/' '{print $1}' | tr -d '\n' | sed 's/^[^:]*: //' | sed s/\;/""/g)

            if [[ "$mobileusercheck" = "LocalCachedUser" ]]
              then
                echo "$user has an AD mobile account. Converting to a local account with the same username and UID." >> "$logfile"

                # Preserve the account password by backing up password hash
                shadowhash=$(/usr/bin/dscl . -read /Users/$user AuthenticationAuthority | grep " ;ShadowHash;HASHLIST:<")

                # Remove the account attributes that identify it as an Active Directory mobile account
                /usr/bin/dscl . -delete /users/$user cached_groups
                /usr/bin/dscl . -delete /users/$user cached_auth_policy
                /usr/bin/dscl . -delete /users/$user CopyTimestamp
                /usr/bin/dscl . -delete /users/$user AltSecurityIdentities
                /usr/bin/dscl . -delete /users/$user SMBPrimaryGroupSID
                /usr/bin/dscl . -delete /users/$user OriginalAuthenticationAuthority
                /usr/bin/dscl . -delete /users/$user OriginalNodeName
                /usr/bin/dscl . -delete /users/$user AuthenticationAuthority
                /usr/bin/dscl . -create /users/$user AuthenticationAuthority \'$shadowhash\'
                /usr/bin/dscl . -delete /users/$user SMBSID
                /usr/bin/dscl . -delete /users/$user SMBScriptPath
                /usr/bin/dscl . -delete /users/$user SMBPasswordLastSet
                /usr/bin/dscl . -delete /users/$user SMBGroupRID
                /usr/bin/dscl . -delete /users/$user PrimaryNTDomain
                /usr/bin/dscl . -delete /users/$user AppleMetaRecordName
                /usr/bin/dscl . -delete /users/$user PrimaryNTDomain
                /usr/bin/dscl . -delete /users/$user MCXSettings
                /usr/bin/dscl . -delete /users/$user MCXFlags

                # Refresh Directory Services
                /usr/bin/killall opendirectoryd

                sleep 20

                accounttype=$(/usr/bin/dscl . -read /Users/"$user" AuthenticationAuthority | head -2 | awk -F'/' '{print $2}' | tr -d '\n')
          			if [[ "$accounttype" != "Active Directory" ]]
                  then
                    echo "Conversion process was successful. The $user account is now a local account." >> "$logfile"

                    # Add user to the staff group on the Mac
              			/usr/sbin/dseditgroup -o edit -a "$user" -t user staff && echo "Added $user to the staff group on this Mac." >> "$logfile"

                    if [[ "$checkAD" = "Active Directory" ]]
                      then
                        # Unbind this Mac forcefully
                        RemoveAD && echo "Removed AD binding for $(hostname)" >> "$logfile" || echo "Failed to remove AD binding for $(hostname)" >> "$logfile"
                    fi

                    echo "Migration Done" >> "$logfile"

          			  else
                    echo "Something went wrong with the conversion process. The $user account is still an AD mobile account." >> "$logfile"
          			fi
              else
                echo "$user doesn't have a mobile AD account. Aborting" >> "$logfile"
           fi
         else
           echo "$user doesn't have a AD account. Aborting" >> "$logfile"
        fi
      else
        echo "uid verification failed. Aborting" >> "$logfile"
    fi
  else
    echo "UID less than 1000. Aborting" >> "$logfile"
fi
