#!/bin/bash
## Create folder in /Library/Application Support/Crashplan
mkdir -p /Library/Application\ Support/CrashPlan
## Create the deploy.properties file in the above directory
## Fill in Deployment URL and Deployment Policy Token
echo "DEPLOYMENT_URL=DEPLOYMENT_URL=
DEPLOYMENT_POLICY_TOKEN=
CP_SILENT=true" > /Library/Application\ Support/CrashPlan/deploy.properties

exit 0
