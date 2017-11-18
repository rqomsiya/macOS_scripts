#!/bin/sh

username=$( stat -f%Su /dev/console )

if [ $username = "root" ]; then

#echo "Non AD user logged in- $username - stopping script"
	exit

else

#for cert_name change to what cert you are looking for in users keychain
cert_name="ml"
desired_keychain="/Users/$username/Library/Keychains/login.keychain"


certexpdate=$(/usr/bin/security find-certificate -a -c "$cert_name" -p -Z "$desired_keychain" | /usr/bin/openssl x509 -noout -enddate | cut -f2 -d=)

dateformat=$(/bin/date -j -f "%b %d %T %Y %Z" "$certexpdate" "+%Y-%m-%d %H:%M:%S")

echo "<result>$dateformat</result>"

fi
