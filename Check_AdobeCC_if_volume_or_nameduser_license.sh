#!/bin/bash

file_path='/Library/Application Support/regid.1986-12.com.adobe/regid.1986-12.com.adobe_V7{}CreativeCloudEnt-1.0-Mac-GM-MUL.swidtag'
subscription_pattern='<swid:channel_type>SUBSCRIPTION'
volume_pattern='<swid:channel_type>VOLUME'

if [[ ! -f "${file_path}" ]]; then 
	echo "I can't find a file at location: ${file_path}"
	echo "Exiting..."
	exit 1 
fi

if grep -q "${subscription_pattern}" "${file_path}"; then
	echo "This is a subscription license";
elif grep -q "${volume_pattern}" "${file_path}"; then
	echo "This is a volume license"
else
	echo "I dont know what kind of license this is"
fi
