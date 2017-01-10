#!/bin/sh
# @Author: Patrick Mac Gregor
# @Date:   2016-12-31
# @Last Modified by:   Patrick Mac Gregor
# @Last Modified time: 2016-12-31

# Install required package
apt-get install php7.1-dev
# Download PhpRedis
cd /tmp
wget https://github.com/phpredis/phpredis/archive/php7.zip -O phpredis.zip
# Unpack, compile and install PhpRedis
unzip -o /tmp/phpredis.zip && mv /tmp/phpredis-* /tmp/phpredis && cd /tmp/phpredis && phpize && ./configure && make && sudo make install
# Add PhpRedis extension to PHP 7
touch /etc/php/7.1/mods-available/redis.ini && echo extension=redis.so > /etc/php/7.1/mods-available/redis.ini
ln -s /etc/php/7.1/mods-available/redis.ini /etc/php/7.1/fpm/conf.d/redis.ini
ln -s /etc/php/7.1/mods-available/redis.ini /etc/php/7.1/cli/conf.d/redis.ini
service php7.1-fpm restart
