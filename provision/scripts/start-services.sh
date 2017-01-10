#!/bin/sh
# @Author: Patrick Mac Gregor
# @Date:   2017-01-03
# @Last Modified by:   Patrick Mac Gregor
# @Last Modified time: 2017-01-04

echo "Starting Services"
sudo service elasticsearch start

ps -ef | grep mailcatcher | grep -v grep
if [ $? -eq "0" ]
    then
        echo "Mailcatcher is already running"
    else
        echo "Mailcatcher is not running, starting..."
        mailcatcher start --http-ip=0.0.0.0
fi
