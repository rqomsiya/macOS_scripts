#!/bin/bash

# enable SUS schedule
softwareupdate --schedule on

sleep 10

# check for XProtect Updates
softwareupdate --background-critical

sleep 10

# disable SUS schedule
softwareupdate --schedule off