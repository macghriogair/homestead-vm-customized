#!/bin/sh
# @Author: Patrick Mac Gregor
# @Date:   2017-01-03
# @Last Modified by:   Patrick Mac Gregor
# @Last Modified time: 2017-01-03

if [ -f /home/vagrant/.yarn-installed ]
then
    echo ">>> Yarn already installed."
    exit 0
fi

echo ">>> Installing Yarn"
touch /home/vagrant/.yarn-installed

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
sudo apt-get update && sudo apt-get install yarn
