#!/usr/bin/env bash

DB=$1;

mysql -uhomestead -psecret -e "CREATE DATABASE IF NOT EXISTS \`$DB\` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_unicode_ci";
mysql -utester -psecret -e "CREATE DATABASE IF NOT EXISTS \`testdb\` DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_unicode_ci";
