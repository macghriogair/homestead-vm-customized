#!/bin/sh
# @Author: Patrick Mac Gregor
# @Date:   2016-11-17
# @Last Modified by:   Patrick Mac Gregor
# @Last Modified time: 2017-01-03

# /var/www/master/public/../
appPath="$1/../"

cd $appPath
echo ">>> Do composer install at $appPath"
composer install

if [ ! -f .env ]
then
echo ">>> Create environment file with key"
    cp .env.example .env
    php artisan key:generate
fi

echo ">>> Executing database migrations"
php artisan migrate:refresh --seed

echo ">>> Installing node dependencies"
yarn install --no-bin-links

echo ">>> Running gulp"
gulp

exit
