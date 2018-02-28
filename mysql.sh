#!/bin/sh

trap 'mysqladmin -uroot -proot shutdown' EXIT

exec /usr/bin/mysqld_safe --user=mysql >>/var/log/mysql.log 2>&1
