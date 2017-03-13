#!/bin/bash

if [ ! -d /Users/$3/Library/Application\ Support/Google ];then
    mkdir /Users/$3/Library/Application\ Support/Google
    echo "Created directory /Users/$3/Library/Application\ Support/Google"
fi

if [ ! -d /Users/$3/Library/Application\ Support/Google/Chrome ];then
    mkdir /Users/$3/Library/Application\ Support/Google/Chrome
    echo "Created directory /Users/$3/Library/Application\ Support/Google/Chrome"
fi

if [ ! -f /Users/$3/Library/Application\ Support/Google/Chrome/First\ Run ];then
    touch /Users/$3/Library/Application\ Support/Google/Chrome/First\ Run
    echo "Created file /Users/$3/Library/Application\ Support/Google/Chrome/First\ Run"
fi

chown -R $3 /Users/$3/Library/Application\ Support/Google
