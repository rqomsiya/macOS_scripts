# Commands to check XProtect and Gatekeeper last update dates:

# Output last version and installed date for Gatekeeper
system_profiler SPInstallHistoryDataType | awk '/Gatekeeper/,/Install/ {$1=$1;print}' | tail -6 | grep Install

# Output last installed date for XProtectPlistConfigData. Version is always 1.0.
system_profiler SPInstallHistoryDataType | awk '/XProtect/,/Install/ {$1=$1;print}' | tail -5 | grep Install


