#!/bin/sh

#change cert name to whatever cert you are looking for in System keychain
cert_name="Capgroup Private SHA"
certexpdate=$(/usr/bin/security find-certificate -a -c "$cert_name" -p -Z "/Library/Keychains/System.keychain" | /usr/bin/openssl x509 -noout -enddate| cut -f2 -d=)

dateformat=$(/bin/date -j -f "%b %d %T %Y %Z" "$certexpdate" "+%Y-%m-%d %H:%M:%S")

echo "<result>$dateformat</result>"
