#!/bin/bash

lpstat -p | cut -d" " -f2 | xargs -I{} lpadmin -x {}

exit 0
