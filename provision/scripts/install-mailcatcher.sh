#!/usr/bin/env bash

if [ -f /home/vagrant/.mailcatcher ]
then
    echo ">>> Mailcatcher already installed."
    exit 0
fi

echo ">>> Installing Mailcatcher"
touch /home/vagrant/.mailcatcher

# Test if PHP is installed
php -v > /dev/null 2>&1
PHP_IS_INSTALLED=$1

# Test if Apache is installed
apache2 -v > /dev/null 2>&1
APACHE_IS_INSTALLED=$?

# Installing dependency
# -qq implies -y --force-yes
sudo apt-get install -qq libsqlite3-dev ruby-dev

if $(which rvm) -v > /dev/null 2>&1; then
    echo ">>>>Installing with RVM"
    $(which rvm) do gem install mime-types -v 2.6.2
    $(which rvm) default@mailcatcher --create do gem install --no-rdoc --no-ri mailcatcher
    $(which rvm) wrapper default@mailcatcher --no-prefix mailcatcher catchmail
else
    # Gem check
    if ! gem -v > /dev/null 2>&1; then sudo aptitude install -y libgemplugin-ruby; fi
    gem install mime-types -v 2.6.2
    # Install
    gem install --no-rdoc --no-ri mailcatcher
fi

# Make it start on boot
sudo tee /etc/init/mailcatcher.conf <<EOL
description "Mailcatcher"
start on runlevel [2345]
stop on runlevel [!2345]
respawn
exec /usr/bin/env $(which mailcatcher) --foreground --http-ip=0.0.0.0
EOL

# Start Mailcatcher
#sudo service mailcatcher start

if [[ $PHP_IS_INSTALLED -eq 0 ]]; then
    # Make php use it to send mail
    echo "sendmail_path = /usr/bin/env $(which catchmail)" | sudo tee /etc/php/7.1/mods-available/mailcatcher.ini
    sudo phpenmod mailcatcher
    sudo service php7.1-fpm restart
fi

if [[ $APACHE_IS_INSTALLED -eq 0 ]]; then
    sudo service apache2 restart
fi
