#!/bin/sh

exec /sbin/setuser redis /usr/bin/redis-server /etc/redis/redis.conf >>/var/log/redis-server.log 2>&1
