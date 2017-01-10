#!/usr/bin/env bash


if [ -f /home/vagrant/.rabbitmq ]
then
    echo ">>> RabbitMQ already installed."
    exit 0
fi

echo ">>> Installing RabbitMQ"
touch /home/vagrant/.rabbitmq

apt-get -y install erlang-nox
wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | apt-key add -

echo "deb http://www.rabbitmq.com/debian/ testing main" > /etc/apt/sources.list.d/rabbitmq.list
apt-get update
apt-get install -y rabbitmq-server

rabbitmqctl add_user $1 $2
rabbitmqctl set_permissions -p / $1 ".*" ".*" ".*"
