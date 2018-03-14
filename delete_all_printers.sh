#!/bin/bash

# Deletes all installed printers on device
lpstat -p | cut -d" " -f2 | xargs -I{} lpadmin -x {}

exit 0
