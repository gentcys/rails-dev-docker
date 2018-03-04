#!/bin/sh

if [ ! -d "/run/mysqld" ]; then
    mkdir -p /run/mysqld
fi

rm -rf /var/run/mysqld/*

if [ ! -d "/var/run/mysqld" ]; then
    mkdir -p /var/run/mysqld
    chown -R mysql:mysql /var/run/mysqld
fi

chown -R mysql:mysql /run/mysqld

if [ ! -d "/var/lib/mysql" ]; then
    echo "[i] MySQL directory not found, creating initial DBs"
    mysqld_safe --initialize-insecure --user=mysql > /dev/null
else
    echo "[i] MySQL directory exists already"
fi

chown -R mysql:mysql /var/lib/mysql

echo "Starting mysqld"
# The sleep 1 is there to make sure that inotifywait starts up before the socket is created
mysqld_safe --user=mysql &

echo "Waiting for mysqld to come online"
while [ ! -x /var/run/mysqld/mysqld.sock ]; do
    sleep 1
done

tfile=`mktemp`
if [ ! -f "$tfile" ]; then
    return 1
fi

cat <<EOF > $tfile
FLUSH PRIVILEGES;
CREATE USER 'rails'@'localhost' IDENTIFIED BY 'rails';
GRANT ALL PRIVILEGES ON activerecord_unittest.* to 'rails'@'localhost';
GRANT ALL PRIVILEGES ON activerecord_unittest2.* to 'rails'@'localhost';
GRANT ALL PRIVILEGES ON inexistent_activerecord_unittest.* to 'rails'@'localhost';
QUIT;
EOF

mysql -u root < $tfile &
rm -f $tfile
mysqladmin -u root shutdown
