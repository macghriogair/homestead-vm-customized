#!/bin/sh
# @Author: Patrick Mac Gregor
# @Date:   2016-11-17
# @Last Modified by:   Patrick Mac Gregor
# @Last Modified time: 2016-11-18

if [ -f /home/vagrant/.php-ppa-fixed ]
then
    echo ">>> PHP repo is already fixed."
    exit 0
fi

rm /etc/apt/sources.list.d/ondrej*
# Add new updated ppa
add-apt-repository ppa:ondrej/php -y
# Update apt-cache
apt-get update

touch /home/vagrant/.php-ppa-fixed
