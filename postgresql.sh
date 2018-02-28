#!/bin/sh

exec /sbin/setuser postgres /usr/lib/postgresql/9.5/bin/postgres -D /usr/local/pgsql/data
