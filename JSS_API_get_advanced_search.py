#!/usr/bin/python

import urllib2
import base64

request = urllib2.Request('https://jss-cms-qa.cguser.capgroup.com:8443/JSSResource/advancedcomputersearches/id/14')
request.add_header('Authorization', 'Basic ' + base64.b64encode('cgjssapi:capgroup'))

# Get
response = urllib2.urlopen(request)

