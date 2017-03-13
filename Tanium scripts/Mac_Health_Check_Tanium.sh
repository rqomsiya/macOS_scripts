#!/bin/bash

# TODO
# - Irrelevant errors while checking disks
# - Use askpass to deal with softwareupdate

echo
echo "############################################"
echo "#            SYSTEM DIAGNOSTICS            #"
echo "############################################"
echo
echo "------------ PERMISSION REPAIR -------------"
diskutil repairPermissions /
for volume in /Volumes/*; do
	volumeNames=("${volumeNames[@]}" "$volume")
	diskInfoBlurb=$(diskutil info "$volume")
	declare -a diskInfoParsed
	declare -i index
	declare -i total
	declare -i free
	declare volumeVerifyStatus="Good"
	declare diskVerifyStatus="Good"
	diskInfoParsed=($diskInfoBlurb)
	echo
	echo "********************************************"
	echo "$volume"
	echo "********************************************"
	echo "----------- VOLUME VERIFICATION ------------"
	diskutil verifyVolume "$volume"
	if [[ "$?" != "0" ]]; then
		volumeVerifyStatus="Error"
	fi
	echo
	echo "------------ DISK VERIFICATION -------------"
	for (( i=0; i < ${#diskInfoParsed[@]}; ++i )); do
		if [[ "${diskInfoParsed[$i]}" = "of" && "${diskInfoParsed[$i+1]}" = "Whole:" ]]; then
			index=$i+2
			echo "Disk: ${diskInfoParsed[$index]}"
			diskutil verifyDisk "${diskInfoParsed[$index]}"
			if [[ "$?" != "0" ]]; then
				diskVerifyStatus="Error"
			fi
			echo
		fi
	done
	echo
	echo "---------------- DISK USAGE ----------------"
	for (( i=0; i < ${#diskInfoParsed[@]}; ++i )); do
		if [[ "${diskInfoParsed[$i]}" = "Total" &&  "${diskInfoParsed[$i+1]}" = "Size:" ]]; then
			index=$i+4
			total=${diskInfoParsed[$index]#*(}
			free=${diskInfoParsed[$index+10]#*(}
			echo "$total Bytes total"
			echo "$free Bytes free"
			python -c "print ($total-$free)/1000000000.0, 'GB used'"
		fi
	done
	echo
	echo "------------------ SUMMARY -----------------"
	echo "Volume: $volume"
	echo "Volume Verification: $volumeVerifyStatus"
	echo "Disk Verification: $diskVerifyStatus"
	python -c "print 'Total Space:', $total/1000000000.0, 'GB'"
	python -c "print 'Total Used:', ($total-$free)/1000000000.0, 'GB'"
	echo
done
echo