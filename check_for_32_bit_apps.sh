#!/usr/bin/python

"""
this code will run through all installed apps, which are locally installed
and generate a CSV file on your desktop listing all 32bit apps
"""

import subprocess
import plistlib
import csv
from Foundation import NSHomeDirectoryForUser
from SystemConfiguration import SCDynamicStoreCopyConsoleUser


def get32bitapps():
	"""function to get list of 32bit apps from System Profiler"""
	# use a list to generate a subprocess command
	cmd = ['/usr/sbin/system_profiler', '-xml', 'SPApplicationsDataType']
	# execute profiler command via subprocess
	proc = subprocess.Popen(cmd, shell=False, bufsize=-1, stdin=subprocess.PIPE, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
	output, err = proc.communicate()
	plist = plistlib.readPlistFromString(output)
	# create a blank list to populate app info into
	app_list = []
	items = plist[0]['_items']
	for item in items:
		# test for 32bit only apps and add them to a dictionary
		if 'no' in item.get('has64BitIntelCode'):
			app_dict = {}
			app_dict['path'] = item.get('path')
			app_dict['name'] = item.get('_name')
			app_dict['version'] = item.get('version')
			app_list.append(app_dict)
	return app_list

def write_csv(apps):
	"""function to take a dictionary of 32bit apps and output to a CSV file"""
	# this code will output to a CSV file on your desktop and list 32bit apps
	currentuser, uid, gid = SCDynamicStoreCopyConsoleUser(None, None, None)
	user_home_folder = NSHomeDirectoryForUser(currentuser)
	file = user_home_folder + '/Desktop/32bitapps.csv'
	with open(file, 'wb') as csv_file:
		keys = apps[0].keys()
		dict_writer = csv.DictWriter(csv_file, keys)
		dict_writer.writeheader()
		dict_writer.writerows(apps)


# run the above functions to get desired output
applist = get32bitapps()
write_csv(applist)
