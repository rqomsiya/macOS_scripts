#!/usr/bin/python
# Based on:
# https://technet.microsoft.com/en-us/library/jj945448(v=office.14).aspx


import glob
import os
import re
import shutil
import subprocess


FILES_TO_REMOVE = (
	"/Applications/Microsoft Lync.app",
	"/Applications/Microsoft Office 2011/Microsoft Lync.app",
	"/Users/*/Library/Preferences/com.microsoft.Lync.plist",
	"/Users/*/Library/Preferences/ByHost/MicrosoftLyncRegistrationDB.*.plist",
	"/Users/*/Library/Logs/Microsoft-Lync-x.log",
	"/Users/*/Library/Logs/Microsoft-Lync.log",
	"/Users/*/Documents/Microsoft User Data/Microsoft Lync Data",
	"/Users/*/Documents/Microsoft User Data/Microsoft Lync History",
	"/Library/Internet Plug-Ins/MeetingJoinPlugin.plugin")

# Edit to include your company's email domain
# e.g.:
# APP_PW_PATTERN = r".*(OC_KeyContainer__.*@tacos.com).*"
# Multiple domains:
# APP_PW_PATTERN = r".*(OC_KeyContainer__.*@(?:tacos|burritos).com).*"
APP_PW_PATTERN = r".*(OC_KeyContainer__.*@capgroup.com).*"

def main():
	# Get Lync unloaded
	try:
		subprocess.check_call(["killall", "Microsoft Lync"])
	except subprocess.CalledProcessError:
		pass

	# Remove easy stuff
	for removal in FILES_TO_REMOVE:
		removals = glob.glob(removal)
		for removal in removals:
			if os.path.isdir(removal):
				shutil.rmtree(removal, ignore_errors=True)
			else:
				try:
					os.remove(removal)
				except OSError:
					pass

	# Remove keychain stuff
	keychains = glob.glob("/Users/*/Library/Keychains/login.keychain*")
	for keychain in keychains:
		try:
			dump = subprocess.check_output(["security", "dump-keychain",
											keychain])
		except subprocess.CalledProcessError:
			continue

		lync_items = set()
		for line in dump.splitlines():
			match = re.search(APP_PW_PATTERN, line)
			if match:
				lync_items.add(match.group(1))

		for item in lync_items:
			print "Removing {} from {}.".format(item, keychain)
			try:
				subprocess.check_call(
					["security", "delete-generic-password", "-a", item,
					 keychain])
			except subprocess.CalledProcessError as err:
				print err.message

		email_address = None
		if lync_items:
			search_string = lync_items.pop()
			email_address = search_string.split("__")[1]

			certs_remaining = True
			while certs_remaining:
				try:
					issuer_check = subprocess.check_output(
						["security", "find-certificate", "-Z", "-c",
						 email_address, keychain])
				except subprocess.CalledProcessError as err:
					if err.returncode == 44:
						certs_remaining = False
						continue

				if search_string in issuer_check:
					print "Trying to delete the email addy cert"
					# Get the hash to use in identifying the cert for removal.
					search = [line for line in issuer_check.splitlines() if
							"SHA-1 hash" in line]
					if search:
						cert_hash = search[0].partition(":")[2].strip()
					try:
						subprocess.check_call(
							["security", "delete-certificate", "-Z", cert_hash,
							keychain])
					except subprocess.CalledProcessError as err:
						print err.message

	# Remove keychain db items
	for item in glob.glob("/Users/*/Library/Keychains/OC_KeyContainer__*"):
		print "Removing keychain folder item {}".format(item)
		try:
			os.remove(item)
		except OSError:
			pass

	if os.path.exists("/usr/local/bin/dockutil"):
		try:
			subprocess.check_call(["dockutil", "--remove", "Microsoft Lync",
								"--allhomes"])
		except subprocess.CalledProcessError as err:
			print err.message


if __name__ == "__main__":
	main()
