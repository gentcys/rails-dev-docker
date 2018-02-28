FROM phusion/baseimage:latest

RUN locale-gen en_US.UTF-8

ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV TERM xterm

RUN apt-get update && apt-get upgrade -y -o Dpkg::Options::="--force-confold"

RUN install_clean bash git curl build-essential nodejs sqlite3 libsqlite3-dev memcached \
    mysql-server mysql-client libmysqlclient-dev \
    postgresql postgresql-client postgresql-contrib libpq-dev

RUN curl -OL https://cache.ruby-lang.org/pub/ruby/2.5/ruby-2.5.0.tar.gz

RUN tar -zxf ruby-2.5.0.tar.gz && rm -f ruby-2.5.0.tar.gz

WORKDIR /ruby-2.5.0

RUN ./configure --prefix=/usr > /dev/null 2>&1
RUN make > /dev/null 2>&1
RUN make install > /dev/null 2>&1

WORKDIR /

RUN rm -rf /ruby-2.5.0

# WORKDIR /home/rails

# RUN git clone https://github.com/rails/rails.git && cd rails

######## Setup MySQL ########
RUN mkdir -p /var/run/mysqld
RUN chown -R mysql:mysql /var/run/mysqld
COPY my.cnf /etc/mysql/my.cnf
COPY mysql_setup.sh /etc/my_init.d/mysql_setup.sh
RUN chmod +x /etc/my_init.d/mysql_setup.sh

######## Set MySQL Daemon ########
RUN mkdir /etc/service/mysql
COPY mysql.sh /etc/service/mysql/run
RUN chmod +x /etc/service/mysql/run

######### Setup PostgreSQL #######
RUN groupadd -r rails && useradd -r -g rails rails
RUN mkdir -p /usr/local/pgsql/data
RUN chown postgres:postgres /usr/local/pgsql/data
RUN su - postgres -c '/usr/lib/postgresql/9.5/bin/initdb -A trust -D /usr/local/pgsql/data/ -U postgres'

######### Setup PostgreSQL Daemon ########
RUN mkdir /etc/service/postgres
COPY postgresql.sh /etc/service/postgres/run
RUN chmod +x /etc/service/postgres/run

CMD ["/sbin/my_init"]
