#!/bin/bash
# Output Chrome Preferences to User's Library

# https://www.chromium.org/administrators/configuring-other-preferences

# Check for existing prefs and exit if found
if [ -f /Users/$3/Library/Application\ Support/Google/Chrome/Default/Preferences ];then
    echo "Google Chrome Preferences file already exists. Exiting..."
    exit 0
fi

# Check for directory structure and create as needed
if [ ! -d /Users/$3/Library/Application\ Support/Google ];then
    mkdir /Users/$3/Library/Application\ Support/Google
    echo "Created directory /Users/$3/Library/Application\ Support/Google"
fi
if [ ! -d /Users/$3/Library/Application\ Support/Google/Chrome ];then
    mkdir /Users/$3/Library/Application\ Support/Google/Chrome
    echo "Created directory /Users/$3/Library/Application\ Support/Google/Chrome"
fi
if [ ! -d /Users/$3/Library/Application\ Support/Google/Chrome/Default ];then
    mkdir /Users/$3/Library/Application\ Support/Google/Chrome/Default
    echo "Created directory /Users/$3/Library/Application\ Support/Google/Chrome/Default"
fi


# Create Preferences file
(
cat <<'EOD'
{
  "browser": {
    "check_default_browser": false,
    "show_update_promotion_info_bar": false
  },
  "distribution": {
    "suppress_first_run_bubble": true,
    "suppress_first_run_default_browser_prompt": true,
    "skip_first_run_ui": true
  }
}
EOD
) > /Users/$3/Library/Application\ Support/Google/Chrome/Default/Preferences

chown -R $3 /Users/$3/Library/Application\ Support/Google
