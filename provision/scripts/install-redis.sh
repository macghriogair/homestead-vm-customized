#!/bin/sh
# @Author: Patrick Mac Gregor
# @Date:   2017-01-05
# @Last Modified by:   Patrick Mac Gregor
# @Last Modified time: 2017-01-05

sudo apt-get update
sudo apt-get install build-essential tcl
cd /tmp
curl -O http://download.redis.io/redis-stable.tar.gz
tar xzvf redis-stable.tar.gz
cd redis-stable
make
make test
sudo make install

# copy defaults & adapt config
sudo mkdir /etc/redis
sudo cp /tmp/redis-stable/redis.conf /etc/redis
sed -i -e 's/supervised no/supervised systemd/g' /etc/redis/redis.conf
sed -i -e 's/dir .\/dir/dir \/var\/lib\/redis/g' /etc/redis/redis.conf

# add service
block="[Unit]
Description=Redis In-Memory Data Store
After=network.target

[Service]
User=redis
Group=redis
ExecStart=/usr/local/bin/redis-server /etc/redis/redis.conf
ExecStop=/usr/local/bin/redis-cli shutdown
Restart=always

[Install]
WantedBy=multi-user.target
"
echo "$block" > "/etc/systemd/system/redis.service"
sudo adduser --system --group --no-create-home redis
sudo mkdir /var/lib/redis
sudo chown redis:redis /var/lib/redis
sudo chmod 770 /var/lib/redis

# start redis
sudo systemctl start redis
